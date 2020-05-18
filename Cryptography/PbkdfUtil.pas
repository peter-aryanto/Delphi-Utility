{
  Based on:
  https://stackoverflow.com/questions/14116954/implementations-pbkdf2-in-delphi
}

unit PbkdfUtil;

interface

uses
  System.SysUtils, IdHMAC;

type
  TIdHMACClass = class of TIdHMAC;

function PBKDF2(const P: TBytes; const S: TBytes; const C: Integer;
  const kLen: Integer; PRFC: TIdHMACClass = nil): TBytes;

implementation

uses
  System.Math, IdHMACSHA1, IdGlobal;

// Modeled after [NOT FOUND] http://www.di-mgt.com.au/cryptoKDFs.html#PKCS5
function PBKDF2(const P: TBytes; const S: TBytes; const C: Integer;
  const kLen: Integer; PRFC: TIdHMACClass = nil): TBytes;
var
  PRF: TIdHMAC;
  D: Integer;
  I: Int32;
  F: TBytes;
  U: TBytes;
  J: Integer;
  T: TBytes;

  function _ConcatenateBytes(const _B1: TBytes; const _B2: TBytes): TBytes; inline;
  begin
    SetLength(Result, Length(_B1) + Length(_B2));
    if Length(_B1) > 0 then
      Move(_B1[Low(_B1)], Result[Low(Result)], Length(_B1));
    if Length(_B2) > 0 then
      Move(_B2[Low(_B2)], Result[Low(Result)+Length(_B1)], Length(_B2));
  end;

  function _INT_32_BE(const _I: Int32): TBytes; inline;
  begin
    Result := TBytes.Create(_I shr 24, _I shr 16, _I shr 8, _I);
  end;

  procedure _XorBytes(var _B1: TBytes; const _B2: TBytes); inline;
  var
    _I: Integer;
  begin
    for _I := Low(_B1) to High(_B1) do
      _B1[_I] := _B1[_I] xor _B2[_I];
  end;

begin
  if not Assigned(PRFC) then
    PRFC := TIdHMACSHA1;

  PRF := PRFC.Create;
  try
    D := Ceil(kLen / PRF.HashSize);
    PRF.Key := TIdBytes(P);
    for I := 1 to D do
    begin
      F := TBytes(PRF.HashValue(TIdBytes(_ConcatenateBytes(S, _INT_32_BE(I)))));
      U := Copy(F);
      for J := 2 to C do
      begin
        U := TBytes(PRF.HashValue(TIdBytes(U)));
        _XorBytes(F, U);
      end;
      T := _ConcatenateBytes(T, F);
    end;
    Result := Copy(T, Low(T), kLen);
  finally
    PRF.Free;
  end;
end;

(*
{
  http://keit.co/p/dcpcrypt-hmac-rfc2104/
  DCPCrypt HMAC / PBKDF1 / PBKDF2
}

unit DCPcryptHmacPbkdf1Pbkdf2Utils;

interface

implementation

uses
dcpcrypt2, Math;

function RPad(x: string; c: Char; s: Integer): string;
var
i: Integer;
begin
Result := x;
if Length(x) < s then
for i := 1 to s-Length(x) do
Result := Result + c;
end;

function XorBlock(s, x: ansistring): ansistring; inline;
var
i: Integer;
begin
SetLength(Result, Length(s));
for i := 1 to Length(s) do
Result[i] := Char(Byte(s[i]) xor Byte(x[i]));
end;

function CalcDigest(text: string; dig: TDCP_hashclass): string;
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

function CalcHMAC(message, key: string; hash: TDCP_hashclass): string;
const
blocksize = 64;
begin
// Definition RFC 2104
if Length(key) > blocksize then
key := CalcDigest(key, hash)
key := RPad(key, #0, blocksize);

Result := CalcDigest(XorBlock(key, RPad('', #$36, blocksize)) + message, hash);
Result := CalcDigest(XorBlock(key, RPad('', #$5c, blocksize)) + result, hash);
end;

function PBKDF1(pass, salt: ansistring; count: Integer; hash: TDCP_hashclass): ansistring;
var
i: Integer;
begin
Result := pass+salt;
for i := 0 to count-1 do
Result := CalcDigest(Result, hash);
end;

function PBKDF2(pass, salt: ansistring; count, kLen: Integer; hash: TDCP_hashclass): ansistring;

function IntX(i: Integer): ansistring; inline;
begin
Result := Char(i shr 24) + Char(i shr 16) + Char(i shr 8) + Char(i);
end;

var
D, I, J: Integer;
T, F, U: ansistring;
begin
T := '';
D := Ceil(kLen / (hash.GetHashSize div 8));
for i := 1 to D do
begin
F := CalcHMAC(salt + IntX(i), pass, hash);
U := F;
for j := 2 to count do
begin
U := CalcHMAC(U, pass, hash);
F := XorBlock(F, U);
end;
T := T + F;
end;
Result := Copy(T, 1, kLen);
end;
*)
end.

