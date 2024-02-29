unit URabbitMQ;

interface

uses
  StompClient, System.SysUtils, UHelpers;

type
  TRabbitMQ = Class
    private
      FStompFrame: IStompFrame;
      FStompClient: IStompClient;
      FClient: IStompClient;
      FFila: String;
      FTimeOut: integer;
    public
      const
        secaoConfiguracoes = 'RABBITMQ';
      var
        FStompFrameReceive: IStompFrame;
      property StompFrame: IStompFrame read FStompFrame write FStompFrame;
      property Client: IStompClient read FClient write FClient;
      property TimeOut: integer read FTimeOut write FTimeOut;

      function EnviarMensagem(mensagem: String): boolean;
      function AssinarLeituraMensagem: boolean;
      function ReceberMensagens(): String;

      procedure AntesEnviarFrame(AFrame: IStompFrame); virtual;
      procedure AposReceberMensagem(mensagem: String); virtual;
      procedure VerificarMensagem; virtual; abstract;
      constructor Create(fila: string; timeout: integer);
      destructor Destroy; override;
  End;

implementation

{ TRabbitMQ }

procedure TRabbitMQ.AntesEnviarFrame(AFrame: IStompFrame);
begin
  inherited;
end;

constructor TRabbitMQ.Create(fila: string; timeout: integer);
var
  caminhoArqIni, hostRabbitMQ: String;
  portaRabbitMQ: Integer;
begin
  caminhoArqIni := IncludeTrailingPathDelimiter(ExtractFileDir(GetCurrentDir)) + THelpers.arquivoIniConfiguracoes;
  hostRabbitMQ := THelpers.LerArquivoIni(caminhoArqIni, secaoConfiguracoes, 'Host');
  portaRabbitMQ := StrToIntDef(THelpers.LerArquivoIni(caminhoArqIni, secaoConfiguracoes, 'Port'), 61613);

  if (Trim(fila) = '') then
    raise Exception.Create('Fila deverá ser informada.');

  if (timeout = 0) then
    timeout := 900;
  FFila := fila;
  FTimeOut := timeout;

  FClient := StompUtils.StompClient;
  FClient.SetHost(hostRabbitMQ);
  FClient.SetPort(portaRabbitMQ);
  FClient.Connect;

  FClient.SetOnBeforeSendFrame(AntesEnviarFrame);

  FStompFrame := StompUtils.NewFrame();

  FClient := StompUtils.StompClient.SetHeartBeat(1000, 1000)
    .SetAcceptVersion(TStompAcceptProtocol.Ver_1_1).Connect;

  AssinarLeituraMensagem;
  VerificarMensagem;

  FStompClient := StompUtils.StompClient;
  FStompClient.SetHost(hostRabbitMQ);
  FStompClient.SetPort(portaRabbitMQ);

  FStompClient.SetOnBeforeSendFrame(AntesEnviarFrame);
end;

destructor TRabbitMQ.Destroy;
begin
  FClient.Disconnect;
  inherited;
end;

function TRabbitMQ.EnviarMensagem(mensagem: String): boolean;
begin
  try
    try
      FStompClient.Connect;
      FStompClient.Send(FFila , mensagem);
    except
      result := false;
    end;
    result := true;
  finally
    FStompClient.Disconnect;
  end;
end;

function TRabbitMQ.ReceberMensagens(): String;
var
  lMessage: string;
begin
  try
    lMessage := FStompFrameReceive.GetBody;

    result := lMessage;
  except
     result := '';
  end;
  FClient.Ack(FStompFrameReceive.MessageID);
  AposReceberMensagem(result);
end;

procedure TRabbitMQ.AposReceberMensagem(mensagem: String);
begin
  inherited;
end;

function TRabbitMQ.AssinarLeituraMensagem: boolean;
begin
  try
    FClient.Subscribe(FFila, TAckMode.amClient);
  except
    result := false;
  end;
  result := true;
end;

end.
