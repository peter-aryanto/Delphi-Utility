unit Cryptography;

interface

type
  IHashGenerator = interface
    ['{311AAE59-B24C-401B-BABD-8B617F029246}']
    function GenerateHash(const APlainText: string): string;
  end;

  TPbkdf2Sha1 = class(TInterfacedObject, IHashGenerator)
  private
    function GenerateHash(const APlainText: string): string;
  end;

implementation

uses
  System.SysUtils
  , System.NetEncoding
  , Winapi.Windows
  , Winapi.BCrypt

  , System.Math
  , DCPcrypt2
  , DCPsha1
  ;

{$Region 'Windows BCrypt-based WinCryptographyAPIs code (minimum Windows Server 2008 R2 onwards)'}
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
  const APassword: TBytes;
  const ASalt: TBytes;
  const AIterations: Cardinal;
  const ADerivedKeyLengthInBytes: Cardinal;
  const AHashAlgorithmName: string
): TBytes; overload;
var
  LPBKDF2AlgorythmHandle: BCRYPT_ALG_HANDLE;
begin
  if CanUseCrytoAPI then
  begin
{
  Let x be string and y be PWideChar/LPCWSTR/LPWSTR:
  y := PWideChar(x); // Alternative: @x[1]
  x := y; // AutoMAGICally casted.
}
    CheckBCryptResult(BCryptOpenAlgorithmProvider(
      LPBKDF2AlgorythmHandle,
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
    raise Exception.Create('Missing windows file: bcrypt.dll');
  end;
end;
{$EndRegion}

{$Region 'Backward compatibility DCPcrypt-based code (https://keit.co/p/dcpcrypt-hmac-rfc2104/)'}
function RPad(x: AnsiString; c: AnsiChar; s: Integer): AnsiString;
var
  i: Integer;
begin
  Result := x;
  if Length(x) < s then
  for i := 1 to s-Length(x) do
    Result := Result + c;
end;

function XorBlock(s, x: AnsiString): AnsiString;
var
  i: Integer;
begin
  SetLength(Result, Length(s));
  for i := 1 to Length(s) do
    Result[i] := AnsiChar(Byte(s[i]) xor Byte(x[i]));
end;

function CalcDigest(text: AnsiString; dig: TDCP_hashclass): AnsiString;
var
  x: TDCP_hash;
begin
  x := dig.Create(nil);
  try
    x.Init;
    x.UpdateStr(text);
    SetLength(Result, x.GetHashSize div 8);
    x.Final(Result[1]);
  finally
    x.Free;
  end;
end;

function CalcHmac(AMessage, key: AnsiString; hash: TDCP_hashclass): AnsiString;
const
  blocksize = 64;
begin
  if Length(key) > blocksize then
    key := CalcDigest(key, hash);
  key := RPad(key, #0, blocksize);
  Result := CalcDigest(XorBlock(key, RPad('', #$36, blocksize)) + AMessage, hash);
  Result := CalcDigest(XorBlock(key, RPad('', #$5c, blocksize)) + Result, hash);
end;

function Pbkdf2(
  const APassword: AnsiString;
  const ASalt: AnsiString;
  const AIterations: Cardinal;
  const ADerivedKeyLength: Cardinal;
  const AHash: TDCP_hashclass
): TBytes; overload;

  function INT_32_BE(i: Integer): AnsiString;
  begin
    Result := AnsiChar(i shr 24) + AnsiChar(i shr 16) + AnsiChar(i shr 8) + AnsiChar(i);
  end;

var
  D, I, J: Integer;
  T, F, U: ansistring;
  LIndex: Integer;
begin
  T := '';
  D := Ceil(ADerivedKeyLength / (AHash.GetHashSize div 8));
  for i := 1 to D do
  begin
    F := CalcHmac(ASalt + INT_32_BE(i), APassword, AHash);
    U := F;
    for j := 2 to AIterations do
    begin
      U := CalcHmac(U, APassword, AHash);
      F := XorBlock(F, U);
    end;
    T := T + F;
  end;

  SetLength(Result, ADerivedKeyLength);
  for LIndex := 1 to ADerivedKeyLength do
  begin
    Result[LIndex - 1] := Byte(T[LIndex]);
  end;
end;
{$EndRegion}

{ TPbkdf2Sha1 }

function TPbkdf2Sha1.GenerateHash(const APlainText: string): string;
const
  CBase64StringSecret =
    'NXVFVXNvdldtM3Q5QE9IVXdeIVdaNCFaNyRzJlRSSlZYTUZJRF5tZnZUbnZQYUlDSUQ=';

  CExpectedResult =
    '8pmlQ5ZltechQZk/iofCz8g+jY2koMotvp0Ka5g0lfZ+nlsbnkGjuLpTmExh3g3f6PfedRW0k0tdgB0W52JRbQ==';

  CNumberOfIterations = 100000;

  // Below, 64 bytes equal to 512 bits to match the length of BCRYPT_SHA512_ALGORITHM result.
  CDerivedKeyLengthInBytes = 64;
var
  LEncoding: TBase64Encoding;
  LSalt: TBytes;
  LPlainTextBytes: TBytes;
  LResultBytes: TBytes;
  LWinCryptographyApiResult: string;
  LManualDCPcryptBasedCodeResult: string;
begin
(*
{
  With the use of TBase64Encoding static methods, the default CharsPerLine will be used, resulting
  the hash containing the line break (: '#$D#$A') after 76 characters. By using either:
  - TBase64Encoding.Create(x)
  - TBase64Encoding.Create(0)
  the line break can be set not to appear before x number of characters or not to appear at all.
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

  LResultBytes := Pbkdf2(BCRYPT_SHA1_ALGORITHM, 64, LPlainTextBytes, LSalt, 100000);
  Result := TBase64Encoding.Base64.EncodeBytesToString(LResultBytes);
*)
  LEncoding := TBase64Encoding.Create(0);
  try
    LSalt := LEncoding.DecodeStringToBytes(CBase64StringSecret);
    LPlainTextBytes := TEncoding.UTF8.GetBytes(APlainText);

    LResultBytes := Pbkdf2(
      LPlainTextBytes,
      LSalt,
      CNumberOfIterations,
      CDerivedKeyLengthInBytes,
      BCRYPT_SHA1_ALGORITHM
    );
    LWinCryptographyApiResult := LEncoding.EncodeBytesToString(LResultBytes);

    LResultBytes := Pbkdf2(
      AnsiString(LPlainTextBytes),
      AnsiString(LSalt),
      CNumberOfIterations,
      CDerivedKeyLengthInBytes,
      TDCP_sha1
    );
    LManualDCPcryptBasedCodeResult := LEncoding.EncodeBytesToString(LResultBytes);

  finally
    LEncoding.Free;
  end;

  Result := '#1: Expected Hash';

  Result := Result + #$D#$A'#2: Windows BCrypt-based WinCryptographyAPIs: ';
  if LWinCryptographyApiResult = CExpectedResult then
    Result := Result + 'MATCHED'
  else
    Result := Result + 'FAILED';

  Result := Result + #$D#$A'#3: DCPcrypt-based manual calculation: ';
  if LManualDCPcryptBasedCodeResult = CExpectedResult then
    Result := Result + 'MATCHED'
  else
    Result := Result + 'FAILED';

  Result := Result
    + #$D#$A
    + #$D#$A + '#1: ' + CExpectedResult
    + #$D#$A + '#2: ' + LWinCryptographyApiResult
    + #$D#$A + '#3: ' + LManualDCPcryptBasedCodeResult;
end;

end.
