unit WebServer.HTTPCore;

interface

uses
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Threading,
  System.Net.Socket,
  System.Generics.Collections,
  System.SyncObjs,
  WebServer.HTTPConnectedClient,
  App.IHandlerCore,
  Net.ConnectedClient,
  WebServer.HTTPServer,
  WebServer.HTTPTypes;

type

  TWebServer = class
  private
    Server: THTTPServer;
    FHandler: IBaseHandler;
    Request: String;
    NeedDestroySelf: Boolean;
    procedure Handle(From: THTTPConnectedClient; AData: TBytes);
    procedure NewConHandle(SocketIP: String);
    procedure DiscClientHandle(SocketIP: String);
    procedure DeleteConnectedClient(AID: integer);
    function GetServerStatus: boolean;
    function GetFreeArraySell: integer;
  public
    ConnectedClients: TArray<THTTPConnectedClient>;
    constructor Create(const AHandler: IBaseHandler);
    property ServerStarted: boolean read GetServerStatus;
    property Handler: IBaseHandler read FHandler write FHandler;
    property DestroyNetCore: Boolean write NeedDestroySelf;
//    function DoApiRequest(Request: TRequest; Response: TResponse): Boolean;
    procedure Start;
    procedure Stop;
    function IsActive: Boolean;
    destructor Destroy; override;
  end;

implementation


{ TWebServer }

constructor TWebServer.Create(const AHandler: IBaseHandler);
var
  id: integer;
begin
  Request := '';
  NeedDestroySelf := False;
  SetLength(ConnectedClients, 0);
  Server := THTTPServer.Create;
  FHandler := AHandler;
  Server.AcceptHandle := (
    procedure(ConnectedCli: THTTPConnectedClient)
    begin
      ConnectedCli.Handle := Handle;
      id := GetFreeArraySell;
      ConnectedCli.IdInArray := id;
      ConnectedCli.AfterDisconnect := DeleteConnectedClient;
      ConnectedClients[id] := ConnectedCli;
    end);
  Server.NewConnectHandle := NewConHandle;
end;

procedure TWebServer.DeleteConnectedClient(AID: integer);
begin
  DiscClientHandle(ConnectedClients[AID].GetSocketIP);
  ConnectedClients[AID] := nil;
end;

destructor TWebServer.Destroy;
begin
  Server.Free;
  Server := nil;
  SetLength(ConnectedClients, 0);
  FHandler := nil;
end;

procedure TWebServer.DiscClientHandle(SocketIP: String);
begin
  FHandler.HandleDisconnectClient(SocketIP);
end;

function TWebServer.GetFreeArraySell: integer;
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

function TWebServer.GetServerStatus: boolean;
begin
  GetServerStatus := Server.isActive;
end;

procedure TWebServer.Handle(From: THTTPConnectedClient; AData: TBytes);
var
  Request: TRequest;
  Response: TResponse;
begin
  try
    Request := TRequest.Create(AData);

    FHandler.HandleReceiveHTTPData(From, AData);

    Response := TResponse.Create(Request);
    From.SendMessage(Response.ByteAnswer);
    From.Disconnect;
  finally
    if Assigned(Request) then
      Request.Free;
    if Assigned(Response) then
      Response.Free;
  end;
end;

function TWebServer.IsActive: Boolean;
begin
  Result := Server.isActive;
end;

procedure TWebServer.NewConHandle(SocketIP: String);
begin
  FHandler.HandleConnectClient(SocketIP);
end;

procedure TWebServer.Start;
begin
  Server.Start;
end;

procedure TWebServer.Stop;
var
  i: integer;
begin
  for i := 0 to Length(ConnectedClients) - 1 do
    if (ConnectedClients[i] <> nil) then
      ConnectedClients[i].Disconnect;

  Server.Stop;
  if NeedDestroySelf then
    Self.Free;
end;

end.
