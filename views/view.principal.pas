unit view.principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  CommCtrl, Vcl.ExtCtrls, UConsultaDeEndereco, System.JSON, URetorno,
  REST.Json, System.Generics.Collections;

type
  TFrmConsultaEnderecos = class(TForm)
    lblTitulo: TLabel;
    GbPesquisa: TGroupBox;
    edtConteudoPesquisa: TEdit;
    btnPesquisar: TButton;
    GbDados: TGroupBox;
    lblDica: TLabel;
    lstResultado: TListView;
    btnCarregarDados: TButton;
    procedure btnPesquisarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCarregarDadosClick(Sender: TObject);
  private
    { Private declarations }
    consultaDeEndereco: TConsultaDeEndereco;
    procedure ConsultarDadosECarregarListView;
  public
    { Public declarations }
  end;

var
  FrmConsultaEnderecos: TFrmConsultaEnderecos;

implementation

{$R *.dfm}

{ TFrmConsultaEnderecos }

procedure TFrmConsultaEnderecos.btnCarregarDadosClick(Sender: TObject);
begin
  ConsultarDadosECarregarListView;
end;

procedure TFrmConsultaEnderecos.btnPesquisarClick(Sender: TObject);
begin
  if(Trim(edtConteudoPesquisa.Text) = '') then
  begin
    MessageDlg('Informe o endereço a ser pesquisado', mtInformation, [mbOk], 0);
    edtConteudoPesquisa.SetFocus;
    Exit;
  end;

  if (not (consultaDeEndereco.SolicitarConsulta(edtConteudoPesquisa.Text))) then
  begin
    MessageDlg('Não foi possível registrar a solicitação.', mtInformation, [mbOk], 0);
    edtConteudoPesquisa.SetFocus;
    Exit;
  end;
end;

procedure TFrmConsultaEnderecos.ConsultarDadosECarregarListView;
var
  item: TListItem;
  retornoLista: TObjectList<TResultado>;
  resultado: TResultado;
begin
  lstResultado.Items.Clear;

  retornoLista := consultaDeEndereco.RetornarDadosListaObjetos;
  for resultado in retornoLista do
  begin
    item := lstResultado.Items.Add;
    item.Caption:= resultado.Cep;
    item.SubItems.Add(resultado.Uf);
    item.SubItems.Add(resultado.Localidade);
    item.SubItems.Add(resultado.Logradouro);
    item.SubItems.Add(resultado.Bairro);
    item.SubItems.Add(resultado.Complemento);
    item.SubItems.Add(resultado.Ddd);
    item.SubItems.Add(resultado.Gia);
    item.SubItems.Add(resultado.Ibge);
    item.SubItems.Add(resultado.Siafi);
  end;
end;

procedure TFrmConsultaEnderecos.FormCreate(Sender: TObject);
var
  i: integer;
begin
  consultaDeEndereco := TConsultaDeEndereco.Create;

  for i := 0 to lstResultado.Columns.Count - 1 do
    lstResultado.Columns[i].Width := LVSCW_AUTOSIZE or LVSCW_AUTOSIZE_USEHEADER;
end;

procedure TFrmConsultaEnderecos.FormDestroy(Sender: TObject);
begin
  FreeAndNil(consultaDeEndereco);
end;

end.
