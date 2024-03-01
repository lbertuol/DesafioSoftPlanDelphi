unit UConsultaDeEndereco;

interface

uses
  URabbitMQ, UClientRequest, System.SysUtils, System.JSON, System.Variants,
  System.Classes, Vcl.Dialogs, UDataBase, URetorno, REST.Json,
  System.Generics.Collections;

type
  rabbitMq = class(TRabbitMQ)
    private
    public
      procedure AposReceberMensagem(mensagem: String); override;
  end;

  TConsultaDeEndereco = Class
    private
      const TEMPO_LEITURA = 900;
      const NOME_FILA = 'DesafioSoftplanDelphi';
      const COLLECTION_NAME = 'enderecos';
      var
        filaRabbitMQ: rabbitMq;
      procedure PopularMensagemRecebidaNoDB(mensagem: String);
    public
      function SolicitarConsulta(filtroPesquisa: String): Boolean;
      function ExecutarConsulta(filtroPesquisa: String): Boolean;
      function RetornarDados(): TJSONArray;
      function RetornarDadosListaObjetos(): TObjectList<TResultado>;
      constructor Create;
      destructor Destroy; override;
  End;

var
  consultaDeEndereco: TConsultaDeEndereco;

implementation

{ TConsultaDeEndereco }

constructor TConsultaDeEndereco.Create;
begin
  filaRabbitMQ := rabbitMq.Create(NOME_FILA, TEMPO_LEITURA);
  filaRabbitMQ.LStop := false;
end;

destructor TConsultaDeEndereco.Destroy;
begin
  filaRabbitMQ.LStop := true;
  FreeAndNil(filaRabbitMQ);
  inherited;
end;

function TConsultaDeEndereco.ExecutarConsulta(filtroPesquisa: String): Boolean;
var
  retorno: TJSONObject;
  filtroComTratamento: String;
begin
  filtroComTratamento := StringReplace(Trim(filtroPesquisa), ',', '/', [rfReplaceAll, rfIgnoreCase]);
  filtroComTratamento := StringReplace(filtroComTratamento, ', ', '/', [rfReplaceAll, rfIgnoreCase]);
  retorno := TClienteRequest.ExecutarGet('https://viacep.com.br/ws/' + filtroComTratamento + '/json');

  result := false;
  if ((not (retorno = nil)) and (not retorno.IsEmpty)) then
  begin
    PopularMensagemRecebidaNoDB(retorno.ToString);
    result := true;
  end
  else //TO DO - utilizar notify para notificar, deixando a classe mais independente de interface
    MessageDlg('Não foi possível encontrar registros com o filtro: ' + filtroComTratamento, mtInformation, [mbOk], 0);
end;

procedure TConsultaDeEndereco.PopularMensagemRecebidaNoDB(mensagem: String);
var
  database: TDataBase;
begin
  database := TDataBase.Create;
  try
    database.ConectarDatabase;

    database.InserirDados(COLLECTION_NAME, mensagem);
  finally
    database.DesconectarDatabase;
    FreeAndNil(database);
  end;
end;

function TConsultaDeEndereco.RetornarDados: TJSONArray;
var
  database: TDataBase;
  objetoJson: TJSONObject;
begin
  database := TDataBase.Create;
  try
    database.ConectarDatabase;

    result := database.BuscarDados(COLLECTION_NAME);

  finally
    database.DesconectarDatabase;
    FreeAndNil(database);
  end;
end;

function TConsultaDeEndereco.RetornarDadosListaObjetos: TObjectList<TResultado>;
var
  retornoDB, propArray: TJsonArray;
  i, x: Integer;
  listaResultado: TObjectList<TResultado>;
  jsonObj: TJSONObject;
begin
  try
    retornoDB := RetornarDados;

    listaResultado := TObjectList<TResultado>.Create;
    for i := 0 to retornoDB.Size - 1 do
    begin
      try
        listaResultado.Add(TJson.JsonToObject<TRetorno>(TJSONObject.ParseJSONValue(retornoDB.Get(i).Value) as TJSONObject).Resultado);
      except
        jsonObj  := TJSONObject.ParseJSONValue(retornoDB.Get(i).Value) as TJSONObject;
        propArray := jsonObj.Get('resultado').JsonValue as TJSONArray;

        for x := 0 to propArray.Size - 1 do
        begin
          listaResultado.Add(TJson.JsonToObject<TResultado>(TJSONObject.ParseJSONValue(propArray.Get(x).ToString) as TJSONObject));
        end;
      end;
    end;

    result := listaResultado;
  except
    on E: Exception do
      begin
        result := TObjectList<TResultado>.Create;
      end;
  end;
end;

function TConsultaDeEndereco.SolicitarConsulta(filtroPesquisa: String): Boolean;
begin
  result := filaRabbitMQ.EnviarMensagem(filtroPesquisa);
end;

procedure rabbitMq.AposReceberMensagem(mensagem: String);
begin
  inherited;
  if(not (Trim(mensagem) = '')) then
    consultaDeEndereco.ExecutarConsulta(mensagem);
end;

end.
