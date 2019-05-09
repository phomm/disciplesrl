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
  DisciplesRL.Scene.Menu in 'DisciplesRL.Scene.Menu.pas',
  DisciplesRL.Scene.Battle in 'DisciplesRL.Scene.Battle.pas',
  DisciplesRL.GUI.Button in 'DisciplesRL.GUI.Button.pas',
  DisciplesRL.Game in 'DisciplesRL.Game.pas',
  DisciplesRL.Scene.Party in 'DisciplesRL.Scene.Party.pas',
  DisciplesRL.Scene.Settlement in 'DisciplesRL.Scene.Settlement.pas',
  DisciplesRL.PascalScript.Battle in 'DisciplesRL.PascalScript.Battle.pas',
  DisciplesRL.PascalScript.Vars in 'DisciplesRL.PascalScript.Vars.pas',
  DisciplesRL.MapObject in 'DisciplesRL.MapObject.pas',
  DisciplesRL.Scene.Hire in 'DisciplesRL.Scene.Hire.pas',
  DisciplesRL.BattleLog in 'DisciplesRL.BattleLog.pas',
  DisciplesRL.Scene.Battle2 in 'DisciplesRL.Scene.Battle2.pas',
  DisciplesRL.Scene.Info in 'DisciplesRL.Scene.Info.pas';

{$R *.res}

begin
  Randomize();
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'DisciplesRL';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

end.
