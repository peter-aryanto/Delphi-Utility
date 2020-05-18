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
  PbkdfUtil
  , IdHMACSHA1
  , System.NetEncoding
  , System.SysUtils
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
    LResultBytes := PBKDF2(LPlainTextBytes, LSalt, 100000, 64, TIdHMACSHA1);
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

end.
