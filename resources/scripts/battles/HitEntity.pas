// A������ ���������� ���������
case Rand(1, 7) of
  1:
    SetStr('Log', GetStr('Slot' + GetStr('ActiveCell') + 'Name') + ' �������� ���������.');
  2:
    SetStr('Log', GetStr('Slot' + GetStr('ActiveCell') + 'Name') + ' �������.');
  3:
    SetStr('Log', GetStr('Slot' + GetStr('ActiveCell') + 'Name') + ' ������ � ���.');
  4:
    SetStr('Log', GetStr('Slot' + GetStr('ActiveCell') + 'Name') + ' �������.');
  5:
    SetStr('Log', GetStr('Slot' + GetStr('ActiveCell') + 'Name') + ' �������.');
  6:
    SetStr('Log', GetStr('Slot' + GetStr('ActiveCell') + 'Name') + ' �������.');
  7:
    SetStr('Log', GetStr('Slot' + GetStr('ActiveCell') + 'Name') + ' �������.');
end;
//
if (Flag('SlepotaSlot' + GetStr('ActiveCell')) and (Rand(0, 100) <= 75)) then
begin
  Run('Battles\Miss.pas');
end
else if (GetInt('Slot' + GetStr('SlotTarget') + 'HP') > 0) then
begin
  if (Rand(0, 100) <= GetInt('Slot' + GetStr('ActiveCell') + 'TCH')) then
  begin
    DecInt('Slot' + GetStr('SlotTarget') + 'HP', GetInt('Slot' + GetStr('ActiveCell') + 'Use'));
    SetInt('DisplayDamageSlot' + GetStr('SlotTarget'), GetInt('Slot' + GetStr('ActiveCell') + 'Use'));
    case Rand(1, 7) of
      1:
        SetStr('Log', GetStr('Log') + ' ' + GetStr('Slot' + GetStr('SlotTarget') + 'Name') + ': -' +
          GetStr('Slot' + GetStr('ActiveCell') + 'Use') + ' ��. ��������.');
      2:
        SetStr('Log', GetStr('Log') + ' ' + GetStr('Slot' + GetStr('SlotTarget') + 'Name') + ': -' +
          GetStr('Slot' + GetStr('ActiveCell') + 'Use') + 'HP.');
      3:
        SetStr('Log', GetStr('Log') + ' ' + GetStr('Slot' + GetStr('SlotTarget') + 'Name') + ' �������� ���� ' +
          GetStr('Slot' + GetStr('ActiveCell') + 'Use') + ' ��.');
      4:
        SetStr('Log', GetStr('Log') + ' ' + GetStr('Slot' + GetStr('SlotTarget') + 'Name') + ' �������� ���� ' +
          GetStr('Slot' + GetStr('ActiveCell') + 'Use') + ' ��.');
      5:
        SetStr('Log', GetStr('Log') + ' ' + GetStr('Slot' + GetStr('SlotTarget') + 'Name') + ' ������ ' +
          GetStr('Slot' + GetStr('ActiveCell') + 'Use') + ' ��. ��������.');
      6:
        SetStr('Log', GetStr('Log') + ' ' + GetStr('Slot' + GetStr('SlotTarget') + 'Name') + ' ������� ' +
          GetStr('Slot' + GetStr('ActiveCell') + 'Use') + ' ��. ��������.');
      7:
        SetStr('Log', GetStr('Log') + ' ' + GetStr('Slot' + GetStr('SlotTarget') + 'Name') + ' ������ ' +
          GetStr('Slot' + GetStr('ActiveCell') + 'Use') + ' ��. ��������.');
    end;
  end
  else
  begin
    Run('Battles\Miss.pas');
  end;
  if (GetInt('Slot' + GetStr('SlotTarget') + 'HP') < 0) then
    SetInt('Slot' + GetStr('SlotTarget') + 'HP', 0);
end;

if (GetInt('Slot' + GetStr('SlotTarget') + 'HP') = 0) then
  Run('Battles\Dead.pas');
// ���������� ���
Log(GetStr('Log'));
