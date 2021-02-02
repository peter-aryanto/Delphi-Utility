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
  Spring.Data.ObjectDataSet;

type
  {$M+}
  TSimpleObject = class
  private
    FId: Integer;
    FDesc: string;
  published // These properties need to be published to support the usage of TObjectDataSet.
    property Id: Integer read FId write FId;
    property Desc: string read FDesc write FDesc;
  end;
  {$M-}

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
    FSourceList: IList<TSimpleObject>;
    FObjectListDataSet: TObjectDataSet;
    function CreateSourceClientDataSet: TClientDataSet;
    function CreateSourceList: IList<TSimpleObject>;
    function CreateObjectListToDataSet(AList: IList<TSimpleObject>): TObjectDataSet;
  end;

var
  MultiColumnComboBoxTestView: TMultiColumnComboBoxTestView;

implementation

{$R *.dfm}

uses
  System.Types,
  MIDASLib;

procedure TMultiColumnComboBoxTestView.FormShow(Sender: TObject);
begin
  FSourceClientDataSet := CreateSourceClientDataSet; // Not used, replaced by FSourceList.
  FSourceList := CreateSourceList;
  FObjectListDataSet := CreateObjectListToDataSet(FSourceList as IList<TSimpleObject>);

  ////DataSource1.DataSet := FSourceClientDataSet;
  DataSource1.DataSet := FObjectListDataSet;

  ////cxLookupComboBox1.Properties.ListFieldNames := 'Id;Desc';
  cxLookupComboBox1.Properties.ListSource := DataSource1;
end;

function TMultiColumnComboBoxTestView.CreateSourceClientDataSet: TClientDataSet;
var
  LClientDataSet: TClientDataSet;
//  LFieldDef: TFieldDef;
begin
  LClientDataSet := TClientDataSet.Create(nil);
  LClientDataSet.FieldDefs.Add('Id', ftInteger);
  LClientDataSet.FieldDefs.Add('Desc', ftString, 100);
//  LFieldDef := LClientDataSet.FieldDefs.AddFieldDef;
//  LFieldDef.DataType := ftInteger;
//  LFieldDef.Desc := 'Id';
//  LFieldDef := LClientDataSet.FieldDefs.AddFieldDef;
//  LFieldDef.DataType := ftString;
//  LFieldDef.Size := 100;
//  LFieldDef.Desc := 'Desc';
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

function TMultiColumnComboBoxTestView.CreateSourceList: IList<TSimpleObject>;
var
  LList: IList<TSimpleObject>;
  LSimpleObject: TSimpleObject;
begin
  LList := Spring.Collections.TCollections.CreateList<TSimpleObject>(True);
  LSimpleObject := TSimpleObject.Create;
  LSimpleObject.Id := 1;
  LSimpleObject.Desc := 'One';
  LList.Add(LSimpleObject);
  LSimpleObject := TSimpleObject.Create;
  LSimpleObject.Id := 2;
  LSimpleObject.Desc := 'Two';
  LList.Add(LSimpleObject);

  Result := LList;
end;

function TMultiColumnComboBoxTestView.CreateObjectListToDataSet(
  AList: IList<TSimpleObject>
): TObjectDataSet;
var
  LObjectListDataSet: TObjectDataSet;
begin
  LObjectListDataSet := TObjectDataSet.Create(nil);
  LObjectListDataSet.DataList := AList as IObjectList;
  LObjectListDataSet.FieldDefs.Add('Id', ftInteger);
  LObjectListDataSet.FieldDefs.Add('Desc', ftString, 100);
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
    ////DrawText(DC, IntToStr(Index + 1), Length(IntToStr(Index + 1)), DrawRect, 0);
    DrawText(DC, IntToStr(Index + 1), Length(IntToStr(Index + 1)), DrawRect, 0);
  end;
  //if ColCount > 1 then
  begin
    DrawRect:= Rect;
    OffsetRect(DrawRect,1,0);
    DrawRect.Left:= DrawRect.Left + DrawRect.Width div 2;
    ////DrawText(DC, ComboBox1.Items[Index], Length(ComboBox1.Items[Index]), DrawRect, 0);
    DrawText(DC, ComboBox1.Items[Index], Length(ComboBox1.Items[Index]), DrawRect, 0);
  end;
end;

procedure TMultiColumnComboBoxTestView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FObjectListDataSet.Free;
  FSourceClientDataSet.Free;
end;

end.
