unit UDataBase;

interface

uses
  System.Classes, System.SysUtils, UComponentMongoDB, System.JSON, UHelpers, Vcl.Forms;

type
  TDataBase = Class
  private
    FDataBaseName: String;
    FUserName: String;
    FPassword: String;
    FServerHost: String;
    FPort: Integer;
    FComponentMongoDB: TComponentMongoDB;

    procedure ObterConfiguracoesDB;
    const
      secaoConfiguracoes = 'DATABASE';
  public
    property DataBaseName: String read FDataBaseName write FDataBaseName;
    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
    property ServerHost: String read FServerHost write FServerHost;
    property Port: Integer read FPort write FPort;

    procedure ConectarDatabase;
    procedure DesconectarDatabase;
    function InserirDados(collectionName, strObjetoJson: String): Boolean;
    function BuscarDados(collectionName: String): TJSONArray;
  End;

implementation

{ TDataBase }

function TDataBase.BuscarDados(collectionName: String): TJSONArray;
var
  retorno: TJSONArray;
begin
  retorno := FComponentMongoDB.BuscarDados(collectionName);
  result := TJSONArray.Create;

  if (not (retorno.Count = 0)) then
    result := retorno;
end;

procedure TDataBase.ConectarDatabase;
begin
 FComponentMongoDB := TComponentMongoDB.Create(nil);
 ObterConfiguracoesDB;
 FComponentMongoDB.DataBaseName := FDataBaseName;
 FComponentMongoDB.UserName := FUserName;
 FComponentMongoDB.Password := FPassword;
 FComponentMongoDB.ServerHost := FServerHost;
 FComponentMongoDB.Port := FPort;
 FComponentMongoDB.ConectarBancoDeDados;
end;

procedure TDataBase.DesconectarDatabase;
begin
  FComponentMongoDB.DesconectarBancoDeDados;
  FreeAndNil(FComponentMongoDB);
end;

function TDataBase.InserirDados(collectionName, strObjetoJson: String): Boolean;
begin
  try
    result := FComponentMongoDB.InserirDados(collectionName, strObjetoJson);
  except
    result := false;
  end;
end;

procedure TDataBase.ObterConfiguracoesDB;
var
  caminhoArqIni: String;
begin
  caminhoArqIni := IncludeTrailingPathDelimiter(ExtractFileDir(GetCurrentDir)) + THelpers.arquivoIniConfiguracoes;

  FDataBaseName := THelpers.LerArquivoIni(caminhoArqIni, secaoConfiguracoes, 'DataBaseName');
  FUserName := THelpers.LerArquivoIni(caminhoArqIni, secaoConfiguracoes, 'UserName');
  FPassword := THelpers.LerArquivoIni(caminhoArqIni, secaoConfiguracoes, 'Password');
  FServerHost := THelpers.LerArquivoIni(caminhoArqIni, secaoConfiguracoes, 'ServerHost');
  FPort := StrToIntDef(THelpers.LerArquivoIni(caminhoArqIni, secaoConfiguracoes, 'Port'), 27017);
end;

end.
