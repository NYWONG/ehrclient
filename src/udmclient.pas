unit udmclient;

{$mode ObjFPC}
{$H+}

interface

uses
  Classes,
  StrUtils,
  DateUtils,
  System.IOUtils,
  SysUtils,
  Registry,
  FileUtil,
  Menus,
  ExtCtrls,
  UniqueInstance,
  {$ifdef MSWINDOWS}
  Windows,
  ShellAPI,
  ComObj,
  ActiveX,
  {$endif}
  gettext,
  LCLTranslator,
  Forms,
  rtcInfo,
  rtcSystem,
  rtcConn,
  rtcHttpSrv,
  rtcDataSrv;

type

  { Tdmclient }

  Tdmclient = class(TDataModule)
    ap:    TApplicationProperties;
    mi11:  TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    mi99:  TMenuItem;
    Separator2: TMenuItem;
    Separator1: TMenuItem;
    pm:    TPopupMenu;
    rtcdp: TRtcDataProvider;
    rtchs: TRtcHttpServer;
    ti:    TTrayIcon;
    ui:    TUniqueInstance;
    procedure apDropFiles(Sender: TObject; const FileNames: array of string);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure mi99Click(Sender: TObject);
    procedure rtcdpCheckRequest(Sender: TRtcConnection);
    procedure rtcdpDataReceived(Sender: TRtcConnection);
    procedure tiDblClick(Sender: TObject);
    procedure uiOtherInstance(Sender: TObject; ParamCount: integer;
      const Parameters: array of string);
  private
    function doPrint(Sender: TRtcConnection): string;
    function doUpload(Sender: TRtcConnection): string;
    function doClient(aQuery: string): string;
    function doCam(aQuery: string): string;
    function doScan(aQuery: string): string;
    function doCard(aQuery: string): string;
    function doOCR(Sender: TRtcConnection): string;
    function doTrans(aSrc, aType: string): string;
    function doTTS(aQuery: string): string;
    procedure setStart;
    procedure setWebShell;
  public
    procedure srvStart;
    procedure srvStop;
  end;

var
  dmclient  : Tdmclient;
  gPath  :    string;
  gConfig  :  TStrings;

procedure sysLog(const aMsg: string; const Params: array of const);
function sysfile(const aFile: string; const abool: boolean = False): string;

implementation

{$R *.lfm}

{ Tdmclient }
uses
  ufrmclient,
  uglobal;

procedure sysLog(const aMsg: string; const Params: array of const);
begin
  if Assigned(frmclient) then
    frmclient.mmolog.Lines.Add(Format(
      '%s %s', [FormatDateTime('hh:nn:ss.zzz', now), Format(aMsg, Params)]));
end;

