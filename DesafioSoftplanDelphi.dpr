program DesafioSoftplanDelphi;

uses
  Vcl.Forms,
  view.principal in 'views\view.principal.pas' {FrmConsultaEnderecos},
  UClientRequest in 'classes\UClientRequest.pas',
  UDataBase in 'classes\UDataBase.pas',
  URabbitMQ in 'classes\URabbitMQ.pas',
  StompClient in 'features\StompClient.pas',
  UDM in 'UDM.pas' {DM: TDataModule},
  UConsultaDeEndereco in 'classes\UConsultaDeEndereco.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmConsultaEnderecos, FrmConsultaEnderecos);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
