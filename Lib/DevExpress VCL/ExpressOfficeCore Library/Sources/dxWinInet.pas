{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressOfficeCore Library classes                        }
{                                                                    }
{           Copyright (c) 2000-2018 Developer Express Inc.           }
{           ALL RIGHTS RESERVED                                      }
{                                                                    }
{   The entire contents of this file is protected by U.S. and        }
{   International Copyright Laws. Unauthorized reproduction,         }
{   reverse-engineering, and distribution of all or any portion of   }
{   the code contained in this file is strictly prohibited and may   }
{   result in severe civil and criminal penalties and will be        }
{   prosecuted to the maximum extent possible under the law.         }
{                                                                    }
{   RESTRICTIONS                                                     }
{                                                                    }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES            }
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE     }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS    }
{   LICENSED TO DISTRIBUTE THE EXPRESSOFFICECORE LIBRARY AND ALL     }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM       }
{   ONLY.                                                            }
{                                                                    }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED       }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE         }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE        }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT   }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                       }
{                                                                    }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON        }
{   ADDITIONAL RESTRICTIONS.                                         }
{                                                                    }
{********************************************************************}

unit dxWinInet;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Types, SysUtils, Windows,
{$IFDEF DELPHIXE6}
  JSON,
{$ELSE}
  DBXJSON,
{$ENDIF}
  WinInet;

{$IFDEF WIN32}
  {$HPPEMIT '#pragma link "wininet.lib"'}
{$ENDIF}

type
  TdxJSONValue = TJSONValue;
  TdxJSONObject = TJSONObject;
  TdxJSONPair = TJSONPair;
  TdxJSONArray = TJSONArray;
  TdxJSONString = TJSONString;
  TdxJSONTrue = TJSONTrue;
  TdxJSONFalse = TJSONFalse;
  TdxJSONNull = TJSONNull;

  { TdxHttpHelper }

  TdxHttpHelper = class
  public const
    HTTP_VERSION_1_1 = 'HTTP/1.1';
  protected
    class function GetJSONObject(ARequest: HINTERNET): TdxJSONObject; overload; static;
    class function SendRequest(const AUserAgent, AServerName, AObjectName, AHeader, AVerb: string; const AParams: TBytes): TdxJSONObject; overload; static;
    class function SendRequest(const AUserAgent, AServerName, AObjectName, AHeader, AVerb: string; const AParams: TdxJSONObject): TdxJSONObject; overload; static;
  public
    class function DeleteRequest(const AUserAgent, AServerName, AObjectName, AHeader: string; const AParams: TdxJSONObject): TdxJSONObject; static;
    class function GetRequest(const AUserAgent, AUri, AHeader: string): TdxJSONObject; overload; static;
    class function GetRequest(const AUserAgent, AServerName, AObjectName, AHeader: string; const AParams: TdxJSONObject): TdxJSONObject; overload; static;
    class function GetRequest(const AUserAgent, AServerName, AObjectName, AHeader: string; const AParams: TBytes): TdxJSONObject; overload; static;
    class function PatchRequest(const AUserAgent, AServerName, AObjectName, AHeader: string; const AParams: TdxJSONObject): TdxJSONObject; static;
    class function PostRequest(const AUserAgent, AServerName, AObjectName, AHeader: string; const AParams: TdxJSONObject): TdxJSONObject; overload; static;
    class function PostRequest(const AUserAgent, AServerName, AObjectName, AHeader: string; const AParams: TBytes): TdxJSONObject; overload; static;
    class function PutRequest(const AUserAgent, AServerName, AObjectName, AHeader: string; const AParams: TdxJSONObject): TdxJSONObject; static;
  end;

  { TJSONValueHelper }

  TJSONValueHelper = class helper for TJSONValue
  public
    class function CreateBooleanValue(const Value: Boolean): TdxJSONValue; static;
    function Get(const AParamName: string): TdxJSONValue;
    function GetChild(const AParentName, AParamName: string): TdxJSONValue;
    function GetChildParamValue(const AParentName, AParamName: string): string;
    function GetPair(const AParamName: string): TdxJSONPair;
    function GetParamValue(const AParamName: string): string;
    function HasChildParam(const AParentName, AParamName: string): Boolean;
    function HasParam(const AParamName: string): Boolean;
    function IsArray: Boolean;
  end;

{$IFNDEF DELPHIXE6}
  { TJSONObjectHelper }

  TJSONObjectHelper = class helper for TJSONObject
  private
    function GetCount: Integer;
    function GetItem(Index: Integer): TJSONPair;
  public
  {$IFNDEF DELPHI2010}
    procedure AddPair(const AName, AValue: UnicodeString); overload;
  {$ENDIF}
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TJSONPair read GetItem;
  end;

  { TJSONArrayHelper }

  TJSONArrayHelper = class helper for TJSONArray
  private
    function GetCount: Integer;
    function GetItem(Index: Integer): TJSONValue;
  public
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TJSONValue read GetItem;
  end;

