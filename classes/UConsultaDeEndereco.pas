unit UConsultaDeEndereco;

interface

uses
  URabbitMQ, UClientRequest, System.SysUtils, System.JSON, System.Variants,
  System.Classes, Vcl.Dialogs, UDataBase;

type
  rabbitMq = class(TRabbitMQ)
    private
    var
      LStop: boolean;
    public
      procedure AposReceberMensagem(mensagem: String); override;
      procedure VerificarMensagem(); override;
  end;

  TConsultaDeEndereco = Class
    private
      const TEMPO_LEITURA = 900;
      const NOME_FILA = 'DesafioSoftplanDelphi';
      const COLLECTION_NAME = 'enderecos';
      var
        filaRabbitMQ: rabbitMq;
        teste: String;
      procedure PopularMensagemRecebidaNoDB(mensagem: String);
    public
      procedure NotificarFalhaRequisicao; virtual;
      function SolicitarConsulta(filtroPesquisa: String): Boolean;
      function ExecutarConsulta(filtroPesquisa: String): Boolean;
      function RetornarDados(): TJSONArray;
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
  else
    MessageDlg('Não foi possível encontrar registros com o filtro: ' + filtroComTratamento, mtInformation, [mbOk], 0);
end;

procedure TConsultaDeEndereco.NotificarFalhaRequisicao;
begin
  inherited;
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

function TConsultaDeEndereco.SolicitarConsulta(filtroPesquisa: String): Boolean;
begin
  result := filaRabbitMQ.EnviarMensagem(filtroPesquisa);
end;

procedure rabbitMq.VerificarMensagem;
begin
  TThread.CreateAnonymousThread(
  procedure
    var
      lMessage: string;
  begin
    while True do
    begin
      if LStop then
        break;
      try
          if Client.Receive(FStompFrameReceive, TimeOut - 10) then
          begin
            TThread.Synchronize(nil,
            procedure
            begin
              ReceberMensagens;
            end);
          end;
      finally
        sleep(TimeOut);
      end;
    end;
  end).Start;
end;

procedure rabbitMq.AposReceberMensagem(mensagem: String);
begin
  inherited;
  if(not (Trim(mensagem) = '')) then
    consultaDeEndereco.ExecutarConsulta(mensagem);
end;

end.
