unit Cryptography;

interface

uses
  System.SysUtils
(*
  , DCPcrypt2
*)
  ;

type
  IHashGenerator = interface
    ['{311AAE59-B24C-401B-BABD-8B617F029246}']
    function GenerateHash(const APlainText: string): string;
  end;

  TPbkdf2Sha1 = class(TInterfacedObject, IHashGenerator)
  private
    function GenerateHash(const APlainText: string): string;
  end;

//function PBKDF2HMACSHA512(pass, salt: TBytes; count, kLen: Integer
//  ; AHash: TDCP_hashclass
//): TBytes;
function Pbkdf2(
  const AHashAlgorithmName: string;
  const ADerivedKeyLengthInBytes: Integer;
  const APassword: TBytes;
  const ASalt: TBytes;
  const AIterations: UInt64
): TBytes; overload;

implementation

uses
(*
  PbkdfUtil
  , IdHMACSHA1
*)
  System.NetEncoding
(*
  , DCPsha1
  , System.Math
*)
  , Winapi.Windows
  , Winapi.BCrypt
  ;

{ TPbkdf2Sha1 }

function TPbkdf2Sha1.GenerateHash(const APlainText: string): string;
const
  CBase64StringSecret =
    'NXVFVXNvdldtM3Q5QE9IVXdeIVdaNCFaNyRzJlRSSlZYTUZJRF5tZnZUbnZQYUlDSUQ=';
  CExpectedResult =
    '8pmlQ5ZltechQZk/iofCz8g+jY2koMotvp0Ka5g0lfZ+nlsbnkGjuLpTmExh3g3f6PfedRW0k0tdgB0W52JRbQ==';
var
  LEncoding: TBase64Encoding;
  LSalt: TBytes;
  LPlainTextBytes: TBytes;
  LResultBytes: TBytes;
begin
(*
{
  With the use of TBase64Encoding static methods, the default CharsPerLine will be used, resulting
  the hash containing the line break (: '#$D#$A') after 76 characters.
}
  LSalt := TBase64Encoding.Base64.DecodeStringToBytes(CBase64StringSecret);

{
  The result for the alternatives below respectivly:
  - Base64:  xRnKiJfIc+Nud9iZlpMtsu1uuR5AxhyXerVIR7XXKKWANx+F6cLR7tkP6emLA3ZSi7fkKbD2fLd0'#$D#$A'KCYYVZMkxA==
  - Unicode: EHIMkiPyS5uy5RBjf91/DgeFzOMYZm9wq7+SRRwq0fKx7HWQiQtifT0IvjMmt1xdd3ro65IG/4m/'#$D#$A'WUCrX3lzHQ==
  - UTF8:    8pmlQ5ZltechQZk/iofCz8g+jY2koMotvp0Ka5g0lfZ+nlsbnkGjuLpTmExh3g3f6PfedRW0k0td'#$D#$A'gB0W52JRbQ==
}
//  LPlainTextBytes := TBase64Encoding.Base64.DecodeStringToBytes(APlainText);
//  LPlainTextBytes := TEncoding.Unicode.GetBytes(APlainText);
  LPlainTextBytes := TEncoding.UTF8.GetBytes(APlainText);

  LResultBytes := PBKDF2(LPlainTextBytes, LSalt, 100000, 64, TIdHMACSHA1);
  Result := TBase64Encoding.Base64.EncodeBytesToString(LResultBytes);
*)
  LEncoding := TBase64Encoding.Create(Length(CExpectedResult));
  try
    LSalt := LEncoding.DecodeStringToBytes(CBase64StringSecret);
    LPlainTextBytes := TEncoding.UTF8.GetBytes(APlainText);

//    LResultBytes := PBKDF2(LPlainTextBytes, LSalt, 100000, 64, TIdHMACSHA1);
//    LResultBytes := PBKDF2HMACSHA512(LPlainTextBytes, LSalt, 100000, 64, TDCP_sha1);
    // Below, 64 bytes equal to 512 bits to match the length of BCRYPT_SHA512_ALGORITHM result.
    LResultBytes := Pbkdf2(BCRYPT_SHA1_ALGORITHM, 64, LPlainTextBytes, LSalt, 100000);
    Result := LEncoding.EncodeBytesToString(LResultBytes);
  finally
    LEncoding.Free;
  end;

  if Result = CExpectedResult then
    Result := Result + #$D#$A'matches'
  else
    Result := Result + #$D#$A'does not match';
  Result := Result + #$D#$A + CExpectedResult;
end;

{$Region 'Internal Crypto Util'}
const
  CBCryptDll = 'bcrypt.dll';
  CPBKDF2Function = 'BCryptDeriveKeyPBKDF2';
  CSuccessStatus = 0;

function CanUseCrytoAPI: Boolean;
var
  LModule: cardinal;
