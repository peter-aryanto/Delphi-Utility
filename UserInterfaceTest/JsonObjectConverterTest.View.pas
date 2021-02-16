unit JsonObjectConverterTest.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls
  , REST.Json, System.JSON
  , Spring.Collections, Spring.Collections.Lists;

const
  CMainObjectJsonString = '{"MainObjectId":1,"MainObjectDesc":"MainObject1"}';

type
  {$M+}
  TSubObject = class
  private
    FSubObjectId: Integer;
    FSubObjectDesc: string;
  public
    property SubObjectId: Integer read FSubObjectId write FSubObjectId;
    property SubObjectDesc: string read FSubObjectDesc write FSubObjectDesc;
  end;

  TMainObject = class
  private
    FMainObjectId: Integer;
    FMainObjectDesc: string;
    FSubObject: TSubObject;
  public
    destructor Destroy; override;
    property MainObjectId: Integer read FMainObjectId write FMainObjectId;
    property MainObjectDesc: string read FMainObjectDesc write FMainObjectDesc;
    property SubObject: TSubObject read FSubObject write FSubObject;
  end;

  TMainObjectClass = class of TMainObject;
  {$M-}

  TJsonObjectConverterTestView = class(TForm)
    ConvertButton: TButton;
    ResultRichEdit: TRichEdit;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ConvertButtonClick(Sender: TObject);
  private
    FMainObjectListJsonString: string;
    FMainObjectList: IList<TMainObject>;
    function GenerateMainObjectListJsonString(ACount: Integer): string;
    function GenerateSubObjectJsonString(AIdAsString: string): string;
    procedure DisplayObjectProperties;
  end;

var
  JsonObjectConverterTestView: TJsonObjectConverterTestView;

implementation

{$R *.dfm}

uses
  System.StrUtils
  , System.Diagnostics
  ;

procedure TJsonObjectConverterTestView.FormShow(Sender: TObject);
begin
  FMainObjectListJsonString := GenerateMainObjectListJsonString(120);
  ResultRichEdit.Lines.Text := FMainObjectListJsonString;
end;

procedure TJsonObjectConverterTestView.FormDestroy(Sender: TObject);
begin
  //FMainObjectList := nil;
end;

function TJsonObjectConverterTestView.GenerateMainObjectListJsonString(ACount: Integer): string;
var
  LCounter: Integer;
  LCounterString: string;
  LMainObjectJsonString: string;
begin
  Result := '[';
  for LCounter := 1 to ACount do
  begin
    LCounterString := IntToStr(LCounter);
    LMainObjectJsonString := IfThen(LCounter > 1, ',')
      + '{'
      + '"MainObjectId":' + LCounterString
      + ',"MainObjectDesc":"MainObject' + LCounterString + '"'
      + ',"SubObject":' + GenerateSubObjectJsonString(LCounterString)
      + '}';
    Result := Result + LMainObjectJsonString;
  end;
  Result := Result + ']';
end;

function TJsonObjectConverterTestView.GenerateSubObjectJsonString(AIdAsString: string): string;
begin
  Result :=
    '{'
    + '"SubObjectId":' + AIdAsString
    + ',"SubObjectDesc":"SubObject' + AIdAsString + '"'
    + '}';
end;

procedure TJsonObjectConverterTestView.ConvertButtonClick(Sender: TObject);
var
  LStopWatch: TStopWatch;
  LJsonValue: TJSONValue;
  LJsonArray: TJSONArray;
  LJsonArrayElement: TJSONValue;
  LMainObject: TMainObject;
  LSubObjectJsonString: string;
  LSubObjectJsonValue: TSubObject;
begin
  FMainObjectList := nil;

  LStopWatch := TStopWatch.StartNew;

  FMainObjectList := TCollections.CreateObjectList<TMainObject>;
  LJsonValue := TJSONObject.ParseJSONValue(FMainObjectListJsonString);
  LJsonArray := LJsonValue as TJSONArray;
  for LJsonArrayElement in LJsonArray do
  begin
    LMainObject := TJson.JsonToObject<TMainObject>(LJsonArrayElement.ToJSON);
    FMainObjectList.Add(LMainObject);
  end;
  LJsonValue.Free;

  DisplayObjectProperties;
  ResultRichEdit.Lines.Insert(0, 'Completed in ' + IntToStr(LStopWatch.Elapsed.Seconds) + 's');
end;

procedure TJsonObjectConverterTestView.DisplayObjectProperties;
var
  LMainObject: TMainObject;
begin
  ResultRichEdit.Clear;

  for LMainObject in FMainObjectList do
  begin
    ResultRichEdit.Lines.Add('"MainObjectId":' + IntToStr(LMainObject.MainObjectId));
    ResultRichEdit.Lines.Add('"MainObjectDesc":"' + LMainObject.MainObjectDesc + '"');
    ResultRichEdit.Lines.Add('    "SubObjectId":' + IntToStr(LMainObject.SubObject.SubObjectId));
    ResultRichEdit.Lines.Add('    "SubObjectDesc":"' + LMainObject.SubObject.SubObjectDesc+ '"');
  end;
end;

{ TMainObject }

destructor TMainObject.Destroy;
begin
  FSubObject.Free;
  inherited Destroy;
end;

end.
