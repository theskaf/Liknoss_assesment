unit InsertFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Mask,
  ADODB, Data.DB, DMDtm,
  System.UITypes;

type
  TfrmInsert = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    btnCustOK: TButton;
    btnCredTranOK: TButton;
    Label7: TLabel;
    Edit7: TEdit;
    Label8: TLabel;
    Edit8: TEdit;
    Label9: TLabel;
    DateTimePicker1: TDateTimePicker;
    btnCancel13: TButton;
    btnCancel23: TButton;
    btnSalesOK: TButton;
    btnCancel33: TButton;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Edit9: TEdit;
    DateTimePicker2: TDateTimePicker;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    procedure FormResize(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure btnCustOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure btnCredTranOKClick(Sender: TObject);
    procedure Edit8KeyPress(Sender: TObject; var Key: Char);
    procedure btnSalesOKClick(Sender: TObject);
    procedure btnCancel13Click(Sender: TObject);
    procedure btnCancel23Click(Sender: TObject);
    procedure btnCancel33Click(Sender: TObject);
    procedure Edit11KeyPress(Sender: TObject; var Key: Char);
    procedure Edit9Exit(Sender: TObject);
    procedure Edit10Exit(Sender: TObject);
    procedure Edit11Exit(Sender: TObject);
    procedure Edit7Exit(Sender: TObject);
    procedure Edit8Exit(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
  private
    FDataPassed: Boolean;
    FConStr: string;

    {FModalResult: TModalResult;

    FCustCode, FCUstName, FCustAddr, FCustVAT: string;
    FCustCredLim, FCustSales: Currency;}

    procedure IWasGonnaCancelThenILookedIntoTheSky;
    procedure MindTheCharsInBoxes(Sender: TObject; var Key: Char);
    procedure RemoveCharFromTextBox(aTextBox: TEdit; aChar: Char);

  public
    property DataPassed: Boolean read FDataPassed;
    property conStr: string read FConStr write FConStr;

    {property pModalResult: TModalResult read FModalResult write FModalResult;

    property CustCode: string read FCustCode write FCustCode; //nvarchar100 κωδικός πελάτη
    property CUstName: string read FCUstName write FCUstName; //nvarchar100 επωνυμία
    property CustAddr: string read FCustAddr write FCustAddr; //nvarchar100 δ/ση
    property CustVAT: string read FCustVAT write FCustVAT; //nvarchar100 φπα
    property CustCredLim: Currency read FCustCredLim write FCustCredLim; //numeric12.2 πιστ όριο
    property CustSales: Currency read FCustSales write FCustSales; //numeric12.2 πωλήσεις     }
  end;

//var
  //frmInsert: TfrmInsert;

implementation

{$R *.dfm}



procedure TfrmInsert.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //if ModalResult <> mrOk then ModalResult := mrCancel;
  //ModalResult := pModalResult;
end;

procedure TfrmInsert.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //CanClose := True;
end;

procedure TfrmInsert.FormResize(Sender: TObject);
begin
  ClientWidth := 405;
  ClientHeight := 380;
end;

procedure TfrmInsert.PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
begin
  AllowChange := False;
end;


procedure TfrmInsert.btnSalesOKClick(Sender: TObject);
var
  ADOConnection1: TADOConnection;
  ADOQueryOne,
  ADOQInsToCredTrans, ADOQUpdCustsFromCredTrans: TADOQuery;

  strBuildInsert, strBuildVals,
  strSlsCode, strSlsDate, strSlsValue, strSlsDscr,
  strTmp: string;
  vResult: Variant;
  i, iTmp, jTmp: Integer;
  currCompCrLim, currCompSales, currComp: Currency;
begin
// INSERT INTO [dbo].[ORDERS] ([CUSTOMER_CODE],[SERVICE_DATE],[DESCRIPTION],[VALUE]) VALUES (<CUSTOMER_CODE, nvarchar(100),> , <SERVICE_DATE, date,> , <DESCRIPTION, nvarchar(100),> , <VALUE, numeric(12,2),>)
  strBuildInsert := 'INSERT INTO [dbo].[ORDERS] ([CUSTOMER_CODE],[SERVICE_DATE],[DESCRIPTION],[VALUE])';
  strBuildVals := EmptyStr;

  FDataPassed := False;

  strSlsCode  := Trim(Edit9.Text);
  strSlsDate  := Trim( FormatDateTime('yyyy-mm-dd', DateTimePicker2.Date) );
  strSlsDscr  := Trim(Edit10.Text);
  strSlsValue := Trim(Edit11.Text);

  if ( (strSlsCode = EmptyStr) or (strSlsDate = EmptyStr) or (strSlsDscr = EmptyStr) or (strSlsValue = EmptyStr) ) then
  begin
    ShowMessage('Tα πεδία είναι υποχρεωτικά. Παρακαλώ προσπαθήστε ξανά.');
    Abort;
  end;

  //

  ADOConnection1 := TADOConnection.Create(nil);
  ADOConnection1.LoginPrompt := False;
  ADOConnection1.DefaultDatabase := 'OrdersMiniDB';
  ADOConnection1.ConnectionString := dtmDM.VulnerableAF(conStr); //VulnerableAF;

  try
    ADOConnection1.Open;

    ADOQueryOne := TADOQuery.Create(nil);
    try
      ADOQueryOne.Connection := ADOConnection1;
      ADOQueryOne.SQL.Text := 'IF EXISTS (SELECT CODE FROM CUSTOMERS WHERE CODE = :CustCode) SELECT CODE FROM CUSTOMERS WHERE CODE = :CustCode ELSE SELECT NULL AS CODE';
      ADOQueryOne.Parameters.ParamByName('CustCode').Value := strSlsCode;
      ADOQueryOne.Open;

      if not ADOQueryOne.IsEmpty then
        vResult := ADOQueryOne.FieldByName('CODE').Value;

      if VarIsNull(vResult) then // handle null case
      begin
        ShowMessage('Ο Κωδικός που εισάγατε δεν υπάρχει. Παρακαλώ προσπαθήστε ξανά, ή δημιουργήστε νέο πελάτη με αυτόν τον κωδικό.');
        Abort;
      end
      else
      begin
        strBuildVals := 'VALUES (N' + QuotedStr(strSlsCode);
      end;
    finally
      ADOQueryOne.Free;
    end;

    strBuildVals := strBuildVals + ' , ' + QuotedStr(strSlsDate);

    strBuildVals := strBuildVals + ' , N' + QuotedStr(strSlsDscr);

    if strSlsValue.Length > 0 then
    begin
      i    := 0;
      iTmp := 0;
      jTmp := 0;
      for i := 1 to Length(strSlsValue) do
      begin
        if strSlsValue[i] = '-' then
          Inc(iTmp);
        if strSlsValue[i] = ',' then
          Inc(jTmp);
      end;
      if ((iTmp > 1) or (jTmp > 1)) then
      begin
        ShowMessage('Έχετε εισάγει πολλά σημεία στίξης ή κόμματα. Παρακαλώ προσπαθήστε ξανά.');
        Abort;
      end
      else
      begin
        strSlsValue := StringReplace(strSlsValue, ',', '.', [rfReplaceAll]);
      end;
      strBuildVals := strBuildVals + ' , ' + strSlsValue;
    end
	else
	begin
	  strBuildVals := strBuildVals + ' , NULL';
	end;
  strBuildVals := strBuildVals + ')';
  strBuildInsert := strBuildInsert + ' ' + strBuildVals;


  try
    currCompCrLim := StrToCurr(Edit11.Text); //StrToFloat
    strTmp := Edit12.Text;
    Delete(strTmp, 1, 1);
    strTmp := StringReplace(strTmp, '.', '', [rfReplaceAll]);
    currCompSales := StrToCurr(strTmp);
  except
    ShowMessage('Aδυναμία σύγκρισης υπολοίπων.');
    Abort;
  end;
  if ( currCompCrLim > currCompSales ) then // currCompCrLim := StrToFloat(Edit11.Text); // currCompSales := StrToFloat(Edit12.Text);  // 11 <= 12
  begin
    ShowMessage('Ο πελάτης δεν έχει επαρκές υπόλοιπο. Η αξία της παραγγελίας πρέπει να είναι μικρότερη ή ίση αυτού. Παρακαλώ προσπαθήστε ξανά.');
    Abort;
  end;

  if currCompCrLim <= 0 then
  begin
    ShowMessage('Δεν επιτρέπονται μηδενικές ή αρνητικές παραγγελίες. Παρακαλώ προσπαθήστε ξανά.');
    Abort;
  end;

//

  FDataPassed := False;
  ADOConnection1.BeginTrans;
  try
    ADOQInsToCredTrans := TADOQuery.Create(nil);
    try
      ADOQInsToCredTrans.Connection := ADOConnection1;
      ADOQInsToCredTrans.SQL.Text := strBuildInsert;
      ADOQInsToCredTrans.ExecSQL;
    finally
      ADOQInsToCredTrans.Free;
    end;

    FDataPassed := True;

    if strSlsValue.Length > 0 then
    begin
      try
        ADOQUpdCustsFromCredTrans := TADOQuery.Create(nil);
        try
          ADOQUpdCustsFromCredTrans.Connection := ADOConnection1;
          ADOQUpdCustsFromCredTrans.SQL.Text := 'UPDATE [dbo].[CUSTOMERS] SET [SALES] = ISNULL([SALES],0) + ' + strSlsValue + ' WHERE [CODE] = ' + QuotedStr(strSlsCode);
          ADOQUpdCustsFromCredTrans.ExecSQL;
        finally
          ADOQUpdCustsFromCredTrans.Free;
        end;
      except
        on e: Exception do
        begin
          FDataPassed := False;
          MessageDlg('Problem Z005: Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message, mtError, mbOKCancel, 0);
        end;
      end;
    end;

    if FDataPassed then
    begin
      ADOConnection1.CommitTrans;
    end
    else
    begin
      ADOConnection1.RollbackTrans;
    end;
  except
    on e: Exception do
    begin
      FDataPassed := False;
      ADOConnection1.RollbackTrans;
      MessageDlg('Problem Z004: Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message, mtError, mbOKCancel, 0);
    end;
  end;

  finally
    ADOConnection1.Free;
  end;
  self.Close;
end;


procedure TfrmInsert.btnCredTranOKClick(Sender: TObject);
var
  ADOConnection1: TADOConnection;
  ADOQueryOne,
  ADOQInsToCredTrans, ADOQUpdCustsFromCredTrans: TADOQuery;

  //strUserID, strTempConStr, strNewConnectionString,
  strBuildInsert, strBuildVals,
  strCredTrCode, strCredTrDate, strCredTrValue: string;

  vResult: Variant;
  i, iTmp, jTmp: Integer;
begin
// INSERT INTO [dbo].[CREDTRANSACTIONS] ([CUSTOMER_CODE],[TRANSDATE],[VALUE]) VALUES (<CUSTOMER_CODE, nvarchar(100),> , <TRANSDATE, date,> , <VALUE, numeric(12,2),>)
  strBuildInsert := 'INSERT INTO [dbo].[CREDTRANSACTIONS] ([CUSTOMER_CODE],[TRANSDATE],[VALUE])';
  strBuildVals := EmptyStr;

  FDataPassed := False;

  strCredTrCode  := Trim(Edit7.Text);
  strCredTrDate  := Trim( FormatDateTime('yyyy-mm-dd', DateTimePicker1.Date) );
  strCredTrValue := Trim(Edit8.Text);

  if ( (strCredTrCode = EmptyStr) or (strCredTrDate = EmptyStr) ) then
  begin
    ShowMessage('Tα πεδία κωδικού και ημερομηνίας είναι υποχρεωτικά. Παρακαλώ προσπαθήστε ξανά.');
    Abort;
  end;

  //

  ADOConnection1 := TADOConnection.Create(nil);
  ADOConnection1.LoginPrompt := False;
  ADOConnection1.DefaultDatabase := 'OrdersMiniDB';
  //ADOConnection1.Provider := 'SQLNCLI11.1';
  ADOConnection1.ConnectionString := dtmDM.VulnerableAF(conStr); //VulnerableAF;

  try
    ADOConnection1.Open;

    ADOQueryOne := TADOQuery.Create(nil);
    try
      ADOQueryOne.Connection := ADOConnection1;
      ADOQueryOne.SQL.Text := 'IF EXISTS (SELECT CODE FROM CUSTOMERS WHERE CODE = :CustCode) SELECT CODE FROM CUSTOMERS WHERE CODE = :CustCode ELSE SELECT NULL AS CODE';
      ADOQueryOne.Parameters.ParamByName('CustCode').Value := strCredTrCode;
      ADOQueryOne.Open;

      if not ADOQueryOne.IsEmpty then
        vResult := ADOQueryOne.FieldByName('CODE').Value;

      if VarIsNull(vResult) then // handle null case
      begin
        ShowMessage('Ο Κωδικός που εισάγατε δεν υπάρχει. Παρακαλώ προσπαθήστε ξανά, ή δημιουργήστε νέο πελάτη με αυτόν τον κωδικό.');
        Abort;
      end
      else
      begin
        strBuildVals := 'VALUES (N' + QuotedStr(strCredTrCode);
      end;
    finally
      ADOQueryOne.Free;
    end;

    strBuildVals := strBuildVals + ' , ' + QuotedStr(strCredTrDate);

    if strCredTrValue.Length > 0 then
    begin
      i    := 0;
      iTmp := 0;
      jTmp := 0;
      for i := 1 to Length(strCredTrValue) do
      begin
        if strCredTrValue[i] = '-' then
          Inc(iTmp);
        if strCredTrValue[i] = ',' then
          Inc(jTmp);
      end;
      if ((iTmp > 1) or (jTmp > 1)) then
      begin
        ShowMessage('Έχετε εισάγει πολλά σημεία στίξης ή κόμματα. Παρακαλώ προσπαθήστε ξανά.');
        Abort;
      end
      else
      begin
        strCredTrValue := StringReplace(strCredTrValue, ',', '.', [rfReplaceAll]);
      end;
      strBuildVals := strBuildVals + ' , ' + strCredTrValue;
    end
	else
	begin
	  strBuildVals := strBuildVals + ' , NULL';
	end;
  strBuildVals := strBuildVals + ')';
  strBuildInsert := strBuildInsert + ' ' + strBuildVals;


  FDataPassed := False;
  ADOConnection1.BeginTrans;
  try
    ADOQInsToCredTrans := TADOQuery.Create(nil);
    try
      ADOQInsToCredTrans.Connection := ADOConnection1;
      ADOQInsToCredTrans.SQL.Text := strBuildInsert;
      ADOQInsToCredTrans.ExecSQL;
    finally
      ADOQInsToCredTrans.Free;
    end;

    FDataPassed := True;
    if strCredTrValue.Length > 0 then
    begin
      try
        ADOQUpdCustsFromCredTrans := TADOQuery.Create(nil);
        try
          ADOQUpdCustsFromCredTrans.Connection := ADOConnection1;
          ADOQUpdCustsFromCredTrans.SQL.Text := 'UPDATE [dbo].[CUSTOMERS] SET [CREDLIMIT] = ISNULL([CREDLIMIT],0) + ' + strCredTrValue + ' WHERE [CODE] = ' + QuotedStr(strCredTrCode);
          ADOQUpdCustsFromCredTrans.ExecSQL;
        finally
          ADOQUpdCustsFromCredTrans.Free;
        end;
      except
        on e: Exception do
        begin
          FDataPassed := False;
          MessageDlg('Problem Z005: Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message, mtError, mbOKCancel, 0);
        end;
      end;
    end;

    if FDataPassed then
    begin
      ADOConnection1.CommitTrans;
    end
    else
    begin
      ADOConnection1.RollbackTrans;
    end;
  except
    on e: Exception do
    begin
      FDataPassed := False;
      ADOConnection1.RollbackTrans;
      MessageDlg('Problem Z004: Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message, mtError, mbOKCancel, 0);
    end;
  end;

  finally
    ADOConnection1.Free;
  end;
  self.Close;
end;


procedure TfrmInsert.btnCustOKClick(Sender: TObject);
    function IsNumericString(const inStr: string): Boolean;
    var
      i: extended;
    begin
      Result := TryStrToFloat(inStr,i);
    end;

var
  ADOConnection1: TADOConnection;
  ADOQueryOne, ADOQTwo, ADOQThree: TADOQuery;
  //strUserID, strTempConStr, strNewConnectionString,
  strBuildInsert, strBuildVals,
  strCustCode, strCustName, strCustAddr, strCustVAT,
  strCredLim, strSales: string;
  sResult, vVatResult: Variant;
  i, iTmp, jTmp: Integer;
begin
//INSERT INTO [dbo].[CUSTOMERS] ([CODE],[NAME],[ADDRESS],[VAT],[CREDLIMIT],[SALES])
//     VALUES (<CODE, nvarchar(100),> , <NAME, nvarchar(100),> , <ADDRESS, nvarchar(100),> , <VAT, nvarchar(11),> , <CREDLIMIT, numeric(12,2),> , <SALES, numeric(12,2),>)

  strBuildInsert := 'INSERT INTO [dbo].[CUSTOMERS] ([CODE],';
  strBuildVals := EmptyStr;

  FDataPassed := False;

  strCustCode := Trim(Edit1.Text);
  if strCustCode = EmptyStr then
  begin
    ShowMessage('Ο Κωδικός είναι υποχρεωτικός. Παρακαλώ προσπαθήστε ξανά.');
    Abort;
  end;

  strCustName := Trim(Edit2.Text);
  if strCustName = EmptyStr then
  begin
    ShowMessage('H Επωνυμία είναι υποχρεωτική. Παρακαλώ προσπαθήστε ξανά.');
    Abort;
  end;
  strBuildInsert := strBuildInsert + '[NAME],';

  strCustAddr := Trim(Edit3.Text);

  if strCustAddr.Length > 0 then // if strCustAddr <> EmptyStr then
    strBuildInsert := strBuildInsert + '[ADDRESS],';

  strCustVAT := Trim(Edit4.Text);
  if strCustVAT = EmptyStr then //ναλότητα, ελ1
  begin
    ShowMessage('Το ΑΦΜ είναι υποχρεωτικό. Παρακαλώ προσπαθήστε ξανά.');
    Abort;
  end;
  if not IsNumericString(strCustVAT) then //ελ2
  begin
    ShowMessage('Το ΑΦΜ πρέπει να αποτελείται από αριθμούς μόνο. Παρακαλώ προσπαθήστε ξανά.');
    Abort;
  end;
  if strCustVAT.Length <> 11 then //3
  begin
    ShowMessage('Το ΑΦΜ πρέπει να έχει 11 χαρακτήρες. Παρακαλώ προσπαθήστε ξανά.');
    Abort;
  end;
  strBuildInsert := strBuildInsert + '[VAT],';

  strCredLim := Trim(Edit5.Text);
  if strCredLim.Length > 0 then
    strBuildInsert := strBuildInsert + '[CREDLIMIT],';
  strSales := Trim(Edit6.Text);
  if strSales.Length > 0 then
    strBuildInsert := strBuildInsert + '[SALES],';

  Delete(strBuildInsert, Length(strBuildInsert), 1);
  strBuildInsert := strBuildInsert + ') ';

  //

  ADOConnection1 := TADOConnection.Create(nil);
  ADOConnection1.LoginPrompt := False;
  ADOConnection1.DefaultDatabase := 'OrdersMiniDB';
  //ADOConnection1.Provider := 'SQLNCLI11.1';
  ADOConnection1.ConnectionString := dtmDM.VulnerableAF(conStr); //VulnerableAF;

  try
    ADOConnection1.Open;

    ADOQueryOne := TADOQuery.Create(nil);
    try
      ADOQueryOne.Connection := ADOConnection1;
      ADOQueryOne.SQL.Text := 'IF EXISTS (SELECT CODE FROM CUSTOMERS WHERE CODE = :CustCode) ' +
                            'SELECT CODE FROM CUSTOMERS WHERE CODE = :CustCode ' +
                            'ELSE SELECT NULL AS CODE';
      ADOQueryOne.Parameters.ParamByName('CustCode').Value := strCustCode;
      ADOQueryOne.Open;

      if not ADOQueryOne.IsEmpty then
        sResult := ADOQueryOne.FieldByName('CODE').Value;

      if VarIsNull(sResult) then // handle null case, we are good to insert //or VarIsEmpty(sResult) VarIsNull   (VarIsNull(sResult) or VarIsEmpty(sResult))
      begin
        strBuildVals := 'N' + QuotedStr(strCustCode);
      end
      else
      begin
        ShowMessage('Ο Κωδικός υπάρχει ήδη. Παρακαλώ προσπαθήστε ξανά.');
        Abort;
      end;
    finally
      ADOQueryOne.Free;
    end;

    strBuildVals := strBuildVals + ' , N' + QuotedStr(strCustName);

    if strCustAddr.Length > 0 then // if strCustAddr <> EmptyStr then
      strBuildVals := strBuildVals + ' , N' + QuotedStr(strCustAddr);


    ADOQTwo := TADOQuery.Create(nil);
    try
      ADOQTwo.Connection := ADOConnection1;
      ADOQTwo.SQL.Text := 'IF EXISTS (SELECT VAT FROM CUSTOMERS WHERE VAT = :CustV) ' +
                            'SELECT VAT FROM CUSTOMERS WHERE VAT = :CustV ' +
                            'ELSE SELECT NULL AS VAT';
      ADOQTwo.Parameters.ParamByName('CustV').Value := strCustVAT;
      ADOQTwo.Open;

      if not ADOQTwo.IsEmpty then
        vVatResult := ADOQTwo.FieldByName('VAT').Value;

      if VarIsNull(vVatResult) then // handle null case, we are good to insert //or VarIsEmpty(sResult)
      begin
        strBuildVals := strBuildVals + ' , ' + QuotedStr(strCustVAT);
      end
      else
      begin
        ShowMessage('Το ΦΠΑ υπάρχει ήδη. Παρακαλώ προσπαθήστε ξανά.');
        Abort;
      end;
    finally
      ADOQTwo.Free;
    end;


    if strCredLim.Length > 0 then
    begin
      i    := 0;
      iTmp := 0;
      jTmp := 0;
      for i := 1 to Length(strCredLim) do
      begin
        if strCredLim[i] = '-' then
          Inc(iTmp);
        if strCredLim[i] = ',' then
          Inc(jTmp);
      end;
      if ((iTmp > 1) or (jTmp > 1)) then
      begin
        ShowMessage('Έχετε εισάγει πολλά σημεία στίξης ή κόμματα. Παρακαλώ προσπαθήστε ξανά.');
        Abort;
      end
      else
      begin
        strCredLim := StringReplace(strCredLim, ',', '.', [rfReplaceAll]);
      end;
      strBuildVals := strBuildVals + ' , ' + strCredLim;
    end;

    if strSales.Length > 0 then
    begin
      i    := 0;
      iTmp := 0;
      jTmp := 0;
      for i := 1 to Length(strSales) do
      begin
        if strSales[i] = '-' then
          Inc(iTmp);
        if strSales[i] = ',' then
          Inc(jTmp);
      end;

      if ((iTmp > 1) or (jTmp > 1)) then
      begin
        ShowMessage('Έχετε εισάγει πολλά σημεία στίξης ή κόμματα. Παρακαλώ προσπαθήστε ξανά.');
        Abort;
      end
      else
      begin
        strSales := StringReplace(strSales, ',', '.', [rfReplaceAll]);
      end;
      strBuildVals := strBuildVals + ' , ' + strSales;
    end;

    strBuildVals := '(' + strBuildVals + ')';
    strBuildInsert := strBuildInsert + ' VALUES ' + strBuildVals;


    try
      FDataPassed := False;
      ADOQThree := TADOQuery.Create(nil);
      try
        ADOQThree.Connection := ADOConnection1;
        ADOQThree.SQL.Text := strBuildInsert;
      ADOQThree.ExecSQL;
      finally
        ADOQThree.Free;
      end;
      FDataPassed := True;
    except
      on e: Exception do
      begin
        FDataPassed := False;
        MessageDlg('Πρόβλημα Z002 λειτουργίας, επικοινωνήστε με τον διαχειριστή αναφέροντας: Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message, mtError, mbOKCancel, 0);
      end;
    end;


  finally
    ADOConnection1.Free;
  end;


  self.Close;
end;







procedure TfrmInsert.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
  MindTheCharsInBoxes(Sender, Key);
end;

procedure TfrmInsert.Edit6KeyPress(Sender: TObject; var Key: Char);
begin
  MindTheCharsInBoxes(Sender, Key);
end;

procedure TfrmInsert.Edit7Exit(Sender: TObject);
begin
  RemoveCharFromTextBox(TEdit(Sender), '''');
end;

procedure TfrmInsert.Edit8Exit(Sender: TObject);
begin
  RemoveCharFromTextBox(TEdit(Sender), '''');
end;

procedure TfrmInsert.Edit8KeyPress(Sender: TObject; var Key: Char);
begin
  MindTheCharsInBoxes(Sender, Key);
end;

procedure TfrmInsert.Edit10Exit(Sender: TObject);
begin
  RemoveCharFromTextBox(TEdit(Sender), '''');
end;

procedure TfrmInsert.Edit11Exit(Sender: TObject);
begin
  RemoveCharFromTextBox(TEdit(Sender), '''');
end;

procedure TfrmInsert.Edit11KeyPress(Sender: TObject; var Key: Char);
begin
  MindTheCharsInBoxes(Sender, Key);
end;

procedure TfrmInsert.Edit1Exit(Sender: TObject);
begin
  RemoveCharFromTextBox(TEdit(Sender), '''');
end;

procedure TfrmInsert.Edit2Exit(Sender: TObject);
begin
  RemoveCharFromTextBox(TEdit(Sender), '''');
end;

procedure TfrmInsert.Edit3Exit(Sender: TObject);
begin
  RemoveCharFromTextBox(TEdit(Sender), '''');
end;

procedure TfrmInsert.Edit4Exit(Sender: TObject);
begin
  RemoveCharFromTextBox(TEdit(Sender), '''');
end;

procedure TfrmInsert.MindTheCharsInBoxes(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', ',', '-', #8]) then
    Key := #0
  else if (Key = ',') and (Pos(',', (Sender as TEdit).Text) > 0) then
    Key := #0
  else if (Key = '-') and (Length((Sender as TEdit).Text) > 0) then
    Key := #0;
end;


procedure TfrmInsert.IWasGonnaCancelThenILookedIntoTheSky;
begin
  FDataPassed := False;
  self.Close;
end;


procedure TfrmInsert.btnCancel13Click(Sender: TObject);
begin
  IWasGonnaCancelThenILookedIntoTheSky;
end;

procedure TfrmInsert.btnCancel23Click(Sender: TObject);
begin
  IWasGonnaCancelThenILookedIntoTheSky;
end;

procedure TfrmInsert.btnCancel33Click(Sender: TObject);
begin
  IWasGonnaCancelThenILookedIntoTheSky;
end;



procedure TfrmInsert.RemoveCharFromTextBox(aTextBox: TEdit; aChar: Char);
var
  modifiedText: string;
begin
  modifiedText := aTextBox.Text;
  modifiedText := StringReplace(modifiedText, aChar, '', [rfReplaceAll]);

  if Length(modifiedText) > 100 then
  begin
    ShowMessage('Εισάγατε κείμενο πάνω από 100 χαρακτήρες. Παρακαλώ μικρύνετέ το.');
    Exit;
  end;
  aTextBox.Text := modifiedText;
end; //RemoveCharFromTextBox(TEdit(Sender), '''');



procedure TfrmInsert.Edit9Exit(Sender: TObject);
var
  ADOConnTmp: TADOConnection;
  ADOQQQOne, ADOQQQTwo: TADOQuery;
  strTempyTemp, strCodeTmp: string;
  vResCode: Variant;
begin
  RemoveCharFromTextBox(TEdit(Sender), '''');

  strCodeTmp  := Trim(Edit9.Text);
  if (strCodeTmp = EmptyStr)  then
    Abort;

  ADOConnTmp := TADOConnection.Create(nil);
  ADOConnTmp.LoginPrompt := False;
  ADOConnTmp.DefaultDatabase := 'OrdersMiniDB';
  ADOConnTmp.ConnectionString := dtmDM.VulnerableAF(conStr); //VulnerableAF;

  strTempyTemp := EmptyStr;
  try
    ADOConnTmp.Open;

    ADOQQQOne := TADOQuery.Create(nil);
    try
      ADOQQQOne.Connection := ADOConnTmp;
      ADOQQQOne.SQL.Text := ' SELECT ISNULL(CREDLIMIT,0) - ISNULL(SALES,0) AS ADEQUACY FROM CUSTOMERS WHERE CODE = :CCode ';
      ADOQQQOne.Parameters.ParamByName('CCode').Value := strCodeTmp;

      try
        ADOQQQOne.Open;
      except
        Edit12.Text := FormatCurr('€#,##0.00', 0.0);
        //Abort;
      end;

      if not ADOQQQOne.IsEmpty then
        vResCode := ADOQQQOne.FieldByName('ADEQUACY').Value;

      if VarIsNull(vResCode) then
        Abort
      else
        strTempyTemp := VarToStr(vResCode);
        if strTempyTemp <> EmptyStr then
          Edit12.Text := FormatCurr('€#,##0.00', StrToFloat(strTempyTemp));
    finally
      ADOQQQOne.Free;
    end;
  finally
    ADOConnTmp.Free;
  end;
end;



end.
