unit ufrmclient;

{$mode objfpc}
{$H+}

interface

uses
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  ExtCtrls,
  ComCtrls,
  StdCtrls;

type

  { Tfrmclient }

  Tfrmclient = class(TForm)
    imglogo: TImage;
    mmolog:  TMemo;
    pc: TPageControl;
    pnlhead: TPanel;
    sb:      TStatusBar;
    tslog:   TTabSheet;
  private

  public

  end;

var
  frmclient  : Tfrmclient;

implementation

{$R *.lfm}

uses
  udmclient,
  uglobal;

end.
