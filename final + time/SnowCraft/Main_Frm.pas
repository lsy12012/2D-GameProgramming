unit Main_Frm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects, FMX.StdCtrls,
  Engine, FMX.Media;

type
  TMain_Form = class(TForm)
    Image_YouStop: TImageControl;
    Image_YouMove1: TImageControl;
    Image_YouMove2: TImageControl;
    Image_YouShoot1: TImageControl;
    Image_YouShoot2: TImageControl;
    Image_YouShoot3: TImageControl;
    Image_YouHit: TImageControl;
    Image_YouDelay1: TImageControl;
    Image_YouDelay2: TImageControl;
    Image_YouDown: TImageControl;
    Image_YouDead1: TImageControl;
    Image_MeStop: TImageControl;
    Image_MeMove1: TImageControl;
    Image_MeMove2: TImageControl;
    Image_MeShoot1: TImageControl;
    Image_MeShoot2: TImageControl;
    Image_MeShoot3: TImageControl;
    Image_MeHit: TImageControl;
    Image_MeDelay1: TImageControl;
    Image_MeDelay2: TImageControl;
    Image_MeDown: TImageControl;
    Image_MeDead: TImageControl;
    Image_MeShadow: TImageControl;
    Image_YouShadow: TImageControl;
    Image_Logo: TImageControl;
    Image_BunkerYou1: TImageControl;
    Image_BunkerMe1: TImageControl;
    Image_BunkerYou2: TImageControl;
    Image_BunkerMe2: TImageControl;
    Image_BunkerYou3: TImageControl;
    Image_BunkerMe3: TImageControl;
    Image_BunkerYou4: TImageControl;
    Image_BunkerMe4: TImageControl;
    Image_Snow: TImageControl;
    Image_SnowShadow: TImageControl;
    Image_SnowDead1: TImageControl;
    Image_SnowDead2: TImageControl;
    Image_Focus: TImageControl;
    Image_Back1: TImageControl;
    Image_Back4: TImageControl;
    Image_YouDead2: TImageControl;
    Image_Power1: TImageControl;
    Image_Power2: TImageControl;
    Image_Power3: TImageControl;
    Image_Power4: TImageControl;
    Image_Power5: TImageControl;
    Image_Power6: TImageControl;
    Image_Power7: TImageControl;
    Image_Power8: TImageControl;
    Image_Power9: TImageControl;
    Image_Power10: TImageControl;
    PaintBox: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject; Canvas: TCanvas);
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure PaintBoxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  private
    Characters: TCharacterCollection;
  public
  end;

var
  Main_Form: TMain_Form;

implementation

{$R *.fmx}

procedure TMain_Form.FormCreate(Sender: TObject);
begin
  Characters := TCharacterCollection.Create( PaintBox );
  Characters.Image_YouStop := Image_YouStop.Bitmap;
  Characters.Image_YouMove1 := Image_YouMove1.Bitmap;
  Characters.Image_YouMove2 := Image_YouMove2.Bitmap;
  Characters.Image_YouShoot1 := Image_YouShoot1.Bitmap;
  Characters.Image_YouShoot2 := Image_YouShoot2.Bitmap;
  Characters.Image_YouShoot3 := Image_YouShoot3.Bitmap;
  Characters.Image_YouHit := Image_YouHit.Bitmap;
  Characters.Image_YouDelay1 := Image_YouDelay1.Bitmap;
  Characters.Image_YouDelay2 := Image_YouDelay2.Bitmap;
  Characters.Image_YouDown := Image_YouDown.Bitmap;
  Characters.Image_YouDead2 := Image_YouDead2.Bitmap;
  Characters.Image_YouDead1 := Image_YouDead1.Bitmap;
  Characters.Image_MeShadow := Image_MeShadow.Bitmap;
  Characters.Image_MeStop := Image_MeStop.Bitmap;
  Characters.Image_MeMove1 := Image_MeMove1.Bitmap;
  Characters.Image_MeMove2 := Image_MeMove2.Bitmap;
  Characters.Image_MeShoot1 := Image_MeShoot1.Bitmap;
  Characters.Image_MeShoot2 := Image_MeShoot2.Bitmap;
  Characters.Image_MeShoot3 := Image_MeShoot3.Bitmap;
  Characters.Image_MeHit := Image_MeHit.Bitmap;
  Characters.Image_MeDelay1 := Image_MeDelay1.Bitmap;
  Characters.Image_MeDelay2 := Image_MeDelay2.Bitmap;
  Characters.Image_MeDown := Image_MeDown.Bitmap;
  Characters.Image_MeDead := Image_MeDead.Bitmap;
  Characters.Image_YouShadow := Image_YouShadow.Bitmap;
  Characters.Image_Snow := Image_Snow.Bitmap;
  Characters.Image_SnowShadow := Image_SnowShadow.Bitmap;
  Characters.Image_SnowDead1 := Image_SnowDead1.Bitmap;
  Characters.Image_SnowDead2 := Image_SnowDead2.Bitmap;
  Characters.Image_Focus := Image_Focus.Bitmap;
  Characters.Image_BunkerMe1 := Image_BunkerMe1.Bitmap;
  Characters.Image_BunkerMe2 := Image_BunkerMe2.Bitmap;
  Characters.Image_BunkerMe3 := Image_BunkerMe3.Bitmap;
  Characters.Image_BunkerMe4 := Image_BunkerMe4.Bitmap;
  Characters.Image_BunkerYou1 := Image_BunkerYou1.Bitmap;
  Characters.Image_BunkerYou2 := Image_BunkerYou2.Bitmap;
  Characters.Image_BunkerYou3 := Image_BunkerYou3.Bitmap;
  Characters.Image_BunkerYou4 := Image_BunkerYou4.Bitmap;
  Characters.Image_Back1 := Image_Back1.Bitmap;
  Characters.Image_Back4 := Image_Back4.Bitmap;
  Characters.Image_Logo := Image_Logo.Bitmap;
  Characters.Image_Power1 := Image_Power1.Bitmap;
  Characters.Image_Power2 := Image_Power2.Bitmap;
  Characters.Image_Power3 := Image_Power3.Bitmap;
  Characters.Image_Power4 := Image_Power4.Bitmap;
  Characters.Image_Power5 := Image_Power5.Bitmap;
  Characters.Image_Power6 := Image_Power6.Bitmap;
  Characters.Image_Power7 := Image_Power7.Bitmap;
  Characters.Image_Power8 := Image_Power8.Bitmap;
  Characters.Image_Power9 := Image_Power9.Bitmap;
  Characters.Image_Power10 := Image_Power10.Bitmap;
end;

procedure TMain_Form.FormDestroy(Sender: TObject);
begin
  Characters.Free;
end;

procedure TMain_Form.FormActivate(Sender: TObject);
begin
  Characters.Restart;
end;

procedure TMain_Form.FormDeactivate(Sender: TObject);
begin
  Characters.Pause;
end;

procedure TMain_Form.PaintBoxPaint(Sender: TObject; Canvas: TCanvas);
begin
  Characters.Draw( Canvas );
end;

procedure TMain_Form.PaintBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if Characters.Active then Characters.MouseDown( Trunc(X), Trunc(Y) )
                       else Characters.StartGame;
end;

procedure TMain_Form.PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  Characters.MouseMove( Trunc(X), Trunc(Y) );
end;

procedure TMain_Form.PaintBoxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  Characters.MouseUp( Trunc(X), Trunc(Y) );
end;

end.
