program SnowCraft;





{$R *.dres}

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  Main_Frm in 'Main_Frm.pas' {Main_Form},
  Data in 'Data.pas',
  Engine in 'Engine.pas',
  Sound in 'Sound.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.soLandscape, TFormOrientation.soInvertedLandscape];
  Application.CreateForm(TMain_Form, Main_Form);
  Application.Run;
end.
