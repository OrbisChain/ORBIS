unit App.Core;

interface

uses
  System.SysUtils,
  System.Classes,
  App.Types,
  App.Abstractions,
  App.HandlerCore,
  BlockChain.Core,
  Net.Core,
  WebServer.HTTPCore,
  UI.Abstractions,
  UI.CommandLineParser,
  UI.ConsoleUI,
  UI.GUI,
  Wallet.Core;

type
  TAppCore = class(TInterfacedObject, IAppCore)
  private
    isTerminate: boolean;
    UI: TBaseUI;
    BlockChain: TBlockChainCore;
    Net: TNetCore;
    WebServer: TWebServer;
    HandlerCore: THandlerCore;
    WalletCore: TWalletCore;
    { Procedures }
    procedure AppException(Sender: TObject);
  public
    procedure Terminate;
    procedure DoRun;
    procedure ShowMessage(AMessage: string);
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TAppCore }

constructor TAppCore.Create;
begin
{$IFDEF CONSOLE}
  UI := TConsoleUI.Create;
{$ENDIF}
{$IFDEF GUI}
  UI := TGUI.Create;
{$ENDIF}
  ApplicationHandleException := AppException;

  BlockChain := TBlockChainCore.Create;
  HandlerCore := THandlerCore.Create;
  Net := TNetCore.Create(HandlerCore);
  WebServer := TWebServer.Create(HandlerCore);
  WalletCore := TWalletCore.Create;
  HandlerCore.BlockChain := BlockChain;
  HandlerCore.UI := UI;
  HandlerCore.Net := Net;
  HandlerCore.WalletCore := WalletCore;
  HandlerCore.WebServer := WebServer;

  UI.ShowMessage := ShowMessage;
  UI.Handler := HandlerCore;
end;

procedure TAppCore.AppException(Sender: TObject);
var
  O: TObject;
begin
  O := ExceptObject;
  if O is Exception then
  begin
    if not(O is EAbort) then
      ShowMessage(Exception(O).Message)
  end
  else
    System.SysUtils.ShowException(O, ExceptAddr);
end;

destructor TAppCore.Destroy;
begin
  UI.Free;
  inherited;
end;

procedure TAppCore.DoRun;
begin
  TConsoleUI(UI).DoRun;
end;

procedure TAppCore.ShowMessage(AMessage: string);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      WriteLn(AMessage)
    end);
end;

procedure TAppCore.Terminate;
begin
  isTerminate := True;
end;

end.
