unit App.IHandlerCore;

interface
uses
  Net.ConnectedClient,
  WebServer.HTTPConnectedClient,
  System.SysUtils;

type
  IBaseHandler = interface
    procedure HandleReceiveTCPData(From: TConnectedClient; const ABytes: TBytes);
    procedure HandleReceiveHTTPData(From: TConnectedClient; const ABytes: TBytes);
    procedure HandleCommand(Command: Byte; args: array of string);
    procedure HandleConnectClient(ClientName: String);
    procedure HandleDisconnectClient(ClientName: String);
  end;

implementation

end.
