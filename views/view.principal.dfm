object FrmConsultaEnderecos: TFrmConsultaEnderecos
  Left = 0
  Top = 0
  Caption = 'Desafio Softplan  Delphi - Consulta Endere'#231'o'
  ClientHeight = 442
  ClientWidth = 856
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object lblTitulo: TLabel
    Left = 0
    Top = 0
    Width = 856
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
  object GbPesquisa: TGroupBox
    Left = 0
    Top = 32
    Width = 856
    Height = 62
    Align = alTop
    Caption = ' Pesquisa '
    TabOrder = 0
    ExplicitWidth = 628
    object lblDica: TLabel
      Left = 2
      Top = 47
      Width = 852
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
      Width = 777
      Height = 30
      Hint = 'Informe o conte'#250'do'
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      ExplicitWidth = 549
      ExplicitHeight = 23
    end
    object btnPesquisar: TButton
      Left = 779
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
      ExplicitLeft = 551
    end
  end
  object GbDados: TGroupBox
    Left = 0
    Top = 94
    Width = 856
    Height = 348
    Align = alClient
    Caption = ' Resultados '
    TabOrder = 1
    ExplicitWidth = 628
    object lstResultado: TListView
      Left = 2
      Top = 42
      Width = 852
      Height = 304
      Align = alClient
      Columns = <
        item
          AutoSize = True
          Caption = 'Cep'
          MinWidth = 100
        end
        item
          AutoSize = True
          Caption = 'Uf'
          MinWidth = 50
        end
        item
          AutoSize = True
          Caption = 'Localidade'
          MinWidth = 100
        end
        item
          AutoSize = True
          Caption = 'Logradouro'
          MinWidth = 100
        end
        item
          AutoSize = True
          Caption = 'Bairro'
          MinWidth = 100
        end
        item
          AutoSize = True
          Caption = 'Complemento'
          MinWidth = 100
        end
        item
          AutoSize = True
          Caption = 'Ddd'
          MinWidth = 50
        end
        item
          AutoSize = True
          Caption = 'Gia'
          MinWidth = 50
        end
        item
          AutoSize = True
          Caption = 'Ibge'
          MinWidth = 50
        end
        item
          AutoSize = True
          Caption = 'Siafi'
          MinWidth = 50
        end>
      ColumnClick = False
      FullDrag = True
      GridLines = True
      TileColumns = <
        item
          Order = 1
        end>
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      ExplicitLeft = 226
      ExplicitTop = 48
      ExplicitWidth = 624
    end
    object btnCarregarDados: TButton
      Left = 2
      Top = 17
      Width = 852
      Height = 25
      Align = alTop
      Caption = 'Carregar Dados'
      TabOrder = 1
      OnClick = btnCarregarDadosClick
      ExplicitWidth = 624
    end
  end
end
