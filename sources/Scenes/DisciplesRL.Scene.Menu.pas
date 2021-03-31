﻿unit DisciplesRL.Scene.Menu;

interface

uses
{$IFDEF FPC}
  Controls,
{$ELSE}
  Vcl.Controls,
{$ENDIF}
  Classes,
  DisciplesRL.Button,
  DisciplesRL.Resources,
  DisciplesRL.Scenes;

type

  { TSceneMenu }

  TSceneMenu = class(TScene)
  private type
    TButtonEnum = (btPlay, btContinue, btHighScores, btQuit);
  private const
    ButtonText: array [TButtonEnum] of TResEnum = (reTextPlay, reTextContinue,
      reTextHighScores, reTextQuit);
  private var
    CursorPos: TButtonEnum;
    Button: array [TButtonEnum] of TButton;
  private
    procedure Next;
    procedure Quit;
    procedure ConfirmQuit;
    procedure PlayGame;
    procedure ContinueGame;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Render; override;
    procedure Update(var Key: Word); override;
    procedure Timer; override;
    procedure MouseDown(AButton: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  end;

implementation

uses
  Math,
  SysUtils,
  DisciplesRL.MainForm,
  DisciplesRL.Saga,
  DisciplesRL.Scene.Hire;

procedure TSceneMenu.Next;
begin
  MediaPlayer.Play(mmClick);
  case CursorPos of
    btPlay:
      PlayGame;
    btContinue:
      ContinueGame;
    btHighScores:
      TSceneHire.Show(stHighScores2);
    btQuit:
      ConfirmQuit;
  end;
end;

procedure TSceneMenu.Quit;
begin
  DisciplesRL.MainForm.MainForm.Close;
end;

procedure TSceneMenu.ConfirmQuit;
begin
  ConfirmDialog2('Завершить игру?', {$IFDEF FPC}@{$ENDIF}Quit);
end;

procedure TSceneMenu.PlayGame;
begin
  TSaga.IsGame := False;
  TSceneHire.Show(stScenario);
end;

procedure TSceneMenu.ContinueGame;
begin
  if TSaga.IsGame then
  begin
    MediaPlayer.PlayMusic(mmMap);
    Scenes.Show(scMap);
  end;
end;

{ TSceneMenu }

constructor TSceneMenu.Create;
var
  L, T, H: Integer;
  I: TButtonEnum;
begin
  inherited;
  L := ScrWidth - (ResImage[reButtonDef].Width div 2);
  H := ResImage[reButtonDef].Height + 10;
  T := (Surface.Height div 3 * 2) - ((H * (Ord(High(TButtonEnum)) + 1)) div 2);
  for I := Low(TButtonEnum) to High(TButtonEnum) do
  begin
    Button[I] := TButton.Create(L, T, ButtonText[I]);
    if (I = btPlay) then
      Button[I].Sellected := True;
    Inc(T, H);
  end;
end;

destructor TSceneMenu.Destroy;
var
  I: TButtonEnum;
begin
  for I := Low(TButtonEnum) to High(TButtonEnum) do
    FreeAndNil(Button[I]);
  inherited;
end;

procedure TSceneMenu.MouseDown(AButton: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  I: TButtonEnum;
begin
  inherited;
  case AButton of
    mbLeft:
      begin
        for I := Low(TButtonEnum) to High(TButtonEnum) do
          if Button[I].MouseDown then
          begin
            CursorPos := I;
            Next;
          end;
      end;
  end;
end;

procedure TSceneMenu.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  I: TButtonEnum;
begin
  inherited;
  for I := Low(TButtonEnum) to High(TButtonEnum) do
    Button[I].MouseMove(X, Y);
  Render;
end;

procedure TSceneMenu.Render;

  procedure RenderButtons;
  var
    I: TButtonEnum;
  begin
    for I := Low(TButtonEnum) to High(TButtonEnum) do
    begin
      Button[I].Sellected := (I = CursorPos);
      Button[I].Render;
    end;
  end;

begin
  inherited;
  DrawImage(reWallpaperMenu);
  DrawTitle(reTitleLogo);
  RenderButtons;
  DrawText(Surface.Height - 50, '2018-2021 by Apromix');
end;

procedure TSceneMenu.Timer;
begin
  inherited;

end;

procedure TSceneMenu.Update(var Key: Word);
const
  ButtonEdges = [Low(TButtonEnum), High(TButtonEnum)];
  Z = SizeOf(ButtonEdges);
type
  SetCast = {$IF Z = 1} Byte {$ELSEIF Z = 2} Word
    {$ELSEIF Z = 4} Integer {$ELSEIF Z = 8} Int64 {$IFEND};
begin
  inherited;
  try
    case Key of
      K_ENTER:
        Next;
      K_ESCAPE:
        ConfirmQuit;
      {$RangeChecks ON}
      K_UP:
        CursorPos := Pred(CursorPos);
      K_DOWN:
        CursorPos := Succ(CursorPos);
      {$RangeChecks OFF}
    end;
  except
    on ERangeError do
      CursorPos := TButtonEnum(Trunc(Log2(SetCast(ButtonEdges - [CursorPos]))));
  end;
end;

end.
