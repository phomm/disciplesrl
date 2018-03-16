unit DisciplesRL.Game;

interface

uses DisciplesRL.Party;

var
  Days: Integer = 0;
  Gold: Integer = 0;
  GoldMines: Integer = 0;
  BattlesWon: Integer = 0;

  // HUMAN, UNDEAD, HERETIC, DWARF
  // FIGHTER, ARCHER, MAGE

var
  Party: array of TParty;
  LeaderParty: TParty;
  CapitalParty: TParty;

procedure Init;
procedure PartyInit(const AX, AY: Integer);
procedure PartyFree;
function GetPartyCount: Integer;
function GetPartyIndex(const AX, AY: Integer): Integer;
procedure AddPartyAt(const AX, AY: Integer);
procedure Free;

implementation

uses System.Math, System.SysUtils, DisciplesRL.Creatures, DisciplesRL.Map, DisciplesRL.Resources;

procedure Init;
begin

end;

procedure PartyInit(const AX, AY: Integer);
var
  L: Integer;
begin
  L := GetDistToCapital(AX, AY);
  SetLength(Party, GetPartyCount + 1);
  Party[GetPartyCount - 1] := TParty.Create(AX, AY);
  with Party[GetPartyCount - 1] do
  begin
    AddCreature(crGoblin_Archer, 1);

    AddCreature(crGoblin, 0);
    AddCreature(crGoblin, 2);
    AddCreature(crGoblin, 4);
    if (RandomRange(0, 3) = 0) then
      AddCreature(crGoblin_Archer, 3);
    if (RandomRange(0, 4) = 0) then
    begin
      AddCreature(crGoblin_Archer, 1);
      AddCreature(crGoblin_Archer, 5);
    end;
  end;
end;

procedure PartyFree;
var
  I: Integer;
begin
  for I := 0 to GetPartyCount - 1 do
    FreeAndNil(Party[I]);
end;

function GetPartyCount: Integer;
begin
  Result := Length(Party);
end;

function GetPartyIndex(const AX, AY: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to GetPartyCount - 1 do
    if (Party[I].X = AX) and (Party[I].Y = AY) then
    begin
      Result := I;
      Exit;
    end;
end;

procedure AddPartyAt(const AX, AY: Integer);
begin
  MapObj[AX, AY] := reEnemies;
  PartyInit(AX, AY);
end;

procedure Free;
begin
  PartyFree;
  FreeAndNil(LeaderParty);
  FreeAndNil(CapitalParty);
end;

end.
