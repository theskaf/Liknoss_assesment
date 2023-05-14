unit DMDtm;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Datasnap.DBClient,
  Vcl.Dialogs, Winapi.Windows,
  System.IOUtils, System.Win.ComObj;

type
  TdtmDM = class(TDataModule)
    AdoConn: TADOConnection;
    qrCustomers: TADOQuery;
    qrCustomersID: TAutoIncField;
    qrCustomersCODE: TWideStringField;
    qrCustomersNAME: TWideStringField;
    qrCustomersADDRESS: TWideStringField;
    qrCustomersVAT: TWideStringField;
    qrCustomersCREDLIMIT: TBCDField;
    qrCustomersSALES: TBCDField;
    dsCustomers: TDataSource;
    qVCustCredTrans: TADOQuery;
    qVCustOrders: TADOQuery;
    dsCustCredTrans: TDataSource;
    dsCustOrders: TDataSource;
    qVCustCredTransCID: TIntegerField;
    qVCustCredTransCODE: TWideStringField;
    qVCustCredTransCNAME: TWideStringField;
    qVCustCredTransCADDRESS: TWideStringField;
    qVCustCredTransCVAT: TWideStringField;
    qVCustCredTransCCDREDITLIMIT: TBCDField;
    qVCustCredTransCSALES: TBCDField;
    qVCustCredTransTID: TIntegerField;
    qVCustCredTransTTRANSDATE: TDateField;
    qVCustCredTransTVALUE: TBCDField;
    qVCustOrdersCID: TIntegerField;
    qVCustOrdersCODE: TWideStringField;
    qVCustOrdersCNAME: TWideStringField;
    qVCustOrdersCADDRESS: TWideStringField;
    qVCustOrdersCVAT: TWideStringField;
    qVCustOrdersCCDREDITLIMIT: TBCDField;
    qVCustOrdersCSALES: TBCDField;
    qVCustOrdersOID: TIntegerField;
    qVCustOrdersOSERVICEDATE: TDateField;
    qVCustOrdersODESCR: TWideStringField;
    qVCustOrdersOVALUE: TBCDField;
    qrCustomersincTest: TIntegerField;
    qrCredTrans: TADOQuery;
    dsCredTrans: TDataSource;
    qrOrders: TADOQuery;
    dsOrders: TDataSource;
    qrCredTransCID: TAutoIncField;
    qrCredTransCODE: TWideStringField;
    qrCredTransCNAME: TWideStringField;
    qrCredTransTID: TAutoIncField;
    qrCredTransTTRANSDATE: TDateField;
    qrCredTransTVALUE: TBCDField;
    qrOrdersCID: TAutoIncField;
    qrOrdersCODE: TWideStringField;
    qrOrdersCNAME: TWideStringField;
    qrOrdersOID: TAutoIncField;
    qrOrdersOSERVICEDATE: TDateField;
    qrOrdersODESCR: TWideStringField;
    qrOrdersOVALUE: TBCDField;
    cdsInputPrint: TClientDataSet;
    cdsInputPrintCode: TStringField;
    cdsInputPrintDateFrom: TDateField;
    cdsInputPrintDateTo: TDateField;
    dsInput: TDataSource;
    qrPrint: TADOQuery;
    dsPrint: TDataSource;
    qrPrintCODE: TWideStringField;
    qrPrintCNAME: TWideStringField;
    qrPrintOSERVICEDATE: TDateField;
    qrPrintODESCR: TWideStringField;
    qrPrintOVALUE: TBCDField;
    procedure DataModuleCreate(Sender: TObject);
    procedure AdoConnBeforeConnect(Sender: TObject);
    procedure qrCustomersCalcFields(DataSet: TDataSet);
    procedure qrCustomersAfterScroll(DataSet: TDataSet);
  private
    procedure LogError(const Msg, RecordID: string);

  public
    function fileVer: string;
    function VulnerableAF(conne: string): string;
    procedure XcelUpd;
    function DeleteCust(const CustomerCode: string): Boolean;
    function DeleteCreditTransaction(const CustomerCode: string; const CreditTransactionID: Integer): Boolean;
    function DeleteOrder(const CustomerCode: string; const OrderID: Integer): Boolean;
  end;

