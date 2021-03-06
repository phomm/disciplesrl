﻿unit DisciplesRL.Scenes;

interface

uses
{$IFDEF FPC}
  Graphics,
  Controls,
{$ELSE}
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Imaging.PNGImage,
{$ENDIF}
  Classes,
  SimplePlayer,
  DisciplesRL.Party,
  DisciplesRL.Resources;

type
  TSceneEnum = (scHire, scMenu, scMenu2, scMap, scParty, scSettlement, scBattle2,
    scBattle3);

const
  Top = 220;
  Left = 10;
  DefaultButtonTop = 600;

type
  TMediaPlayer = class(TSimplePlayer)
    procedure Play(const MusicEnum: TMusicEnum); overload;
    procedure PlayMusic(const MusicEnum: TMusicEnum);
  end;

procedure DrawText(const AX, AY: Integer; AText: string); overload;
procedure DrawText(const AY: Integer; AText: string); overload;
procedure DrawText(const AX, AY: Integer; Value: Integer); overload;
procedure DrawText(const AX, AY: Integer; AText: string; F: Boolean); overload;

const
  K_ESCAPE = 27;
  K_ENTER = 13;
  K_SPACE = 32;

  K_A = ord('A');
  K_B = ord('B');
  K_C = ord('C');
  K_D = ord('D');
  K_E = ord('E');
  K_I = ord('I');
  K_J = ord('J');
  K_H = ord('H');
  K_N = ord('N');
  K_P = ord('P');
  K_Q = ord('Q');
  K_R = ord('R');
  K_S = ord('S');
  K_V = ord('V');
  K_W = ord('W');
  K_X = ord('X');
  K_Z = ord('Z');

  K_RIGHT = 39;
  K_LEFT = 37;
  K_DOWN = 40;
  K_UP = 38;

  K_KP_1 = 97;
  K_KP_2 = 98;
  K_KP_3 = 99;
  K_KP_4 = 100;
  K_KP_5 = 101;
  K_KP_6 = 102;
  K_KP_7 = 103;
  K_KP_8 = 104;
  K_KP_9 = 105;

type
  TConfirmMethod = procedure() of object;

var
  ConfirmHandler: TConfirmMethod;

  { TScene }

