unit UConsultaDeEndereco;

interface

uses
  URabbitMQ, UClientRequest, System.SysUtils, System.JSON, System.Variants,
  System.Classes, Vcl.Dialogs;

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
      var
        filaRabbitMQ: rabbitMq;

      procedure PopularMensagemRecebidaNoDB(mensagem: String);
    public
      function SolicitarConsulta(filtroPesquisa: String): Boolean;
      function ExecutarConsulta(filtroPesquisa: String): Boolean;
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
  filtroComTratamento := StringReplace(filtroComTratamento, ', ', '/', [rfReplaceAll, rfIgnoreCase]);
  filtroComTratamento := StringReplace(Trim(filtroPesquisa), ',', '/', [rfReplaceAll, rfIgnoreCase]);
  retorno := TClienteRequest.ExecutarGet('https://viacep.com.br/ws/' + filtroComTratamento + '/json');

  result := false;
  if ((not (retorno = nil)) and (not retorno.IsEmpty)) then
  begin
    PopularMensagemRecebidaNoDB(retorno.ToString);
    result := true;
  end;
end;

procedure TConsultaDeEndereco.PopularMensagemRecebidaNoDB(mensagem: String);
begin
  ShowMessage(mensagem);
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
