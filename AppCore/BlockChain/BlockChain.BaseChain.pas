unit BlockChain.BaseChain;

interface
uses
  System.IOUtils,
  System.SysUtils,
  App.Types,
  BlockChain.BaseBlock,
  BlockChain.Types,
  BlockChain.FileHandler;
type
  TBaseChain = class abstract
  protected
    ChainFile: TChainFile;
    FPath: string;
    FName: string;
  public
    procedure SetBlock(ABlock: TBaseBlock); virtual; abstract;
    function  GetBlock(Ind: uint64): TBaseBlock; virtual; abstract;
    function  GetLastBlockHash: THash; virtual; abstract;
    constructor Create(AName: string; const Data: TBytes; AtypeChain: TTypesChain); virtual;
    destructor Destroy; override;
  end;

implementation

{$Region 'TBaseChain'}

constructor TBaseChain.Create(AName: string; const Data: TBytes; AtypeChain: TTypesChain);
begin
  FName :=  AName;
  FPath :=  TPath.Combine(GetCurrentDir,FName);
  ChainFile:= TChainFile.Create(FPath, Data, AtypeChain);
end;

destructor TBaseChain.Destroy;
begin
  ChainFile.Destroy;
end;
{$endregion}

end.
