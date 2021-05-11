program ONodeConsole;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  App.Abstractions in 'AppCore\App.Abstractions.pas',
  App.Core in 'AppCore\App.Core.pas',
  App.Globals in 'AppCore\App.Globals.pas',
  App.Types in 'AppCore\App.Types.pas',
  UI.ConsoleUI in 'AppCore\UICore\UI.ConsoleUI.pas',
  UI.GUI in 'AppCore\UICore\UI.GUI.pas',
  UI.CommandLineParser in 'AppCore\UICore\UI.CommandLineParser.pas',
  UI.ParserCommand in 'AppCore\UICore\UI.ParserCommand.pas',
  UI.Types in 'AppCore\UICore\UI.Types.pas',
  Net.Core in 'AppCore\NetCore\Net.Core.pas',
  Crypto.RSA in 'AppCore\CryptoCore\Crypto.RSA.pas',
  CryptoEntity in 'AppCore\CryptoCore\CryptoEntity.pas',
  RSA.cEncrypt in 'AppCore\CryptoCore\RSA.cEncrypt.pas',
  RSA.cHash in 'AppCore\CryptoCore\RSA.cHash.pas',
  RSA.cHugeInt in 'AppCore\CryptoCore\RSA.cHugeInt.pas',
  RSA.cRandom in 'AppCore\CryptoCore\RSA.cRandom.pas',
  RSA.main in 'AppCore\CryptoCore\RSA.main.pas',
  BlockChain.Core in 'AppCore\BlockChain\BlockChain.Core.pas',
  App.IHandlerCore in 'AppCore\App.IHandlerCore.pas',
  UI.Abstractions in 'AppCore\UICore\UI.Abstractions.pas',
  WebServer.HTTPCore in 'AppCore\WebCore\WebServer.HTTPCore.pas',
  Wallet.Core in 'AppCore\WalletCore\Wallet.Core.pas',
  Unit_cryptography in 'AppCore\CryptoCore\Unit_cryptography.pas';

begin
  try
    AppCore := TAppCore.Create;
    AppCore.DoRun;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
