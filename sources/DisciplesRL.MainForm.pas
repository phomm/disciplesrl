unit DisciplesRL.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TMainForm = class(TForm)
    Timer1: TTimer;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses DisciplesRL.Scenes, DisciplesRL.Resources, DisciplesRL.Map, DisciplesRL.Player, DisciplesRL.Game;

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  Top := 0;
  Left := 0;
  Randomize;
  // Test
  DisciplesRL.Resources.Init;
  DisciplesRL.Map.Init;
  DisciplesRL.Map.Gen;
  DisciplesRL.Player.Init;
  //
  ClientWidth := MapWidth * TileSize;
  ClientHeight := MapHeight * TileSize;
  DisciplesRL.Scenes.Init;
  for I := 1 to ParamCount do
  begin
    if (LowerCase(ParamStr(I)) = '-w') then
      Wizard := True;
  end;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  DisciplesRL.Scenes.Render;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  DisciplesRL.Scenes.Timer;
end;

procedure TMainForm.FormClick(Sender: TObject);
begin
  DisciplesRL.Scenes.MouseClick;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DisciplesRL.Resources.Free;
  DisciplesRL.Scenes.Free;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisciplesRL.Scenes.KeyDown(Key, Shift);
end;

procedure TMainForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  DisciplesRL.Scenes.MouseMove(Shift, X, Y);
  Caption := Format('DisciplesRL (%d:%d) [m:%d]', [X, Y, GoldMines]);
end;

end.