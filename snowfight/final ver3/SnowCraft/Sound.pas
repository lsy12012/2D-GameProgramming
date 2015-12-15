unit Sound;

interface

procedure PlaySound(const ResourceID: String);

implementation

uses
  System.Classes, System.Types, FMX.Media, System.IOUtils, System.SysUtils, FMX.forms;

var
  MediaPlayer: TMediaPlayer;

procedure PlaySound(const ResourceID: String);
var
  ResStream: TResourceStream;
  TempFile, FileName: String;
begin
  if MediaPlayer.State = TMediaState.Playing then Exit;

  FileName := ResourceID + '_tmp.mp3';
  TempFile := TPath.Combine( TPath.GetTempPath, FileName );

  if not FileExists( TempFile ) then
   begin
     ResStream := TResourceStream.Create(HInstance, ResourceID, RT_RCDATA);
     try
       ResStream.SaveToFile( TempFile );
     finally
       ResStream.Free;
     end;
   end;
  MediaPlayer.FileName := TempFile;
  MediaPlayer.Play;
end;

initialization
  MediaPlayer := TMediaPlayer.Create( nil );

finalization
  MediaPlayer.Free;

end.
