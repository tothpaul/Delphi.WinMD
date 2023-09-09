program DelphiWinMD;

uses
  Vcl.Forms,
  DelphiWinMD.Main in 'DelphiWinMD.Main.pas' {Main},
  DelphiWinMD.Files in '..\lib\DelphiWinMD.Files.pas',
  DelphiWinMD.Types in '..\lib\DelphiWinMD.Types.pas',
  DelphiWinMD.FieldDefs in '..\lib\DelphiWinMD.FieldDefs.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
