unit MultiColumnSearchLookupComboBox;

interface

uses
  cxDBLookupComboBox, cxEdit, cxLookupEdit, cxDBLookupEdit, dxCoreClasses, cxLookupDBGrid,
  cxDBData, cxCustomData, cxDataUtils, cxDropDownEdit,
  System.Generics.Collections,
  System.Classes;

type
  {
    TMultiColumnSearchLookupComboBox extends TcxLookupComboBox multi-column dropdown list feature,
    so that typing on the edit field can trigger a search not just on the field specified in
    Properties.ListFieldIndex, but across multiple columns.

    Here are the required steps:

    - Declare an alias of TcxLookupComboBox inheriting TMultiColumnSearchLookupComboBox before the
      definition of the form as below.
      <start of code example>
      TcxLookupComboBox = class(MultiColumnSearchLookupComboBox.TMultiColumnSearchLookupComboBox)
      end;

      TTheFormThatUsesTMultiColumnSearchLookupComboBox = class(TForm)
        ...
        cxLookupComboBox1: TcxLookupComboBox;
        ...
      end;
      <end of code example>

    - Set the multi field search properties as below.
      <start of code example>
        var
          ...
          LMultiFieldSearchProperties: TMultiFieldSearchProperties;
          ...
        begin
          ...
          LMultiFieldSearchProperties := TMultiColumnSearchLookupComboBoxProperties(
            cxLookupComboBox1.Properties
          ).MultiFieldSearchProperties;
          LMultiFieldSearchProperties.IsActive := True;
          LMultiFieldSearchProperties.FieldIndexList.Add(0);
          LMultiFieldSearchProperties.FieldIndexList.Add(1);
      <end of code example>

    - At design time, set the properties of the TcxLookupComboBox component as below.
      Properties.DrowDownListStyle: lsEditList
      Properties.HideSelection: False
      Properties.KeyFieldNames: <Field/Column Name #1>;<Field/Column Name #2>;...
      Properties.ListColumns: <populate the fields to display on dropdown list>
      [Optional] Properties.ListOptions.ColumnSorting: False
      [Optional] Properties.ListOptions.ShowHeader: False
      [Optional] Properties.ListOptions.SyncMode: True
      Propoerties.ListSource: <the TDataSource to use; alternatively, this can also be set in code>
  }
  TMultiColumnSearchLookupComboBox = class(TcxLookupComboBox)
  public
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
  end;

  TMultiFieldSearchProperties = class
  private
    FIsActive: Boolean;
    FFieldIndexList: TList<Integer>;
  public
    constructor Create;
    destructor Destroy; override;
    property IsActive: Boolean read FIsActive write FIsActive;
    property FieldIndexList: TList<Integer> read FFieldIndexList;
  end;

  TMultiColumnSearchLookupComboBoxProperties = class(TcxLookupComboBoxProperties)
  private
    FMultiFieldSearchProperties: TMultiFieldSearchProperties;
  protected
    function GetLookupGridClass: TcxCustomLookupDBGridClass; override;
    function GetDBLookupGridDataController: TcxDBDataController; override;
    class function GetLookupDataClass: TcxInterfacedPersistentClass; override;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    property MultiFieldSearchProperties: TMultiFieldSearchProperties
      read FMultiFieldSearchProperties;
  end;

  TMultiColumnSearchLookupComboBoxGrid = class(TcxCustomLookupDBGrid)
  protected
    function GetDataControllerClass: TcxCustomDataControllerClass; override;
  end;

  TMultiColumnSearchLookupComboBoxDataController = class(TcxDBDataController)
  private
    FMultiFieldSearchProperties: TMultiFieldSearchProperties;
    FCurrentSearchedFieldIndex: Integer;
  protected
    function DoIncrementalFilterRecord(ARecordIndex: Integer): Boolean; override;
  public
    property MultiFieldSearchProperties: TMultiFieldSearchProperties
      read FMultiFieldSearchProperties
      write FMultiFieldSearchProperties;
    property CurrentSearchedFieldIndex: Integer read FCurrentSearchedFieldIndex;
  end;

  TMultiColumnSearchLookupComboBoxLookupData = class(TcxCustomDBLookupEditLookupData)
  private
    FIsVisible: Boolean;
  protected
    procedure CloseUp; override;
    procedure DropDown; override;
    function Locate(var AText, ATail: string; ANext: Boolean): Boolean; override;
  end;

implementation

uses
  System.SysUtils;

{ TMultiColumnSearchLookupComboBox }

class function TMultiColumnSearchLookupComboBox.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TMultiColumnSearchLookupComboBoxProperties;
end;

{ TMultiFieldSearchProperties }

constructor TMultiFieldSearchProperties.Create;
begin
  inherited Create;
  FFieldIndexList := TList<Integer>.Create;
end;

destructor TMultiFieldSearchProperties.Destroy;
begin
  FFieldIndexList.Free;
  inherited Destroy;
end;

{ TMultiColumnSearchLookupComboBoxProperties }

constructor TMultiColumnSearchLookupComboBoxProperties.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FMultiFieldSearchProperties := TMultiFieldSearchProperties.Create;
end;

destructor TMultiColumnSearchLookupComboBoxProperties.Destroy;
begin
  FMultiFieldSearchProperties.Free;
  inherited Destroy;
end;

