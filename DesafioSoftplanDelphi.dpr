program DesafioSoftplanDelphi;

uses
  Vcl.Forms,
  view.principal in 'views\view.principal.pas' {FrmConsultaEnderecos},
  UClientRequest in 'classes\UClientRequest.pas',
  UDataBase in 'classes\UDataBase.pas',
  URabbitMQ in 'classes\URabbitMQ.pas',
  StompClient in 'features\StompClient.pas',
  UConsultaDeEndereco in 'classes\UConsultaDeEndereco.pas',
  UHelpers in 'classes\UHelpers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmConsultaEnderecos, FrmConsultaEnderecos);
  Application.Run;
end.