{$ENDIF}

  { TdxISO8601Helper }

  TdxISO8601Helper = class
  public
    class function DateTimeToString(AValue: TDateTime): string; static;
    class function StringToDateTime(const AValue: string; out AIsUtcTimeZone: Boolean): TDateTime; static;
  end;

implementation

uses
  DateUtils,
  cxDateUtils, dxCore;

{ TdxHttpHelper }

class function TdxHttpHelper.GetJSONObject(ARequest: HINTERNET): TdxJSONObject;
const
  ABufSize = 1024;
var
  AHttpQueryInfoBuffer: DWORD;
  AHttpQueryInfoBufferLength: DWORD;
  AIndex: DWORD;
  ABuf, ABuffer: TBytes;
  ACount: DWORD;
  AReadByteCount: DWORD;
  AResult: TdxJSONValue;
begin
  Result := nil;
  AHttpQueryInfoBufferLength := SizeOf(AHttpQueryInfoBuffer);
  AIndex := 0;
  if HttpQueryInfo(ARequest, HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER,
    @AHttpQueryInfoBuffer, AHttpQueryInfoBufferLength, AIndex) and (AIndex = 0) then
  begin
    Result := nil;
    SetLength(ABuf, ABufSize);
    AReadByteCount := 0;
    repeat
      ACount := 0;
      InternetReadFile(ARequest, @ABuf[0], ABufSize, ACount);
      AReadByteCount := AReadByteCount + ACount;
      if ACount > 0 then
      begin
        SetLength(ABuffer, AReadByteCount);
        Move(ABuf[0], ABuffer[AReadByteCount - ACount], ACount);
      end;
    until (ACount = 0);
    AResult := TJSONObject.ParseJSONValue(ABuffer, 0, AReadByteCount);
    try
      if AResult is TJSONObject then
        Result := TJSONObject(AResult);
    finally
      if Result <> AResult then
        AResult.Free;
    end;
  end;
end;

class function TdxHttpHelper.DeleteRequest(const AUserAgent, AServerName, AObjectName, AHeader: string; const AParams: TdxJSONObject): TdxJSONObject;
begin
  Result := SendRequest(AUserAgent, AServerName, AObjectName, AHeader, 'DELETE', AParams);
end;

class function TdxHttpHelper.GetRequest(const AUserAgent, AUri, AHeader: string): TdxJSONObject;
var
  AInet: HINTERNET;
  ARequest: HINTERNET;
