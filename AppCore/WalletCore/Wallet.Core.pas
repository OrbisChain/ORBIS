unit Wallet.Core;

interface
uses
  System.SysUtils,
  System.Generics.Collections,
  System.Classes,
  Wallet.FileHandler,
  Wallet.Types;
type
  TWalletCore = class
  private
    WalletsFile:  TWalletsFileHandler;
  public
    Wallets:       TStringList;
    CurrentWallet: TWallet;
    function OpenWallet(AWalletName: string; APassword: string): boolean;
    procedure CloseWallet;
    procedure CreateNewWallet(APassword: string; Replace: boolean);
    function GetWallets: string;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TWalletCore }

procedure TWalletCore.CloseWallet;
begin
  CurrentWallet := Default(TWallet);
end;

constructor TWalletCore.Create;
begin
  Wallets := TStringList.Create;
  WalletsFile := TWalletsFileHandler.Create(Wallets);
  CurrentWallet := Default(TWallet);
end;

procedure TWalletCore.CreateNewWallet(APassword: string; Replace: boolean);
begin
  if Replace then
    CurrentWallet := WalletsFile.CreateNewWallet(APassword)
  else
    WalletsFile.CreateNewWallet(APassword);
end;

destructor TWalletCore.Destroy;
begin
  Wallets.Destroy;
  inherited;
end;

function TWalletCore.GetWallets: string;
begin
  Result := Wallets.GetText;
end;

function TWalletCore.OpenWallet(AWalletName, APassword: string): boolean;
begin
  Result := False;
  CurrentWallet := WalletsFile.TryOpenWallet(AWalletName,APassword);
  if CurrentWallet.GetAddress = AWalletName then
    Result := True;
end;




end.
