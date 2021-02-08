unit MultiColumnComboBoxTest.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary,
  dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox,
  Vcl.DBCtrls, Vcl.StdCtrls,
  Data.DB,
  Datasnap.DBClient,
  Spring.Collections,
  Spring.Data.ObjectDataSet,
  cxCustomData,
  MultiColumnSearchLookupComboBox;

type
  {$M+}
  TSimpleObject = class
  private
    FSubId: Integer;
    FSubDesc: string;
  published // These properties need to be published to support the usage of TObjectDataSet.
    property SubId: Integer read FSubId write FSubId;
    property SubDesc: string read FSubDesc write FSubDesc;
  end;

  TParentObject = class
  private
    FId: string;
    FDesc: string;
    FIdDesc: string;
    FSubObject: TSimpleObject;
  public
    destructor Destroy; override;
  published // These properties need to be published to support the usage of TObjectDataSet.
    property Id: string read FId write FId;
    property Desc: string read FDesc write FDesc;
    property IdDesc: string read FIdDesc write FIdDesc;
    property SubObject: TSimpleObject read FSubObject write FSubObject;
  end;
  {$M-}

  TcxLookupComboBox = class(MultiColumnSearchLookupComboBox.TMultiColumnSearchLookupComboBox)
  end;

  TMultiColumnComboBoxTestView = class(TForm)
    cxLookupComboBox1: TcxLookupComboBox;
    ComboBox1: TComboBox;
    DataSource1: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBox1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
  private
    FSourceClientDataSet: TClientDataSet;
    FSourceList: IList<TParentObject>;
    FObjectListDataSet: TObjectDataSet;
    function CreateSourceClientDataSet: TClientDataSet;
    function CreateSourceList: IList<TParentObject>;
    function CreateObjectListToDataSet(AList: IList<TParentObject>): TObjectDataSet;
  end;

var
  MultiColumnComboBoxTestView: TMultiColumnComboBoxTestView;

implementation

{$R *.dfm}

uses
  System.Types,
  MIDASLib;

procedure TMultiColumnComboBoxTestView.FormShow(Sender: TObject);
var
  LMultiFieldSearchProperties: TMultiFieldSearchProperties;
begin
  FSourceClientDataSet := CreateSourceClientDataSet; // Not used, replaced by FSourceList.
  FSourceList := CreateSourceList;
  FObjectListDataSet := CreateObjectListToDataSet(FSourceList as IList<TParentObject>);

  ////DataSource1.DataSet := FSourceClientDataSet;
  DataSource1.DataSet := FObjectListDataSet;

  ////cxLookupComboBox1.Properties.ListFieldNames := 'Id;Desc';
  cxLookupComboBox1.Properties.ListSource := DataSource1;
  LMultiFieldSearchProperties := TMultiColumnSearchLookupComboBoxProperties(
    cxLookupComboBox1.Properties
  ).MultiFieldSearchProperties;
  LMultiFieldSearchProperties.IsActive := True;
  LMultiFieldSearchProperties.FieldIndexList.Add(0);
  LMultiFieldSearchProperties.FieldIndexList.Add(1);
end;

function TMultiColumnComboBoxTestView.CreateSourceClientDataSet: TClientDataSet;
var
  LClientDataSet: TClientDataSet;
begin
  LClientDataSet := TClientDataSet.Create(nil);
  LClientDataSet.FieldDefs.Add('Id', ftInteger);
  LClientDataSet.FieldDefs.Add('Desc', ftString, 100);
  LClientDataSet.CreateDataSet;
  LClientDataSet.Insert;
  LClientDataSet.FieldByName('Id').AsInteger := 1;
  LClientDataSet.FieldByName('Desc').AsString := 'One';
  LClientDataSet.Post;
  LClientDataSet.Insert;
  LClientDataSet.FieldByName('Id').AsInteger := 2;
  LClientDataSet.FieldByName('Desc').AsString := 'Two';
  LClientDataSet.Post;

  Result := LClientDataSet;
end;

function TMultiColumnComboBoxTestView.CreateSourceList: IList<TParentObject>;
var
  LList: IList<TParentObject>;
  LSimpleObject: TSimpleObject;
  LParentObject: TParentObject;
begin
  LList := Spring.Collections.TCollections.CreateList<TParentObject>(True);
  LSimpleObject := TSimpleObject.Create;
  LSimpleObject.SubId := 11;
  LSimpleObject.SubDesc := 'Eleven';
  LParentObject := TParentObject.Create;
  LParentObject.Id := '10001';
  LParentObject.Desc := 'One';
  LParentObject.IdDesc := LParentObject.Id + LParentObject.Desc;
  LParentObject.SubObject := LSimpleObject;
  LList.Add(LParentObject);
  LSimpleObject := TSimpleObject.Create;
  LSimpleObject.SubId := 22;
  LSimpleObject.SubDesc := 'Twenty Two';
  LParentObject := TParentObject.Create;
  LParentObject.Id := '80002';
  LParentObject.Desc := 'Two';
  LParentObject.IdDesc := LParentObject.Id + LParentObject.Desc;
  LParentObject.SubObject := LSimpleObject;
  LList.Add(LParentObject);
  LParentObject := TParentObject.Create;
  LParentObject.Id := '10003';
  LParentObject.Desc := '8Three';
  LParentObject.IdDesc := LParentObject.Id + LParentObject.Desc;
  LList.Add(LParentObject);

  Result := LList;
end;

function TMultiColumnComboBoxTestView.CreateObjectListToDataSet(
  AList: IList<TParentObject>
): TObjectDataSet;
var
  LObjectListDataSet: TObjectDataSet;
begin
  LObjectListDataSet := TObjectDataSet.Create(nil);
  LObjectListDataSet.DataList := AList as IObjectList;
  LObjectListDataSet.FieldDefs.Add('Id', ftString, 100);
  LObjectListDataSet.FieldDefs.Add('Desc', ftString, 100);
  LObjectListDataSet.FieldDefs.Add('IdDesc', ftString, 200);
  LObjectListDataSet.FieldDefs.Add('SubId', ftInteger);
  LObjectListDataSet.FieldDefs.Add('SubDesc', ftString, 100);
  LObjectListDataSet.Active := True;

  Result := LObjectListDataSet;
end;

// This has not been tidied up; for quick testing only.
procedure TMultiColumnComboBoxTestView.ComboBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  DrawRect: TRect;
  DC: HDC;
begin
  DC := ComboBox1.Canvas.Handle;
  //if ColCount > 0 then
  begin
    DrawRect:= Rect;
    OffsetRect(DrawRect,1,0);
    DrawRect.Right:= DrawRect.Right - DrawRect.Width div 2;
    DrawText(DC, IntToStr(Index + 1), Length(IntToStr(Index + 1)), DrawRect, 0);
  end;
  //if ColCount > 1 then
  begin
    DrawRect:= Rect;
    OffsetRect(DrawRect,1,0);
    DrawRect.Left:= DrawRect.Left + DrawRect.Width div 2;
    DrawText(DC, ComboBox1.Items[Index], Length(ComboBox1.Items[Index]), DrawRect, 0);
  end;
end;

procedure TMultiColumnComboBoxTestView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FObjectListDataSet.Free;
  FSourceClientDataSet.Free;
end;

{ TParentObject }

destructor TParentObject.Destroy;
begin
  FSubObject.Free;
  inherited Destroy;
end;

end.
