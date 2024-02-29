unit UHelpers;

interface

uses IniFiles;

type
  THelpers = class
    public
    const
      arquivoIniConfiguracoes = 'Configuracoes.ini';

    class function LerArquivoIni(arquivo, secao, propriedade: String): String;
  end;

implementation

{ THelpers }

class function THelpers.LerArquivoIni(arquivo, secao,
  propriedade : String): String;
var
  ArquivoINI: TIniFile;
begin
  ArquivoINI := TIniFile.Create(arquivo);
  try
    result := ArquivoINI.ReadString(secao, propriedade, '');
  finally
    ArquivoINI.Free;
  end;
end;

end.
