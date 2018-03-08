program DisciplesRL;

uses
  Vcl.Forms,
  DisciplesRL.MainForm in 'DisciplesRL.MainForm.pas' {MainForm},
  DisciplesRL.Utils in 'DisciplesRL.Utils.pas',
  DisciplesRL.Scenes in 'DisciplesRL.Scenes.pas',
  DisciplesRL.Scene.Map in 'DisciplesRL.Scene.Map.pas',
  DisciplesRL.Map in 'DisciplesRL.Map.pas',
  DisciplesRL.Resources in 'DisciplesRL.Resources.pas',
  DisciplesRL.Player in 'DisciplesRL.Player.pas',
  DisciplesRL.Creatures in 'DisciplesRL.Creatures.pas',
  DisciplesRL.Party in 'DisciplesRL.Party.pas',
  DisciplesRL.City in 'DisciplesRL.City.pas',
  DisciplesRL.PathFind in 'DisciplesRL.PathFind.pas',
  DisciplesRL.Scene.Defeat in 'DisciplesRL.Scene.Defeat.pas',
  DisciplesRL.Scene.Victory in 'DisciplesRL.Scene.Victory.pas',
  DisciplesRL.Scene.Menu in 'DisciplesRL.Scene.Menu.pas',
  DisciplesRL.Scene.Battle in 'DisciplesRL.Scene.Battle.pas',
  DisciplesRL.Scene.Capital in 'DisciplesRL.Scene.Capital.pas',
  DisciplesRL.Scene.City in 'DisciplesRL.Scene.City.pas',
  DisciplesRL.GUI.Button in 'DisciplesRL.GUI.Button.pas',
  DisciplesRL.Game in 'DisciplesRL.Game.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.