unit App.Types;

interface
uses
  System.Sysutils,
  System.Classes,
  System.StrUtils,
  Crypto.Encoding;

const
  SIZE_PRIVATE_KEY = 174;
  SIZE_PUBLIC_KEY = 96;
type
  TMessageState = (Normal, Error, Allert);

  TUint64Helper = record helper for UINt64
    function AsBytes: TBytes;
  end;

  Strings = TArray<string>;
  StringsHelper = record helper for Strings
    procedure SetStrings(const AValue: string);
    function Length: uint64;
    function AsString(const Splitter: string): string;
    function IsEmpty:boolean;
  end;

  THash = packed record
    Hash: array [0..31] of Byte;
    class operator Implicit(Buf: THash): string;
    class operator Implicit(Buf: THash): TBytes;
    class operator Implicit(Buf: string): THash;
    class operator Implicit(Buf: TBytes): THash;
    class operator Add(buf1: TBytes; buf2: THash): TBytes;
    class operator Add(buf2: THash; buf1: TBytes): TBytes;
    class operator Add(buf1: string; buf2: THash): string;
    class operator Add(buf2: THash; buf1: string): string;
    procedure Clear;
  end;

  TSignedHash = packed record
    SignedHash: array [0..63] of Byte;
    class operator Implicit(Buf: TSignedHash): string;
    class operator Implicit(Buf: TSignedHash): TBytes;
    class operator Implicit(Buf: string): TSignedHash;
    class operator Implicit(Buf: TBytes): TSignedHash;
    class operator Add(buf1: TBytes; buf2: TSignedHash): TBytes;
    class operator Add(buf2: TSignedHash; buf1: TBytes): TBytes;
    procedure Clear;
  end;

  TPrivateKey = packed record
    PrivateKey : array [0..SIZE_PRIVATE_KEY-1] of Byte;
    class operator Implicit(Buf: TPrivateKey): string;
    class operator Implicit(Buf: TPrivateKey): TBytes;
    class operator Implicit(Buf: string): TPrivateKey;
    class operator Implicit(Buf: TBytes): TPrivateKey;
    class operator Add(buf1: TBytes; buf2: TPrivateKey): TBytes;
    class operator Add(buf2: TPrivateKey; buf1: TBytes): TBytes;
    procedure Clear;
  end;

  TPublicKey = packed record
    PublicKey : array [0..SIZE_PUBLIC_KEY-1] of Byte;
    class operator Implicit(Buf: TPublicKey): string;
    class operator Implicit(Buf: TPublicKey): TBytes;
    class operator Implicit(Buf: string): TPublicKey;
    class operator Implicit(Buf: TBytes): TPublicKey;
    class operator Add(buf1: TBytes; buf2: TPublicKey): TBytes;
    class operator Add(buf2: TPublicKey; buf1: TBytes): TBytes;
    procedure Clear;
  end;

implementation


{$REGION 'StringsHelper'}

function StringsHelper.AsString(const Splitter: string): string;
var
  Value: string;
begin
  Result := '';
  for Value in Self do
    Result := Result + Splitter + Value;
end;

procedure StringsHelper.SetStrings(const AValue: string);
begin
  Self := SplitString(AValue,' ');
end;

function StringsHelper.IsEmpty: boolean;
begin
  Result := Length = 0;
end;

function StringsHelper.Length: uint64;
begin
  Result := System.Length(Self);
end;
{$ENDREGION}

{$REGION 'THash'}

class operator THash.Implicit(Buf: THash): TBytes;
var
  Data: TBytes;
begin
  SetLength(Data,SizeOf(THash));
  Move(Buf.Hash[0],Data[0],SizeOf(THash));
  Result := Data;
end;

class operator THash.Implicit(Buf: THash): string;
var
  Data: Tbytes;
begin
  SetLength(Data,SizeOf(THash));
  Move(Buf.Hash[0],Data[0],SizeOf(THash));
  Result := BytesEncodeBase64URL(Data);
end;

class operator THash.Add(buf1: TBytes; buf2: THash): TBytes;
var
  LData, RData: TBytes;
