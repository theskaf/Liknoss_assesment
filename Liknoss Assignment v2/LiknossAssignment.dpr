program LiknossAssignment;

uses
  Vcl.Forms,
  MainFrm in 'MainFrm.pas' {frmMain},
  MyHelper in 'MyHelper.pas',
  Vcl.Themes,
  Vcl.Styles,
  DMDtm in 'DMDtm.pas' {dtmDM: TDataModule},
  InsertFrm in 'InsertFrm.pas' {frmInsert};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Lavender Classico');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
