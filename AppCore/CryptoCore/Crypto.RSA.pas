unit Crypto.RSA;

interface
uses
  System.SysUtils,
  RSA.main;

function RSAGenPrivateKey: TBytes;
function RSAGetPublicKey(const PrivateKey: TBytes): TBytes;
function RSAEncrypt(const PrivateKey,Data: TBytes): TBytes;
function RSADecrypt(const PublicKey,Data: TBytes): TBytes;

implementation

const
  KeySize = 512;

function RSAGenPrivateKey: TBytes;
var Pri: TPrivateKey;
begin
  GenPrivKey(KeySize,Pri);
  PrivKeyToBytes_lt(Pri,Result);
  FinalizePrivKey(Pri);
end;

function RSAGetPublicKey(const PrivateKey: TBytes): TBytes;
var
  Pri: TPrivateKey;
  Pub: TPublicKey;
begin
  if Length(PrivateKey)=0 then Exit(nil);
  BytesToPrivKey_lt(PrivateKey,Pri);
  GenPubKey(Pri,Pub);
  PubKeyToBytes(Pub,Result);
  FinalizePrivKey(Pri);
  FinalizePubKey(Pub);
end;

function RSAEncrypt(const PrivateKey,Data: TBytes): TBytes;
var Pri: TPrivateKey;
begin
  if Length(PrivateKey)=0 then Exit(nil);
  BytesToPrivKey_lt(PrivateKey,Pri);
  RSAPrKEncrypt(Pri,Data,Result);
  FinalizePrivKey(Pri);
end;

function RSADecrypt(const PublicKey,Data: TBytes): TBytes;
var Pub: TPublicKey;
begin
  if Length(PublicKey)=0 then Exit(nil);
  BytesToPubKey(PublicKey,Pub);
  RSAPbKDecrypt(Pub,Data,Result);
  FinalizePubKey(Pub);
end;

end.
