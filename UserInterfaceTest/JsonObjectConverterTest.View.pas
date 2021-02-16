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
    FSubObjectList: IList<TSubObject>;
  public
    destructor Destroy; override;
    property MainObjectId: Integer read FMainObjectId write FMainObjectId;
    property MainObjectDesc: string read FMainObjectDesc write FMainObjectDesc;
    property SubObject: TSubObject read FSubObject write FSubObject;
    property SubObjectList: IList<TSubObject> read FSubObjectList write FSubObjectList;
  end;

  IJsonUtils<T> = interface
    ['{D8E422DC-7034-4AFF-B3DD-4B84A39FBDFF}']
    function JsonArrayToList(
      AJsonArray: TJSONArray
    ): IList<T>;
  end;

  TJsonUtils<T: class, constructor> = class(TInterfacedObject, IJsonUtils<T>)
  private
    function JsonArrayToList(
      AJsonArray: TJSONArray
    ): IList<T>;
  end;
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
    function GenerateSubObjectListJsonString(AIdAsString: string): string;
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
  for LCounter := 1 to ACount do
  begin
    LCounterString := IntToStr(LCounter);
    LMainObjectJsonString := IfThen(LCounter > 1, ',')
      + '{'
      + '"MainObjectId":' + LCounterString
      + ',"MainObjectDesc":"MainObject' + LCounterString + '"'
      + ',"SubObject":' + GenerateSubObjectJsonString(LCounterString)
      + ',"SubObjectList":' + GenerateSubObjectListJsonString(LCounterString)
      + '}';
    Result := Result + LMainObjectJsonString;
  end;
  Result := '[' + Result + ']';
end;

function TJsonObjectConverterTestView.GenerateSubObjectJsonString(AIdAsString: string): string;
begin
  Result :=
    '{'
    + '"SubObjectId":' + AIdAsString
    + ',"SubObjectDesc":"SubObject' + AIdAsString + '"'
    + '}';
end;

function TJsonObjectConverterTestView.GenerateSubObjectListJsonString(AIdAsString: string): string;
begin
  Result :=
    '{'
    + '"SubObjectId":' + AIdAsString
    + ',"SubObjectDesc":"SubObject' + AIdAsString + 'A"'
    + '}';

  Result := Result +
    ',{'
    + '"SubObjectId":' + AIdAsString
    + ',"SubObjectDesc":"SubObject' + AIdAsString + 'B"'
    + '}';

  Result := '[' + Result + ']'
end;

procedure TJsonObjectConverterTestView.ConvertButtonClick(Sender: TObject);
var
  LStopWatch: TStopWatch;
  LJsonValue: TJSONValue;
  LJsonArray: TJSONArray;
  LJsonArrayElement: TJSONValue;
  LMainObject: TMainObject;
//  LSubObjectJson: TJSONObject;
  LSubObjectJsonArray: TJSONArray;
  LSubObjectJsonUtils: IJsonUtils<TSubObject>;
begin
  FMainObjectList := nil;

  LStopWatch := TStopWatch.StartNew;

  FMainObjectList := TCollections.CreateObjectList<TMainObject>;
  LJsonValue := TJSONObject.ParseJSONValue(FMainObjectListJsonString);
  LJsonArray := LJsonValue as TJSONArray;
  for LJsonArrayElement in LJsonArray do
  begin
//    LMainObject := TJson.JsonToObject<TMainObject>(LJsonArrayElement.ToJSON);
    LMainObject := TMainObject.Create;
    LMainObject.MainObjectId := LJsonArrayElement.GetValue('MainObjectId', 0);
    LMainObject.MainObjectDesc := LJsonArrayElement.GetValue('MainObjectDesc', '');

//    LSubObjectJson := LJsonArrayElement.GetValue<TJSONObject>('SubObject', nil);
    LMainObject.SubObject := TSubObject.Create;
    LMainObject.SubObject.SubObjectId := LJsonArrayElement.GetValue('SubObject.SubObjectId', 0);
    LMainObject.SubObject.SubObjectDesc := LJsonArrayElement.GetValue('SubObject.SubObjectDesc', '');

    LSubObjectJsonArray := LJsonArrayElement.GetValue<TJSONArray>('SubObjectList', nil);
    LSubObjectJsonUtils := TJsonUtils<TSubObject>.Create;
    LMainObject.FSubObjectList := LSubObjectJsonUtils.JsonArrayToList(LSubObjectJsonArray);
    FMainObjectList.Add(LMainObject);
  end;
  LJsonValue.Free;

  DisplayObjectProperties;
  ResultRichEdit.Lines.Insert(0, 'Completed in ' + IntToStr(LStopWatch.Elapsed.Seconds) + 's');
end;

procedure TJsonObjectConverterTestView.DisplayObjectProperties;
var
  LMainObject: TMainObject;
  LSubObject: TSubObject;
begin
  ResultRichEdit.Clear;

  for LMainObject in FMainObjectList do
  begin
    ResultRichEdit.Lines.Add('"MainObjectId":' + IntToStr(LMainObject.MainObjectId));
    ResultRichEdit.Lines.Add('"MainObjectDesc":"' + LMainObject.MainObjectDesc + '"');
    ResultRichEdit.Lines.Add('    "SubObjectId":' + IntToStr(LMainObject.SubObject.SubObjectId));
    ResultRichEdit.Lines.Add('    "SubObjectDesc":"' + LMainObject.SubObject.SubObjectDesc+ '"');
    ResultRichEdit.Lines.Add('    "SubObjectList":');
    for LSubObject in LMainObject.SubObjectList do
    begin
      ResultRichEdit.Lines.Add('        "SubObjectId":' + IntToStr(LSubObject.SubObjectId));
      ResultRichEdit.Lines.Add('        "SubObjectDesc":"' + LSubObject.SubObjectDesc+ '"');
    end;
  end;
end;

{ TMainObject }

destructor TMainObject.Destroy;
begin
  FSubObject.Free;
  inherited Destroy;
end;

{ TJsonUtils<T> }

function TJsonUtils<T>.JsonArrayToList(
  AJsonArray: TJSONArray
): IList<T>;
var
  LJsonArrayElement: TJSONValue;
  LListElementObject: T;
begin
  Result := TCollections.CreateObjectList<T>;
  for LJsonArrayElement in AJsonArray do
  begin
    LListElementObject := TJson.JsonToObject<T>(LJsonArrayElement.ToJSON);
    Result.Add(LListElementObject);
  end;
end;

end.
