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
  TMainObject = class
  private
    FMainObjectId: Integer;
    FMainObjectDesc: string;
  public
    property MainObjectId: Integer read FMainObjectId write FMainObjectId;
    property MainObjectDesc: string read FMainObjectDesc write FMainObjectDesc;
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
    procedure DisplayObjectProperties;
  end;

var
  JsonObjectConverterTestView: TJsonObjectConverterTestView;

implementation

{$R *.dfm}

uses
  System.StrUtils;

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
      + '{"MainObjectId":' + LCounterString
      + ',"MainObjectDesc":"MainObject' + LCounterString + '"}';
    Result := Result + LMainObjectJsonString;
  end;
  Result := Result + ']';
end;

procedure TJsonObjectConverterTestView.ConvertButtonClick(Sender: TObject);
var
  LMainObjectListJsonString: string;
  LJsonValue: TJSONValue;
  LJsonArray: TJSONArray;
  LJsonArrayElement: TJSONValue;
  LMainObject: TMainObject;
begin
  FMainObjectList := nil;

  LMainObjectListJsonString := FMainObjectListJsonString;

  FMainObjectList := TCollections.CreateObjectList<TMainObject>;
  LJsonValue := TJSONObject.ParseJSONValue(LMainObjectListJsonString);
  LJsonArray := LJsonValue as TJSONArray;
  for LJsonArrayElement in LJsonArray do
  begin
    LMainObject := TMainObject.Create;
    LMainObject.MainObjectId := LJsonArrayElement.GetValue('MainObjectId', 0);
    LMainObject.MainObjectDesc := LJsonArrayElement.GetValue('MainObjectDesc', '');
    FMainObjectList.Add(LMainObject);
  end;
  DisplayObjectProperties;

  LJsonValue.Free;
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
  end;
end;

end.
