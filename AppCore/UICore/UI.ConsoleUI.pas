unit UI.ConsoleUI;

interface
uses
  System.SysUtils,
  System.Classes,
  App.Types,
  App.Abstractions,
  App.Meta,
  App.IHandlerCore,
  UI.Abstractions,
  UI.ParserCommand,
  UI.GUI,
  UI.Types;

type
  TConsoleUI = class(TBaseUI)
  private
    {Fields}
    fversion: string;
    isTerminate: boolean;
    {Instances}
    parser: TCommandsParser;
  public
    procedure DoRun;
    procedure DoTerminate;
    procedure RunCommand(Data: TCommandData);
    constructor Create;
    destructor Destroy; override;
  end;
implementation

{$REGION 'TConsoleUI'}

constructor TConsoleUI.Create;
begin
  isTerminate := False;
  parser := TCommandsParser.Create;
end;

destructor TConsoleUI.Destroy;
begin
  Parser.Free;
  inherited;
end;

procedure TConsoleUI.RunCommand(Data: TCommandData);
begin
  case Data.CommandName of
    TCommandsNames.help:
    begin
      try
        case TCommandsNames.AsCommand(Data.Parametrs[0].Name) of
          TCommandsNames.node:
          begin
            ShowMessage('INFO: Node - command for work with node app.');
          end;
        end;
      except
        ShowMessage('INFO: Incorrect parametrs.');
      end;
    end;
    TCommandsNames.node:
    begin
    end;
    TCommandsNames.check:
    begin
      ShowMessage('ECHO: check');
    end;
    TCommandsNames.update:
    begin
    //need updatecore
    end;
    TCommandsNames.quit:
    begin
      isTerminate := True;
    end;
    TCommandsNames.createwallet:
    begin
      handler.HandleCommand(CMD_CREATE_WALLET, data.Parametrs.AsStringArray);
    end;
    TCommandsNames.openwallet:
    begin
      handler.HandleCommand(CMD_OPEN_WALLET,data.Parametrs.AsStringArray)
    end;
    TCommandsNames.getwalletlist:
    begin
      handler.HandleCommand(CMD_GET_WALLETS,data.Parametrs.AsStringArray);
    end;
  end;
end;

procedure TConsoleUI.DoRun;
var
  inputString: string;
  args: strings;
begin
  TThread.CreateAnonymousThread(procedure
  begin
    Writeln(GetTextGreeting(English));
    Writeln(Carriage);
    Writeln(GetTextRequestForInput(English));

    while not isTerminate do
    begin
      readln(inputString);
      if length(trim(inputString)) = 0 then
        Continue;

      args.SetStrings(inputString);
      RunCommand(parser.TryParse(args));
    end;
  end).Start;
  Handler.HandleCommand(255,[]);
  while not isTerminate do
  begin
    CheckSynchronize(100);
  end;
end;

procedure TConsoleUI.DoTerminate;
begin
  isTerminate := True;
end;
{$ENDREGION}

end.
