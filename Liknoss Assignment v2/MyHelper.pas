﻿unit MyHelper; // Includes a mutex - kinda thingy only, no other helper functions and whatnot

interface

uses
  Winapi.Windows, Winapi.Messages; //,  Vcl.Dialogs,  System.IniFiles,  Vcl.Forms;

const
  cWindowClassName = 'Liknoss.Assignment.0.0.0.9'; // Name of main window class
  cCopyDataWaterMark = $000007B3; //1971 =  Any 32 bit number here to perform check on copied data
  UM_ENSURERESTORED = WM_USER + 1; // User window message handled by main form ensures that // app not minimized or hidden and is in foreground

function FindDuplicateMainWdw: HWND;
function SwitchToPrevInst(Wdw: HWND): Boolean;

implementation

uses
  System.SysUtils;

function SendParamsToPrevInst(Wdw: HWND): Boolean;
var
    CopyData: TCopyDataStruct;
    I, CharCount: Integer;
    Data, PData: PChar;
begin
  CharCount := 0;
  for I := 1 to ParamCount do
     Inc(CharCount, Length(ParamStr(I)) + 1);
  Inc(CharCount);
  Data := StrAlloc(CharCount);
  try
     PData := Data;
     for I := 1 to ParamCount do
     begin
       StrPCopy(PData, ParamStr(I));
       Inc(PData, Length(ParamStr(I)) + 1);
     end;
     PData^ := #0; //i lol at pointers, not safe, why do i even
     CopyData.lpData := Data;
     CopyData.cbData := CharCount * SizeOf(Char);
     CopyData.dwData := cCopyDataWaterMark;
     Result := SendMessage(
       Wdw, WM_COPYDATA, 0, LPARAM(@CopyData)
     ) = 1;
  finally
     StrDispose(Data);
  end;
end;

function FindDuplicateMainWdw: HWND;
begin
  Result := FindWindow(cWindowClassName, nil);
end;

function SwitchToPrevInst(Wdw: HWND): Boolean;
begin
  Assert(Wdw <> 0);
  if ParamCount > 0 then
    Result := SendParamsToPrevInst(Wdw)
  else
    Result := True;
  if Result then
    SendMessage(Wdw, UM_ENSURERESTORED, 0, 0);
end;

end.
