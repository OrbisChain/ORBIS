unit UI.GUI;

interface
uses
  UI.Abstractions;

type
  TGUI= class(TBaseUI)
    procedure DoRun;
    procedure DoTerminate;
  end;
implementation

{$REGION 'TGUI'}
procedure TGUI.DoRun;
begin

end;

procedure TGUI.DoTerminate;
begin

end;
{$ENDREGION}

end.
