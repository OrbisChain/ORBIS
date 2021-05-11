unit UI.Types;

interface
uses
  System.StrUtils,
  System.SysUtils,
  System.TypInfo,
  System.Generics.Collections,
  App.Types;

type
  TCommandsNames = (help, node, check, update, quit, createwallet, openwallet, getwalletlist);
  TCommandsHelper = record helper for TCommandsNames
    class function InType(ACommand: string): boolean; static;
    class function AsCommand(ACommand: string): TCommandsNames; static;
  end;

  TParametr = record
    Name: string;
    Value: string;
  end;

  TParametrs = TArray<TParametr>;
  THelpParametrs = record helper for TParametrs
    function AsStringArray: TArray<string>;
  end;

  TCommandData = record
    CommandName: TCommandsNames;
    Parametrs: TParametrs;
  end;

implementation

{$Region 'CommandsHelper'}

class function TCommandsHelper.AsCommand(ACommand: string): TCommandsNames;
begin
  Result := TCommandsNames(GetEnumValue(TypeInfo(TCommandsNames),ACommand));
end;

class function TCommandsHelper.InType(ACommand: string): Boolean;
begin
  Result := GetEnumValue(TypeInfo(TCommandsHelper),ACommand).ToBoolean;
end;
{$ENDREGION}
{ TCommandData }


{ THelpParametrs }

function THelpParametrs.AsStringArray: TArray<string>;
var
  Param: TParametr;
begin
  Result := [];
  for Param in Self do
    Result := Result + [Param.Name] + [Param.Value];
end;

end.
