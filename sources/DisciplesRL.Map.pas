unit DisciplesRL.Map;

interface

uses
  DisciplesRL.Resources,
  DisciplesRL.Party;

var
  MapWidth: Integer = 40 + 2;
  MapHeight: Integer = 20 + 2;

const
  TileSize = 32;

type
  TLayerEnum = (lrTile, lrPath, lrDark, lrObj);

type
  TMapLayer = array of array of TResEnum;
  TIgnoreRes = set of TResEnum;

var
  Map: array [TLayerEnum] of TMapLayer;

function GetDist(X1, Y1, X2, Y2: Integer): Integer;
function GetDistToCapital(const AX, AY: Integer): Integer;
procedure Init;
procedure Clear(const L: TLayerEnum);
procedure Gen;
function InRect(const X, Y, X1, Y1, X2, Y2: Integer): Boolean;
function InMap(const X, Y: Integer): Boolean;
procedure UpdateRadius(const AX, AY, AR: Integer; var MapLayer: TMapLayer; const AResEnum: TResEnum; IgnoreRes: TIgnoreRes = []);
function LeaderTile: TResEnum;
function IsLeaderMove(const X, Y: Integer): Boolean;

implementation

uses
  System.Math,
  System.SysUtils,
  DisciplesRL.Leader,
  DisciplesRL.City,
  DisciplesRL.PathFind,
  DisciplesRL.Game,
  DisciplesRL.Creatures;

function GetDist(X1, Y1, X2, Y2: Integer): Integer;
begin
  Result := Round(Sqrt(Sqr(X2 - X1) + Sqr(Y2 - Y1)));
end;

function GetDistToCapital(const AX, AY: Integer): Integer;
begin
  Result := GetDist(City[0].X, City[0].Y, AX, AY);
end;

procedure Init;
var
  L: TLayerEnum;
begin
  for L := Low(TLayerEnum) to High(TLayerEnum) do
  begin
    SetLength(Map[L], MapWidth, MapHeight);
    Clear(L);
  end;
  DisciplesRL.City.Init;
  LeaderParty := TParty.Create(Leader.X, Leader.Y, Leader.Race);
  CapitalParty := TParty.Create(Leader.X, Leader.Y, Leader.Race);
end;

procedure Clear(const L: TLayerEnum);
var
  X, Y: Integer;
begin
  for Y := 0 to MapHeight - 1 do
    for X := 0 to MapWidth - 1 do
      case L of
        lrTile, lrPath, lrObj:
          Map[L][X, Y] := reNone;
        lrDark:
          Map[L][X, Y] := reDark;
      end;
end;

function ChTile(X, Y: Integer): Boolean; stdcall;
begin
  Result := True;
end;

procedure Gen;
var
  X, Y, RX, RY, I: Integer;
begin
  for Y := 0 to MapHeight - 1 do
    for X := 0 to MapWidth - 1 do
    begin
      Map[lrTile][X, Y] := reNeutralTerrain;
      if (X = 0) or (X = MapWidth - 1) or (Y = 0) or (Y = MapHeight - 1) then
      begin
        Map[lrObj][X, Y] := reMountain;
        Continue;
      end;
      case RandomRange(0, 5) of
        0:
          Map[lrObj][X, Y] := reTreePine;
        1:
          Map[lrObj][X, Y] := reTreeOak;
      else
        Map[lrObj][X, Y] := reMountain;
      end;

    end;
  // Capital and Cities
  DisciplesRL.City.Gen;
  X := City[0].X;
  Y := City[0].Y;
  for I := 1 to High(City) do
  begin
    repeat
      if IsPathFind(MapWidth, MapHeight, X, Y, City[I].X, City[I].Y, ChTile, RX, RY) then
      begin
        // if (RandomRange(0, 2) = 0) then
        begin
          X := RX + RandomRange(-1, 2);
          Y := RY + RandomRange(-1, 2);
          if Map[lrObj][X, Y] = reMountain then
            Map[lrObj][X, Y] := reNone;
        end;
        X := RX;
        Y := RY;
        if Map[lrObj][X, Y] = reMountain then
          Map[lrObj][X, Y] := reNone;
      end;
    until ((X = City[I].X) and (Y = City[I].Y));
  end;
  // Golds and Bags
  for I := 0 to High(City) div 2 do
  begin
    repeat
      X := RandomRange(2, MapWidth - 2);
      Y := RandomRange(2, MapHeight - 2);
    until (Map[lrTile][X, Y] = reNeutralTerrain) and (Map[lrObj][X, Y] = reNone);
    if (GetDistToCapital(X, Y) <= 15) and (RandomRange(0, 9) > 2) then
      Map[lrObj][X, Y] := reGold
    else
      Map[lrObj][X, Y] := reBag;
  end;
  // Enemies
  for I := 0 to High(City) do
  begin
    repeat
      X := RandomRange(1, MapWidth - 1);
      Y := RandomRange(1, MapHeight - 1);
    until (Map[lrObj][X, Y] = reNone) and (Map[lrTile][X, Y] = reNeutralTerrain) and (GetDistToCapital(X, Y) >= 3);
    AddPartyAt(X, Y);
  end;
  Leader.AddToParty;
end;

function InRect(const X, Y, X1, Y1, X2, Y2: Integer): Boolean;
begin
  Result := (X >= X1) and (Y >= Y1) and (X <= X2) and (Y <= Y2);
end;

function InMap(const X, Y: Integer): Boolean;
begin
  Result := InRect(X, Y, 0, 0, MapWidth - 1, MapHeight - 1);
end;

procedure UpdateRadius(const AX, AY, AR: Integer; var MapLayer: TMapLayer; const AResEnum: TResEnum; IgnoreRes: TIgnoreRes = []);
var
  X, Y: Integer;
begin
  for Y := -AR to AR do
    for X := -AR to AR do
      if (GetDist(AX + X, AY + Y, AX, AY) <= AR) and DisciplesRL.Map.InMap(AX + X, AY + Y) then
        if (MapLayer[AX + X, AY + Y] in IgnoreRes) then
          Continue
        else
        begin
          // Add mine
          if (MapLayer = Map[lrTile]) and (Map[lrObj][AX + X, AY + Y] = reMine) and (Map[lrTile][AX + X, AY + Y] = reNeutralTerrain) then
            Inc(GoldMines);
          MapLayer[AX + X, AY + Y] := AResEnum;
        end;
end;

function LeaderTile: TResEnum;
begin
  Result := Map[lrTile][Leader.X, Leader.Y];
end;

function IsLeaderMove(const X, Y: Integer): Boolean;
begin
  Result := InRect(X, Y, Leader.X - 1, Leader.Y - 1, Leader.X + 1, Leader.Y + 1);
end;

end.
