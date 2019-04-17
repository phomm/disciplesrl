unit DisciplesRL.GUI.Button;

interface

uses
  DisciplesRL.Resources,
  Vcl.Graphics,
  Vcl.Imaging.PNGImage;

type
  TButtonState = (bsNone, bsOver, bsSell, bsDown);

type
  TButton = class(TObject)
  private
    FLeft: Integer;
    FTop: Integer;
    FMouseX: Integer;
    FMouseY: Integer;
    FSellected: Boolean;
    FCanvas: TCanvas;
    FState: TButtonState;
    FText: TResEnum;
    FTextLeft: Integer;
    FTextTop: Integer;
    FSurface: array [TButtonState] of TPNGImage;
    procedure Refresh;
  public
    constructor Create(ALeft, ATop: Integer; ACanvas: TCanvas; ARes: TResEnum);
    destructor Destroy; override;
    procedure Render;
    property Canvas: TCanvas read FCanvas write FCanvas;
    property Top: Integer read FTop;
    property Left: Integer read FLeft;
    property Sellected: Boolean read FSellected write FSellected;
    property State: TButtonState read FState write FState;
    procedure MouseMove(X, Y: Integer);
    function MouseOver(X, Y: Integer): Boolean; overload;
    function MouseOver: Boolean; overload;
    function MouseDown: Boolean;
  end;

implementation

{ TButton }

constructor TButton.Create(ALeft, ATop: Integer; ACanvas: TCanvas; ARes: TResEnum);
var
  I: TButtonState;
begin
  FTop := ATop;
  FLeft := ALeft;
  FCanvas := ACanvas;
  FSellected := False;
  FText := ARes;
  for I := Low(TButtonState) to High(TButtonState) do
  begin
    FSurface[I] := TPNGImage.Create;
    case I of
      bsNone:
        FSurface[I].Assign(ResImage[reButtonDef]);
      bsOver:
        FSurface[I].Assign(ResImage[reButtonAct]);
      bsSell:
        FSurface[I].Assign(ResImage[reButtonAct]);
      bsDown:
        FSurface[I].Assign(ResImage[reButtonAct]);
    end;
  end;
  FTextLeft := FLeft + ((ResImage[reButtonDef].Width div 2) - (ResImage[ARes].Width div 2));
  FTextTop := FTop + ((ResImage[reButtonDef].Height div 2) - (ResImage[ARes].Height div 2));
end;

destructor TButton.Destroy;
var
  I: TButtonState;
begin
  for I := Low(TButtonState) to High(TButtonState) do
    FSurface[I].Free;
  inherited;
end;

function TButton.MouseDown: Boolean;
begin
  Result := False;
  if MouseOver(FMouseX, FMouseY) then
  begin
    State := bsDown;
    Result := True;
  end
  else
    State := bsNone;
  Refresh;
end;

procedure TButton.MouseMove(X, Y: Integer);
begin
  FMouseX := X;
  FMouseY := Y;
end;

function TButton.MouseOver(X, Y: Integer): Boolean;
begin
  Result := (X > Left) and (X < Left + FSurface[bsNone].Width) and (Y > Top) and (Y < Top + FSurface[bsNone].Height);
end;

function TButton.MouseOver: Boolean;
begin
  Result := MouseOver(FMouseX, FMouseY);
end;

procedure TButton.Refresh;
begin
  case State of
    bsNone:
      if Sellected then
        Canvas.Draw(Left, Top, FSurface[bsSell])
      else
        Canvas.Draw(Left, Top, FSurface[bsNone]);
    bsOver:
      Canvas.Draw(Left, Top, FSurface[bsOver]);
    bsDown:
      Canvas.Draw(Left, Top, FSurface[bsDown]);
  end;
end;

procedure TButton.Render;
begin
  if (State <> bsDown) then
  begin
    if MouseOver and not Sellected then
      State := bsOver
    else
      State := bsNone;
  end;
  Refresh;
  Canvas.Draw(FTextLeft, FTextTop, ResImage[FText]);
  if (State = bsDown) and not MouseOver then
    State := bsNone;
end;

end.
