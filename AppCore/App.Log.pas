unit App.Log;

interface

uses
  System.TypInfo,
  System.DateUtils,
  System.Classes,
  System.IOUtils,
  System.SyncObjs,
  System.SysUtils;

type
  TLogStates = (lsStart, lsEnd, lsError, lsAllert, lsNormal);

  TLogs = class
  private
    PathName: string;
    Name: String;
    LogFile: TextFile;
    CriticalSection: TCriticalSection;
    procedure DoLog(NameProc: string; State: TLogStates; Msg: string);
    procedure Init(AName: string);
    procedure CreateLogFile;
    procedure CreateFolber;
  public
    constructor Create(AName: string);
    procedure DoStartProcedure(NameProcedure: String = '');
    procedure DoEndProcedure(NameProcedure: String = '');
    procedure DoError(NameProc: string; Msg: string);
    procedure DoAlert(NameProc: string; Msg: string);
    destructor Destroy; override;
  end;

var
  LogFolberPath: string;

implementation

{ TWebServerLogs }

constructor TLogs.Create(AName: String);
begin
  Init(AName);
  Name := AName;
  CriticalSection := TCriticalSection.Create;
  CriticalSection.Leave;
end;

destructor TLogs.Destroy;
begin
  CriticalSection.Release;
  CriticalSection.Destroy;
end;

procedure TLogs.CreateFolber;
var
  Apath: string;
begin
  Apath := TPath.Combine(GetCurrentDir, 'Logs');
  LogFolberPath := Apath;
  TDirectory.CreateDirectory(LogFolberPath);
end;

procedure TLogs.CreateLogFile;
begin
  Assign(LogFile, PathName);
  Rewrite(LogFile);
  Close(LogFile);
end;

procedure TLogs.DoAlert(NameProc, Msg: string);
begin
  DoLog(NameProc,lsAllert,'Allert Message: ' + Msg);
end;

procedure TLogs.DoEndProcedure(NameProcedure: String);
begin
  DoLog(NameProcedure,lsEnd,'End procedure');
end;

procedure TLogs.DoError(NameProc, Msg: string);
begin
  DoLog(NameProc,lsError,'Error: ' + UpperCase(Msg));
end;

procedure TLogs.DoLog(NameProc: string; State: TLogStates; Msg: string);
var
  Value: string;
begin
  Value := '[' + IntToStr(TThread.CurrentThread.ThreadID) +']' +
           '[' + DateTimeToStr(Now) + ']' +
           '[' + NameProc + ']' +
           '[' + GetEnumName(TypeInfo(TLogStates),Ord(State)) + ']' +
           '[' + Msg + ']';
  try
    CriticalSection.Enter;
    Assign(LogFile,PathName);
    Append(LogFile);
    Writeln(LogFIle,Value);
    Close(LogFile);
  finally
    CriticalSection.Leave;
  end;
end;

procedure TLogs.DoStartProcedure(NameProcedure: String);
begin
  DoLog(NameProcedure,lsStart,'Start Procedure');
end;

procedure TLogs.Init(AName: string);
begin
  if not TDirectory.Exists(LogFolberPath) then
    CreateFolber;

  PathName := TPath.Combine(LogFolberPath, AName);

  if not TFile.Exists(PathName) then
      CreateLogFile;
end;

end.
