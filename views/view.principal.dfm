object FrmConsultaEnderecos: TFrmConsultaEnderecos
  Left = 0
  Top = 0
  Caption = 'Desafio Softplan  Delphi - Consulta Endere'#231'o'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 628
    Height = 32
    Align = alTop
    Alignment = taCenter
    Caption = 'Pesquisa ViaCep'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 185
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 32
    Width = 628
    Height = 62
    Align = alTop
    Caption = ' Pesquisa '
    TabOrder = 0
    object Label2: TLabel
      Left = 2
      Top = 47
      Width = 624
      Height = 13
      Align = alBottom
      Caption = 
        'Dica: Pesquisa por endere'#231'o, separar por v'#237'rgula seguindo a orde' +
        'm Estado, Cidade, Logradouro'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 496
    end
    object edtConteudoPesquisa: TEdit
      Left = 2
      Top = 17
      Width = 549
      Height = 30
      Hint = 'Informe o conte'#250'do'
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      ExplicitHeight = 23
    end
    object btnPesquisar: TButton
      Left = 551
      Top = 17
      Width = 75
      Height = 30
      Hint = 'Pesquisar'
      Align = alRight
      Caption = 'Pesquisar'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnPesquisarClick
      ExplicitHeight = 33
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 94
    Width = 628
    Height = 348
    Align = alClient
    Caption = ' Resultados '
    TabOrder = 1
    ExplicitTop = 84
    ExplicitHeight = 358
    object LstResultados: TListView
      Left = 2
      Top = 17
      Width = 624
      Height = 329
      Align = alClient
      Columns = <
        item
          MaxWidth = -1
          Width = -1
          WidthType = (
            -1)
        end>
      ColumnClick = False
      GridLines = True
      RowSelect = True
      SortType = stText
      TabOrder = 0
      ViewStyle = vsList
      ExplicitHeight = 339
    end
    object ListBox1: TListBox
      Left = 2
      Top = 17
      Width = 624
      Height = 329
      Align = alClient
      ItemHeight = 15
      TabOrder = 1
      ExplicitLeft = 152
      ExplicitTop = 128
      ExplicitWidth = 121
      ExplicitHeight = 97
    end
  end
end