function TMultiColumnSearchLookupComboBoxProperties.GetLookupGridClass: TcxCustomLookupDBGridClass;
begin
  Result := TMultiColumnSearchLookupComboBoxGrid;
end;

function TMultiColumnSearchLookupComboBoxProperties.GetDBLookupGridDataController: TcxDBDataController;
begin
  Result := inherited GetDBLookupGridDataController;

  if Result <> nil then
  begin
    TMultiColumnSearchLookupComboBoxDataController(Result).MultiFieldSearchProperties :=
      MultiFieldSearchProperties;
  end;
end;

class function TMultiColumnSearchLookupComboBoxProperties.GetLookupDataClass: TcxInterfacedPersistentClass;
begin
  Result := TMultiColumnSearchLookupComboBoxLookupData;
end;

{ TMultiColumnSearchLookupComboBoxGrid }

function TMultiColumnSearchLookupComboBoxGrid.GetDataControllerClass: TcxCustomDataControllerClass;
begin
  Result := TMultiColumnSearchLookupComboBoxDataController;
end;

{ TMultiColumnSearchLookupComboBoxDataController }

function TMultiColumnSearchLookupComboBoxDataController.DoIncrementalFilterRecord(ARecordIndex: Integer): Boolean;
const
  CUnknownColumnIndex = -1;
var
  LFieldIndex: Integer;
  LSearchField: TcxCustomDataField;
  LSearchText: string;
begin
  if not MultiFieldSearchProperties.IsActive then
  begin
    Result := inherited DoIncrementalFilterRecord(ARecordIndex);
    Exit;
  end;

  Result := False;

  if ARecordIndex = 0 then
  begin
    FCurrentSearchedFieldIndex := CUnknownColumnIndex;
  end;

  for LFieldIndex in MultiFieldSearchProperties.FFieldIndexList do
  begin
    LSearchField := Fields[LFieldIndex];
    LSearchText := GetInternalDisplayText(ARecordIndex, LSearchField);
    Result := DataCompareText(LSearchText, GetIncrementalFilterText, True, False);

    if Result then
    begin

      if FCurrentSearchedFieldIndex = CUnknownColumnIndex then
      begin
        FCurrentSearchedFieldIndex := LFieldIndex;
      end;

      Exit;
    end;

  end;
end;

{ TMultiColumnSearchLookupComboBoxLookupData }

procedure TMultiColumnSearchLookupComboBoxLookupData.CloseUp;
begin
  inherited CloseUp;
  FIsVisible := False;
end;

procedure TMultiColumnSearchLookupComboBoxLookupData.DropDown;
begin
  inherited DropDown;
  FIsVisible := True;
end;

function TMultiColumnSearchLookupComboBoxLookupData.Locate(var AText, ATail: string; ANext: Boolean): Boolean;

  function SetGridFilter(AItemIndex: Integer; const AText: string): Integer;
  var
    APrevIncrementalFilterText: string;
  begin
    if AText = '' then
    begin
      ResetIncrementalFilter;
      Result := TMultiColumnSearchLookupComboBoxProperties(Properties).FindByText(AItemIndex, AText, True);
    end
    else
    begin
      APrevIncrementalFilterText := DataController.GetIncrementalFilterText;
      Result := DataController.SetIncrementalFilter(AItemIndex, AText, IsLikeTypeFiltering);
      if DataController.FilteredRecordCount = 0 then
      begin
        if Properties.DropDownListStyle <> lsEditList then
          DataController.SetIncrementalFilter(AItemIndex, APrevIncrementalFilterText, IsLikeTypeFiltering);
        Result := -1;
      end;
    end;
    UpdateDropDownCount;
  end;

var
  AItemIndex, ARecordIndex: Integer;
  S: string;
begin
  Result := False;
  DisableChanging;
  try
    AItemIndex := TMultiColumnSearchLookupComboBoxProperties(Properties).GetListIndex;

    if (AItemIndex <> -1) and (DataController <> nil) then
    begin

      if FIsVisible and TMultiColumnSearchLookupComboBoxProperties(Properties).GetIncrementalFiltering then
        ARecordIndex := SetGridFilter(AItemIndex, AText)
      else
        ARecordIndex := TMultiColumnSearchLookupComboBoxProperties(Properties).FindByText(AItemIndex, AText, True);

      if ARecordIndex <> -1 then
      begin

        if TMultiColumnSearchLookupComboBoxProperties(Properties).MultiFieldSearchProperties.IsActive
          and (TMultiColumnSearchLookupComboBoxDataController(DataController).CurrentSearchedFieldIndex <> -1)
        then
        begin
          AItemIndex :=
            TMultiColumnSearchLookupComboBoxDataController(DataController).CurrentSearchedFieldIndex;
        end;

        DataController.ChangeFocusedRecordIndex(ARecordIndex);
        DoSetCurrentKey(ARecordIndex);
        Result := True;
        S := DataController.DisplayTexts[ARecordIndex, AItemIndex];

        if IsLikeTypeFiltering then
          ATail := ''
        else
        begin
          AText := Copy(S, 1, Length(AText));
          ATail := Copy(S, Length(AText) + 1, Length(S));
        end;

        DoSetKeySelection(True);
      end
      else
        DoSetKeySelection(False);

    end;
  finally
    EnableChanging;
  end;
end;

end.
