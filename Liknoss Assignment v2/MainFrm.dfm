object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Liknoss assignment for Dev candidates'
  ClientHeight = 505
  ClientWidth = 875
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  TextHeight = 15
  object Panel1: TPanel
    Left = 774
    Top = 0
    Width = 101
    Height = 468
    Align = alRight
    TabOrder = 0
    ExplicitLeft = 772
    ExplicitHeight = 465
    DesignSize = (
      101
      468)
    object lblV: TLabel
      Left = 51
      Top = 448
      Width = 40
      Height = 11
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'xxxxxxxxxx'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitTop = 381
    end
    object btnInsert: TButton
      Left = 16
      Top = 206
      Width = 75
      Height = 25
      Caption = #917#953#963#945#947#969#947#942
      TabOrder = 3
      OnClick = btnInsertClick
    end
    object btnDelete: TButton
      Left = 16
      Top = 86
      Width = 75
      Height = 25
      Caption = #916#953#945#947#961#945#966#942
      TabOrder = 1
      OnClick = btnDeleteClick
    end
    object btnEdit: TButton
      Left = 16
      Top = 146
      Width = 75
      Height = 25
      Caption = #916#953#972#961#952#969#963#951
      TabOrder = 2
      OnClick = btnEditClick
    end
    object btnView: TButton
      Left = 16
      Top = 26
      Width = 75
      Height = 25
      Caption = #928#961#959#946#959#955#942
      TabOrder = 0
      OnClick = btnViewClick
    end
    object btnExcel: TButton
      Left = 16
      Top = 263
      Width = 75
      Height = 25
      Caption = 'Excel'
      TabOrder = 4
      OnClick = btnExcelClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 468
    Width = 875
    Height = 37
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 465
    ExplicitWidth = 873
    object btnExit: TButton
      Left = 368
      Top = 7
      Width = 75
      Height = 25
      Caption = ' '#904#958#959#948#959#962' '
      TabOrder = 0
      OnClick = btnExitClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 774
    Height = 468
    ActivePage = tabCustomer
    Align = alClient
    TabOrder = 2
    OnChange = PageControl1Change
    ExplicitWidth = 772
    ExplicitHeight = 465
    object tabCustomer: TTabSheet
      Caption = #928#949#955#940#964#949#962
      object Splitter1: TSplitter
        Left = 0
        Top = 185
        Width = 766
        Height = 8
        Cursor = crVSplit
        Align = alTop
        ExplicitTop = 184
        ExplicitWidth = 765
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 766
        Height = 185
        Align = alTop
        TabOrder = 0
        ExplicitWidth = 764
        object DBGrid1: TDBGrid
          Left = 1
          Top = 1
          Width = 764
          Height = 183
          Align = alClient
          DataSource = dtmDM.dsCustomers
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'incTest'
              Title.Caption = #913'/'#913
              Width = 37
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CODE'
              Title.Caption = #922#969#948#953#954#972#962
              Width = 63
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'NAME'
              Title.Caption = #917#960#969#957#965#956#943#945
              Width = 198
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ADDRESS'
              Title.Caption = #916#953#949#973#952#965#957#963#951
              Width = 192
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'VAT'
              Title.Caption = #913#934#924
              Width = 74
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CREDLIMIT'
              Title.Caption = #928'. '#908#961#953#959
              Width = 50
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'SALES'
              Title.Caption = #928#969#955#942#963#949#953#962
              Width = 69
              Visible = True
            end>
        end
      end
      object Panel4: TPanel
        Left = 0
        Top = 193
        Width = 766
        Height = 245
        Align = alClient
        TabOrder = 1
        ExplicitWidth = 764
        ExplicitHeight = 242
        object PageControl2: TPageControl
          Left = 1
          Top = 1
          Width = 764
          Height = 243
          ActivePage = tabCustCredTrans
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 762
          ExplicitHeight = 240
          object tabCustCredTrans: TTabSheet
            Caption = ' '#922#953#957#942#963#949#953#962' '#960#953#963#964#969#964#953#954#959#973' '#959#961#943#959#965' '
            object DBGrid2: TDBGrid
              Left = 0
              Top = 0
              Width = 756
              Height = 213
              Align = alClient
              DataSource = dtmDM.dsCustCredTrans
              ReadOnly = True
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -12
              TitleFont.Name = 'Segoe UI'
              TitleFont.Style = []
              Columns = <
                item
                  Expanded = False
                  FieldName = 'CODE'
                  Title.Caption = #922#969#948#953#954#972#962
                  Width = 100
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'CNAME'
                  Title.Caption = #917#960#969#957#965#956#943#945
                  Width = 190
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'TTRANSDATE'
                  Title.Caption = #919#956#949#961#959#956#951#957#943#945
                  Width = 80
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'TVALUE'
                  Title.Caption = #913#958#943#945
                  Width = 80
                  Visible = True
                end>
            end
          end
          object tabCustOrders: TTabSheet
            Caption = ' '#928#945#961#945#947#947#949#955#943#949#962' '
            ImageIndex = 1
            object DBGrid3: TDBGrid
              Left = 0
              Top = 0
              Width = 756
              Height = 213
              Align = alClient
              DataSource = dtmDM.dsCustOrders
              ReadOnly = True
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -12
              TitleFont.Name = 'Segoe UI'
              TitleFont.Style = []
              Columns = <
                item
                  Expanded = False
                  FieldName = 'CODE'
                  Title.Caption = #922#969#948#953#954#972#962
                  Width = 99
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'CNAME'
                  Title.Caption = #917#960#969#957#965#956#943#945
                  Width = 196
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'OSERVICEDATE'
                  Title.Caption = #919#956#949#961#959#956#951#957#943#945
                  Width = 80
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'ODESCR'
                  Title.Caption = #928#949#961#953#947#961#945#966#942' '#933#960#951#961#949#963#943#945#962
                  Width = 128
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'OVALUE'
                  Title.Caption = #913#958#943#945
                  Width = 80
                  Visible = True
                end>
            end
          end
        end
      end
    end
    object tabCredTrans: TTabSheet
      Caption = #922#953#957#942#963#949#953#962' '#960#953#963#964#969#964#953#954#959#973' '#959#961#943#959#965
      ImageIndex = 1
      object DBGrid4: TDBGrid
        Left = 0
        Top = 0
        Width = 766
        Height = 438
        Align = alClient
        DataSource = dtmDM.dsCredTrans
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'CODE'
            Title.Caption = #922#969#948#953#954#972#962
            Width = 99
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CNAME'
            Title.Caption = #917#960#969#957#965#956#943#945' '#960#949#955#940#964#951
            Width = 175
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TTRANSDATE'
            Title.Caption = #919#956#949#961#959#956#951#957#943#945
            Width = 195
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TVALUE'
            Title.Caption = #913#958#943#945
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CID'
            Visible = False
          end>
      end
    end
    object tabOrders: TTabSheet
      Caption = #928#945#961#945#947#947#949#955#943#949#962
      ImageIndex = 2
      object DBGrid5: TDBGrid
        Left = 0
        Top = 0
        Width = 766
        Height = 438
        Align = alClient
        DataSource = dtmDM.dsOrders
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'CODE'
            Title.Caption = #922#969#948#953#954#972#962
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CNAME'
            Title.Caption = #917#960#969#957#965#956#943#945' '#960#949#955#940#964#951
            Width = 175
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OSERVICEDATE'
            Title.Caption = #919#956#949#961#959#956#951#957#943#945
            Width = 85
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ODESCR'
            Title.Caption = #928#949#961#953#947#961#945#966#942' '#933#960#951#961#949#963#943#945#962
            Width = 180
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OVALUE'
            Title.Caption = #913#958#943#945
            Width = 60
            Visible = True
          end>
      end
    end
    object tabPrint: TTabSheet
      Caption = #917#954#964#973#960#969#963#951' '#960#945#961#945#947#947#949#955#953#974#957' '#960#949#955#945#964#974#957
      ImageIndex = 3
      object TPanel
        Left = 0
        Top = 0
        Width = 766
        Height = 73
        Align = alTop
        TabOrder = 0
        ExplicitWidth = 765
        object Label1: TLabel
          Left = 8
          Top = 14
          Width = 46
          Height = 15
          Caption = #928#949#955#940#964#951#962
        end
        object Label2: TLabel
          Left = 31
          Top = 45
          Width = 23
          Height = 15
          Caption = #913#960#972
        end
        object Label3: TLabel
          Left = 231
          Top = 45
          Width = 24
          Height = 15
          Caption = #904#969#962
        end
        object btnFind: TButton
          Left = 434
          Top = 22
          Width = 75
          Height = 25
          Caption = #913#957#949#973#961#949#963#951
          TabOrder = 0
          OnClick = btnFindClick
        end
        object btnPrint: TButton
          Left = 575
          Top = 22
          Width = 75
          Height = 25
          Caption = #917#954#964#973#960#969#963#951
          TabOrder = 1
          OnClick = btnPrintClick
        end
        object dtTo: TDateTimePicker
          Left = 261
          Top = 41
          Width = 89
          Height = 23
          Date = 45057.000000000000000000
          Time = 0.680503217590740000
          TabOrder = 2
        end
        object dtFrom: TDateTimePicker
          Left = 60
          Top = 41
          Width = 89
          Height = 23
          Date = 45057.000000000000000000
          Time = 0.680503217590740000
          TabOrder = 3
        end
        object DBLookupComboBox1: TDBLookupComboBox
          Left = 60
          Top = 10
          Width = 290
          Height = 23
          DataField = 'Code'
          DataSource = dtmDM.dsInput
          KeyField = 'CODE'
          ListField = 'CODE; NAME'
          ListSource = dtmDM.dsCustomers
          TabOrder = 4
          OnCloseUp = DBLookupComboBox1CloseUp
          OnDropDown = DBLookupComboBox1DropDown
        end
      end
      object DBGrid6: TDBGrid
        Left = 0
        Top = 73
        Width = 766
        Height = 365
        Align = alClient
        DataSource = dtmDM.dsPrint
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'CODE'
            Width = 91
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CNAME'
            Width = 223
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OSERVICEDATE'
            Width = 87
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ODESCR'
            Width = 165
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OVALUE'
            Width = 68
            Visible = True
          end>
      end
    end
  end
end
