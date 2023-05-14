object dtmDM: TdtmDM
  OnCreate = DataModuleCreate
  Height = 394
  Width = 518
  object AdoConn: TADOConnection
    DefaultDatabase = 'OrdersMiniDB'
    LoginPrompt = False
    Provider = 'SQLNCLI11.1'
    BeforeConnect = AdoConnBeforeConnect
    Left = 48
    Top = 16
  end
  object qrCustomers: TADOQuery
    Connection = AdoConn
    CursorType = ctStatic
    AfterScroll = qrCustomersAfterScroll
    OnCalcFields = qrCustomersCalcFields
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM CUSTOMERS ORDER BY CODE DESC, NAME')
    Left = 176
    Top = 16
    object qrCustomersID: TAutoIncField
      FieldName = 'ID'
      ReadOnly = True
    end
    object qrCustomersCODE: TWideStringField
      FieldName = 'CODE'
      Size = 100
    end
    object qrCustomersNAME: TWideStringField
      FieldName = 'NAME'
      Size = 100
    end
    object qrCustomersADDRESS: TWideStringField
      FieldName = 'ADDRESS'
      Size = 100
    end
    object qrCustomersVAT: TWideStringField
      FieldName = 'VAT'
      Size = 11
    end
    object qrCustomersCREDLIMIT: TBCDField
      FieldName = 'CREDLIMIT'
      Precision = 12
      Size = 2
    end
    object qrCustomersSALES: TBCDField
      FieldName = 'SALES'
      Precision = 12
      Size = 2
    end
    object qrCustomersincTest: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'incTest'
      Calculated = True
    end
  end
  object dsCustomers: TDataSource
    DataSet = qrCustomers
    Left = 200
    Top = 40
  end
  object qVCustCredTrans: TADOQuery
    Connection = AdoConn
    CursorType = ctStatic
    Filtered = True
    Parameters = <
      item
        Name = 'pCustomerCode'
        DataType = ftWideString
        Size = 13
        Value = 'CODE'
      end>
    SQL.Strings = (
      'SELECT * FROM VCUSTCREDTRANS ORDER BY CODE')
    Left = 304
    Top = 16
    object qVCustCredTransCID: TIntegerField
      FieldName = 'CID'
    end
    object qVCustCredTransCODE: TWideStringField
      FieldName = 'CODE'
      Size = 100
    end
    object qVCustCredTransCNAME: TWideStringField
      FieldName = 'CNAME'
      Size = 100
    end
    object qVCustCredTransCADDRESS: TWideStringField
      FieldName = 'CADDRESS'
      Size = 100
    end
    object qVCustCredTransCVAT: TWideStringField
      FieldName = 'CVAT'
      Size = 11
    end
    object qVCustCredTransCCDREDITLIMIT: TBCDField
      FieldName = 'CCDREDITLIMIT'
      Precision = 12
      Size = 2
    end
    object qVCustCredTransCSALES: TBCDField
      FieldName = 'CSALES'
      Precision = 12
      Size = 2
    end
    object qVCustCredTransTID: TIntegerField
      FieldName = 'TID'
    end
    object qVCustCredTransTTRANSDATE: TDateField
      FieldName = 'TTRANSDATE'
    end
    object qVCustCredTransTVALUE: TBCDField
      FieldName = 'TVALUE'
      Precision = 12
      Size = 2
    end
  end
  object qVCustOrders: TADOQuery
    Connection = AdoConn
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'pCustomerCode'
        DataType = ftWideString
        Size = 13
        Value = 'CODE'
      end>
    SQL.Strings = (
      'SELECT * FROM VCUSTORDERS ORDER BY CODE')
    Left = 416
    Top = 16
    object qVCustOrdersCID: TIntegerField
      FieldName = 'CID'
    end
    object qVCustOrdersCODE: TWideStringField
      FieldName = 'CODE'
      Size = 100
    end
    object qVCustOrdersCNAME: TWideStringField
      FieldName = 'CNAME'
      Size = 100
    end
    object qVCustOrdersCADDRESS: TWideStringField
      FieldName = 'CADDRESS'
      Size = 100
    end
    object qVCustOrdersCVAT: TWideStringField
      FieldName = 'CVAT'
      Size = 11
    end
    object qVCustOrdersCCDREDITLIMIT: TBCDField
      FieldName = 'CCDREDITLIMIT'
      Precision = 12
      Size = 2
    end
    object qVCustOrdersCSALES: TBCDField
      FieldName = 'CSALES'
      Precision = 12
      Size = 2
    end
    object qVCustOrdersOID: TIntegerField
      FieldName = 'OID'
    end
    object qVCustOrdersOSERVICEDATE: TDateField
      FieldName = 'OSERVICEDATE'
    end
    object qVCustOrdersODESCR: TWideStringField
      FieldName = 'ODESCR'
      Size = 100
    end
    object qVCustOrdersOVALUE: TBCDField
      FieldName = 'OVALUE'
      Precision = 12
      Size = 2
    end
  end
  object dsCustCredTrans: TDataSource
    DataSet = qVCustCredTrans
    Left = 320
    Top = 40
  end
  object dsCustOrders: TDataSource
    DataSet = qVCustOrders
    Left = 432
    Top = 40
  end
  object qrCredTrans: TADOQuery
    Connection = AdoConn
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'SELECT C.ID AS CID, C.CODE AS CODE, C.NAME AS CNAME, T.ID AS TID' +
        ', T.TRANSDATE AS TTRANSDATE, T.VALUE AS TVALUE'
      
        'FROM CUSTOMERS C INNER JOIN CREDTRANSACTIONS T WITH (NOLOCK) ON ' +
        'C.CODE = T.CUSTOMER_CODE '
      'ORDER BY T.TRANSDATE, C.CODE')
    Left = 176
    Top = 104
    object qrCredTransCID: TAutoIncField
      FieldName = 'CID'
      ReadOnly = True
    end
    object qrCredTransCODE: TWideStringField
      FieldName = 'CODE'
      Size = 100
    end
    object qrCredTransCNAME: TWideStringField
      FieldName = 'CNAME'
      Size = 100
    end
    object qrCredTransTID: TAutoIncField
      FieldName = 'TID'
      ReadOnly = True
    end
    object qrCredTransTTRANSDATE: TDateField
      FieldName = 'TTRANSDATE'
    end
    object qrCredTransTVALUE: TBCDField
      FieldName = 'TVALUE'
      Precision = 12
      Size = 2
    end
  end
  object dsCredTrans: TDataSource
    DataSet = qrCredTrans
    Left = 200
    Top = 128
  end
  object qrOrders: TADOQuery
    Connection = AdoConn
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'SELECT C.ID AS CID, C.CODE AS CODE, C.NAME AS CNAME, O.ID AS OID' +
        ', O.SERVICE_DATE AS OSERVICEDATE, O.DESCRIPTION AS ODESCR, O.VAL' +
        'UE AS OVALUE'
      
        'FROM CUSTOMERS C INNER JOIN ORDERS O WITH (NOLOCK) ON C.CODE = O' +
        '.CUSTOMER_CODE '
      'ORDER BY O.SERVICE_DATE, C.CODE')
    Left = 176
    Top = 192
    object qrOrdersCID: TAutoIncField
      FieldName = 'CID'
      ReadOnly = True
    end
    object qrOrdersCODE: TWideStringField
      FieldName = 'CODE'
      Size = 100
    end
    object qrOrdersCNAME: TWideStringField
      FieldName = 'CNAME'
      Size = 100
    end
    object qrOrdersOID: TAutoIncField
      FieldName = 'OID'
      ReadOnly = True
    end
    object qrOrdersOSERVICEDATE: TDateField
      FieldName = 'OSERVICEDATE'
    end
    object qrOrdersODESCR: TWideStringField
      FieldName = 'ODESCR'
      Size = 100
    end
    object qrOrdersOVALUE: TBCDField
      FieldName = 'OVALUE'
      Precision = 12
      Size = 2
    end
  end
  object dsOrders: TDataSource
    DataSet = qrOrders
    Left = 200
    Top = 216
  end
  object cdsInputPrint: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 272
    object cdsInputPrintCode: TStringField
      FieldName = 'Code'
      Size = 100
    end
    object cdsInputPrintDateFrom: TDateField
      FieldName = 'DateFrom'
    end
    object cdsInputPrintDateTo: TDateField
      FieldName = 'DateTo'
    end
  end
  object dsInput: TDataSource
    DataSet = cdsInputPrint
    Left = 64
    Top = 296
  end
  object qrPrint: TADOQuery
    Connection = AdoConn
    CursorType = ctStatic
    Parameters = <>
    Left = 416
    Top = 280
    object qrPrintCODE: TWideStringField
      DisplayLabel = #922#969#948#953#954#972#962
      FieldName = 'CODE'
      Size = 100
    end
    object qrPrintCNAME: TWideStringField
      DisplayLabel = #917#960#969#957#965#956#943#945
      FieldName = 'CNAME'
      Size = 100
    end
    object qrPrintOSERVICEDATE: TDateField
      DisplayLabel = #919#956#949#961#959#956#951#957#943#945
      FieldName = 'OSERVICEDATE'
    end
    object qrPrintODESCR: TWideStringField
      DisplayLabel = #928#949#961#953#947#961#945#966#942' '#965#960#951#961#949#963#943#945#962
      FieldName = 'ODESCR'
      Size = 100
    end
    object qrPrintOVALUE: TBCDField
      DisplayLabel = #913#958#943#945
      FieldName = 'OVALUE'
      Precision = 12
      Size = 2
    end
  end
  object dsPrint: TDataSource
    DataSet = qrPrint
    Left = 432
    Top = 296
  end
end
