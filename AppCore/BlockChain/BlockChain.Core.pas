unit BlockChain.Core;

interface
uses
  System.SysUtils,
  System.Classes,
  System.Hash,
  BlockChain.BaseBlock,
  BlockChain.MainChain,
  BlockChain.Account,
  BlockChain.Tokens,
  BlockChain.Transfer,
  BlockChain.Types,
  BlockChain.Inquiries,
  Crypto.RSA;
type
  TBlockChainCore = class
  private
    MainChain:      TMainChain;
    AccountsChain : TAccountChain;
    TokensChain:    TTokensChain;
    TransfersChain: TTransferChain;
  public
    Inquiries: TBlockChainInquiries;
    constructor Create;
    destructor Destroy; override;
  end;

implementation


{ TBlockChainCore }

constructor TBlockChainCore.Create;
begin
  SIZE_MAIN_CHAIN_INFO_V0 := Length(TMainBlockV0.GenerateInitBlock);
  SIZE_ACCOUNT_INFO_V0 := Length(TAccountBlockV0.GenerateInitBlock);
  SIZE_TOKENS_INFO_V0 := Length(TTokensBlockV0.GenerateInitBlock);
  SIZE_TRANSFER_INFO_V0 := Length(TTransferBlockV0.GenerateInitBlock);

  MainChain      := TMainChain.Create('MainChain',       TMainBlockV0.GenerateInitBlock,   Main);
  AccountsChain  := TAccountChain.Create('AccountChain', TAccountBlockV0.GenerateInitBlock, Accounts);
  TokensChain    := TTokensChain.Create('TokensChain', TTokensBlockV0.GenerateInitBlock, Tokens);
  TransfersChain := TTransferChain.Create('TransfersChain', TTransferBlockV0.GenerateInitBlock, Transfers);
  Inquiries := TBlockChainInquiries.Create(MainChain,AccountsChain,TokensChain,TransfersChain);
end;

destructor TBlockChainCore.Destroy;
begin
  AccountsChain.Free;
  inherited;
end;

end.
