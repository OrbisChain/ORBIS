unit Net.Core;

interface

uses
  App.IHandlerCore,
  Net.Server,
  Net.ConnectedClient,
  Net.Client,
  Net.Types,
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Threading,
  System.Net.Socket,
  System.Generics.Collections;

type
  TNetCore = class
  private
    NodesHosts: array of string;
    Server: TServer;
    FClient: TClient;
    FHandler: IBaseHandler;
    NeedDestroySelf: Boolean;
    procedure Handle(From: TConnectedClient; AData: TBytes);
    procedure NewConHandle(SocketIP: String);
    procedure DeleteConnectedClient(AID: integer);
    function GetServerStatus: boolean;
    function GetFreeArraySell: uint64;
    procedure NilConClient(arg: Boolean);
  public
    ConnectedClients: TArray<TConnectedClient>;
    property ServerStarted: boolean read GetServerStatus;
    property Handler: IBaseHandler read FHandler write FHandler;
    property DestroyNetCore: Boolean write NeedDestroySelf;
    property Client: TClient read FClient write FClient;
    procedure Start;
    procedure Stop;
    function IsActive: Boolean;
    constructor Create(AHandler: IBaseHandler);
    destructor Destroy; override;
  end;

implementation

{$REGION 'TNetCore'}

constructor TNetCore.Create(AHandler: IBaseHandler);
var
  id: uint64;
begin
{$IFDEF DEBUG}
  NodesHosts := ['127.0.0.1'];
{$ENDIF}

  NeedDestroySelf := False;
  SetLength(ConnectedClients, 0);
  Server := TServer.Create;
  FHandler := AHandler;
  Server.AcceptHandle := (
    procedure(ConnectedCli: TConnectedClient)
    begin
      ConnectedCli.Handle := Handle;
      id := GetFreeArraySell;
      ConnectedCli.IdInArray := id;
      ConnectedCli.AfterDisconnect := DeleteConnectedClient;
      ConnectedClients[id] := ConnectedCli;
    end);
  Server.NewConnectHandle := NewConHandle;

  Client := TClient.Create(AHandler);
  Client.BeforeDestroy := NilConClient;
end;

procedure TNetCore.DeleteConnectedClient(AID: integer);
begin
  ConnectedClients[AID] := nil;
end;

destructor TNetCore.Destroy;
begin
  Server.Free;
  Client.Free;
  Server := nil;
  SetLength(ConnectedClients, 0);
  FHandler := nil;
end;

function TNetCore.GetFreeArraySell: uint64;
var
  i, len: integer;
begin
  len := Length(ConnectedClients);
  Result := len;
  for i := 0 to len - 1 do
    if (ConnectedClients[i] = nil) then
    begin
      Result := i;
      exit;
    end;
  SetLength(ConnectedClients, len + 1);
end;

function TNetCore.GetServerStatus: boolean;
begin
  GetServerStatus := Server.isActive;
end;

procedure TNetCore.Handle(From: TConnectedClient; AData: TBytes);
begin
  FHandler.HandleReceiveTCPData(From,AData);
end;

function TNetCore.IsActive: Boolean;
begin
  Result := Server.isActive;
end;

procedure TNetCore.NewConHandle(SocketIP: String);
begin
  FHandler.HandleConnectClient(SocketIP);
end;

procedure TNetCore.NilConClient(arg: Boolean);
begin
  Client := nil;
end;

procedure TNetCore.Start;
begin
  Server.Start;
  Client.TryConnect(NodesHosts[0],30000);
end;

procedure TNetCore.Stop;
var
  i: uint64;
begin
  for i := 0 to Length(ConnectedClients) - 1 do
    if (ConnectedClients[i] <> nil) then
      ConnectedClients[i].Disconnect;

  Server.Stop;
  if NeedDestroySelf then
    Free;
end;

{$ENDREGION}

end.
