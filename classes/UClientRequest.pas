unit UClientRequest;

interface

uses
  SysUtils, StrUtils, System.JSON, REST.Client;

type
  TClienteRequest = Class
    FURL: String;
    private
    public
      class function ExecutarGet(URL: String): TJSONObject;
  End;

implementation

{ TClienteRequest }

class function TClienteRequest.ExecutarGet(URL: String): TJSONObject;
var
  retorno: TJSONObject;
  restClient: TRESTClient;
  restRequest: TRESTRequest;
  restResponse: TRESTResponse;
  resultadoTratado: String;
const
  resultadoJson = '{"resultado": #resultado}';
begin
  try
    restClient := TRESTClient.Create(nil);
    restRequest := TRESTRequest.Create(nil);
    restResponse := TRESTResponse.Create(nil);
    try
      restRequest.Client := restClient;
      restRequest.Response := restResponse;
      restClient.BaseURL := URL;
      restRequest.Execute;

      retorno := nil;
      if (restResponse.StatusCode in [200, 201, 202]) then
      begin
        resultadoTratado := StringReplace(resultadoJson, '#resultado', restResponse.JSONValue.ToString, []);
        retorno := TJSONObject.ParseJSONValue(resultadoTratado) as TJSONObject;
      end;
    except
      on E: Exception do
      begin
        retorno := nil;
        raise Exception.Create('Error: ' + E.Message);
      end;
    end;
    result := retorno;
  finally
    FreeAndNil(restClient);
  end;
end;

end.
