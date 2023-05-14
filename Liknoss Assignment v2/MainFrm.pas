unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  MyHelper, DMDtm, InsertFrm,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls,
  Registry,
  System.IniFiles, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls,
  Printers ;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    tabCustomer: TTabSheet;
    tabCredTrans: TTabSheet;
    tabOrders: TTabSheet;
    tabPrint: TTabSheet;
    btnExit: TButton;
    btnInsert: TButton;
    btnDelete: TButton;
    btnEdit: TButton;
    btnView: TButton;
    Panel3: TPanel;
    Splitter1: TSplitter;
    Panel4: TPanel;
    PageControl2: TPageControl;
    tabCustCredTrans: TTabSheet;
    tabCustOrders: TTabSheet;
    btnExcel: TButton;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnFind: TButton;
    btnPrint: TButton;
    dtTo: TDateTimePicker;
    dtFrom: TDateTimePicker;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    DBGrid6: TDBGrid;
    DBLookupComboBox1: TDBLookupComboBox;
    lblV: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnExcelClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject); //procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure DBLookupComboBox1DropDown(Sender: TObject);
    procedure DBLookupComboBox1CloseUp(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    procedure ProcessParam(const Param: string);
    procedure UMEnsureRestored(var Msg: TMessage);
    message UM_ENSURERESTORED;
    procedure WMCopyData(var Msg: TWMCopyData);
    message WM_COPYDATA;

  protected
    procedure CreateParams(var Params: TCreateParams);
      override;

  public
    function RegistryReadSrvKeyz: Variant;
    procedure MakeIniFile;
  end;

var
  frmMain: TfrmMain;



implementation

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
var
  I: Integer;

  iniFile: TIniFile;
  connectionString: string;
begin
  for I := 1 to ParamCount do
    ProcessParam(ParamStr(I)); // mutex HELPER kinda thing for my app

  Application.CreateForm(TdtmDM, dtmDM);

  MakeIniFile;
  try
    iniFile := TIniFile.Create(ChangeFileExt(Application.Exename,'.ini'));
    dtmDM.AdoConn.Close;
    connectionString := iniFile.ReadString('Database', 'ConnectionString', '');
    dtmDM.AdoConn.ConnectionString := connectionString;
    dtmDM.AdoConn.Open;
  finally
    iniFile.Free;
  end;

  lblV.Caption := dtmDM.fileVer;
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  btnExit.Left := (Panel2.Width - btnExit.Width) div 2;
  btnExit.Top := (Panel2.Height - btnExit.Height) div 2;
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  //TODO: Check for any other open database connections or transactions here or @ OnClose
  dtmDM.AdoConn.Close;
  dtmDM.Free;
  Application.Terminate;
end;

function TfrmMain.RegistryReadSrvKeyz: Variant;
var
  reg, holpReg : TRegistry;
  openResult, bRes : Boolean;
  strVersion, numStr, strKeyOne, strKeyTwo: string;
  i, numStart, numEnd: Integer;
begin  //I simply lol ini files, here's my spaghetti for registry
  strKeyOne  := 'Zonk';
  strKeyTwo  := 'Zonk';
  strVersion := 'Zonk';

  holpReg := TRegistry.Create(KEY_READ OR KEY_WOW64_64KEY);
  holpReg.RootKey := HKEY_LOCAL_MACHINE;
  if (not holpReg.KeyExists('SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL\')) then //SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL
  begin
    strVersion := 'Zonk'; //kaboom
    MessageDlg('Πρόβλημα X001 αναγνώρισης κλειδιού, επικοινωνήστε με τον διαχειριστή.', mtError, mbOKCancel, 0);
  end
  else
  begin
    try
      holpReg.Access := KEY_READ OR KEY_WOW64_64KEY;

      bRes := holpReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL\', False);
      if not bRes then
      begin
        strVersion := 'Zonk'; //kaboom
        MessageDlg('Πρόβλημα X002 αναγνώρισης κλειδιού, επικοινωνήστε με τον διαχειριστή.', mtError, mbOKCancel, 0);
      end;
      if holpReg.ValueExists('MSSQLSERVER') then
        strVersion := holpReg.ReadString('MSSQLSERVER')
      else
        strVersion := 'Zonk'; //Not MSSQLxxx.MSSQLSERVER
    finally
      holpReg.CloseKey();
      holpReg.Free;
    end;
  end;

  if strVersion = 'Zonk' then
  begin
    MessageDlg('Πρόβλημα X003 αναγνώρισης κλειδιού, επικοινωνήστε με τον διαχειριστή.', mtError, mbOKCancel, 0);
    Application.Terminate;
  end
  else
  begin
    numStart := -1;
    numEnd := -1;
    for i := 1 to Length(strVersion) do
    begin
      if (strVersion[i] >= '0') and (strVersion[i] <= '9') then
      begin
        if numStart = -1 then
          numStart := i;
        numEnd := i;
      end
      else if numStart <> -1 then
        Break;
    end;
    if (numStart <> -1) and (numEnd <> -1) then
    begin
      numStr := Copy(strVersion, numStart, numEnd - numStart + 1);
    end
    else
    begin
      MessageDlg('Πρόβλημα X004 αναγνώρισης κλειδιού, επικοινωνήστε με τον διαχειριστή.', mtError, mbOKCancel, 0);
      Application.Terminate;
    end; //ShowMessage('No numbers found in string.');
  end;

  numStr := numStr + '0';
  if (numStr = '160') or //SQL Server 2022
     (numStr = '150') or //SQL Server 2019
     (numStr = '140') or //SQL Server 2017
     (numStr = '130') or //SQL Server 2016
     (numStr = '120') or //SQL Server 2014
     (numStr = '110') then //SQL Server 2012
  begin
    numStr := 'SOFTWARE\Microsoft\Microsoft SQL Server\' + numStr + '\Machines\';
  end
  else
  begin
    MessageDlg('Πρόβλημα Y001 έκδοσης βάσης, επικοινωνήστε με τον διαχειριστή.', mtError, mbOKCancel, 0);
    Application.Terminate;
  end;

  reg := TRegistry.Create(KEY_READ);
  reg.RootKey := HKEY_LOCAL_MACHINE;

  if (not reg.KeyExists(numStr)) then //SOFTWARE\Microsoft\Microsoft SQL Server\150\Machines\
  begin
    strKeyOne := 'Zonk'; //kaboom
    MessageDlg('Πρόβλημα X005 αναγνώρισης κλειδιού, επικοινωνήστε με τον διαχειριστή.', mtError, mbOKCancel, 0);
  end
  else
  begin
    try
      reg.Access := KEY_READ;

      openResult := reg.OpenKey(numStr, False); //SOFTWARE\Microsoft\Microsoft SQL Server\150\Machines\
      if not openResult then
      begin
        MessageDlg('Πρόβλημα X006 αναγνώρισης κλειδιού, επικοινωνήστε με τον διαχειριστή.', mtError, mbOKCancel, 0);
        Application.Terminate;
      end;
      if reg.ValueExists('OriginalMachineName') then
        strKeyOne := reg.ReadString('OriginalMachineName')
      else
        strKeyOne := 'Zonk';
    finally
      reg.CloseKey();
      reg.Free;
    end;
  end;

  Result := VarArrayOf([strKeyOne, strKeyTwo]);
end;


procedure TfrmMain.MakeIniFile;
{ Δεν ήθελα να φτιάξω χρήστη, ούτε να βάλω τα credentials του sa στο ini, το έκανα με Win security:
                            Provider=SQLNCLI11.1;Integrated Security=SSPI;
                            Persist Security Info=False;User ID="";Initial Catalog=...myDb...;
                            Data Source=.....my server.....;Initial File Name="";Server SPN="" }
var
  Ini: TIniFile;
  strSrvName: string;
begin
  Ini := TIniFile.Create(ChangeFileExt(Application.Exename,'.ini'));
  try
    strSrvName := RegistryReadSrvKeyz[0];
    if strSrvName = 'Zonk' then
    begin
      raise Exception.Create('Πρόβλημα X007 αναγνώρισης κλειδιού, επικοινωνήστε με τον διαχειριστή.');
      Application.Terminate;
    end
    else
      strSrvName := 'Provider=SQLNCLI11.1;Integrated Security=SSPI;Persist Security Info=False;User ID="";Initial Catalog=OrdersMiniDB;Data Source=' + strSrvName + ';Initial File Name="";Server SPN=""';
    //Ini.WriteString('Database', 'Provider', 'SQLNCLI11.1');
    //Ini.WriteString('Database', 'Integrated Security', 'SSPI');
    //Ini.WriteString('Database', 'Persist Security Info', 'False'); //WriteBool
    //Ini.WriteString('Database', 'User ID', '');
    //Ini.WriteString('Database', 'Initial Catalog', 'OrdersMiniDB');
    //Ini.WriteString('Database', 'Data Source', 'KURVA');
    //Ini.WriteString('Database', 'Initial File Name', '');
    //Ini.WriteString('Database', 'Server SPN', '');
    Ini.WriteString('Database', 'ConnectionString', strSrvName);
    Ini.WriteString('Comments', '1', 'Δεν ήθελα να φτιάξω χρήστη, ούτε να βάλω τα credentials του sa στο ini, το έκανα με Win security');

  finally
    Ini.Free;
  end;
end;



procedure TfrmMain.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePageIndex = 0 then
  begin
    btnView.Enabled := True;
    btnDelete.Enabled := True;
    btnEdit.Enabled := True;
    btnInsert.Enabled := True;
    btnExcel.Enabled := True;
  end;
  if PageControl1.ActivePageIndex = 1 then
  begin
    btnView.Enabled := True;
    btnDelete.Enabled := True;
    btnEdit.Enabled := True;
    btnInsert.Enabled := True;
    btnExcel.Enabled := False;
  end;
  if PageControl1.ActivePageIndex = 2 then
  begin
    btnView.Enabled := True;
    btnDelete.Enabled := True;
    btnEdit.Enabled := True;
    btnInsert.Enabled := True;
    btnExcel.Enabled := False;
  end;
  if PageControl1.ActivePageIndex = 3 then
  begin
    btnView.Enabled := False;
    btnDelete.Enabled := False;
    btnEdit.Enabled := False;
    btnInsert.Enabled := False;
    btnExcel.Enabled := False;

    dtmDM.qrCustomers.Open;
  end;
end;



procedure TfrmMain.ProcessParam(const Param: string);
begin
// TODO : Code to process a parameter if any, will think about it probs no time
end;

procedure TfrmMain.UMEnsureRestored(var Msg: TMessage);
begin
  if IsIconic(Application.Handle) then
    Application.Restore;
  if not Visible then
    Visible := True;
  Application.BringToFront;
  SetForegroundWindow(Self.Handle);
end;

procedure TfrmMain.WMCopyData(var Msg: TWMCopyData);
var
  PData: PChar;
  Param: string;
begin
  if Msg.CopyDataStruct.dwData <> cCopyDataWaterMark then
    raise Exception.Create(
      'Invalid data structure passed in WM_COPYDATA'
    );
  PData := Msg.CopyDataStruct.lpData;
  while PData^ <> #0 do
  begin
    Param := PData;
    ProcessParam(Param);
    Inc(PData, Length(Param) + 1);
  end;
  Msg.Result := 1;
end;

procedure TfrmMain.CreateParams(var Params: TCreateParams);
begin
  inherited;
  StrCopy(Params.WinClassName, cWindowClassName);
end;


procedure TfrmMain.DBLookupComboBox1CloseUp(Sender: TObject);
begin
  DBLookupComboBox1.ListSource.DataSet.FieldByName('CODE').Visible := False;
  DBLookupComboBox1.ListSource.DataSet.FieldByName('NAME').Visible := False;
end;

procedure TfrmMain.DBLookupComboBox1DropDown(Sender: TObject);
begin
  DBLookupComboBox1.ListSource.DataSet.FieldByName('CODE').Visible := True;
  DBLookupComboBox1.ListSource.DataSet.FieldByName('CODE').DisplayWidth := 12;
  DBLookupComboBox1.ListSource.DataSet.FieldByName('NAME').Visible := True;
  DBLookupComboBox1.ListSource.DataSet.FieldByName('NAME').DisplayWidth := 80;
  //DBLookupComboBox1.ListFields := 'CODE; NAME';
end;



//iSender 1 View 2 Delete 3 Edit 4 Insert 5 Excel
procedure TfrmMain.btnViewClick(Sender: TObject); //1 if not DoStuff(1, PageControl1.ActivePageIndex) then MessageDlg('Πρόβλημα Z001 λειτουργίας, επικοινωνήστε με τον διαχειριστή.', mtError, mbOKCancel, 0);
    //TdtmDM(dtmDM).       //dtmDM.ADOQuery1.active
    //dtmDM.qrCustomers.SQL.Text := 'SELECT * FROM CUSTOMERS ORDER BY CODE DESC, NAME';
begin
  try
    with dtmDM do
    begin
      qrCredTrans.Close;
      qrCredTrans.Open;
      //dtmDM.qrCredTrans.Refresh;
      qrOrders.Close;
      qrOrders.Open;
      //dtmDM.qrOrders.Refresh;
      qrCustomers.Close;
      qrCustomers.Open;
      //dtmDM.qrCustomers.Refresh;
      qVCustCredTrans.Close;
      qVCustCredTrans.Open;
      qVCustOrders.Close;
      qVCustOrders.Open;
      {qrCustomers.DisableControls;
      qrCustomers.AfterScroll := nil;
      try
        qrCustomers.First;
        while not qrCustomers.Eof do
        begin
          if qrCustomersincTest.AsInteger < 0 then
          begin
            qrCustomers.Edit;
            qrCustomersincTest.AsInteger := (-1) * qrCustomersincTest.AsInteger;
            //Will NOT: qrCustomers.Post;
          end;
          qrCustomers.Next;
        end;
      finally
        qrCustomers.AfterScroll := qrCustomersAfterScroll;
        qrCustomers.First;
        qrCustomers.EnableControls;
      end;}
    end;


    if PageControl1.ActivePageIndex = 0 then //iTabInd = PageControl1.ActivePageIndex 0 πελάτες 1 κινήσεις 2 παραγγελίες 3 εκτύπωση
    begin
      DBGrid1.SetFocus;
    end;
    if PageControl1.ActivePageIndex = 1 then
    begin
      DBGrid4.SetFocus;
    end;
    if PageControl1.ActivePageIndex = 2 then
    begin
      DBGrid5.SetFocus;
    end;
  except
    on e: Exception do
    begin
      MessageDlg('Πρόβλημα Z001 λειτουργίας, επικοινωνήστε με τον διαχειριστή αναφέροντας: Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message, mtError, mbOKCancel, 0);
    end;
  end;
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
var
  sCode: string;
  iUserSelected, TransactionID: Integer;
begin
  TransactionID := -999999;
  sCode := EmptyStr;
  iUserSelected := mrCancel;

  if PageControl1.ActivePageIndex = 0 then
  begin
    sCode := DBGrid1.DataSource.DataSet.FieldByName('CODE').AsString; //qrCustomers = DataSet
    if sCode = EmptyStr then
    begin
      MessageDlg('Δεν έχετε επιλέξει κάποια εγγραφή πελάτη, ή δεν υπάρχουν δεδομένα. Η διαδικασία ακυρώνεται.', mtError, [mbOK], 0); //ShowMessage(...);
      Abort;
    end
    else
    begin
      iUserSelected := MessageDlg('Είστε βέβαιοι ότι θέλετε να διαγράψετε τον πελάτη με κωδικό ' + sCode + ' ;', mtConfirmation, mbOKCancel, 0);

      if iUserSelected = mrOk then
      begin
        if dtmDM.DeleteCust(sCode) then
        begin
          MessageDlg('H διαγραφή ήταν επιτυχής.', mtInformation, [mbOK], 0);
          btnView.Click;
        end
        else
        begin
          MessageDlg('Η διαγραφή απέτυχε.', mtError, [mbOK], 0);
        end;
      end;
    end;
  end;

  if PageControl1.ActivePageIndex = 1 then
  begin
    sCode := DBGrid4.DataSource.DataSet.FieldByName('CODE').AsString; //qrCredTrans = DataSet
    if sCode = EmptyStr then
    begin
      MessageDlg('Δεν έχετε επιλέξει κάποια κίνηση πελάτη, ή δεν υπάρχουν δεδομένα. Η διαδικασία ακυρώνεται.', mtError, [mbOK], 0); //ShowMessage(...);
      Abort;
    end
    else
    begin
      iUserSelected := MessageDlg('Είστε βέβαιοι ότι θέλετε να διαγράψετε την κίνηση του πελάτη ' + sCode + ' ;', mtConfirmation, mbOKCancel, 0);

      if iUserSelected = mrOk then
      begin
	    TransactionID := dbGrid4.DataSource.DataSet.FieldByName('TID').AsInteger;
        if dtmDM.DeleteCreditTransaction(sCode, TransactionID) then
        begin
          MessageDlg('H διαγραφή ήταν επιτυχής.', mtInformation, [mbOK], 0);
          btnView.Click;
        end
        else
        begin
          MessageDlg('Η διαγραφή απέτυχε.', mtError, [mbOK], 0);
        end;
      end;
    end;
  end;

  if PageControl1.ActivePageIndex = 2 then
  begin
    sCode := DBGrid5.DataSource.DataSet.FieldByName('CODE').AsString;
    if sCode = EmptyStr then
    begin
      MessageDlg('Δεν έχετε επιλέξει κάποια παραγγελία, ή δεν υπάρχουν δεδομένα. Η διαδικασία ακυρώνεται.', mtError, [mbOK], 0);
      Abort;
    end
    else
    begin
      iUserSelected := MessageDlg('Είστε βέβαιοι ότι θέλετε να διαγράψετε την παραγγελία του πελάτη ' + sCode + ' ;', mtConfirmation, mbOKCancel, 0);

      if iUserSelected = mrOk then
      begin
	    TransactionID := dbGrid5.DataSource.DataSet.FieldByName('OID').AsInteger;
        if dtmDM.DeleteOrder(sCode, TransactionID) then
        begin
          MessageDlg('H διαγραφή ήταν επιτυχής.', mtInformation, [mbOK], 0);
          btnView.Click;
        end
        else
        begin
          MessageDlg('Η διαγραφή απέτυχε.', mtError, [mbOK], 0);
        end;
      end;
    end;
  end;

end;


procedure TfrmMain.btnEditClick(Sender: TObject); //3
begin
//cba
end;

procedure TfrmMain.btnInsertClick(Sender: TObject); //4
var
  InsertStuffFrm: TfrmInsert;
begin
  try
    InsertStuffFrm := TfrmInsert.Create(Self); //TfrmInsert.Create(nil);
    InsertStuffFrm.conStr := dtmDM.AdoConn.ConnectionString;

    try
      InsertStuffFrm.PageControl1.OnChanging := nil;
      InsertStuffFrm.PageControl1.ActivePageIndex := PageControl1.ActivePageIndex;
    finally
      InsertStuffFrm.PageControl1.OnChanging := InsertStuffFrm.PageControl1Changing;
    end;

    try
      InsertStuffFrm.ShowModal;

      if InsertStuffFrm.DataPassed then
      begin
        ShowMessage('H εισαγωγή ήταν επιτυχής.');
        //btnView.Click;
      end
      else
      begin
        ShowMessage('Η εισαγωγή απέτυχε.');
      end;

      btnView.Click;

    finally
      InsertStuffFrm.Free;
    end;

  except
    on e: Exception do
    begin
      MessageDlg('Πρόβλημα Z001 λειτουργίας, επικοινωνήστε με τον διαχειριστή αναφέροντας: Exception class name : ' + e.ClassName + ' ' + 'Exception message : ' + e.Message, mtError, mbOKCancel, 0);
    end;
  end;
end;


procedure TfrmMain.btnExcelClick(Sender: TObject); //5
begin
  dtmDM.XcelUpd;
end;



procedure TfrmMain.btnPrintClick(Sender: TObject);
var
  i, x, y: integer;
  s, sTmp: string;
  GridTop, GridLeft, GridWidth, GridHeight: integer;
begin
  if not dtmDM.qrPrint.Active then //if not (Assigned(dtmDM.qrPrint)) then
    abort;

  if dtmDM.qrPrint.RecordCount > 0 then // if DBGrid6.DataSource.DataSet.RecordCount > 0 then
  begin
    if dtmDM.cdsInputPrintCode.AsString = EmptyStr then
      sTmp := 'Πελάτες: Όλοι'
    else
      sTmp := 'Κωδικός πελάτη: ' + dtmDM.cdsInputPrintCode.AsString;


    Printer.BeginDoc;
    try
      Printer.Canvas.Font.Name := 'Arial';
      Printer.Canvas.Font.Size := 12;
      Printer.Canvas.Font.Style := [fsBold];

      Printer.Canvas.TextOut(100, 50, 'Εκτύπωση παραγγελιών πελατών');

      Printer.Canvas.Font.Size := 10;
      Printer.Canvas.Font.Style := [];
      Printer.Canvas.TextOut(100, 75, sTmp);
      Printer.Canvas.TextOut(500, 75, 'Εύρος ημ/νιών: ' + DateTimeToStr(dtFrom.DateTime) + ' - ' + DateTimeToStr(dtTo.DateTime));

      Printer.Canvas.Font.Name := 'Arial';
      Printer.Canvas.Font.Size := 8;
      Printer.Canvas.Font.Style := [];

      GridTop := 120;
      GridLeft := 100;
      GridWidth := 600;
      GridHeight := 300;

      try
        dtmDM.qrPrint.DisableControls;

        y := GridTop;
        for i := 0 to DBGrid6.Columns.Count - 1 do
        begin
          s := DBGrid6.Columns[i].Title.Caption;
          Printer.Canvas.TextOut(GridLeft + i * GridWidth div DBGrid6.Columns.Count, y, s);
        end;

        for x := 0 to DBGrid6.DataSource.DataSet.RecordCount - 1 do
        begin
          DBGrid6.DataSource.DataSet.RecNo := x + 1;
          y := GridTop + (x + 1) * GridHeight div (DBGrid6.DataSource.DataSet.RecordCount + 1);
          for i := 0 to DBGrid6.Columns.Count - 1 do
          begin
            s := DBGrid6.Fields[i].DisplayText;
            Printer.Canvas.TextOut(GridLeft + i * GridWidth div DBGrid6.Columns.Count, y, s);
          end;
        end;

      finally
        dtmDM.qrPrint.EnableControls;
      end;

    finally
      Printer.EndDoc;
    end;
  end
  else
  begin
    MessageDlg('Δεν υπάρχουν δεδομένα για εκτύπωση. Βάλτε τα κατάλληλα κριτήρια και πατήστε Ανεύρεση.', mtError, mbOKCancel, 0);
  end;
end;


procedure TfrmMain.btnFindClick(Sender: TObject);
var
  sDFrom, sDTo, strSql: string;

begin
  sDFrom := Trim( FormatDateTime('yyyy-mm-dd', dtFrom.Date) );
  sDTo   := Trim( FormatDateTime('yyyy-mm-dd', dtTo.Date) );
  strSql :=
    ' SELECT [CODE], [CNAME], [OSERVICEDATE], [ODESCR], [OVALUE] ' + #10+#13+
    ' FROM [dbo].[VCUSTORDERS] ' + #10+#13+
    ' WHERE [OSERVICEDATE] BETWEEN ' + QuotedStr(sDFrom) + ' AND ' + QuotedStr(sDTo) + ' AND %s ' + #10+#13+
    ' ORDER BY [CODE], [OSERVICEDATE] ';
  if dtmDM.cdsInputPrintCode.AsString = EmptyStr then
    strSql := Format(strSql, ['1=1'])
  else
    strSql := Format(strSql, ['[CODE] = ' + QuotedStr(dtmDM.cdsInputPrintCode.AsString)]);

  dtmDM.qrPrint.SQL.Text := strSql;
  dtmDM.qrPrint.Open;
end;






end.