function sysfile(const aFile: string; const abool: boolean = False): string;
begin
  Result := TPath.Combine(TPath.GetAppPath, 'webroot') + afile;
  Result := Result.Replace('/', '\').Replace('\\', '\');
  if not abool and not DirectoryExists(ExtractFilePath(Result)) then
    ForceDirectories(ExtractFilePath(Result));
end;

procedure Tdmclient.DataModuleCreate(Sender: TObject);
begin
  SetDefaultLang('', '', 'ehrreport', True);
  setStart;
  setWebShell;
  srvStart;
  {$ifdef MSWINDOWS}
  ShellExecute(0, 'open', PChar('http://127.0.0.1:5858/index.html'), '', '', 1);
  {$endif}
end;

procedure Tdmclient.apDropFiles(Sender: TObject; const FileNames: array of string);
begin
  uiOtherInstance(ui, High(FileNames) + 1, FileNames);
end;

procedure Tdmclient.DataModuleDestroy(Sender: TObject);
begin
  srvStop;
end;

procedure Tdmclient.mi99Click(Sender: TObject);
begin
  case TMenuItem(Sender).tag of
    99:
      Application.Terminate;
    11:
      if frmclient.Showing then
        frmclient.Hide
      else
        frmclient.Show;
    end;
end;

procedure Tdmclient.rtcdpCheckRequest(Sender: TRtcConnection);
begin
  with Sender, request do
    accept;
end;

procedure Tdmclient.rtcdpDataReceived(Sender: TRtcConnection);
var
  aFile  : string;
begin
  with Sender, request do
    begin
    Response.HeaderText  := Response.HeaderText + 'Access-Control-Allow-Origin:*'#13#10;
    Response.HeaderText  := Response.HeaderText +
      'Access-Control-Allow-Method:GET,POST'#13#10;
    Response.HeaderText  := Response.HeaderText +
      'Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With'#13#10;
    Response.ContentType := 'application/json;charset=utf-8';

    if FileName = '/print' then
      Write(doPrint(Sender))
    else if FileName = '/upload' then
      Write(doUpload(Sender))
    else if FileName = '/card' then
      Write(doCard(Query.Value['type']))
    else if FileName = '/scan' then
      Write(doScan(Query.Text))
    else if FileName = '/cam' then
      Write(doCam(Query.Text))
    else if FileName = '/client' then
      Write(doClient(Query.Text))
    else if FileName = '/tts' then
      Write(doTTS(Query.Value['txt']))
    else if FileName = '/ocr' then
      begin
      aFile := doOCR(Sender);
      Write(aFile);
      end
    else if FileName = '/trans' then
      Write(doTrans(Query.Value['src'], Query.Value['type']))
    else
      begin
      Response.ContentType := 'text/html;charset=utf-8';
      aFile := sysfile(filename);
      Write(Read_File(aFile));
      end;
    end;
end;

procedure Tdmclient.tiDblClick(Sender: TObject);
begin
  mi11.Click;
end;

procedure Tdmclient.uiOtherInstance(Sender: TObject; ParamCount: integer;
  const Parameters: array of string);
var
  i  : integer;
begin
  for i := 0 to ParamCount - 1 do
    sysLog(Parameters[i], []);
end;

function Tdmclient.doPrint(Sender: TRtcConnection): string;
begin

end;

function Tdmclient.doUpload(Sender: TRtcConnection): string;
begin

end;

function Tdmclient.doClient(aQuery: string): string;
begin

end;

function Tdmclient.doCam(aQuery: string): string;
begin

end;

function Tdmclient.doScan(aQuery: string): string;
begin

end;

function Tdmclient.doCard(aQuery: string): string;
begin

end;

function Tdmclient.doOCR(Sender: TRtcConnection): string;
begin

end;

function Tdmclient.doTrans(aSrc, aType: string): string;
begin

end;

function Tdmclient.doTTS(aQuery: string): string;
begin
    try
    sysCmd('nircmd speak text "' + aQuery + '" 2 80');
    Result := Format(msg2, [0, '成功']);
    except
    on e: Exception do
      Result := Format(msg2, [1, '失败']);
    end;
end;

procedure Tdmclient.setStart;
begin
  with TRegistry.Create do
    try
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', True) then
      begin
      WriteString('ehrprint', ParamStr(0));
      CloseKey;
      end;
    if OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System', True) then
      begin
      WriteInteger('EnableLUA', 0);
      CloseKey;
      end;
    finally
    Free;
    end;
end;

procedure Tdmclient.setWebShell;
begin
  with TRegistry.Create do
    try
    RootKey := HKEY_CLASSES_ROOT;
    if OpenKey('ehrclient', True) then
      begin
      WriteString('', 'URL:ehrclient Protocol');
      WriteString('URL Protocol', '');
      CloseKey;
      end;
    if OpenKey('ehrclient\shell\open\command', True) then
      begin
      WriteString('', ParamStr(0) + ' "%1"');
      CloseKey;
      end;
    finally
    Free;
    end;
end;

procedure Tdmclient.srvStart;
begin
  rtchs.Listen();
end;

procedure Tdmclient.srvStop;
begin
  rtchs.StopListenNow();
end;

initialization
  gPath   := ExtractFilePath(ParamStr(0));
  gConfig := TStringList.Create();

  gConfig.LoadFromFile(gpath + 'config.dat');

finalization
  gConfig.Free;
end.
