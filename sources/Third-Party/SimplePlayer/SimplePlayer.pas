﻿unit SimplePlayer;

interface

uses
  Bass;

const
  MusicChannel = 0;

type
  TChannelType = (ctUnknown, ctStream, ctMusic);

type
  TSimplePlayer = class
  private
    FC: Integer;
    FChannelType: TChannelType;
    FChannel: array [Byte] of DWORD;
    FVolume: ShortInt;
    procedure SetVolume(const Value: ShortInt);
    function GetVolume: ShortInt;
  public
    constructor Create;
    destructor Destroy; override;
    property Volume: ShortInt read GetVolume write SetVolume;
    property CurrentChannel: Integer read FC write FC;
    function Play(const FileName: string; F: Boolean): Boolean;
    procedure Stop;
    procedure StopMusic;
  end;

implementation

{ TSimplePlayer }

constructor TSimplePlayer.Create;
begin
  BASS_Init(1, 44100, BASS_DEVICE_3D, 0, nil);
  BASS_Start;
  Volume := 100;
  FC := 1;
end;

destructor TSimplePlayer.Destroy;
var
  I: Byte;
begin
  for I := 0 to High(FChannel) do
  begin
    BASS_ChannelStop(FChannel[I]);
    BASS_StreamFree(FChannel[I]);
  end;
  BASS_Free();
  inherited;
end;

function TSimplePlayer.GetVolume: ShortInt;
begin
  if (FVolume > 100) then
    FVolume := 100;
  if (FVolume < 0) then
    FVolume := 0;
  Result := FVolume;
end;

function TSimplePlayer.Play(const FileName: string; F: Boolean): Boolean;
begin
  Result := False;
  if (Volume <= 0) then
    Exit;
  case F of
    True:
      FChannel[FC] := BASS_StreamCreateFile(False, PChar(FileName), 0, 0,
        BASS_MUSIC_LOOP {$IFDEF UNICODE} or BASS_UNICODE
{$ENDIF});
    False:
      FChannel[FC] := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, 0
{$IFDEF UNICODE } or BASS_UNICODE {$ENDIF});
  end;
  if (FChannel[FC] <> 0) then
  begin
    FChannelType := ctStream;
    BASS_ChannelSetAttribute(FChannel[FC], BASS_ATTRIB_VOL, Volume / 100);
    BASS_ChannelPlay(FChannel[FC], False);
  end;
  Result := FChannel[FC] <> 0;
  Inc(FC);
  if (FC > High(FChannel)) then
    FC := 1;
end;

procedure TSimplePlayer.SetVolume(const Value: ShortInt);
begin
  FVolume := Value;
  if (FVolume > 100) then
    FVolume := 100;
  if (FVolume < 0) then
    FVolume := 0;
end;

procedure TSimplePlayer.Stop;
var
  I: Byte;
begin
  for I := 1 to High(FChannel) do
    BASS_ChannelStop(FChannel[I]);
  FC := 1;
end;

procedure TSimplePlayer.StopMusic;
begin
  BASS_ChannelStop(FChannel[MusicChannel]);
end;

end.
