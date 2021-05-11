unit BlockChain.BaseBlock;

interface
uses
  System.SysUtils,
  App.Types,
  BlockChain.Types;

type
  TBaseBlock = class abstract
  protected
    Header: THeader;
  public
    function GetHeader: THeader;
    function GetSizeBlock: uint64; virtual; abstract;
    function GetData: TBytes; virtual; abstract;
    function GetHash: THash; virtual; abstract;
    procedure SetData(const AData: TBytes); virtual; abstract;
  end;

implementation

{ TBaseBlock }

function TBaseBlock.GetHeader: THeader;
begin
  Result := Header;
end;

end.
