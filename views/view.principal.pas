unit view.principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  CommCtrl, Vcl.ExtCtrls, UConsultaDeEndereco;

type


  TFrmConsultaEnderecos = class(TForm)
    Label1: TLabel;
    GroupBox1: TGroupBox;
    edtConteudoPesquisa: TEdit;
    btnPesquisar: TButton;
    GroupBox2: TGroupBox;
    LstResultados: TListView;
    ListBox1: TListBox;
    Label2: TLabel;
    procedure btnPesquisarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    consultaDeEndereco: TConsultaDeEndereco;
  public
    { Public declarations }
  end;

var
  FrmConsultaEnderecos: TFrmConsultaEnderecos;

implementation

{$R *.dfm}

{ TFrmConsultaEnderecos }

procedure TFrmConsultaEnderecos.btnPesquisarClick(Sender: TObject);
begin
  if(Trim(edtConteudoPesquisa.Text) = '') then
  begin
    MessageDlg('Informe o endereço a ser pesquisado', mtInformation, [mbOk], 0);
    edtConteudoPesquisa.SetFocus;
    Exit;
  end;

  if (not (consultaDeEndereco.ExecutarConsulta(edtConteudoPesquisa.Text))) then
  begin
    MessageDlg('Nenhum registro foi encontrado através do filtro informado.', mtInformation, [mbOk], 0);
    edtConteudoPesquisa.SetFocus;
    Exit;
  end;
end;

procedure TFrmConsultaEnderecos.FormCreate(Sender: TObject);
begin
  consultaDeEndereco := TConsultaDeEndereco.Create;
end;

procedure TFrmConsultaEnderecos.FormDestroy(Sender: TObject);
begin
  FreeAndNil(consultaDeEndereco);
end;

end.