var
  dtmDM: TdtmDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdtmDM.AdoConnBeforeConnect(Sender: TObject); //ShowMessage(AdoConn.ConnectionString);
var
  strConnectionString, strUserID, strNewConnectionString: string;
begin
  //Άκομψες πρακτικές κατά την γνώμη μου, θέματα ασφαλείας κλπ αλλά ήταν στα απαιτούμενα η διαχείριση με ini κλπ
  //TODO: encode credentials, store in registry - αν έχω αρκετό χρόνο
  try
    strConnectionString := AdoConn.ConnectionString;

    if Pos('User ID=', strConnectionString) > 0 then
    begin
      strUserID := Copy(strConnectionString, Pos('User ID=', strConnectionString) + 8, MaxInt);
      strNewConnectionString := StringReplace(strConnectionString, 'User ID=' + strUserID, 'User Id=LiknossUser; Password=pass123;', []);
    end
    else
    begin
      strNewConnectionString := strConnectionString + 'User Id=LiknossUser; Password=pass123;';
    end;

    AdoConn.ConnectionString := strNewConnectionString;
  except
    on e: Exception do
    begin
        ShowMessage('Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message);
        AdoConn.ConnectionString := strConnectionString;
    end;
  end;
end;

procedure TdtmDM.DataModuleCreate(Sender: TObject);
begin
  cdsInputPrint.CreateDataSet;
end;

function TdtmDM.DeleteCreditTransaction(const CustomerCode: string; const CreditTransactionID: Integer): Boolean;
var
  CustomerID: string;
  bRes: Boolean;
  QrDelCredit, QrUpdateCust: TADOQuery;
  DelCreditConn: TADOConnection;
  CreditValue: Currency;
begin
  bRes := False;
  CustomerID := CustomerCode;
  DelCreditConn := dtmDM.AdoConn;
  QrDelCredit := TADOQuery.Create(nil);
  QrUpdateCust := TADOQuery.Create(nil);

  try
    QrDelCredit.Connection := DelCreditConn;
    QrUpdateCust.Connection := DelCreditConn;

    DelCreditConn.BeginTrans; // start tran
    try
      QrDelCredit.SQL.Text := 'SELECT ISNULL([VALUE],0) AS VALUE FROM CREDTRANSACTIONS WHERE [ID] = :CreditTransactionID';
      QrDelCredit.Parameters.ParamByName('CreditTransactionID').Value := CreditTransactionID;
      QrDelCredit.Open;
      CreditValue := QrDelCredit.FieldByName('VALUE').AsCurrency;
      QrDelCredit.Close;

      QrDelCredit.SQL.Text := 'DELETE FROM CREDTRANSACTIONS WHERE [ID] = :CreditTransactionID';
      QrDelCredit.Parameters.ParamByName('CreditTransactionID').Value := CreditTransactionID;
      QrDelCredit.ExecSQL;

      QrUpdateCust.SQL.Text := 'UPDATE CUSTOMERS SET [CREDLIMIT] = ISNULL([CREDLIMIT],0) - :CreditValue WHERE [CODE] = :CustomerID';
      QrUpdateCust.Parameters.ParamByName('CreditValue').Value := CreditValue;
      QrUpdateCust.Parameters.ParamByName('CustomerID').Value := CustomerID;
      QrUpdateCust.ExecSQL;

      DelCreditConn.CommitTrans; // commit tran
      bRes := True;
    except
      DelCreditConn.RollbackTrans; // rollback tran
      bRes := False;
    end;

  finally
    QrDelCredit.Free;
    QrUpdateCust.Free;
  end;

  Result := bRes;
end;

function TdtmDM.DeleteCust(const CustomerCode: string): Boolean;
var
  bRes: Boolean;
  CustomerID: string;
  QrDelSpecific: TADOQuery;
  DelSpecificConn: TADOConnection;
begin
  bRes := False;
  CustomerID := CustomerCode;

  DelSpecificConn := dtmDM.AdoConn;
  QrDelSpecific := TADOQuery.Create(nil);
  try
    QrDelSpecific.Connection := DelSpecificConn;
    DelSpecificConn.BeginTrans; // start tran
    try
      QrDelSpecific.SQL.Text := 'DELETE FROM CREDTRANSACTIONS WHERE [CUSTOMER_CODE] = :CustomerID';
      QrDelSpecific.Parameters.ParamByName('CustomerID').Value := CustomerID;
      QrDelSpecific.ExecSQL;

      QrDelSpecific.SQL.Text := 'DELETE FROM ORDERS WHERE [CUSTOMER_CODE] = :CustomerID';
      QrDelSpecific.Parameters.ParamByName('CustomerID').Value := CustomerID;
      QrDelSpecific.ExecSQL;

      QrDelSpecific.SQL.Text := 'DELETE FROM CUSTOMERS WHERE [CODE] = :CustomerID';
      QrDelSpecific.Parameters.ParamByName('CustomerID').Value := CustomerID;
      QrDelSpecific.ExecSQL;

      DelSpecificConn.CommitTrans; // commit tran
      //ShowMessage('Επιτυχής διαγραφή.');
      bRes := True;
    except
      DelSpecificConn.RollbackTrans; // rollback tran
      //ShowMessage('Πρόβλημα στην διαγραφή.');
      bRes := False;
    end;
  finally
    QrDelSpecific.Free;
  end;
  Result := bRes;
end;

function TdtmDM.DeleteOrder(const CustomerCode: string; const OrderID: Integer): Boolean;
var
  CustomerID: string;
  bRes: Boolean;
  QrDelOrder, QrUpdateCust: TADOQuery;
  DelOrderConn: TADOConnection;
  OrderSales: Currency;
begin
  bRes := False;
  CustomerID := CustomerCode;
  DelOrderConn := dtmDM.AdoConn;
  QrDelOrder := TADOQuery.Create(nil);
  QrUpdateCust := TADOQuery.Create(nil);

  try
    QrDelOrder.Connection := DelOrderConn;
    QrUpdateCust.Connection := DelOrderConn;

    DelOrderConn.BeginTrans; // start tran
    try
      QrDelOrder.SQL.Text := 'SELECT ISNULL([VALUE],0) AS VALUE FROM ORDERS WHERE [ID] = :OrderID';
      QrDelOrder.Parameters.ParamByName('OrderID').Value := OrderID;
      QrDelOrder.Open;
      OrderSales := QrDelOrder.FieldByName('VALUE').AsCurrency;
      QrDelOrder.Close;

      QrDelOrder.SQL.Text := 'DELETE FROM ORDERS WHERE [ID] = :OrderID';
      QrDelOrder.Parameters.ParamByName('OrderID').Value := OrderID;
      QrDelOrder.ExecSQL;

      QrUpdateCust.SQL.Text := 'UPDATE CUSTOMERS SET [SALES] = ISNULL([SALES],0) - :OrderSales WHERE [CODE] = :CustomerID';
      QrUpdateCust.Parameters.ParamByName('OrderSales').Value := OrderSales;
      QrUpdateCust.Parameters.ParamByName('CustomerID').Value := CustomerID;
      QrUpdateCust.ExecSQL;

      DelOrderConn.CommitTrans; // commit tran
      bRes := True;
    except
      DelOrderConn.RollbackTrans; // rollback tran
      bRes := False;
    end;

  finally
    QrDelOrder.Free;
    QrUpdateCust.Free;
  end;
  Result := bRes;
end;



procedure TdtmDM.qrCustomersAfterScroll(DataSet: TDataSet);
begin
  try

    qVCustCredTrans.DisableControls;
    qVCustCredTrans.Active := True;
    try
      qVCustCredTrans.Filtered := False;
      qVCustCredTrans.Filter := 'CODE=''' + qrCustomers.FieldByName('CODE').AsString + '''';
      qVCustCredTrans.Filtered := True;
    finally
      qVCustCredTrans.EnableControls;
    end;

    qVCustOrders.DisableControls;
    qVCustOrders.Active := True;
    try
      qVCustOrders.Filtered := False;
      qVCustOrders.Filter := 'CODE=''' + qrCustomers.FieldByName('CODE').AsString + '''';
      qVCustOrders.Filtered := True;
    finally
      qVCustOrders.EnableControls;
    end;
    {qVCustCredTrans.Close;
    qVCustCredTrans.Parameters.ParamByName('pCustomerCode').Value := qrCustomers.FieldByName('CODE').AsString;
    qVCustCredTrans.Active := True;
    qVCustCredTrans.Open;

    qVCustOrders.Close;
    qVCustOrders.Parameters.ParamByName('pCustomerCode').Value := qrCustomers.FieldByName('CODE').AsString;
    qVCustOrders.Active := True;
    qVCustOrders.Open;}
  except
    on e: Exception do
    begin
      ShowMessage('Πρόβλημα W001 λειτουργίας, επικοινωνήστε με τον διαχειριστή αναφέροντας: Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message);
    end;
  end;
end;

procedure TdtmDM.qrCustomersCalcFields(DataSet: TDataSet);
begin
  if qrCustomers.RecNo < 0 then
    qrCustomersincTest.AsInteger := - qrCustomers.RecNo
  else
    qrCustomersincTest.AsInteger := qrCustomers.RecNo;
end;


function TdtmDM.VulnerableAF(conne: string): string;
var
  strNewConnectionString, strUserID: string;
begin
  if conne = EmptyStr then
  begin
    MessageDlg('Πρόβλημα Z101 λειτουργίας, επικοινωνήστε με τον διαχειριστή αναφέροντας πρόβλημα σύνδεσης με βάση ', mtError, mbOKCancel, 0);
    Abort;
  end
  else
  begin
    //VULERABLE CODE INC: <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    //TODO: encode credentials, store in registry - αν έχω αρκετό χρόνο <<<<<<<<
    try
      if Pos('User ID=', conne) > 0 then
      begin
        strUserID := Copy(conne, Pos('User ID=', conne) + 8, MaxInt);
        strNewConnectionString := StringReplace(conne, 'User ID=' + strUserID, 'User Id=LiknossUser; Password=pass123;', []);
      end
      else
      begin
        strNewConnectionString := conne + 'User Id=LiknossUser; Password=pass123;';
      end;

      Result := strNewConnectionString;
    except
      on e: Exception do
      begin
          ShowMessage('Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message);
          Result := conne;
      end;
    end;
    //VULERABLE CODE END <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  end;
end;

procedure TdtmDM.LogError(const Msg, RecordID: string);
var
  ErrorLog: TextFile;
  ErrorFileName: string;
begin
  ErrorFileName := ExtractFilePath(ParamStr(0)) + 'error.log';
  AssignFile(ErrorLog, ErrorFileName);
  Append(ErrorLog);
  try
    WriteLn(ErrorLog, Format('%s - Excel file Record ID: %s', [Msg, RecordID]));
    Flush(ErrorLog);
  finally
    CloseFile(ErrorLog);
  end;
end;

//Reqs:
//--- Θα πρέπει από ένα excel να γίνονται μαζικές ενημερώσεις του πιστωτικού ορίου των πελατών.
//--- Το πιστωτικό όριο ενός πελάτη ενημερώνεται από τις κινήσεις πιστωτικού ορίου.
procedure TdtmDM.XcelUpd; //TODO: Test <----- not tested thoroughly !!!!!!!!!!!!
// For example,  it is possible that the code is not reaching the LogError call
//due to an early exit from the XcelUpd procedure or due to an exception being raised earlier in the code, hence Flush(ErrorLog) :D
var
  ExcelApp, ExcelWorkbook, Sheet: Variant;
  i: Integer;
  strSQL: string;
  ADOConnXcl: TADOConnection;
  ADOQOneXcl, ADOQTwoXcl: TADOQuery;
  OpenDialog: TOpenDialog;
  bCheckPoint: Boolean;
begin
  bCheckPoint := False;

  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Filter := 'Excel files (*.xlsx)|*.xlsx|All files (*.*)|*.*';
    if OpenDialog.Execute then
    begin
      ADOConnXcl := TADOConnection.Create(nil);
      try
        //ADOConnXcl.ConnectionString := AdoConn.ConnectionString;
        ADOConnXcl.ConnectionString := VulnerableAF(AdoConn.ConnectionString);
        ADOConnXcl.LoginPrompt := False;
        ADOConnXcl.Open;

        try
          ExcelApp := CreateOleObject('Excel.Application');
          ExcelWorkbook := ExcelApp.Workbooks.Open(OpenDialog.FileName);
          Sheet := ExcelWorkbook.Sheets[1];


          try
            ADOQOneXcl := TADOQuery.Create(nil);
            ADOQTwoXcl := TADOQuery.Create(nil);
            try

              bCheckPoint := False;
              ADOQOneXcl.Connection := ADOConnXcl;
              ADOConnXcl.BeginTrans;
              for i := 2 to Sheet.UsedRange.Rows.Count do  //header assumed, more requirements??? eg the first tab/sheet???
              begin  //The first index is the row index and the second index is the column index, so Sheet.Cells[2, 2] would refer to cell B2 for example.
                strSQL :=
                  ' UPDATE [dbo].[CREDTRANSACTIONS] SET [TRANSDATE] = ' + QuotedStr(Sheet.Cells[i, 2].Value) + ', [VALUE] = ' + Sheet.Cells[i, 3].Value +
                  ' WHERE [CUSTOMER_CODE] = ' + QuotedStr(Sheet.Cells[i, 1].Value);

                try
                  ADOQOneXcl.SQL.Text := strSQL;
                  ADOQOneXcl.ExecSQL;

                  bCheckPoint := True;
                except
                  on e: Exception do
                  begin
                    bCheckPoint := False;
                    ShowMessage('Customer code: ' + Sheet.Cells[i, 1].Value + ' --- ' + e.Message);
                    LogError(e.Message, 'Customer code: ' + Sheet.Cells[i, 1].Value);
                    ADOConnXcl.RollbackTrans;
                    Exit;
                  end;
                end;
              end;
              ADOConnXcl.CommitTrans;

              if bCheckPoint then
              begin
                ADOQOneXcl.Connection := ADOConnXcl;
                ADOConnXcl.BeginTrans;
                for i := 2 to Sheet.UsedRange.Rows.Count do
                begin
                  strSQL := 'UPDATE [dbo].[CUSTOMERS] SET [CREDLIMIT] = [CREDLIMIT] + ' + Sheet.Cells[i, 3].Value +
                    ' WHERE [CODE] = ' + QuotedStr(Sheet.Cells[i, 1].Value);

                  try
                    ADOQOneXcl.SQL.Text := strSQL;
                    ADOQOneXcl.ExecSQL;
                  except
                    on e: Exception do
                    begin
                      bCheckPoint := False;
                      ShowMessage('Customer code: ' + Sheet.Cells[i, 1].Value + ' --- ' + e.Message);
                      LogError(e.Message, Sheet.Cells[i, 1].Value);
                      ADOConnXcl.RollbackTrans;
                      Exit;
                    end;
                  end;
                end;
                ADOConnXcl.CommitTrans;
              end;
              //TODO: Think about bCheckPoint instead of Exit
            finally
              ADOQOneXcl.Free;
              ADOQTwoXcl.Free;
            end;
          finally
            ExcelWorkbook.Close(False);
            ExcelApp.Quit;
          end;

        except
          on e: Exception do
          begin
            LogError(e.Message, 'Outer try..except block, ExcelApp, ExcelWorkbook and SQL transaction ADOQOneXcl');
            ADOConnXcl.RollbackTrans;
          end;
        end;
      finally
        ADOConnXcl.Close;
        ADOConnXcl.Free;
      end;
    end;
  finally
    OpenDialog.Free;
    ShowMessage('Η λειτουργία τερματίστηκε.');
  end;
end;

function TdtmDM.fileVer: string;
var
  FileName: string;
  VersionInfo: Pointer;
  VersionInfoSize, Dummy: DWORD;
  VersionValue: PVSFixedFileInfo;
  strR: string;
begin
  strR := EmptyStr;
  try
    FileName := ParamStr(0);
    VersionInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);

    if VersionInfoSize > 0 then
    begin
      GetMem(VersionInfo, VersionInfoSize);

      try
        if GetFileVersionInfo(PChar(FileName), 0, VersionInfoSize, VersionInfo) then
        begin
          if VerQueryValue(VersionInfo, '\', Pointer(VersionValue), Dummy) then
          begin
            strR :=
              IntToStr(VersionValue.dwFileVersionMS shr 16) + '.' +
              IntToStr(VersionValue.dwFileVersionMS and $FFFF) + '.' +
              IntToStr(VersionValue.dwFileVersionLS shr 16) + '.' +
              IntToStr(VersionValue.dwFileVersionLS and $FFFF);
          end;
        end;
      finally
        FreeMem(VersionInfo);
      end;
    end;
    Result := strR;
  except
    Result := EmptyStr;
  end;
end;


end.
