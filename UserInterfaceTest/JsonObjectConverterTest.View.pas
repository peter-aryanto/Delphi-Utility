unit JsonObjectConverterTest.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls
  , REST.Json, System.JSON
//  , Spring.Collections, Spring.Collections.Lists;
  , System.Generics.Collections;

const
  CMainObjectJsonString = '{"MainObjectId":1,"MainObjectDesc":"MainObject1"}';
  CMainObjectListJsonString = '['
    + '{"MainObjectId":1,"MainObjectDesc":"MainObject1"}'
    + ',{"MainObjectId":2,"MainObjectDesc":"MainObject2"}'
    + ']';

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
    ResultMemo: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ConvertButtonClick(Sender: TObject);
    procedure DisplayObjectProperties;
  private
    FMainObject: TMainObject;
    FMainObjectList: TList<TMainObject>;
    procedure FreeListElement(AList: TList<TMainObject>);//; AClassOfT: TClass);
  public
    { Public declarations }
  end;

var
  JsonObjectConverterTestView: TJsonObjectConverterTestView;

implementation

{$R *.dfm}

procedure TJsonObjectConverterTestView.FormShow(Sender: TObject);
begin
  ResultMemo.Text := CMainObjectJsonString;
end;

procedure TJsonObjectConverterTestView.FormDestroy(Sender: TObject);
begin
  FMainObject.Free;
  FreeListElement(FMainObjectList);//, TMainObjectClass);
  FMainObjectList.Free;
end;

procedure TJsonObjectConverterTestView.FreeListElement(AList: TList<TMainObject>);//; AClassOfT: TClass);
var
  LElement: TMainObject;
begin
  if not Assigned(AList) then
  begin
    Exit;
  end;

  for LElement in AList do
  begin

//    if LElement is TObject then
    begin
//      (LElement as AClassOfT).Free;
//      (LElement as TObject).Free;
      LElement.Free;
    end;

  end;
end;

procedure TJsonObjectConverterTestView.ConvertButtonClick(Sender: TObject);
var
  LJsonValue: TJSONValue;
  LJsonArray: TJSONArray;
  LJsonArrayElement: TJSONValue;
  LMainObject: TMainObject;
begin
  FMainObject.Free;
  FMainObject := nil;
//  if Assigned(FMainObjectList) then
//  begin
//    for LMainObject in FMainObjectList do
//    begin
//      LMainObject.Free;
//    end;
//  end;
  FreeListElement(FMainObjectList);//, TMainObjectClass);
  FMainObjectList.Free;
  FMainObjectList := nil;

//  FMainObject := TJson.JsonToObject<TMainObject>(CMainObjectJsonString);
//  FMainObjectList := TJson.JsonToObject<TList<TMainObject>>(CMainObjectListJsonString);
  FMainObjectList := TList<TMainObject>.Create;
  LJsonValue := TJSONObject.ParseJSONValue(CMainObjectListJsonString);
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
  ResultMemo.Clear;

//  ResultMemo.Lines.Add('"MainObjectId":' + IntToStr(FMainObject.MainObjectId));
//  ResultMemo.Lines.Add('"MainObjectDesc":"' + FMainObject.MainObjectDesc + '"');
  for LMainObject in FMainObjectList do
  begin
    ResultMemo.Lines.Add('"MainObjectId":' + IntToStr(LMainObject.MainObjectId));
    ResultMemo.Lines.Add('"MainObjectDesc":"' + LMainObject.MainObjectDesc + '"');
  end;
end;

end.
