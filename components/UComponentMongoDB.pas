unit UComponentMongoDB;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MongoDB,
  FireDAC.Phys.MongoDBDef, System.Rtti, System.JSON.Types, System.JSON.Readers,
  System.JSON.BSON, System.JSON.Builders, FireDAC.Phys.MongoDBWrapper,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.Phys.MongoDBDataSet, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.JSON;

type
  TComponentMongoDB = class(TComponent)
  private
    { Private declarations }
    FDConnection: TFDConnection;
    FDMongoQuery: TFDMongoQuery;
    FDPhysMongoDriverLink: TFDPhysMongoDriverLink;
    FDMongoDataSet: TFDMongoDataSet;
    FMongoConn: TMongoConnection;
    FDManager: TFDManager;

    FDataBaseName: String;
    FUserName: String;
    FPassword: String;
    FServerHost: String;
    FPort: Integer;

    procedure CriarComponentes;
    procedure DestruirComponentes;
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure ConectarBancoDeDados;
    procedure DesconectarBancoDeDados;
    function InserirDados(collectionName, strObjetoJson: String): Boolean;
    function BuscarDados(collectionName: String): TJSONArray;
  published
    { Published declarations }
    property DataBaseName: String read FDataBaseName write FDataBaseName;
    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
    property ServerHost: String read FServerHost write FServerHost;
    property Port: Integer read FPort write FPort;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TComponentMongoDB]);
end;

{ TComponentMongoDB }

function TComponentMongoDB.BuscarDados(collectionName: String): TJSONArray;
var
  resultadoBusca: TJSONArray;
  oCrs: IMongoCursor;
begin
  try
    try
      resultadoBusca := TJSONArray.Create;
      oCrs :=FMongoConn.Databases[FDataBaseName].GetCollection(collectionName).Find();

      while oCrs.Next do
       resultadoBusca.Add(oCrs.Doc.AsJSON);

      result := resultadoBusca;
    except
      result := TJSONArray.Create;
    end;

  finally
    FDMongoDataSet.Filter := '';
    FDMongoDataSet.Filtered := false;
  end;
end;

procedure TComponentMongoDB.ConectarBancoDeDados;
begin
  try
    CriarComponentes;

    FDConnection.Connected := True;
    FMongoConn := TMongoConnection(FDConnection.CliObj);
  except
    on e : exception do
      raise Exception.Create('Erro ao conectar ao banco de dados: ' + #13#10 + e.Message);
  end;
end;

procedure TComponentMongoDB.DesconectarBancoDeDados;
begin
  try
    FDConnection.Connected := false;
  finally
    DestruirComponentes;
  end;
end;

procedure TComponentMongoDB.DestruirComponentes;
begin
  FreeAndNil(FDMongoDataSet);
  FreeAndNil(FDMongoQuery);
  FreeAndNil(FDConnection);
  FreeAndNil(FDManager);
  FreeAndNil(FDPhysMongoDriverLink);
end;

function TComponentMongoDB.InserirDados(collectionName, strObjetoJson: String): Boolean;
var
  oDoc: TMongoDocument;
  collection : TMongoCollection;
begin
  try
    try
      result := false;
      collection := FMongoConn.Databases[FDataBaseName].GetCollection(collectionName);

      oDoc := TMongoDocument.Create(collection.Env);
      oDoc.Append(strObjetoJson);
      collection.Insert(oDoc);
      result := true;
    except
      on e : exception do
        begin
          result := false;
          raise Exception.Create('Erro ao inserir na collection: ' + collectionName + '.' + #13#10 + e.Message);
        end;
    end;
  finally
    FreeAndNil(oDoc);
  end;
end;

procedure TComponentMongoDB.CriarComponentes;
var
  oParams: TStrings;
begin
  try
    FDPhysMongoDriverLink := TFDPhysMongoDriverLink.Create(nil);

    oParams := TStringList.Create;
    oParams.Add('Database=' + FDataBaseName);
    oParams.Add('User_name=' + FUserName);
    oParams.Add('Password=' + FPassword);
    oParams.Add('Server=' + FServerHost);
    oParams.Add('Port=' + IntToStr(FPort));

    if not FDManager.IsConnectionDef('MyMongoDB_Connection_1') then
      FDManager.AddConnectionDef('MyMongoDB_Connection_1', 'Mongo', oParams);

    FDConnection := TFDConnection.Create(nil);
    FDConnection.LoginPrompt := false;
    FDConnection.ConnectionDefName := 'MyMongoDB_Connection_1';

    FDMongoQuery := TFDMongoQuery.Create(nil);
    FDMongoQuery.Connection := FDConnection;

    FDMongoDataSet := TFDMongoDataSet.Create(nil);
    FDMongoDataSet.Connection := FDConnection;
  finally
    FreeAndNil(oParams);
  end;
end;

end.
