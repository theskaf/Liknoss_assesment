object frmInsert: TfrmInsert
  Left = 0
  Top = 0
  Caption = #917#953#963#945#947#969#947#942
  ClientHeight = 380
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 405
    Height = 380
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 0
    OnChanging = PageControl1Changing
    ExplicitWidth = 403
    ExplicitHeight = 377
    object TabSheet1: TTabSheet
      Caption = ' '#913#961#967#949#943#959' '#960#949#955#945#964#974#957' '
      object Label1: TLabel
        Left = 42
        Top = 22
        Width = 50
        Height = 15
        Caption = #922#969#948#953#954#972#962':'
      end
      object Label2: TLabel
        Left = 34
        Top = 65
        Width = 58
        Height = 15
        Caption = #917#960#969#957#965#956#943#945':'
      end
      object Label3: TLabel
        Left = 32
        Top = 108
        Width = 60
        Height = 15
        Caption = #916#953#949#973#952#965#957#963#951':'
      end
      object Label4: TLabel
        Left = 61
        Top = 151
        Width = 31
        Height = 15
        Caption = #913#934#924':'
      end
      object Label5: TLabel
        Left = 4
        Top = 194
        Width = 88
        Height = 15
        Caption = #928#953#963#964#969#964#953#954#972' '#972#961#953#959':'
        Enabled = False
      end
      object Label6: TLabel
        Left = 35
        Top = 237
        Width = 57
        Height = 15
        Caption = #928#969#955#942#963#949#953#962':'
        Enabled = False
      end
      object Edit1: TEdit
        Left = 112
        Top = 19
        Width = 120
        Height = 23
        TabOrder = 0
        OnExit = Edit1Exit
      end
      object Edit2: TEdit
        Left = 112
        Top = 62
        Width = 251
        Height = 23
        TabOrder = 1
        OnExit = Edit2Exit
      end
      object Edit3: TEdit
        Left = 112
        Top = 105
        Width = 251
        Height = 23
        TabOrder = 2
        OnExit = Edit3Exit
      end
      object Edit4: TEdit
        Left = 112
        Top = 148
        Width = 120
        Height = 23
        TabOrder = 3
        OnExit = Edit4Exit
      end
      object Edit5: TEdit
        Left = 112
        Top = 191
        Width = 120
        Height = 23
        Enabled = False
        TabOrder = 4
        OnKeyPress = Edit5KeyPress
      end
      object Edit6: TEdit
        Left = 112
        Top = 234
        Width = 120
        Height = 23
        Enabled = False
        TabOrder = 5
        OnKeyPress = Edit6KeyPress
      end
      object btnCustOK: TButton
        Left = 75
        Top = 312
        Width = 75
        Height = 25
        Caption = ' OK '
        TabOrder = 6
        OnClick = btnCustOKClick
      end
      object btnCancel13: TButton
        Left = 250
        Top = 312
        Width = 75
        Height = 25
        Caption = #913#954#973#961#969#963#951
        TabOrder = 7
        OnClick = btnCancel13Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = ' '#922#953#957#942#963#949#953#962' '#960#953#963#964#969#964#953#954#959#973' '#959#961#943#959#965' '
      ImageIndex = 1
      object Label7: TLabel
        Left = 42
        Top = 22
        Width = 50
        Height = 15
        Caption = #922#969#948#953#954#972#962':'
      end
      object Label8: TLabel
        Left = 24
        Top = 65
        Width = 68
        Height = 15
        Caption = #919#956#949#961#959#956#951#957#943#945':'
      end
      object Label9: TLabel
        Left = 66
        Top = 108
        Width = 26
        Height = 15
        Caption = #913#958#943#945':'
      end
      object btnCredTranOK: TButton
        Left = 75
        Top = 312
        Width = 75
        Height = 25
        Caption = ' OK '
        TabOrder = 3
        OnClick = btnCredTranOKClick
      end
      object Edit7: TEdit
        Left = 112
        Top = 19
        Width = 120
        Height = 23
        TabOrder = 0
        OnExit = Edit7Exit
      end
      object Edit8: TEdit
        Left = 112
        Top = 105
        Width = 120
        Height = 23
        TabOrder = 2
        OnExit = Edit8Exit
        OnKeyPress = Edit8KeyPress
      end
      object DateTimePicker1: TDateTimePicker
        Left = 112
        Top = 62
        Width = 120
        Height = 23
        Date = 45058.000000000000000000
        Time = 0.799513229168951500
        TabOrder = 1
      end
      object btnCancel23: TButton
        Left = 250
        Top = 312
        Width = 75
        Height = 25
        Caption = #913#954#973#961#969#963#951
        TabOrder = 4
        OnClick = btnCancel23Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = ' '#913#961#967#949#943#959' '#928#945#961#945#947#947#949#955#953#974#957' '
      ImageIndex = 2
      object Label10: TLabel
        Left = 62
        Top = 22
        Width = 50
        Height = 15
        Caption = #922#969#948#953#954#972#962':'
      end
      object Label11: TLabel
        Left = 44
        Top = 65
        Width = 68
        Height = 15
        Caption = #919#956#949#961#959#956#951#957#943#945':'
      end
      object Label12: TLabel
        Left = 4
        Top = 108
        Width = 108
        Height = 15
        Caption = #928#949#961#953#947#961#945#966#942' '#954#943#957#951#963#951#962':'
      end
      object Label13: TLabel
        Left = 86
        Top = 151
        Width = 26
        Height = 15
        Caption = #913#958#943#945':'
      end
      object btnSalesOK: TButton
        Left = 75
        Top = 312
        Width = 75
        Height = 25
        Caption = ' OK '
        TabOrder = 5
        OnClick = btnSalesOKClick
      end
      object btnCancel33: TButton
        Left = 250
        Top = 312
        Width = 75
        Height = 25
        Caption = #913#954#973#961#969#963#951
        TabOrder = 6
        OnClick = btnCancel33Click
      end
      object Edit9: TEdit
        Left = 137
        Top = 19
        Width = 120
        Height = 23
        TabOrder = 0
        OnExit = Edit9Exit
      end
      object DateTimePicker2: TDateTimePicker
        Left = 137
        Top = 62
        Width = 120
        Height = 23
        Date = 45059.000000000000000000
        Time = 0.291390243059140600
        TabOrder = 1
      end
      object Edit10: TEdit
        Left = 137
        Top = 105
        Width = 255
        Height = 23
        TabOrder = 2
        OnExit = Edit10Exit
      end
      object Edit11: TEdit
        Left = 137
        Top = 148
        Width = 120
        Height = 23
        TabOrder = 3
        OnExit = Edit11Exit
        OnKeyPress = Edit11KeyPress
      end
      object Edit12: TEdit
        Left = 271
        Top = 148
        Width = 121
        Height = 23
        Enabled = False
        TabOrder = 4
      end
    end
  end
end
