unit uglobal;

{$mode ObjFPC}
{$H+}

interface

uses
  Classes,
  SysUtils,
  Process,
  fphttpclient,
  opensslsockets;

const
  msg2  = '{"code":%d,"msg":"%s"}';
  msg3c = '{"code":%d,"msg":"%s","data":"%s"}';
  msg3  = '{"code":%d,"msg":"%s","data":%s}';

var
  gPath  :   string;
  gConfig  : string;
  gHTTPClient  : TFPHTTPClient;

function SysCmd(const ACommand: string): string;
function sysGet(const aUrl: string; const aHead: string = ''): string;
function sysPost(const aUrl, aParams: string; const aHead: string = ''): string;

implementation

function SysCmd(const ACommand: string): string;
var
  Process  : TProcess;
  Output  :  TStringList;
begin
  Result  := '';
  Process := TProcess.Create(nil);
  Output  := TStringList.Create;
    try
    Process.CommandLine := ACommand;
    Process.Options     := Process.Options + [poWaitOnExit, poUsePipes];
    Process.Execute;

    Output.LoadFromStream(Process.Output);
    Result := Output.Text;

    if Process.ExitCode <> 0 then
      begin
      Output.Clear;
      Output.LoadFromStream(Process.Stderr);
      Result := Result + 'Error: ' + Output.Text;
      end;
    finally
    Output.Free;
    Process.Free;
    end;
end;

function sysGet(const aUrl: string; const aHead: string = ''): string;
var
  i  : integer;
  Headers  : TStringList;
begin
  Result := '';
  if not Assigned(gHTTPClient) then
    Exit;

    try
    gHTTPClient.RequestHeaders.Clear;
    if aHead <> '' then
      begin
      Headers := TStringList.Create;
        try
        Headers.Text := aHead;
        for i := 0 to Headers.Count - 1 do
          begin
          gHTTPClient.RequestHeaders.Add(Headers[i]);
          end;
        finally
        Headers.Free;
        end;
      end;

    Result := gHTTPClient.Get(aUrl);
    except
    on E: Exception do
      begin
      Result := 'Error: ' + E.Message;
      end;
    end;
end;

function sysPost(const aUrl, aParams: string; const aHead: string = ''): string;
var
  i  : integer;
  Headers  : TStringList;
  RequestStream  : TStringStream;
  ResponseStream  : TStringStream;
begin
  Result := '';
  if not Assigned(gHTTPClient) then
    Exit;

    try
    gHTTPClient.RequestHeaders.Clear;
    if aHead <> '' then
      begin
      Headers := TStringList.Create;
        try
        Headers.Text := aHead;
        for i := 0 to Headers.Count - 1 do
          begin
          gHTTPClient.RequestHeaders.Add(Headers[i]);
          end;
        finally
        Headers.Free;
        end;
      end;

    RequestStream  := TStringStream.Create(aParams, TEncoding.UTF8);
    ResponseStream := TStringStream.Create('', TEncoding.UTF8);
      try
      gHTTPClient.RequestBody := RequestStream;
      Result := gHTTPClient.Post(aUrl);
      finally
      ResponseStream.Free;
      RequestStream.Free;
      end;
    except
    on E: Exception do
      begin
      Result := 'Error: ' + E.Message;
      end;
    end;
end;

initialization

  gHTTPClient := TFPHTTPClient.Create(nil);
  gHTTPClient.AllowRedirect := True;
  gHTTPClient.ConnectTimeout := 5000;

finalization
  gHTTPClient.Free;

end.