type
  IScene = interface
    procedure Show(const S: TSceneEnum);
    procedure Render;
    procedure Update(var Key: Word);
    procedure Timer;
    procedure MouseDown(AButton: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
  end;

type
  TBGStat = (bsCharacter, bsEnemy, bsParalyze);

type
  TScene = class(TInterfacedObject, IScene)
  private
    FScrWidth: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Show(const S: TSceneEnum); virtual;
    procedure Render; virtual;
    procedure Update(var Key: Word); virtual;
    procedure Timer; virtual;
    procedure MouseDown(AButton: TMouseButton; Shift: TShiftState;
      X, Y: Integer); virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure DrawTitle(Res: TResEnum);
    procedure DrawImage(X, Y: Integer; Image: TPNGImage); overload;
    procedure DrawImage(Res: TResEnum); overload;
    procedure DrawImage(X, Y: Integer; Res: TResEnum); overload;
    procedure RenderFrame(const PartySide: TPartySide;
      const I, AX, AY: Integer);
    procedure DrawUnit(AResEnum: TResEnum; const AX, AY: Integer; F: TBGStat);
    procedure ConfirmDialog(const S: string; OnYes: TConfirmMethod = nil);
    procedure InformDialog(const S: string);
    procedure DrawResources;
    function MouseOver(AX, AY, MX, MY: Integer): Boolean;
    function GetPartyPosition(const MX, MY: Integer): Integer;
    property ScrWidth: Integer read FScrWidth write FScrWidth;
  end;

type
  TScenes = class(TScene)
  private
    FSceneEnum: TSceneEnum;
    FScene: array [TSceneEnum] of IScene;
    procedure SetScene(const ASceneEnum: TSceneEnum);
  public
    InformMsg: string;
    IsShowInform: Boolean;
    IsShowConfirm: Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure Show(const S: TSceneEnum); override;
    procedure Render; override;
    procedure Update(var Key: Word); override;
    procedure Timer; override;
    procedure MouseDown(AButton: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    property SceneEnum: TSceneEnum read FSceneEnum write FSceneEnum;
    function GetScene(const I: TSceneEnum): TScene;
  end;

var
  Scenes: TScenes;
  Surface: TBitmap;
  MediaPlayer: TMediaPlayer;

implementation

uses
  SysUtils,
  DisciplesRL.MainForm,
  DisciplesRL.Button,
  DisciplesRL.Scene.Map,
  DisciplesRL.Scene.Menu,
  DisciplesRL.Scene.Menu2,
  DisciplesRL.Scene.Settlement,
  DisciplesRL.Scene.Party,
  DisciplesRL.Scene.Hire,
  DisciplesRL.Scene.Battle2,
  DisciplesRL.Scene.Battle3,
  DisciplesRL.Saga;

var
  MediaAvailable: Boolean;
  Button: TButton;

type
  TButtonEnum = (btOk, btCancel);

const
  ButtonsText: array [TButtonEnum] of TResEnum = (reTextOk, reTextCancel);

var
  Buttons: array [TButtonEnum] of TButton;

  { TScene }

constructor TScene.Create;
begin
  inherited;
  ScrWidth := Surface.Width div 2;
  ConfirmHandler := nil;
end;

destructor TScene.Destroy;
begin

  inherited;
end;

procedure TScene.MouseDown(AButton: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin

end;

procedure TScene.MouseMove(Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TScene.Render;
begin

end;

procedure TScene.Show(const S: TSceneEnum);
begin

end;

procedure TScene.Timer;
begin

end;

procedure TScene.Update(var Key: Word);
begin

end;

procedure TScene.DrawTitle(Res: TResEnum);
begin
  DrawImage(ScrWidth - (ResImage[Res].Width div 2), 10, Res);
end;

procedure TScene.ConfirmDialog(const S: string; OnYes: TConfirmMethod);
begin
  MediaPlayer.Play(mmExit);
  Scenes.InformMsg := S;
  Scenes.IsShowConfirm := True;
  ConfirmHandler := OnYes;
end;

procedure TScene.InformDialog(const S: string);
begin
  MediaPlayer.Play(mmExit);
  Scenes.InformMsg := S;
  Scenes.IsShowInform := True;
end;

procedure TScene.DrawImage(X, Y: Integer; Image: TPNGImage);
begin
  Surface.Canvas.Draw(X, Y, Image);
end;

procedure TScene.DrawImage(Res: TResEnum);
begin
  Surface.Canvas.StretchDraw(Rect(0, 0, Surface.Width, Surface.Height),
    ResImage[Res]);
end;

procedure TScene.DrawUnit(AResEnum: TResEnum; const AX, AY: Integer;
  F: TBGStat);
begin
  case F of
    bsCharacter:
      DrawImage(AX + 7, AY + 7, reBGChar);
    bsEnemy:
      DrawImage(AX + 7, AY + 7, reBGEnemy);
    bsParalyze:
      DrawImage(AX + 7, AY + 7, reBGParalyze);
  end;
  DrawImage(AX + 7, AY + 7, AResEnum);
end;

procedure TScene.DrawImage(X, Y: Integer; Res: TResEnum);
begin
  DrawImage(X, Y, ResImage[Res]);
end;

procedure DrawText(const AX, AY: Integer; AText: string);
var
  vStyle: TBrushStyle;
begin
  vStyle := Surface.Canvas.Brush.Style;
  Surface.Canvas.Brush.Style := bsClear;
  Surface.Canvas.TextOut(AX, AY, AText);
  Surface.Canvas.Brush.Style := vStyle;
end;

procedure DrawText(const AX, AY: Integer; Value: Integer);
begin
  DrawText(AX, AY, Value.ToString);
end;

procedure DrawText(const AY: Integer; AText: string);
var
  S: Integer;
begin
  S := Surface.Canvas.TextWidth(AText);
  DrawText((Surface.Width div 2) - (S div 2), AY, AText);
end;

procedure DrawText(const AX, AY: Integer; AText: string; F: Boolean);
var
  N: Integer;
begin
  if F then
  begin
    N := Surface.Canvas.Font.Size;
    Surface.Canvas.Font.Size := N * 2;
  end;
  DrawText(AX, AY, AText);
  if F then
    Surface.Canvas.Font.Size := N;
end;

procedure TScene.RenderFrame(const PartySide: TPartySide;
  const I, AX, AY: Integer);
var
  J: Integer;
begin
  case PartySide of
    psLeft:
      J := I;
  else
    J := I + 6;
  end;
  if (ActivePartyPosition = J) then
    DrawImage(AX, AY, reActFrame)
  else if (SelectPartyPosition = J) then
    DrawImage(AX, AY, reSelectFrame)
  else
    DrawImage(AX, AY, reFrame);
end;

procedure TScene.DrawResources;
begin
  DrawImage(10, 10, reSmallFrame);
  DrawImage(15, 10, reGold);
  DrawText(45, 24, TSaga.Gold);
  DrawImage(15, 40, reMana);
  DrawText(45, 54, TSaga.Mana);
end;

function TScene.MouseOver(AX, AY, MX, MY: Integer): Boolean;
begin
  Result := (MX > AX) and (MX < AX + ResImage[reFrame].Width) and (MY > AY) and
    (MY < AY + ResImage[reFrame].Height);
end;

function TScene.GetPartyPosition(const MX, MY: Integer): Integer;
var
  R: Integer;
  Position: TPosition;
  PartySide: TPartySide;
begin
  R := -1;
  Result := R;
  for PartySide := Low(TPartySide) to High(TPartySide) do
    for Position := Low(TPosition) to High(TPosition) do
    begin
      Inc(R);
      if MouseOver(TSceneParty.GetFrameX(Position, PartySide),
        TSceneParty.GetFrameY(Position, PartySide), MX, MY) then
      begin
        Result := R;
        Exit;
      end;
    end;
end;

{ TMediaPlayer }

procedure TMediaPlayer.Play(const MusicEnum: TMusicEnum);
begin
  Play(ResMusicPath[MusicEnum], MusicBase[MusicEnum].ResType = teMusic);
end;

procedure TMediaPlayer.PlayMusic(const MusicEnum: TMusicEnum);
begin
  if TSaga.NoMusic or not MediaAvailable then
    Exit;
  StopMusic;
  CurrentChannel := MusicChannel;
  Play(MusicEnum);
  CurrentChannel := 1;
end;

{ TScenes }

constructor TScenes.Create;
var
  J, L: Integer;
  I: TButtonEnum;
begin
  Randomize;
  //
  Surface := TBitmap.Create;
  Surface.Width := MainForm.ClientWidth;
  Surface.Height := MainForm.ClientHeight;
  Surface.Canvas.Font.Size := 12;
  Surface.Canvas.Font.Color := clGreen;
  Surface.Canvas.Brush.Style := bsClear;
  //
  inherited Create;
  //
  InformMsg := '';
  IsShowInform := False;
  IsShowConfirm := False;
  //
  TSaga.Wizard := False;
  TSaga.NoMusic := False;
  TSaga.NewBattle := False;
  for J := 1 to ParamCount do
  begin
    if (LowerCase(ParamStr(J)) = '-w') then
      TSaga.Wizard := True;
    if (LowerCase(ParamStr(J)) = '-m') then
      TSaga.NoMusic := True;
    if (LowerCase(ParamStr(J)) = '-b') then
      TSaga.NewBattle := True;
  end;
  //
  try
    MediaPlayer := TMediaPlayer.Create;
    MediaAvailable := True;
  except
    MediaAvailable := False;
  end;
  MediaPlayer.PlayMusic(mmMenu);
  SceneEnum := scMenu2;
  //
  FScene[scMap] := TSceneMap.Create;
  FScene[scMenu] := TSceneMenu.Create;
  FScene[scMenu2] := TSceneMenu2.Create;
  FScene[scHire] := TSceneHire.Create;
  FScene[scParty] := TSceneParty.Create;
  FScene[scBattle2] := TSceneBattle2.Create;
  FScene[scBattle3] := TSceneBattle3.Create;
  FScene[scSettlement] := TSceneSettlement.Create;
  //
  //Inform
  L := ScrWidth - (ResImage[reButtonDef].Width div 2);
  Button := TButton.Create(L, 400, reTextOk);
  Button.Sellected := True;
  //Confirm
  L := ScrWidth - ((ResImage[reButtonDef].Width * 2) div 2);
  for I := Low(TButtonEnum) to High(TButtonEnum) do
  begin
    Buttons[I] := TButton.Create(L, 400, ButtonsText[I]);
    Inc(L, ResImage[reButtonDef].Width);
    if (I = btOk) then
      Buttons[I].Sellected := True;
  end;
end;

destructor TScenes.Destroy;
var
  I: TButtonEnum;
begin
  MediaPlayer.Stop;
  for I := Low(TButtonEnum) to High(TButtonEnum) do
    FreeAndNil(Buttons[I]);
  FreeAndNil(Button);
  FreeAndNil(MediaPlayer);
  FreeAndNil(Surface);
  TSaga.PartyFree;
  inherited;
end;

function TScenes.GetScene(const I: TSceneEnum): TScene;
begin
  Result := TScene(FScene[I]);
end;

procedure TScenes.MouseDown(AButton: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if (FScene[SceneEnum] <> nil) then
  begin
    if IsShowInform then
    begin
      case AButton of
        mbLeft:
          begin
            if Button.MouseDown then
            begin
              IsShowInform := False;
              Self.Render;
              Exit;
            end else
              Exit;
          end;
      end;
      Exit;
    end;
    if IsShowConfirm then
    begin
      case AButton of
          mbLeft:
            begin
              if Buttons[btOk].MouseDown then
              begin
                IsShowConfirm := False;
                if Assigned(ConfirmHandler) then
                begin
                  ConfirmHandler();
                  ConfirmHandler := nil;
                end;
                Self.Render;
                Exit;
              end else
              if Buttons[btCancel].MouseDown then
              begin
                IsShowConfirm := False;
                Self.Render;
                Exit;
              end else
                Exit;
            end;
      end;
      Exit;
    end;
    FScene[SceneEnum].MouseDown(AButton, Shift, X, Y);
    Self.Render;
  end;
end;

procedure TScenes.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  I: TButtonEnum;
begin
  inherited;
  if (FScene[SceneEnum] <> nil) then
  begin
    if IsShowInform then
    begin
      Button.MouseMove(X, Y);
      Exit;
    end;
    if IsShowConfirm then
    begin
      for I := Low(TButtonEnum) to High(TButtonEnum) do
        Buttons[I].MouseMove(X, Y);
      Exit;
    end;
    FScene[SceneEnum].MouseMove(Shift, X, Y);
    Self.Render;
  end;
end;

procedure TScenes.Render;
var
  I: TButtonEnum;
begin
  inherited;
  if (FScene[SceneEnum] <> nil) then
  begin
    Surface.Canvas.Brush.Color := clBlack;
    Surface.Canvas.FillRect(Rect(0, 0, Surface.Width, Surface.Height));
    FScene[SceneEnum].Render;
    if IsShowInform or IsShowConfirm then
    begin
      DrawImage(ScrWidth - (ResImage[reBigFrame].Width div 2), 150,
        ResImage[reBigFrame]);
      DrawText(250, InformMsg);
      if IsShowInform then
        Button.Render;
      if IsShowConfirm then
        for I := Low(Buttons) to High(Buttons) do
          Buttons[I].Render;
    end;
    MainForm.Canvas.Draw(0, 0, Surface);
  end;
end;

procedure TScenes.SetScene(const ASceneEnum: TSceneEnum);
begin
  Self.SceneEnum := ASceneEnum;
end;

procedure TScenes.Show(const S: TSceneEnum);
begin
  SetScene(S);
  if (FScene[SceneEnum] <> nil) then
  begin
    FScene[SceneEnum].Show(S);
    Scenes.Render;
  end;
end;

procedure TScenes.Timer;
begin
  if (FScene[SceneEnum] <> nil) then
  begin
    FScene[SceneEnum].Timer;
  end;
end;

procedure TScenes.Update(var Key: Word);
begin
  if (FScene[SceneEnum] <> nil) then
  begin
    if IsShowInform then
    begin
      case Key of
        K_ESCAPE, K_ENTER:
          begin
            IsShowInform := False;
            Self.Render;
            Exit;
          end
        else
          Exit;
      end;
    end;
    if IsShowConfirm then
    begin
      case Key of
        K_ENTER:
          begin
            IsShowConfirm := False;
            if Assigned(ConfirmHandler) then
            begin
              ConfirmHandler();
              ConfirmHandler := nil;
            end;
            Self.Render;
            Exit;
          end;
        K_ESCAPE:
          begin
            IsShowConfirm := False;
            Self.Render;
            Exit;
          end
        else
          Exit;
      end;
    end;
    FScene[SceneEnum].Update(Key);
    Self.Render;
  end;
end;

end.