begin
  LModule := LoadLibrary(CBCryptDll);
  Result := (LModule <> 0) and Assigned(GetProcAddress(LModule, CPBKDF2Function));
end;

function CheckBCryptResult(const AResult: NTSTATUS): Boolean;
begin
  Result := AResult = CSuccessStatus;
  if not Result then
    raise Exception.CreateFmt('Failed to call WinCryptographyAPIs with error code: %d', [AResult]);
end;

function Pbkdf2(
  const AHashAlgorithmName: string;
  const ADerivedKeyLengthInBytes: Integer;
  const APassword: TBytes;
  const ASalt: TBytes;
  const AIterations: UInt64
): TBytes; overload;
var
  LPBKDF2AlgorythmHandle: BCRYPT_ALG_HANDLE;
begin
  SetLength(Result, ADerivedKeyLengthInBytes);
  if CanUseCrytoAPI then
  begin
{
  Let x be string and y be PWideChar/LPCWSTR/LPWSTR:
  y := PWideChar(x); // Alternative: @x[1]
  x := y; // AutoMAGICally casted.
}
    CheckBCryptResult(BCryptOpenAlgorithmProvider(
      LPBKDF2AlgorythmHandle,
//      BCRYPT_SHA512_ALGORITHM,
      PWideChar(AHashAlgorithmName), // Alternative: @AHashAlgorithmName[1]
      nil,
      BCRYPT_ALG_HANDLE_HMAC_FLAG
    ));
    try
      SetLength(Result, ADerivedKeyLengthInBytes);

      CheckBCryptResult(BCryptDeriveKeyPBKDF2(
        LPBKDF2AlgorythmHandle,
        @APassword[0],
        Length(APassword),
        @ASalt[0],
        Length(ASalt),
        AIterations,
        @Result[0],
        Length(Result),
        0
      ));
    finally
      BCryptCloseAlgorithmProvider(LPBKDF2AlgorythmHandle, 0);
    end;
  end
  else
  begin
//    Log.Info('Using internal implementation of PBKDF2-HMAC-SHA512');
//    Result := PBKDF2HMACSHA512(
//      APassword,
//      ASalt,
//      AIterations,
//      ADerivedKeyLengthInBytes
//    );
    raise Exception.Create('Missing windows file: bcrypt.dll');
  end;
end;

(*
function CalcDigest(text: TBytes; dig: TDCP_hashclass): TBytes;
var
  x: TDCP_hash;
begin
  x := dig.Create(nil);
  try
    x.Init;
    x.Update(text[0], Length(text));
    SetLength(Result, x.GetHashSize div 8);
    x.Final(Result[0]);
  finally
    x.Free;
  end;
end;

function RPad(x: TBytes; c: Byte; s: Integer): TBytes;
begin
  Result := x;
  if Length(Result) < s then
  begin
    SetLength(Result, s);
    FillChar(Result[length(x)], s - length(x), c);
  end;
end;

function XorBlock(s, x: TBytes): TBytes; inline;
var
 i: Integer;
begin
 SetLength(Result, Length(s));
 for i := 0 to Length(s) - 1 do
   Result[i] := Byte(s[i]) xor Byte(x[i]);
end;

function CalcHMAC(sequence, key: TBytes; hash: TDCP_hashclass): TBytes;
const
  blocksize = 128;
var
  o_key_pad: TBytes;
  i_key_pad: TBytes;
begin
  // Definition RFC 2104
  if Length(key) > blocksize then
    key := CalcDigest(key, hash);
  key := RPad(key, 0, blocksize);

  o_key_pad := XorBlock(key, RPad(nil, $5c, blocksize));
  i_key_pad := XorBlock(key, RPad(nil, $36, blocksize));

  Result := CalcDigest(Concat(o_key_pad, CalcDigest(Concat(i_key_pad, sequence), hash)), hash);
end;

function PBKDF2HMACSHA512(pass, salt: TBytes; count, kLen: Integer
  ; AHash: TDCP_hashclass
): TBytes;

  function IntX(i: Integer): TBytes; inline;
  begin
    SetLength(Result, 4);
    Result[0] := Byte(i shr 24);
    Result[1] := Byte(i shr 16);
    Result[2] := Byte(i shr 8);
    Result[3] := Byte(i);
  end;

var
  D, I, J: Integer;
  T, F, U: TBytes;
begin
//  AHash := TDCP_sha512;
  D := Ceil(kLen / (AHash.GetHashSize div 8));
  for i := 1 to D do
  begin
    F := CalcHMAC(concat(salt, IntX(i)), pass, AHash);
    U := F;
    for j := 2 to count do
    begin
      U := CalcHMAC(U, pass, AHash);
      F := XorBlock(F, U);
    end;
    T := T + F;
  end;
  Result := Copy(T, 0, kLen);
end;
*)
{$EndRegion}

end.