begin
  RData := buf1;
  SetLength(LData, SizeOf(THash));
  Move(buf2.Hash[0], LData[0],SizeOf(THash));
  RData := RData + LData;
  Result := RData;
end;

class operator THash.Add(buf2: THash; buf1: TBytes): TBytes;
var
  LData, RData: TBytes;
begin
  RData := buf1;
  SetLength(LData, SizeOf(THash));
  Move(buf2.Hash[0], LData[0],SizeOf(THash));
  RData := LData + RData;
  Result := RData;
end;

class operator THash.Add(buf2: THash; buf1: string): string;
var
  Data: TBytes;
begin
  SetLength(Data, SizeOf(THash));
  Move(buf2.Hash[0], Data[0],SizeOf(THash));
  Result := BytesEncodeBase64URL(Data) + buf1;
end;


class operator THash.Add(buf1: string; buf2: THash): string;
var
  Data: TBytes;
begin
  SetLength(Data, SizeOf(THash));
  Move(buf2.Hash[0], Data[0],SizeOf(THash));
  Result := buf1 + BytesEncodeBase64URL(Data);
end;

procedure THash.Clear;
begin
  fillchar(Hash[0],SizeOf(Hash),0);
end;

class operator THash.Implicit(Buf: TBytes): THash;
var
  RHash: THash;
begin
  Move(Buf[0], RHash.Hash[0],Length(Buf));
  Result := RHash;
end;

class operator THash.Implicit(Buf: string): THash;
var
  RHash: THash;
  Data: TBytes;
begin
  Data := BytesDecodeBase64URL(Buf);
  Move(Data[0],RHash.Hash[0],Length(Data));
  Result := RHash;
end;
{$ENDREGION}

{$REGION 'TSignedHash'}

class operator TSignedHash.Add(buf1: TBytes; buf2: TSignedHash): TBytes;
var
  LData, RData: TBytes;
begin
  RData := buf1;
  SetLength(LData, SizeOf(TSignedHash));
  Move(buf2.SignedHash[0], LData[0],SizeOf(TSignedHash));
  RData := RData + LData;
  Result := RData;
end;

class operator TSignedHash.Add(buf2: TSignedHash; buf1: TBytes): TBytes;
var
  LData, RData: TBytes;
begin
  RData := buf1;
  SetLength(LData, SizeOf(TSignedHash));
  Move(buf2.SignedHash[0], LData[0],SizeOf(TSignedHash));
  RData := LData + RData;
  Result := RData;
end;


procedure TSignedHash.Clear;
begin
  fillchar(SignedHash[0],SizeOf(SignedHash),0);
end;

class operator TSignedHash.Implicit(Buf: TSignedHash): TBytes;
var
  Data: TBytes;
begin
  SetLength(Data,SizeOf(TSignedHash));
  Move(Buf.SignedHash[0],Data[0],SizeOf(TSignedHash));
  Result := Data;
end;

class operator TSignedHash.Implicit(Buf: TSignedHash): string;
var
  Data: Tbytes;
begin
  SetLength(Data,SizeOf(TSignedHash));
  Move(Buf.SignedHash[0],Data[0],SizeOf(TSignedHash));
  Result := BytesEncodeBase64URL(Data);
end;

class operator TSignedHash.Implicit(Buf: string): TSignedHash;
var
  RHash: TSignedHash;
  Data: TBytes;
begin
  Data := BytesDecodeBase64URL(Buf);
  Move(Data[0],RHash.SignedHash[0],Length(Data));
  Result := RHash;
end;

class operator TSignedHash.Implicit(Buf: TBytes): TSignedHash;
var
  RHash: TSignedHash;
begin
  Move(Buf[0], RHash.SignedHash[0],Length(Buf));
  Result := RHash;
end;
{$ENDREGION}

{$REGION 'TPrivateKey'}
class operator TPrivateKey.Add(buf1: TBytes; buf2: TPrivateKey): TBytes;
var
  LData, RData: TBytes;
begin
  RData := buf1;
  SetLength(LData, SizeOf(TPrivateKey));
  Move(buf2.PrivateKey[0], LData[0],SizeOf(TPrivateKey));
  RData := RData + LData;
  Result := RData;
