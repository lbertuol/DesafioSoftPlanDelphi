unit URetorno;

interface

uses
  System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TResultado = class
  private
    FBairro: string;
    FCep: string;
    FComplemento: string;
    FDdd: string;
    FGia: string;
    FIbge: string;
    FLocalidade: string;
    FLogradouro: string;
    FSiafi: string;
    FUf: string;
  published
    property Bairro: string read FBairro write FBairro;
    property Cep: string read FCep write FCep;
    property Complemento: string read FComplemento write FComplemento;
    property Ddd: string read FDdd write FDdd;
    property Gia: string read FGia write FGia;
    property Ibge: string read FIbge write FIbge;
    property Localidade: string read FLocalidade write FLocalidade;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Siafi: string read FSiafi write FSiafi;
    property Uf: string read FUf write FUf;
  end;

  TId = class
  private
    FOId: string;
  published
    property OId: string read FOId write FOId;
  end;

  TRetorno = class
  private
    [JSONName('_id')]
    FId: TId;
    FResultado: TResultado;
  published
    property Id: TId read FId;
    property Resultado: TResultado read FResultado;
  public
    constructor Create;
    destructor Destroy;
  end;

implementation

{ TRetorno }

constructor TRetorno.Create;
begin
  inherited;
  FId := TId.Create;
  FResultado := TResultado.Create;
end;

destructor TRetorno.Destroy;
begin
  FId.Free;
  FResultado.Free;
  inherited;
end;

end.