begin
  Result := nil;
  try
    AInet := InternetOpen(PChar(AUserAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    if Assigned(AInet) then
    try
      ARequest := InternetOpenUrl(AInet, PChar(AUri), PChar(AHeader), Length(AHeader),
        INTERNET_FLAG_KEEP_CONNECTION or INTERNET_FLAG_PASSIVE or INTERNET_FLAG_SECURE or INTERNET_FLAG_DONT_CACHE, 0);
      if Assigned(ARequest) then
      try
        Result := TdxHttpHelper.GetJSONObject(ARequest);
      finally
        InternetCloseHandle(ARequest);
      end;
    finally
      InternetCloseHandle(AInet);
    end;
  except
  end;
end;

class function TdxHttpHelper.SendRequest(
  const AUserAgent, AServerName, AObjectName, AHeader, AVerb: string;
  const AParams: TBytes): TdxJSONObject;
var
  AInet: HINTERNET;
  AConnect: HINTERNET;
  ARequest: HINTERNET;
begin
  Result := nil;
  try
    AInet := InternetOpen(PChar(AUserAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    if Assigned(AInet) then
    try
      AConnect := InternetConnect(AInet, PChar(AServerName), INTERNET_DEFAULT_HTTPS_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
      if Assigned(AConnect) then
      try
        ARequest := HttpOpenRequest(AConnect, PChar(AVerb), PChar(AObjectName), HTTP_VERSION_1_1, '', nil,
          INTERNET_SERVICE_HTTP or INTERNET_FLAG_SECURE or INTERNET_FLAG_PASSIVE or INTERNET_FLAG_KEEP_CONNECTION or INTERNET_FLAG_DONT_CACHE, 0);
        if Assigned(ARequest) then
        try
          if not HTTPSendRequest(ARequest, PChar(AHeader), Length(AHeader), @AParams[0], Length(AParams)) then
            Exit;
          Result := TdxHttpHelper.GetJSONObject(ARequest);
        finally
          InternetCloseHandle(ARequest);
        end;
      finally
        InternetCloseHandle(AConnect);
      end;
    finally
      InternetCloseHandle(AInet);
    end;
  except
    Result := nil;
  end;
end;

class function TdxHttpHelper.SendRequest(const AUserAgent, AServerName, AObjectName, AHeader, AVerb: string; const AParams: TdxJSONObject): TdxJSONObject;
var
  ABytes: TBytes;
begin
  if AParams <> nil then
    ABytes := TEncoding.UTF8.GetBytes(AParams.ToString)
  else
    ABytes := nil;
  Result := SendRequest(AUserAgent, AServerName, AObjectName, AHeader, AVerb, ABytes);
end;

class function TdxHttpHelper.GetRequest(
  const AUserAgent, AServerName, AObjectName, AHeader: string;
  const AParams: TdxJSONObject): TdxJSONObject;
begin
  Result := SendRequest(AUserAgent, AServerName, AObjectName, AHeader, 'GET', AParams);
end;

class function TdxHttpHelper.GetRequest(const AUserAgent, AServerName, AObjectName, AHeader: string; const AParams: TBytes): TdxJSONObject;
begin
  Result := SendRequest(AUserAgent, AServerName, AObjectName, AHeader, 'GET', AParams);
end;

class function TdxHttpHelper.PostRequest(const AUserAgent, AServerName, AObjectName,
  AHeader: string; const AParams: TdxJSONObject): TdxJSONObject;
begin
  Result := SendRequest(AUserAgent, AServerName, AObjectName, AHeader, 'POST', AParams);
end;

class function TdxHttpHelper.PostRequest(const AUserAgent, AServerName, AObjectName, AHeader: string; const AParams: TBytes): TdxJSONObject;
begin
  Result := SendRequest(AUserAgent, AServerName, AObjectName, AHeader, 'POST', AParams);
end;

class function TdxHttpHelper.PatchRequest(const AUserAgent, AServerName, AObjectName,
  AHeader: string; const AParams: TdxJSONObject): TdxJSONObject;
begin
  Result := SendRequest(AUserAgent, AServerName, AObjectName, AHeader, 'PATCH', AParams);
end;

class function TdxHttpHelper.PutRequest(const AUserAgent, AServerName,
  AObjectName, AHeader: string; const AParams: TdxJSONObject): TdxJSONObject;
begin
  Result := SendRequest(AUserAgent, AServerName, AObjectName, AHeader, 'PUT', AParams);
end;

{ TJSONValueHelper }

class function TJSONValueHelper.CreateBooleanValue(const Value: Boolean): TdxJSONValue;
begin
  if Value then
    Result := TJSONTrue.Create
  else
    Result := TJSONFalse.Create;
end;

function TJSONValueHelper.GetPair(const AParamName: string): TdxJSONPair;
{$IFNDEF DELPHIXE}
  var
    I: Integer;
{$ENDIF}
begin
  Result := nil;
  if Self is TdxJSONObject then
  begin
  {$IFNDEF DELPHIXE}
    for I := 0 to TdxJSONObject(Self).Size - 1 do
      if TdxJSONObject(Self).Get(I).JsonString.Value = AParamName then
      begin
        Result := TdxJSONObject(Self).Get(I);
        Break;
      end;
  {$ELSE}
    Result := TdxJSONObject(Self).Get(AParamName);
  {$ENDIF}
  end;
end;

function TJSONValueHelper.Get(const AParamName: string): TdxJSONValue;
var
  APair: TJSONPair;
begin
  APair := GetPair(AParamName);
  if APair <> nil then
    Result := APair.JsonValue
  else
    Result := nil;
end;

function TJSONValueHelper.GetChild(const AParentName, AParamName: string): TdxJSONValue;
var
  AValue: TdxJSONValue;
begin
  AValue := Self.Get(AParentName);
  if AValue <> nil then
    Result := AValue.Get(AParamName)
  else
    Result := nil;
end;

function TJSONValueHelper.GetChildParamValue(const AParentName, AParamName: string): string;
var
  AValue: TdxJSONValue;
begin
  AValue := Self.GetChild(AParentName, AParamName);
  if AValue <> nil then
    Result := AValue.Value
  else
    Result := '';
end;

function TJSONValueHelper.GetParamValue(const AParamName: string): string;
var
  AObject: TdxJSONValue;
begin
  AObject := Get(AParamName);
  if AObject <> nil then
    Result := AObject.Value
  else
    Result := '';
end;

function TJSONValueHelper.HasParam(const AParamName: string): Boolean;
begin
  Result := Get(AParamName) <> nil;
end;

function TJSONValueHelper.IsArray: Boolean;
begin
  Result := Self is TdxJSONArray;
end;

function TJSONValueHelper.HasChildParam(const AParentName, AParamName: string): Boolean;
var
  AObject: TdxJSONValue;
begin
  AObject := Get(AParentName);
  Result := (AObject <> nil) and (AObject.HasParam(AParamName));
end;

{$IFNDEF DELPHIXE6}
  { TJSONObjectHelper }

  {$IFNDEF DELPHI2010}
    procedure TJSONObjectHelper.AddPair(const AName, AValue: UnicodeString);
    begin
      AddPair(TJSONPair.Create(AName, AValue));
    end;
  {$ENDIF}

  function TJSONObjectHelper.GetCount: Integer;
  begin
    Result := Size;
  end;

  function TJSONObjectHelper.GetItem(Index: Integer): TJSONPair;
  begin
    Result := Get(Index);
  end;

  { TJSONArrayHelper }

  function TJSONArrayHelper.GetCount: Integer;
  begin
    Result := Size;
  end;

  function TJSONArrayHelper.GetItem(Index: Integer): TJSONValue;
  begin
    Result := Get(Index);
  end;
{$ENDIF}

{ TdxISO8601Helper }

class function TdxISO8601Helper.DateTimeToString(AValue: TDateTime): string;
const
  AIso8601UtcDateTimeFormat = 'yyyy-MM-dd"T"HH:mm:ss"Z"';
  AIso8601UtcDateFormat = 'yyyy-MM-dd';
begin
  if dxDateOf(AValue) = AValue then
    SysUtils.DateTimeToString(Result, AIso8601UtcDateFormat, AValue)
  else
    SysUtils.DateTimeToString(Result, AIso8601UtcDateTimeFormat, AValue);
end;

class function TdxISO8601Helper.StringToDateTime(const AValue: string; out AIsUtcTimeZone: Boolean): TDateTime;
var
  S: string;
  AYear, AMonth, ADay, AHours, AMinute, ASec, AMSec: Integer;
  AMSecValue: string;
  AOffsetHours, AOffsetMinute: Integer;
  AOffsetSign: Integer;
  AOffset: TTime;
  P: PChar;
begin
  AYear := 0;
  AMonth := 0;
  ADay := 0;
  AHours := 0;
  AMinute := 0;
  ASec := 0;
  AMSec := 0;
  AOffsetSign := 0;
  AIsUtcTimeZone := False;
  Result := InvalidDate;
  if AValue <> '' then
  begin
    S := AValue + #0;
    P := PChar(S);
    if not TryStrToInt(Copy(P, 1, 4), AYear) then
      Exit;
    Inc(P, 5);
    if not TryStrToInt(Copy(P, 1, 2), AMonth) then
      Exit;
    Inc(P, 3);
    if not TryStrToInt(Copy(P, 1, 2), ADay) then
      Exit;
    Inc(P, 3);
    if P^ = #0 then
      AOffset := 0
    else
    begin
      if not TryStrToInt(Copy(P, 1, 2), AHours) then
        Exit;
      Inc(P, 3);
      if not TryStrToInt(Copy(P, 1, 2), AMinute) then
        Exit;
      Inc(P, 3);
      if not TryStrToInt(Copy(P, 1, 2), ASec) then
        Exit;
      Inc(P, 2);
      if P^ = '.' then
      begin
        Inc(P);
        AMSecValue := '';
        while dxCharInSet(P^, ['0'..'9']) do
        begin
          AMSecValue := AMSecValue + P^;
          Inc(P);
        end;
        if not TryStrToInt(AMSecValue, AMSec) then
          Exit;
      end;
      AOffset := 0;
      if (P^ <> #0) then
      begin
        if P^ = '-' then
          AOffsetSign := -1
        else
          if P^ = '+' then
            AOffsetSign := 1;
        if (AOffsetSign = 0) and (P^ <> 'Z') then
          Exit;
        if AOffsetSign <> 0 then
        begin
          Inc(P);
          if not TryStrToInt(Copy(P, 1, 2), AOffsetHours) then
            Exit;
          Inc(P, 3);
          if dxCharInSet(P^, ['0'..'9']) then
          begin
            if not TryStrToInt(Copy(P, 1, 2), AOffsetMinute) then
              Exit;
          end;
          AOffset := EncodeTime(AOffsetHours, AOffsetMinute, 0, 0);
        end;
      end;
      AIsUtcTimeZone := (P^ = 'Z') or (AOffset <> 0);
    end;
    Result := EncodeDateTime(AYear, AMonth, ADay, AHours, AMinute, ASec, AMSec);
    Result := Result - AOffsetSign * AOffset;
  end;
end;

end.