end;

class operator TPrivateKey.Add(buf2: TPrivateKey; buf1: TBytes): TBytes;
var
  LData, RData: TBytes;
begin
  RData := buf1;
  SetLength(LData, SizeOf(TPrivateKey));
  Move(buf2.PrivateKey[0], LData[0],SizeOf(TPrivateKey));
  RData := LData + RData;
  Result := RData;
end;

procedure TPrivateKey.Clear;
begin
  fillchar(PrivateKey[0],SizeOf(PrivateKey),0);
end;

class operator TPrivateKey.Implicit(Buf: TPrivateKey): TBytes;
var
  Data: TBytes;
begin
  SetLength(Data,SizeOf(TPrivateKey));
  Move(Buf.PrivateKey[0],Data[0],SizeOf(TPrivateKey));
  Result := Data;
end;

class operator TPrivateKey.Implicit(Buf: TPrivateKey): string;
var
  Data: Tbytes;
begin
  SetLength(Data,SizeOf(TPrivateKey));
  Move(Buf.PrivateKey[0],Data[0],SizeOf(TPrivateKey));
  Result := BytesEncodeBase64URL(Data);
end;

class operator TPrivateKey.Implicit(Buf: string): TPrivateKey;
var
  RKey: TPrivateKey;
  Data: TBytes;
begin
  Data := BytesDecodeBase64URL(Buf);
  Move(Data[0],RKey.PrivateKey[0],Length(Data));
  Result := RKey;
end;

class operator TPrivateKey.Implicit(Buf: TBytes): TPrivateKey;
var
  RKey: TPrivateKey;
begin
  Move(Buf[0], RKey.PrivateKey[0],Length(Buf));
  Result := RKey;
end;
{$ENDREGION}

{$REGION 'TPublicKey'}
class operator TPublicKey.Add(buf1: TBytes; buf2: TPublicKey): TBytes;
var
  LData, RData: TBytes;
begin
  RData := buf1;
  SetLength(LData, SizeOf(TPublicKey));
  Move(buf2.PublicKey[0], LData[0],SizeOf(TPublicKey));
  RData := RData + LData;
  Result := RData;
end;

class operator TPublicKey.Add(buf2: TPublicKey; buf1: TBytes): TBytes;
var
  LData, RData: TBytes;
begin
  RData := buf1;
  SetLength(LData, SizeOf(TPublicKey));
  Move(buf2.PublicKey[0], LData[0],SizeOf(TPublicKey));
  RData := LData + RData;
  Result := RData;
end;

procedure TPublicKey.Clear;
begin
  fillchar(PublicKey[0],SizeOf(PublicKey),0);
end;

class operator TPublicKey.Implicit(Buf: TPublicKey): TBytes;
var
  Data: TBytes;
begin
  SetLength(Data,SizeOf(TPublicKey));
  Move(Buf.PublicKey[0],Data[0],SizeOf(TPublicKey));
  Result := Data;
end;

class operator TPublicKey.Implicit(Buf: TPublicKey): string;
var
  Data: Tbytes;
begin
  SetLength(Data,SizeOf(TPublicKey));
  Move(Buf.PublicKey[0],Data[0],SizeOf(TPublicKey));
  Result := BytesEncodeBase64URL(Data);
end;

class operator TPublicKey.Implicit(Buf: string): TPublicKey;
var
  RKey: TPublicKey;
  Data: TBytes;
begin
  Data := BytesDecodeBase64URL(Buf);
  Move(Data[0],RKey.PublicKey[0],Length(Data));
  Result := RKey;
end;

class operator TPublicKey.Implicit(Buf: TBytes): TPublicKey;
var
  RKey: TPublicKey;
begin
  Move(Buf[0], RKey.PublicKey[0],Length(Buf));
  Result := RKey;
end;
{$ENDREGION}

{ TUint64Helper }

function TUint64Helper.AsBytes: TBytes;
var
  buf: TBytes;
begin
  SetLength(buf, SizeOf(UINT64));
  Move(self,buf[0], SizeOf(UINT64));
  Result := buf;
end;

end.
