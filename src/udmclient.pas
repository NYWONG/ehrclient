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
  FileUtil,
  Menus,
  ExtCtrls,
  UniqueInstance,
  gettext,
  LCLTranslator, rtcHttpSrv, rtcDataSrv;

type

  { Tdmclient }

  Tdmclient = class(TDataModule)
    pm: TPopupMenu;
    rtcdp: TRtcDataProvider;
    rtchs: TRtcHttpServer;
    ti: TTrayIcon;
    ui: TUniqueInstance;
    procedure DataModuleCreate(Sender: TObject);
  private

  public

  end;

var
  dmclient  : Tdmclient;

implementation

{$R *.lfm}

{ Tdmclient }

procedure Tdmclient.DataModuleCreate(Sender: TObject);
begin
  SetDefaultLang('', '', 'ehrclient', True);
end;

end.
