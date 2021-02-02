{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressEditors                                           }
{                                                                    }
{           Copyright (c) 1998-2018 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSEDITORS AND ALL                }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY. }
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

unit cxInplaceContainer;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Classes, SysUtils, Windows, Messages, Variants, Types, dxCore,
  Forms, Controls, StdCtrls, Graphics,
  dxCoreClasses, cxVariants, cxClasses, cxControls, cxGraphics, cxStyles, cxContainer,
  cxCustomData, cxData, cxDataUtils, cxDataStorage, cxLookAndFeels, cxLookAndFeelPainters,
  cxGeometry, cxLibraryConsts, dxCustomHint, cxFindPanel,
  cxEdit, cxTextEdit, cxEditDataRegisteredRepositoryItems, cxNavigator, cxFilterControl;

const
   ecs_Content               = 0;
   ecs_Background            = 1;
   ecs_Inactive              = 2;
   ecs_Selection             = 3;
   ecs_Navigator             = 4;
   ecs_NavigatorInfoPanel    = 5;
   ecs_FindPanel             = 6;
   ecs_SearchResultHighlight = 7;

   ecs_EditContainerStylesMaxIndex = ecs_Content;
   ecs_EditingStylesMaxIndex = ecs_SearchResultHighlight;

// predefined hit codes
   echc_Empty          = 0;
   echc_IsMouseEvent   = 1;
   echc_HitAtFindPanel = 2;
   echc_MaxIndex       = echc_HitAtFindPanel;

// viewinfo states
   cvis_IsDirty      = 1;
   cvis_StyleInvalid = 2;

   cxSizingMarkWidth = 1;
   cxScrollWidthDragInterval = 50;

type
  TcxDragSizingDirection = (dsdHorz, dsdVert);

  TcxGetEditPropertiesEvent = procedure(Sender: TObject; AData: Pointer;
    var AEditProperties: TcxCustomEditProperties) of object;
  TcxOnGetContentStyleEvent = procedure(Sender: TObject; AData: Pointer;
    out AStyle: TcxStyle) of object;

  TcxInplaceEditContainerClass = class of TcxCustomInplaceEditContainer;
  TcxCustomInplaceEditContainer = class;
  TcxItemDataBindingClass = class of TcxCustomItemDataBinding;

  TcxCustomControlDragAndDropObjectClass = class of TcxCustomControlDragAndDropObject;

  TcxEditingController = class;
  TcxEditingControllerClass = class of TcxEditingController;

  TcxCustomEditStyleClass = class of TcxCustomEditStyle;

  TcxCustomControlControllerClass = class of TcxCustomControlController;
  TcxCustomControlController = class;
  TcxControlDataController = class;
  TcxCustomControlPainter = class;
  TcxEditingControl = class;
  TcxExtEditingControl = class;

  TcxHotTrackController = class;
  TcxHotTrackControllerClass = class of TcxHotTrackController;
  TcxCustomHitTestController = class;

  TcxEditItemShowEditButtons = (eisbDefault, eisbNever, eisbAlways);
  TcxEditingControlEditShowButtons = (ecsbAlways, ecsbFocused, ecsbNever);

  TcxCustomControlViewInfo = class;

  TcxCustomControlStyles = class;

  TcxCustomViewInfoItem = class;
  TcxCustomCellViewInfoClass = class of TcxCustomViewInfoItem;

  TcxEditCellViewInfo = class;
  TcxEditCellViewInfoClass = class of TcxEditCellViewInfo;

  TcxCustomNavigatorSiteViewInfo = class;
  TcxCustomNavigatorSiteViewInfoClass = class of TcxCustomNavigatorSiteViewInfo;

  TcxControlFindPanelViewInfo = class;
  TcxControlFindPanelViewInfoClass = class of TcxControlFindPanelViewInfo;
  TcxControlFindPanel = class;

  TcxHitCode = type Int64;

  { TcxControlFindPanel }

  TcxControlFindPanel = class(TcxCustomFindPanel)
  private
    FController: TcxCustomControlController;

    function GetEditingControl: TcxEditingControl;
  protected
    procedure ApplyText(const AText: string); override;
    procedure ClearText; override;
    procedure FocusChanged; override;
    procedure FocusControl; override;
    function FocusData: Boolean; override;
    procedure GetContentViewParams(var AParams: TcxViewParams); override;
    function GetEditLookAndFeel: TcxLookAndFeel; override;
    function GetOwner: TComponent; override;
    function GetParent: TWinControl; override;
    function GetText: string; override;
    function GetUseExtendedSyntax: Boolean; override;
    procedure GetViewParams(var AParams: TcxViewParams); override;
    procedure VisibilityChanged; override;
    procedure SetUseExtendedSyntax(AValue: Boolean); override;
  public
    constructor Create(AController: TcxCustomControlController); reintroduce; virtual;

    procedure Changed; override;

    property Controller: TcxCustomControlController read FController;
    property EditingControl: TcxEditingControl read GetEditingControl;
  end;
  TcxControlFindPanelClass = class of TcxControlFindPanel;

  { TcxControlFindPanelOptions }

  TcxControlOptionsFindPanel = class(TcxOwnedPersistent)
  private
    function GetApplyInputDelay: Integer;
    function GetClearFindFilterTextOnClose: Boolean;
    function GetDisplayMode: TcxFindPanelDisplayMode;
    function GetEditingControl: TcxEditingControl;
    function GetFocusContentOnApplyFilter: Boolean;
    function GetHighlightSearchResults: Boolean;
    function GetInfoText: string;
    function GetOptions: TcxFindPanelOptions;
    function GetMRUItems: TStrings;
    function GetMRUItemsListCount: Integer;
    function GetMRUItemsListDropDownCount: Integer;
    function GetPosition: TcxFindPanelPosition;
    function GetShowClearButton: Boolean;
    function GetShowCloseButton: Boolean;
    function GetShowFindButton: Boolean;
    function GetUseDelayedFind: Boolean;
    function GetUseExtendedSyntax: Boolean;
    function IsInfoTextStored: Boolean;
    procedure SetApplyInputDelay(AValue: Integer);
    procedure SetClearFindFilterTextOnClose(AValue: Boolean);
    procedure SetDisplayMode(AValue: TcxFindPanelDisplayMode);
    procedure SetFocusContentOnApplyFilter(AValue: Boolean);
    procedure SetHighlightSearchResults(AValue: Boolean);
    procedure SetInfoText(AValue: string);
    procedure SetOptions(AValue: TcxFindPanelOptions);
    procedure SetMRUItems(AValue: TStrings);
    procedure SetMRUItemsListCount(AValue: Integer);
    procedure SetMRUItemsListDropDownCount(AValue: Integer);
    procedure SetPosition(AValue: TcxFindPanelPosition);
    procedure SetShowClearButton(AValue: Boolean);
    procedure SetShowCloseButton(AValue: Boolean);
    procedure SetShowFindButton(AValue: Boolean);
    procedure SetUseExtendedSyntax(AValue: Boolean);
    procedure SetUseDelayedFind(AValue: Boolean);
  protected
    property Options: TcxFindPanelOptions read GetOptions write SetOptions;
  public
    procedure Assign(Source: TPersistent); override;

    property EditingControl: TcxEditingControl read GetEditingControl;
    property MRUItems: TStrings read GetMRUItems write SetMRUItems;
  published
    property ApplyInputDelay: Integer read GetApplyInputDelay write SetApplyInputDelay default 1000;
    property ClearFindFilterTextOnClose: Boolean read GetClearFindFilterTextOnClose write SetClearFindFilterTextOnClose default True;
    property DisplayMode: TcxFindPanelDisplayMode read GetDisplayMode write SetDisplayMode default fpdmNever;
    property FocusContentOnApplyFilter: Boolean read GetFocusContentOnApplyFilter write SetFocusContentOnApplyFilter default False;
    property HighlightSearchResults: Boolean read GetHighlightSearchResults write SetHighlightSearchResults default True;
    property InfoText: string read GetInfoText write SetInfoText stored IsInfoTextStored;
    property MRUItemsListCount: Integer read GetMRUItemsListCount write SetMRUItemsListCount default cxFindPanelDefaultMRUItemsListCount;
    property MRUItemsListDropDownCount: Integer read GetMRUItemsListDropDownCount write SetMRUItemsListDropDownCount default cxFindPanelDefaultMRUItemsListDropDownCount;
    property Position: TcxFindPanelPosition read GetPosition write SetPosition default fppTop;
    property ShowClearButton: Boolean read GetShowClearButton write SetShowClearButton default True;
    property ShowCloseButton: Boolean read GetShowCloseButton write SetShowCloseButton default True;
    property ShowFindButton: Boolean read GetShowFindButton write SetShowFindButton default True;
    property UseDelayedFind: Boolean read GetUseDelayedFind write SetUseDelayedFind default True;
    property UseExtendedSyntax: Boolean read GetUseExtendedSyntax write SetUseExtendedSyntax default False;
  end;
  TcxControlOptionsFindPanelClass = class of TcxControlOptionsFindPanel;

  { TcxContainerItemDefaultValuesProvider }

  TcxContainerItemDefaultValuesProvider = class(TcxCustomEditDefaultValuesProvider)
    function IsDisplayFormatDefined(AIsCurrencyValueAccepted: Boolean): Boolean; override;
  end;

  { TcxCustomItemDataBinding }

  TcxCustomItemDataBinding = class(TcxOwnedPersistent)
  private
    FDefaultValuesProvider: TcxCustomEditDefaultValuesProvider;
    FData: Pointer;
    function GetDataController: TcxCustomDataController;
    function GetEditContainer: TcxCustomInplaceEditContainer;
  protected
    function DefaultRepositoryItem: TcxEditRepositoryItem; virtual;
    function GetDefaultCaption: string; virtual;
    function GetDefaultValuesProvider(AProperties: TcxCustomEditProperties): IcxEditDefaultValuesProvider; virtual;
    function GetDefaultValuesProviderClass: TcxCustomEditDefaultValuesProviderClass; virtual;
    function GetFilterFieldName: string; virtual;
    function GetValueTypeClass: TcxValueTypeClass; virtual;
    procedure Init; virtual;
    function IsDisplayFormatDefined(AIsCurrencyValueAccepted: Boolean): Boolean;
    procedure ValueTypeClassChanged; virtual;
    property DataController: TcxCustomDataController read GetDataController;
    property DefaultValuesProvider: TcxCustomEditDefaultValuesProvider read FDefaultValuesProvider;
    property EditContainer: TcxCustomInplaceEditContainer read GetEditContainer;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;

    property Data: Pointer read FData write FData;
    property FilterFieldName: string read GetFilterFieldName;
  end;

  { TcxItemDataBinding }

  TcxItemDataBinding = class(TcxCustomItemDataBinding)
  private
    FValueTypeClass: TcxValueTypeClass;
    function GetValueType: string;
    procedure SetValueType(const Value: string);
    procedure SetValueTypeClass(Value: TcxValueTypeClass);
  protected
    function GetValueTypeClass: TcxValueTypeClass; override;
    function IsValueTypeStored: Boolean; virtual;
  public
    procedure Assign(Source: TPersistent); override;

    property ValueTypeClass: TcxValueTypeClass read GetValueTypeClass write SetValueTypeClass;
  published
    property ValueType: string read GetValueType write SetValueType stored IsValueTypeStored;
  end;

  { TcxControlDataController }

  TcxControlDataController = class(TcxDataController)
  private
    function GetControl: TcxEditingControl;
  protected
    procedure UpdateControl(AInfo: TcxUpdateControlInfo); override;
  public
    function GetItem(Index: Integer): TObject; override;
    function GetItemID(AItem: TObject): Integer; override;
    function GetItemValueSource(AItemIndex: Integer): TcxDataEditValueSource; override;
    procedure UpdateData; override;
    procedure UpdateItemIndexes; override;
  end;

  { TcxCustomEditContainerItemOptions }

  TcxCustomEditContainerItemOptionsClass = class of TcxCustomEditContainerItemOptions;

  TcxCustomEditContainerItemOptions = class(TcxOwnedPersistent)
  private
    FCustomizing: Boolean;
    FEditing: Boolean;
    FFiltering: Boolean;
    FFilteringWithFindPanel: Boolean;
    FFocusing: Boolean;
    FIncSearch: Boolean;
    FMoving: Boolean;
    FShowEditButtons: TcxEditItemShowEditButtons;
    FSorting: Boolean;
    FTabStop: Boolean;
    function GetEditContainer: TcxCustomInplaceEditContainer;
    procedure SetEditing(Value: Boolean);
    procedure SetFiltering(Value: Boolean);
    procedure SetFilteringWithFindPanel(AValue: Boolean);
    procedure SetFocusing(Value: Boolean);
    procedure SetIncSearch(Value: Boolean);
    procedure SetShowEditButtons(Value: TcxEditItemShowEditButtons);
  protected
    procedure Changed; virtual;
    property EditContainer: TcxCustomInplaceEditContainer read GetEditContainer;
    property Moving: Boolean read FMoving write FMoving default True;
    property Customizing: Boolean read FCustomizing write FCustomizing default True;
    property Sorting: Boolean read FSorting write FSorting default True;
    property Editing: Boolean read FEditing write SetEditing default True;
    property Filtering: Boolean read FFiltering write SetFiltering default True;
    property FilteringWithFindPanel: Boolean read FFilteringWithFindPanel write SetFilteringWithFindPanel default True;
    property Focusing: Boolean read FFocusing write SetFocusing default True;
    property IncSearch: Boolean read FIncSearch write SetIncSearch default True;
    property ShowEditButtons: TcxEditItemShowEditButtons read FShowEditButtons
      write SetShowEditButtons default eisbDefault;
    property TabStop: Boolean read FTabStop write FTabStop default True;
  public
    constructor Create(AOwner: TPersistent); override;
    procedure Assign(AOwner: TPersistent); override;
  end;

  { TcxControlOptionsView }

  TcxControlOptionsViewClass = class of TcxControlOptionsView;
  TcxControlOptionsView = class(TcxOwnedPersistent)
  strict private
    FCellAutoHeight: Boolean;
    FCellEndEllipsis: Boolean;
    FCellTextMaxLineCount: Integer;
    FNavigatorOffset: Integer;
    FShowEditButtons: TcxEditingControlEditShowButtons;

    function GetEditingControl: TcxEditingControl;
    function GetScrollBars: TcxScrollStyle;
    procedure SetCellAutoHeight(const Value: Boolean);
    procedure SetCellEndEllipsis(const Value: Boolean);
    procedure SetCellTextMaxLineCount(const Value: Integer);
    procedure SetNavigatorOffset(AValue: Integer);
    procedure SetScrollBars(const Value: TcxScrollStyle);
    procedure SetShowEditButtons(const Value: TcxEditingControlEditShowButtons);
    function IsShowEditButtonsStored: Boolean;
  protected
    procedure Changed; virtual;
    procedure ChangeScale(M, D: Integer); virtual;
    function GetDefaultShowEditButtons: TcxEditingControlEditShowButtons; virtual;

    property EditingControl: TcxEditingControl read GetEditingControl;
    property NavigatorOffset: Integer read FNavigatorOffset write SetNavigatorOffset default cxInplaceNavigatorDefaultOffset;
  public
    constructor Create(AOwner: TPersistent); override;
    procedure Assign(Source: TPersistent); override;
  published
    property CellAutoHeight: Boolean read FCellAutoHeight write SetCellAutoHeight default False;
    property CellEndEllipsis: Boolean read FCellEndEllipsis write SetCellEndEllipsis default False;
    property CellTextMaxLineCount: Integer read FCellTextMaxLineCount write SetCellTextMaxLineCount default 0;
    property ScrollBars: TcxScrollStyle read GetScrollBars write SetScrollBars default ssBoth;
    property ShowEditButtons: TcxEditingControlEditShowButtons read FShowEditButtons write SetShowEditButtons stored IsShowEditButtonsStored;
  end;

  { TcxControlOptionsData }

  TcxControlOptionsDataClass = class of TcxControlOptionsData;

  TcxControlOptionsData = class(TcxOwnedPersistent)
  private
    FCancelOnExit: Boolean;
    FEditing: Boolean;
    function GetEditingControl: TcxEditingControl;
    procedure SetEditing(Value: Boolean);
  protected
    procedure Changed; virtual;
  public
    constructor Create(AOwner: TPersistent); override;
    procedure Assign(Source: TPersistent); override;
    property EditingControl: TcxEditingControl read GetEditingControl;
  published
    property CancelOnExit: Boolean read FCancelOnExit write FCancelOnExit default True;
    property Editing: Boolean read FEditing write SetEditing default True;
  end;

  { TcxControlOptionsBehavior }

  TcxControlOptionsBehaviorClass = class of TcxControlOptionsBehavior;

  TcxControlOptionsBehavior = class(TcxOwnedPersistent)
  private
    FAlwaysShowEditor: Boolean;
    FCellHints: Boolean;
    FDragDropText: Boolean;
    FFocusCellOnCycle: Boolean;
    FFocusFirstCellOnNewRecord: Boolean;
    FHintHidePause: Integer;
    FGoToNextCellOnEnter: Boolean;
    FGoToNextCellOnTab: Boolean;
    FImmediateEditor: Boolean;
    FIncSearch: Boolean;
    FIncSearchItem: TcxCustomInplaceEditContainer;
    FNavigatorHints: Boolean;
    function GetEditingControl: TcxEditingControl;
    procedure SetAlwaysShowEditor(Value: Boolean);
    procedure SetCellHints(Value: Boolean);
    procedure SetFocusCellOnCycle(Value: Boolean);
    procedure SetFocusFirstCellOnNewRecord(Value: Boolean);
    procedure SetGoToNextCellOnEnter(Value: Boolean);
    procedure SetGoToNextCellOnTab(Value: Boolean);
    procedure SetImmediateEditor(Value: Boolean);
    procedure SetIncSearch(Value: Boolean);
    procedure SetIncSearchItem(Value: TcxCustomInplaceEditContainer);
  protected
    procedure Changed; virtual;
    property DragDropText: Boolean read FDragDropText write FDragDropText default False;
    property EditingControl: TcxEditingControl read GetEditingControl;
    property FocusCellOnCycle: Boolean read FFocusCellOnCycle write SetFocusCellOnCycle default False;
    property FocusFirstCellOnNewRecord: Boolean read FFocusFirstCellOnNewRecord write SetFocusFirstCellOnNewRecord default False;
    property IncSearch: Boolean read FIncSearch write SetIncSearch default False;
    property IncSearchItem: TcxCustomInplaceEditContainer read FIncSearchItem write SetIncSearchItem;
    property NavigatorHints: Boolean read FNavigatorHints write FNavigatorHints default False;
  public
    constructor Create(AOwner: TPersistent); override;
    procedure Assign(Source: TPersistent); override;
  published
    property AlwaysShowEditor: Boolean read FAlwaysShowEditor write SetAlwaysShowEditor default False;
    property CellHints: Boolean read FCellHints write SetCellHints default False;
    property GoToNextCellOnEnter: Boolean read FGoToNextCellOnEnter write SetGoToNextCellOnEnter default False;
    property GoToNextCellOnTab: Boolean read FGoToNextCellOnTab write SetGoToNextCellOnTab default False;
    property HintHidePause: Integer read FHintHidePause write FHintHidePause default 0;
    property ImmediateEditor: Boolean read FImmediateEditor write SetImmediateEditor default True;
  end;

  { TcxExtEditingControlNavigatorButtons }

  TcxExtEditingControlNavigatorButtons = class(TcxNavigatorControlButtons)
  private
    FControl: TcxExtEditingControl;
  protected
    function IsButtonVisibleByDefault(AIndex: Integer): Boolean; override;
  public
    constructor Create(AControl: TcxExtEditingControl); reintroduce; virtual;
  published
    property ConfirmDelete default False;
  end;

  TcxExtEditingControlNavigatorButtonsClass = class of TcxExtEditingControlNavigatorButtons;

  { TcxControlNavigatorInfoPanel }

  TcxControlNavigatorInfoPanel = class(TcxCustomNavigatorInfoPanel)
  private
    FControl: TcxExtEditingControl;
  protected
    function GetViewParams: TcxViewParams; override;
  public
    constructor Create(AControl: TcxExtEditingControl); reintroduce; virtual;

    property Control: TcxExtEditingControl read FControl;
  published
    property DisplayMask;
    property Visible;
    property Width;
  end;

  TcxControlNavigatorInfoPanelClass = class of TcxControlNavigatorInfoPanel;

  { TcxControlNavigator }

  TcxControlNavigator = class(TcxOwnedPersistent)
  private
    FButtons: TcxExtEditingControlNavigatorButtons;
    FInfoPanel: TcxControlNavigatorInfoPanel;
    FVisible: Boolean;

    function GetControl: TcxExtEditingControl;
    function GetIRecordPosition: IcxNavigatorRecordPosition;
    procedure SetButtons(Value: TcxExtEditingControlNavigatorButtons);
    procedure SetInfoPanel(Value: TcxControlNavigatorInfoPanel);
    procedure SetVisible(Value: Boolean);
  protected
    function GetInfoPanelClass: TcxControlNavigatorInfoPanelClass; virtual;
    function GetNavigatorButtonsClass: TcxExtEditingControlNavigatorButtonsClass; virtual;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property Control: TcxExtEditingControl read GetControl;
  published
    property Buttons: TcxExtEditingControlNavigatorButtons read FButtons write SetButtons;
    property InfoPanel: TcxControlNavigatorInfoPanel read FInfoPanel write SetInfoPanel;
    property Visible: Boolean read FVisible write SetVisible default False;
  end;

  TcxControlNavigatorClass = class of TcxControlNavigator;

  { TcxEditContainerStyles }

  TcxEditContainerStylesClass = class of TcxEditContainerStyles;

  TcxEditContainerStyles = class(TcxStyles)
  private
    function GetContainer: TcxCustomInplaceEditContainer;
    function GetControl: TcxEditingControl;
    function GetControlStyles: TcxCustomControlStyles;
  protected
    procedure Changed(AIndex: Integer); override;
  public
    procedure Assign(Source: TPersistent); override;
    property Container: TcxCustomInplaceEditContainer read GetContainer;
    property Control: TcxEditingControl read GetControl;
    property ControlStyles: TcxCustomControlStyles read GetControlStyles;
  published
    property Content: TcxStyle index ecs_Content read GetValue write SetValue;
  end;

  { TcxCustomInplaceEditContainer }

  IcxEditorPropertiesContainer = interface
  ['{9F0CD5D9-A3D1-44B7-82DC-CAEAC1367C5D}']
    function GetProperties: TcxCustomEditProperties;
    function GetPropertiesClass: TcxCustomEditPropertiesClass;
    procedure SetPropertiesClass(Value: TcxCustomEditPropertiesClass);
  end;

  TcxCustomInplaceEditContainer = class(TComponent,
    IcxEditRepositoryItemListener,
    IcxEditorPropertiesContainer,
    IdxScaleFactor)
  private
    FData: Pointer;
    FEditData: TcxCustomEditData;
    FEditingControl: TcxEditingControl;
    FEditViewData: TcxCustomEditViewData;
    FEditValueSource: TcxDataEditValueSource;
    FItemIndex: Integer;
    FLastEditingProperties: TcxCustomEditProperties;
    FOptions: TcxCustomEditContainerItemOptions;
    FProperties: TcxCustomEditProperties;
    FPropertiesClass: TcxCustomEditPropertiesClass;
    FPropertiesEvents: TNotifyEvent;
    FPropertiesValue: TcxCustomEditProperties;
    FRepositoryItem: TcxEditRepositoryItem;
    FStyles: TcxEditContainerStyles;

    FOnGetEditProperties: TcxGetEditPropertiesEvent;
    FOnGetEditingProperties: TcxGetEditPropertiesEvent;

    procedure IcxEditRepositoryItemListener.PropertiesChanged = RepositoryItemPropertiesChanged;
    procedure IcxEditRepositoryItemListener.ItemRemoved = RepositoryItemRemoved;
    function GetDataController: TcxCustomDataController;
    function GetFilterable: Boolean;
    function GetFocused: Boolean;
    function GetFocusedCellViewInfo: TcxEditCellViewInfo;
    function GetIncSearching: Boolean;
    function GetProperties: TcxCustomEditProperties;
    function GetPropertiesClass: TcxCustomEditPropertiesClass;
    function GetPropertiesClassName: string;
    function GetPropertiesValue: TcxCustomEditProperties;
    function GetScaleFactor: TdxScaleFactor;
    procedure SetDataBinding(Value: TcxCustomItemDataBinding);
    procedure SetFocused(Value: Boolean);
    procedure SetOptions(Value: TcxCustomEditContainerItemOptions);
    procedure SetProperties(Value: TcxCustomEditProperties);
    procedure SetPropertiesClass(Value: TcxCustomEditPropertiesClass);
    procedure SetPropertiesClassName(const Value: string);
    procedure SetRepositoryItem(Value: TcxEditRepositoryItem);
    procedure SetStyles(Value: TcxEditContainerStyles);
    procedure CreateProperties;
    procedure DestroyProperties;
    procedure RecreateProperties;
    procedure RepositoryItemPropertiesChanged(Sender: TcxEditRepositoryItem);
    procedure RepositoryItemRemoved(Sender: TcxEditRepositoryItem);
  protected
    FDataBinding: TcxCustomItemDataBinding;

    procedure CalculateEditViewInfo(const AValue: Variant; AEditViewInfo: TcxEditCellViewInfo; const APoint: TPoint); virtual;
    function CanEdit: Boolean; virtual;
    function CanFocus: Boolean; virtual;
    procedure CancelIncSearching;
    function CanFind: Boolean; virtual;
    function CanInitEditing: Boolean; virtual;
    function CanIncSearch: Boolean; virtual;
    function CanTabStop: Boolean; virtual;
    procedure Changed; virtual;
    procedure CheckUsingInFind; virtual;
    function CreateEditViewData(AProperties: TcxCustomEditProperties; AEditStyleData: Pointer): TcxCustomEditViewData; virtual;
    procedure DataChanged; virtual;
    procedure DoCalculateEditViewInfo(AEditViewInfo: TcxEditCellViewInfo); virtual;
    procedure DoGetDisplayText(ARecordIndex: TdxNativeInt; var AText: string); virtual;
    function DoGetEditProperties(AData: Pointer): TcxCustomEditProperties; virtual;
    procedure DoGetEditingProperties(AData: Pointer; var AProperties: TcxCustomEditProperties); virtual;
    function DoGetPropertiesFromEvent(AEvent: TcxGetEditPropertiesEvent; AData: Pointer;
      AProperties: TcxCustomEditProperties): TcxCustomEditProperties; virtual;
    procedure DoOnPropertiesChanged(Sender: TObject); virtual;
    procedure EditViewDataGetDisplayTextHandler(Sender: TcxCustomEditViewData; var AText: string); virtual;
    function GetControlCanvas: TcxCanvas; virtual;
    function GetController: TcxCustomControlController; virtual;
    function GetCurrentValue: Variant; virtual;
    function GetDataBindingClass: TcxItemDataBindingClass; virtual;
    function GetDefaultCaption: string; virtual;
    function GetDefaultEditProperties: TcxCustomEditProperties; virtual;
    function GetDisplayValue(AProperties: TcxCustomEditProperties; ARecordIndex: Integer): Variant; virtual;
    function GetEditDataValueTypeClass: TcxValueTypeClass; virtual;              // todo:
    function GetEditDefaultHeight(AFont: TFont): Integer; virtual;
    function GetEditHeight(AEditViewInfo: TcxEditCellViewInfo): Integer; virtual;
    function GetEditing: Boolean; virtual;
    function GetEditStyle(AData: Pointer): TcxCustomEditStyle; virtual;
    function GetEditValue: Variant; virtual;
    function GetEditWidth(AEditViewInfo: TcxEditCellViewInfo): Integer; virtual;
    function GetOptionsClass: TcxCustomEditContainerItemOptionsClass; virtual;
    function GetStylesClass: TcxEditContainerStylesClass; virtual;
    function GetValue(ARecordIndex: Integer): Variant; virtual;
    function GetValueCount: Integer; virtual;
    function HasDataTextHandler: Boolean; virtual;
    procedure InitEditViewInfo(AEditViewInfo: TcxEditCellViewInfo); virtual;
    procedure InitProperties(AProperties: TcxCustomEditProperties); virtual;
    procedure InternalPropertiesChanged;
    function IsDestroying: Boolean;
    function IsEditPartVisible: Boolean;
    procedure PropertiesChanged; virtual;
    procedure SetCurrentValue(const Value: Variant); virtual;
    procedure SetEditing(Value: Boolean); virtual;
    procedure SetEditingControl(Value: TcxEditingControl); virtual;
    procedure SetEditValue(const Value: Variant); virtual;
    procedure SetValue(ARecordIndex: Integer; const Value: Variant); virtual;
    procedure ValidateDrawValue(const AValue: Variant; AEditViewInfo: TcxEditCellViewInfo); virtual;
    procedure ValidateEditData(AEditProperties: TcxCustomEditProperties);

    property Controller: TcxCustomControlController read GetController;
    property DataBinding: TcxCustomItemDataBinding read FDataBinding write SetDataBinding;
    property DataController: TcxCustomDataController read GetDataController; // todo: should be protected
    property IncSearching: Boolean read GetIncSearching;
    property EditData: TcxCustomEditData read FEditData;
    property Editing: Boolean read GetEditing write SetEditing;
    property EditingControl: TcxEditingControl read FEditingControl write SetEditingControl;
    property EditValue: Variant read GetEditValue write SetEditValue;
    property EditValueSource: TcxDataEditValueSource read FEditValueSource;
    property EditViewData: TcxCustomEditViewData read FEditViewData;
    property Filterable: Boolean read GetFilterable;
    property Focused: Boolean read GetFocused write SetFocused;
    property FocusedCellViewInfo: TcxEditCellViewInfo read GetFocusedCellViewInfo;
    property Options: TcxCustomEditContainerItemOptions read FOptions write SetOptions;
    property PropertiesValue: TcxCustomEditProperties read GetPropertiesValue;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property Value: Variant read GetCurrentValue write SetCurrentValue;
    property ValueCount: Integer read GetValueCount;
    property Values[ARecordIndex: Integer]: Variant read GetValue write SetValue;

    property OnGetEditProperties: TcxGetEditPropertiesEvent read FOnGetEditProperties write FOnGetEditProperties;
    property OnGetEditingProperties: TcxGetEditPropertiesEvent read FOnGetEditingProperties write FOnGetEditingProperties;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Data: Pointer read FData write FData;
    property ItemIndex: Integer read FItemIndex;
    property PropertiesClass: TcxCustomEditPropertiesClass read FPropertiesClass write SetPropertiesClass;
  published
    property PropertiesClassName: string read GetPropertiesClassName write SetPropertiesClassName;

    property Properties: TcxCustomEditProperties read GetProperties write SetProperties;
    property PropertiesEvents: TNotifyEvent read FPropertiesEvents write FPropertiesEvents;
    property RepositoryItem: TcxEditRepositoryItem read FRepositoryItem write SetRepositoryItem;
    property Styles: TcxEditContainerStyles read FStyles write SetStyles;
  end;

  { IcxHotTrackElement }

  IcxHotTrackElement = interface
  ['{E7171E58-276E-499B-9DDF-298D850883C9}']
    function GetHintBounds: TRect;
    function IsNeedHint(ACanvas: TcxCanvas; const P: TPoint;
      out AText: TCaption;
      out AIsMultiLine: Boolean;
      out ATextRect: TRect; var IsNeedOffsetHint: Boolean): Boolean;
    procedure UpdateHotTrackState(const APoint: TPoint);
  end;

  { TcxInplaceContainerHintHelper }

  TcxInplaceContainerHintHelper = class(TcxControlHintHelper)
  private
    FController: TcxHotTrackController;
  protected
    procedure CorrectHintWindowRect(var ARect: TRect); override;
    function GetHintHidePause: Integer;  override;
    function GetOwnerControl: TcxControl; override;
  public
    constructor Create(AController: TcxHotTrackController); virtual;
  end;

  { TcxHotTrackController }

  TcxHotTrackController = class
  private
    FControl: TcxEditingControl;
    FHintHelper: TcxInplaceContainerHintHelper;
    FShowHint: Boolean;
  protected
    HintElement: TObject;
    IsNeedOffsetHint: Boolean;
    PrevHitPoint: TPoint;
    PrevElement: TObject;
    function CanShowHint: Boolean;
    procedure CheckDestroyingElement(AElement: TObject);
    procedure CheckHint;
    property HintHelper: TcxInplaceContainerHintHelper read FHintHelper;
  public
    constructor Create(AControl: TcxEditingControl); virtual;
    destructor Destroy; override;
    procedure CancelHint;
    procedure Clear;
    procedure SetHotElement(AElement: TObject; const APoint: TPoint);
    property Control: TcxEditingControl read FControl write FControl;
    property ShowHint: Boolean read FShowHint write FShowHint;
  end;

    { IcxDragSizing }

  IcxDragSizing = interface
  ['{5EA02F4E-E367-4E4D-A26D-000B5E5CD434}']
    function CanSizing(ADirection: TcxDragSizingDirection): Boolean;
    function GetSizingBoundsRect(ADirection: TcxDragSizingDirection): TRect;
    function GetSizingIncrement(ADirection: TcxDragSizingDirection): Integer;
    function IsDynamicUpdate: Boolean;
    procedure SetSizeDelta(ADirection: TcxDragSizingDirection; ADelta: Integer);
  end;

  { TcxSizingDragAndDropObject }

  TcxSizingDragAndDropObject = class(TcxDragAndDropObject)
  private
    FDelta: Integer;
    FDirection: TcxDragSizingDirection;
    FDragBounds: TRect;
    FDragPos: TPoint;
    FDynamicUpdate: Boolean;
    FStartPos: TPoint;
    FSizeDelta: Integer;
    function GetCanvas: TcxCanvas;
    function GetController: TcxCustomControlController;
    function GetDragCoord(APoint: TPoint): Integer;
    function GetDragItem: TObject;
    function GetDragSizing: IcxDragSizing;
    function GetIsSizingKind(Index: Integer): Boolean;
  protected
    procedure BeginDragAndDrop; override;
    procedure DirtyChanged; override;
    procedure DragAndDrop(const P: TPoint; var Accepted: Boolean); override;
    procedure EndDragAndDrop(Accepted: Boolean); override;
    function GetDragAndDropCursor(Accepted: Boolean): TCursor; override;
    function GetDragPos(const APoint: TPoint): TPoint; virtual;
    function GetImmediateStart: Boolean; override;
    function GetSizingMarkBounds: TRect; virtual;
    property StartPos: TPoint read FStartPos;
    property Controller: TcxCustomControlController read GetController;
    property Delta: Integer read FDelta;
    property DragCoord[Point: TPoint]: Integer read GetDragCoord;
    property DragPos: TPoint read FDragPos;
    property DragSizing: IcxDragSizing read GetDragSizing;
    property Direction: TcxDragSizingDirection read FDirection;
  public
    property Canvas: TcxCanvas read GetCanvas;
    property DragBounds: TRect read FDragBounds;
    property DragItem: TObject read GetDragItem;
    property DynamicUpdate: Boolean read FDynamicUpdate;
    property IsHorzSizing: Boolean index 0 read GetIsSizingKind;
    property IsVertSizing: Boolean index 1 read GetIsSizingKind;
    property SizeDelta: Integer read FSizeDelta;
  end;

  { TcxCustomAutoScrollingObject }

  TcxCustomAutoScrollingObject = class
  private
    FArea: TRect;
    FCode: TScrollCode;
    FIncrement: Integer;
    FKind: TScrollBarKind;
    FOwner: TObject;
    FTimer: TcxTimer;
  protected
    procedure DoScrollInspectingControl; virtual;
    function GetControl: TcxControl; virtual;
    function GetHasScrollBar: Boolean; virtual;
    function GetScrollBar(AKind: TScrollBarKind): IcxControlScrollBar; virtual;
    procedure GetScrollBarParams(var AMin, AMax, APos: Integer); virtual;
    procedure Scroll(AKind: TScrollBarKind; ACode: TScrollCode; var APosition: Integer); virtual;
    procedure TimerHandler(Sender: TObject); virtual;
    procedure UpdateTimer(AValue: Boolean);
  public
    constructor Create(AOwner: TObject); virtual;
    destructor Destroy; override;
    function Check(APos: TPoint): Boolean;
    procedure SetParams(const Area: TRect; AKind: TScrollBarKind;
      ACode: TScrollCode; AIncrement: Integer);
    procedure Stop;
    property Code: TScrollCode read FCode;
    property Control: TcxControl read GetControl;
    property HasScrollBar: Boolean read GetHasScrollBar;
    property Increment: Integer read FIncrement;
    property Kind: TScrollBarKind read FKind;
    property Owner: TObject read FOwner;
    property Timer: TcxTimer read FTimer;
  end;

  { TcxAutoScrollingEditingControlObject }

  TcxAutoScrollingEditingControlObject = class(TcxCustomAutoScrollingObject)
  protected
    procedure Scroll(AKind: TScrollBarKind; ACode: TScrollCode; var APosition: Integer); override;
  end;


  { TcxDragDropAutoScrollingObject }

  TcxDragDropObjectAutoScrollingObject = class(TcxAutoScrollingEditingControlObject)
  protected
    function GetControl: TcxControl; override;
  end;

  { TcxControllerAutoScrollingObject }

  TcxControllerAutoScrollingObject = class(TcxAutoScrollingEditingControlObject)
  private
    FBoundsMode: Boolean;
    FCheckHorz: Boolean;
    FCheckVert: Boolean;
    FDirections: TcxNeighbors;
  protected
    procedure DoScrollInspectingControl; override;
    function GetControl: TcxControl; override;
  public
    function CheckBounds(APos: TPoint): Boolean;
    procedure SetBoundsParams(const AClientArea: TRect;
      ACheckHorz, ACheckVert: Boolean; AIncrement: Integer);
  end;

  TcxCustomAutoScrollingObjectClass = class of TcxCustomAutoScrollingObject;

  { TcxBaseDragAndDropObject }

  TcxBaseDragAndDropObject = class(TcxDragAndDropObject)
  private
    function GetEditingControl: TcxEditingControl;
  protected
    function GetDragAndDropCursor(Accepted: Boolean): TCursor; override;
    property EditingControl: TcxEditingControl read GetEditingControl;
  end;

  { TcxDragImage }

  TcxDragImage = class(cxControls.TcxDragImage)
  public
    property Image;
    property WindowCanvas;
  end;

  { TcxPlaceArrows }

  TcxPlaceArrows = class
  strict private
    FArrow1: TcxDragAndDropArrow;
    FArrow2: TcxDragAndDropArrow;
    FPrevRect: TRect;
    FPrevSide: TcxBorder;

    function GetVisible: Boolean;
    procedure SetVisible(AValue: Boolean);
  public
    constructor CreateArrows(AColor: TColor; ABorderColor: TColor = clDefault); virtual;
    destructor Destroy; override;
    function MoveTo(ARect: TRect; ASide: TcxBorder): Boolean;
    procedure Hide;
    //
    property Visible: Boolean read GetVisible write SetVisible;
  end;

  { TcxCustomControlDragAndDropObject }

  TcxCustomControlDragAndDropObject = class(TcxBaseDragAndDropObject)
  private
    FAutoScrollObjects: TList;
    FCanDrop: Boolean;
    FDragImage: TcxDragImage;
    FHotSpot: TPoint;
    FOrgOffset: TPoint;
    FPictureSize: TRect;
    function GetAutoScrollObject(Index: Integer): TcxCustomAutoScrollingObject;
    function GetAutoScrollObjectCount: Integer;
    function GetCanvas: TcxCanvas;
    function GetHitTestController: TcxCustomHitTestController;
  protected
    procedure AddAutoScrollingObject(const ARect: TRect; AKind: TScrollBarKind;  ACode: TScrollCode);
    procedure BeginDragAndDrop; override;
    procedure DragAndDrop(const P: TPoint; var Accepted: Boolean); override;
    procedure DrawDragImage; virtual;
    procedure DrawImage(const APoint: TPoint);
    procedure EndDragAndDrop(Accepted: Boolean); override;
    function GetAcceptedRect: TRect; virtual;
    function GetAutoScrollingObjectClass: TcxCustomAutoScrollingObjectClass; virtual;
    function GetDisplayRect: TRect; virtual;
    function GetDragAndDropCursor(Accepted: Boolean): TCursor; override;
    function GetHorzScrollInc: Integer; virtual;
    function GetVertScrollInc: Integer; virtual;
    procedure OwnerImageChanged; virtual;
    procedure OwnerImageChanging; virtual;
    procedure Paint; virtual;
    procedure StopScrolling;
    // screen image working
    property AcceptedRect: TRect read GetAcceptedRect;
    property AutoScrollObjectCount: Integer read GetAutoScrollObjectCount;
    property AutoScrollObjects[Index: Integer]: TcxCustomAutoScrollingObject read GetAutoScrollObject;
    property CanDrop: Boolean read FCanDrop;
    property Canvas: TcxCanvas read GetCanvas; 
    property DisplayRect: TRect read GetDisplayRect;
    property DragImage: TcxDragImage read FDragImage;
    property HitTestController: TcxCustomHitTestController read GetHitTestController;
    property HotSpot: TPoint read FHotSpot;
    property OrgOffset: TPoint read FOrgOffset write FOrgOffset;
    property PictureSize: TRect read FPictureSize;
  public
    constructor Create(AControl: TcxControl); override;
    destructor Destroy; override;
  end;

  { TcxDragImageHelper }

  TcxDragImageHelperClass = class of TcxDragImageHelper;

  TcxDragImageHelper = class
  private
    FDragControl: TcxEditingControl;
    FDragImageVisible: Boolean;
    FDragPos: TPoint;
    function GetImageRect: TRect;
    procedure SetDragImageVisible(Value: Boolean);
  protected
    DragImage: TcxDragImage;
    HotSpot: TPoint;
    DragPictureBounds: TRect;
    MousePos: TPoint;
    procedure DragAndDrop(const P: TPoint); virtual;
    function GetDisplayRect: TRect; virtual;
    procedure InitDragImage; virtual;
    // working with screen
    procedure DrawImage(const APoint: TPoint); virtual;
  public
    constructor Create(AControl: TcxEditingControl; ADragPos: TPoint); virtual;
    destructor Destroy; override;
    procedure Hide; virtual;
    procedure Show; virtual;

    property DragControl: TcxEditingControl read FDragControl;
    property DragImageRect: TRect read GetImageRect;
    property DragImageVisible: Boolean read FDragImageVisible write SetDragImageVisible;
  end;

  { TcxCustomHitTestController }

  TcxHitTestControllerClass  = class of TcxCustomHitTestController;

  TcxCustomHitTestController = class
  private
    FController: TcxCustomControlController;
    FHitPoint: TPoint;
    FHitTestItem: TObject;
    FShift: TShiftState;
    function GetControl: TcxEditingControl;
    function GetCoordinate(AIndex: Integer): Integer;
    function GetEditCellViewInfo: TcxEditCellViewInfo;
    function GetHasCode(Mask: TcxHitCode): Boolean;
    function GetHotTrackController: TcxHotTrackController;
    function GetIsItemEditCell: Boolean;
    function GetIsMouseEvent: Boolean;
    function GetViewInfo: TcxCustomControlViewInfo;
    procedure SetCoordinate(AIndex: Integer; Value: Integer);
    procedure SetHasCode(ACode: TcxHitCode; AValue: Boolean);
    procedure SetHitPoint(const APoint: TPoint);
    procedure SetHitTestItem(AItem: TObject);
    procedure SetIsMouseEvent(Value: Boolean);
  protected
    FHitState: TcxHitCode;
    function AllowDesignMouseEvents(X, Y: Integer; AShift: TShiftState): Boolean; virtual;
    function CanShowHint(AItem: TObject): Boolean; virtual;
    procedure ClearState;
    procedure DoCalculate; virtual;
    function GetCurrentCursor: TCursor; virtual;
    function GetHitAtFindPanel: Boolean; virtual;
    function GetHitAtNavigator: Boolean; virtual;
    procedure HitCodeChanged(APrevCode: Integer); virtual;
    procedure HitTestItemChanged(APrevHitTestItem: TObject); virtual;
    procedure RecalculateOnMouseEvent(X, Y: Integer; AShift: TShiftState);

    property Control: TcxEditingControl read GetControl;
    property Controller: TcxCustomControlController read FController;
    property HotTrackController: TcxHotTrackController read GetHotTrackController;
    property IsMouseEvent: Boolean read GetIsMouseEvent write SetIsMouseEvent;
    property Shift: TShiftState read FShift;
    property ViewInfo: TcxCustomControlViewInfo read GetViewInfo;
  public
    constructor Create(AOwner: TcxCustomControlController); virtual;
    procedure CheckDestroyingItem(AItem: TObject);
    procedure ReCalculate; overload;
    procedure ReCalculate(const APoint: TPoint); overload;
    property EditCellViewInfo: TcxEditCellViewInfo read GetEditCellViewInfo;
    property HitAtFindPanel: Boolean read GetHitAtFindPanel;
    property HitAtNavigator: Boolean read GetHitAtNavigator;
    property HitPoint: TPoint read FHitPoint write SetHitPoint;
    property HitX: Integer index 0 read GetCoordinate write SetCoordinate;
    property HitY: Integer index 1 read GetCoordinate write SetCoordinate;
    property HitState: TcxHitCode read FHitState;
    property HitCode[ACode: TcxHitCode]: Boolean read GetHasCode write SetHasCode;
    property HitTestItem: TObject read FHitTestItem write SetHitTestItem;
    property IsItemEditCell: Boolean read GetIsItemEditCell;
  end;

  { TcxCustomCellNavigator }

  TcxCustomCellNavigator = class
  private
    FController: TcxCustomControlController;
    FEatKeyPress: Boolean;
    FDownOnEnter: Boolean;
    FDownOnTab: Boolean;
    function GetDataController: TcxCustomDataController;
  protected
    RowCount: Integer;
    function SelectCell(AForward, ANextRow: Boolean;
      var ARowIndex, ACellIndex: Integer): TcxCustomInplaceEditContainer; virtual;

    procedure CalcNextRow(AForward: Boolean; var ARowIndex, ACellIndex: Integer); virtual;
    function GetCellContainer(ARowIndex, ACellIndex: Integer): TcxCustomInplaceEditContainer; virtual;
    function GetCount(ARowIndex: Integer): Integer; virtual;
    procedure Init(var ARowIndex, ACellIndex, ARowCount: Integer); virtual;
    function MayFocusedEmptyRow(ARowIndex: Integer): Boolean; virtual;
    procedure SetFocusCell(ARowIndex, ACellIndex: Integer; AShift: TShiftState); virtual;
    procedure DoKeyPress(var Key: Char); virtual;
    property DownOnEnter: Boolean read FDownOnEnter write FDownOnEnter;
    property DownOnTab: Boolean read FDownOnTab write FDownOnTab;
  public
    constructor Create(AController: TcxCustomControlController); virtual;
    function FocusNextCell(AForward, ANextRow: Boolean; AShift: TShiftState = []): Boolean; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); virtual;
    procedure KeyPress(var Key: Char); virtual;
    procedure Refresh; virtual;
    property Count[ARowIndex: Integer]: Integer read GetCount;
    property Controller: TcxCustomControlController read FController;
    property DataController: TcxCustomDataController read GetDataController;
    property EatKeyPress: Boolean read FEatKeyPress write FEatKeyPress;
  end;

  TcxCustomCellNavigatorClass = class of TcxCustomCellNavigator;

  { TcxDesignSelectionHelper }

  TcxCustomDesignSelectionHelper = class
  private
    FControl: TcxEditingControl;
    function GetController: TcxCustomControlController;
  protected
    property Control: TcxEditingControl read FControl;
    property Controller: TcxCustomControlController read GetController;
  public
    constructor Create(AControl: TcxEditingControl); virtual;
    function IsObjectSelected(AObject: TPersistent): Boolean; virtual; abstract;
    procedure Select(AObject: TPersistent; AShift: TShiftState); virtual; abstract;
    procedure SetSelection(AList: TList); virtual; abstract;
    procedure UnselectObject(AObject: TPersistent); virtual; abstract;
  end;

  TcxCustomDesignSelectionHelperClass = class of TcxCustomDesignSelectionHelper;

  { TcxCustomControlController }

  TcxCustomControlController = class
  private
    FAllowCheckEdit: Boolean;
    FBlockRecordKeyboardHandling: Boolean;
    FCheckEditNeeded: Boolean;
    FDisableCellsRefresh: Boolean;
    FDragCancel: Boolean;
    FDragItem: TObject;
    FEatKeyPress: Boolean;
    FEditingBeforeDrag: Boolean;
    FEditingController: TcxEditingController;
    FEditingControl: TcxEditingControl;
    FFindPanel: TcxControlFindPanel;
    FFocused: Boolean;
    FFocusedItem: TcxCustomInplaceEditContainer;
    FHitTestController: TcxCustomHitTestController;
    FHotTrackController: TcxHotTrackController;
    FIsDblClick: Boolean;
    FIsHandleTabStop: Boolean;
    FNavigator: TcxCustomCellNavigator;
    FWasFocusedBeforeClick: Boolean;
    function GetDataController: TcxCustomDataController;
    function GetDesignSelectionHelper: TcxCustomDesignSelectionHelper;
    function GetEditingItem: TcxCustomInplaceEditContainer;
    function GetIsEditing: Boolean;
    function GetItemForIncSearching: TcxCustomInplaceEditContainer;
    procedure SetEditingItem(Value: TcxCustomInplaceEditContainer);
    procedure SetIncSearchingText(const Value: string);
  protected
    procedure MouseEnter; virtual;
    procedure MouseLeave; virtual;
    procedure DoCancelMode; virtual;

    procedure AfterPaint; virtual;
    procedure BeforeEditKeyDown(var Key: Word; var Shift: TShiftState); virtual;
    procedure BeforeMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure BeforePaint; virtual;
    procedure BeforeShowEdit; virtual;
    procedure BehaviorChanged; virtual;
    procedure CancelCheckEditPost;
    function CanHandleDeleteRecordKeys: Boolean; virtual;
    function CanFocusedRecordIndex(AIndex: TdxNativeInt): Boolean; virtual;
    function CanShowHint: Boolean; virtual;
    procedure CheckEdit; virtual;
    procedure HandleNonContentMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoEditDblClick(Sender: TObject); virtual;
    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoMouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoNextPage(AForward: Boolean; Shift: TShiftState); virtual;
    function GetEditingViewInfo: TcxEditCellViewInfo; virtual;
    function GetFindPanelClass: TcxControlFindPanelClass; virtual;
    function GetFindStartPosition(ARecordIndex: TdxNativeInt; AItemIndex: Integer; out AHighlightedText: string): Integer; virtual;
    function GetFocused: Boolean; virtual;
    function GetFocusedCellViewInfo(AEditContainer: TcxCustomInplaceEditContainer): TcxEditCellViewInfo; virtual;
    function GetFocusedRecordIndex: TdxNativeInt; virtual;
    function GetResizeDirection: TcxDragSizingDirection; virtual;
    procedure FocusedItemChanged(APrevFocusedItem: TcxCustomInplaceEditContainer); virtual;
    procedure FocusedRecordChanged(APrevFocusedRecordIndex, AFocusedRecordIndex: Integer); virtual;
    function HasFocusedControls: Boolean; virtual;
    procedure HideHint; virtual;
    function IncSearchKeyDown(AKey: Word; AShift: TShiftState): Word; virtual;
    procedure InternalSetFocusedItem(Value: TcxCustomInplaceEditContainer);
    function IsImmediatePost: Boolean; virtual;
    function IsKeyForController(AKey: Word; AShift: TShiftState): Boolean; virtual;
    procedure PostCheckEdit;
    procedure PostShowEdit;
    procedure ProcessCheckEditPost;
    procedure RefreshFocusedCellViewInfo(AItem: TcxCustomInplaceEditContainer); virtual;
    procedure RefreshFocusedRecord; virtual;
    procedure SetFocused(Value: Boolean); virtual;
    procedure SetFocusedItem(Value: TcxCustomInplaceEditContainer); virtual;
    procedure SetFocusedRecordIndex(Value: TdxNativeInt); virtual;
    // behavior options
    function GetAlwaysShowEditor: Boolean; virtual;
    function GetCancelEditingOnExit: Boolean; virtual;
    function GetFocusCellOnCycle: Boolean; virtual;
    function GetGoToNextCellOnEnter: Boolean; virtual;
    function GetGoToNextCellOnTab: Boolean; virtual;
    function GetImmediateEditor: Boolean; virtual;
    // drag'n'drop
    procedure BeforeStartDrag; virtual;
    function CanDrag(X, Y: Integer): Boolean; virtual;
    procedure DragDrop(Source: TObject; X, Y: Integer); virtual;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); virtual;
    procedure EndDrag(Target: TObject; X, Y: Integer); virtual;
    function GetDragAndDropObject: TcxCustomControlDragAndDropObject;
    function GetDragAndDropObjectClass: TcxDragAndDropObjectClass; virtual;
    function GetIsDragging: Boolean; virtual;
    function GetNavigatorClass: TcxCustomCellNavigatorClass; virtual;
    procedure StartDrag(var DragObject: TDragObject); virtual;
    // scrolling
    function GetMouseWheelScrollingKind: TcxMouseWheelScrollingKind; virtual;
    function IsPixelScrollBar(AKind: TScrollBarKind): Boolean; virtual;
    // focus
    procedure DoEnter; virtual;
    procedure DoExit; virtual;
    function MayFocus: Boolean; virtual;
    procedure FocusChanged; virtual;
    procedure RemoveFocus; virtual;
    procedure SetFocus; virtual;
    // incremental search
    procedure CancelIncSearching; virtual;
    function GetIncSearchingItem: TcxCustomInplaceEditContainer; virtual;
    function GetIncSearchingText: string; virtual;
    function GetIsIncSearching: Boolean; virtual;
    procedure SearchLocate(AItem: TcxCustomInplaceEditContainer; const Value: string); virtual;
    procedure SearchLocateNext(AItem: TcxCustomInplaceEditContainer; AForward: Boolean); virtual;
    procedure UpdateRecord(ARecordIndex: TdxNativeInt); virtual;
    procedure ViewInfoChanged; virtual;

    property AllowCheckEdit: Boolean read FAllowCheckEdit write FAllowCheckEdit;
    property BlockRecordKeyboardHandling: Boolean read FBlockRecordKeyboardHandling
      write FBlockRecordKeyboardHandling;
    property DesignSelectionHelper: TcxCustomDesignSelectionHelper read GetDesignSelectionHelper;
    property DisableCellsRefresh: Boolean read FDisableCellsRefresh write FDisableCellsRefresh;
    property DragAndDropObject: TcxCustomControlDragAndDropObject read GetDragAndDropObject;
    property DragCancel: Boolean read FDragCancel write FDragCancel;
    property DragItem: TObject read FDragItem write FDragItem;
    property EatKeyPress: Boolean read FEatKeyPress write FEatKeyPress;
    property EditingControl: TcxEditingControl read FEditingControl;
    property EditingController: TcxEditingController read FEditingController;
    property EditingItem: TcxCustomInplaceEditContainer read GetEditingItem write SetEditingItem;
    property EditingViewInfo: TcxEditCellViewInfo read GetEditingViewInfo;
    property FindPanel: TcxControlFindPanel read FFindPanel;
    property HotTrackController: TcxHotTrackController read FHotTrackController;
    property HitTestController: TcxCustomHitTestController read FHitTestController;
    property IncSearchingText: string read GetIncSearchingText write SetIncSearchingText;
    property IncSearchingItem: TcxCustomInplaceEditContainer read GetIncSearchingItem;
    property IsHandleTabStop: Boolean read FIsHandleTabStop write FIsHandleTabStop;
    property IsDragging: Boolean read GetIsDragging;
    property IsIncSearching: Boolean read GetIsIncSearching;
    property ItemForIncSearching: TcxCustomInplaceEditContainer read GetItemForIncSearching;
    property Navigator: TcxCustomCellNavigator read FNavigator;
    property WasFocusedBeforeClick: Boolean read FWasFocusedBeforeClick write FWasFocusedBeforeClick;
  public
    constructor Create(AOwner: TcxEditingControl); reintroduce; virtual;
    destructor Destroy; override;
    procedure Clear; virtual;
    procedure ControlFocusChanged; virtual;
    procedure DblClick; virtual;
    function GetCursor(X, Y: Integer): TCursor; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); virtual;
    procedure KeyPress(var Key: Char); virtual;
    procedure KeyUp(var Key: Word; Shift: TShiftState); virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure Reset;
    function HandleMessage(var Message: TMessage): Boolean; virtual;
    // drag'n'drop
    procedure BeginDragAndDrop; virtual;
    procedure DragAndDrop(const P: TPoint; var Accepted: Boolean); virtual;
    procedure EndDragAndDrop(Accepted: Boolean); virtual;
    function StartDragAndDrop(const P: TPoint): Boolean; virtual;
    // scrolling
    procedure InitScrollBarsParameters; virtual;
    procedure Scroll(AScrollBarKind: TScrollBarKind; AScrollCode: TScrollCode;
      var AScrollPos: Integer); virtual;
    procedure SetFocusedRecordItem(ARecordIndex: TdxNativeInt;
      AItem: TcxCustomInplaceEditContainer); virtual;
    procedure SetScrollBarInfo(AScrollBarKind: TScrollBarKind;
      AMin, AMax, AStep, APage, APos: Integer; AAllowShow, AAllowHide: Boolean);
    procedure MakeFocusedItemVisible; virtual;
    procedure MakeFocusedRecordVisible; virtual;

    //find panel
    procedure ApplyFindFilterText(const AText: string);
    procedure ClearFindFilterText;
    function GetFindFilterText: string;
    procedure HideFindPanel;
    function IsFindPanelVisible: Boolean;
    procedure ShowFindPanel;

    property DataController: TcxCustomDataController read GetDataController;
    property Focused: Boolean read GetFocused write SetFocused;
    property FocusedItem: TcxCustomInplaceEditContainer read FFocusedItem write SetFocusedItem;
    property FocusedRecordIndex: TdxNativeInt read GetFocusedRecordIndex write SetFocusedRecordIndex;

    property IsDblClick: Boolean read FIsDblClick;
    property IsEditing: Boolean read GetIsEditing;
  end;

  { TcxEditingController }

  TcxEditingController = class(TcxCustomEditingController)
  private
    FController: TcxCustomControlController;
    FEditingItem: TcxCustomInplaceEditContainer;
    FEditingItemSetting: Boolean;
    FEditShowingTimerItem: TcxCustomInplaceEditContainer;
    function GetEditingCellViewInfo: TcxEditCellViewInfo; inline;
    function GetEditingControl: TcxEditingControl;
    function GetEditingProperties: TcxCustomEditProperties;
    function GetIsDragging: Boolean;
    procedure SetEditingItem(Value: TcxCustomInplaceEditContainer);
  protected
    function CanHideEdit: Boolean; override;
    function CanInitEditing: Boolean; override;
    function CanUpdateEditValue: Boolean; override;
    procedure ClearEditingItem; override;
    procedure DoHideEdit(Accept: Boolean); override;
    procedure DoUpdateEdit; override;
    procedure FocusControlOnHideEdit; virtual;
    function GetCancelEditingOnExit: Boolean; override;
    function GetEditParent: TWinControl; override;
    function GetFocusedCellBounds: TRect; override;
    function GetHideEditOnExit: Boolean; override;
    function GetHideEditOnFocusedRecordChange: Boolean; override;
    function GetIsEditing: Boolean; override;
    procedure HideInplaceEditor; override;
    function NeedFocusControlOnHideEdit: Boolean; virtual;
    function PrepareEdit(AItem: TcxCustomInplaceEditContainer; AIsMouseEvent: Boolean): Boolean; virtual;
    procedure StartEditingByTimer; override;
    procedure UpdateInplaceParamsPosition; override;

    //editing value
    function GetValue: TcxEditValue; override;
    procedure SetValue(const AValue: TcxEditValue); override;

    procedure EditAfterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    procedure EditChanged(Sender: TObject); override;
    procedure EditDblClick(Sender: TObject); override;
    procedure EditExit(Sender: TObject); override;
    procedure EditFocusChanged(Sender: TObject); override;
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    procedure EditKeyPress(Sender: TObject; var Key: Char); override;
    procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    procedure EditValueChanged(Sender: TObject); override;

    property Controller: TcxCustomControlController read FController;
    property EditingCellViewInfo: TcxEditCellViewInfo read GetEditingCellViewInfo;
    property EditingControl: TcxEditingControl read GetEditingControl;
    property EditingProperties: TcxCustomEditProperties read GetEditingProperties;
  public
    constructor Create(AController: TcxCustomControlController); virtual;
    procedure HideEdit(Accept: Boolean); override;

    procedure ShowEdit; overload; override;
    procedure ShowEdit(AItem: TcxCustomInplaceEditContainer); reintroduce; overload;
    procedure ShowEdit(AItem: TcxCustomInplaceEditContainer; Key: Char); reintroduce; overload;
    procedure ShowEdit(AItem: TcxCustomInplaceEditContainer; Shift: TShiftState; X, Y: Integer); reintroduce; overload;

    procedure StartEditShowingTimer(AItem: TcxCustomInplaceEditContainer);

    property EditingItem: TcxCustomInplaceEditContainer read FEditingItem write SetEditingItem;
    property IsDragging: Boolean read GetIsDragging;
  end;

  { TcxCustomControlViewInfo }

  TcxCustomControlViewInfo = class
  private
    FBounds: TRect;
    FControl: TcxEditingControl;
    FClientRect: TRect;
    FDefaultEditHeight: Integer;
    FEditCellViewInfoList: TList;
    FFindPanelViewInfo: TcxControlFindPanelViewInfo;
    FPainter: TcxCustomControlPainter;
    FState: Integer;

    function GetFindPanelHeight: Integer;
    function GetFindPanelPosition: TcxFindPanelPosition;
    function GetFindPanelVisibleRect: TRect;
    function GetFindPanelWidth: Integer;
    function GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
    function GetScaleFactor: TdxScaleFactor;
    function GetState(AMask: Integer): Boolean;
    procedure SetState(AMask: Integer; Value: Boolean);
    procedure UpdateSelectionParams;
  protected
    Brush: TBrush;
    SelectionBrush: TBrush;
    SelectionParams: TcxViewParams;

    function AddEditCellViewInfo(AViewInfoClass: TcxEditCellViewInfoClass;
      AEditContainer: TcxCustomInplaceEditContainer): TcxEditCellViewInfo;
    function CalculateClientRect: TRect; virtual;
    function CalculateDefaultEditHeight: Integer; virtual;
    procedure CalculateDefaultHeights; virtual;
    procedure CalculateFindPanel; virtual;
    procedure ClearEditCellViewInfos;
    procedure CreatePainter; virtual;
    procedure DoCalculate; virtual;
    function GetFindPanelViewInfoClass: TcxControlFindPanelViewInfoClass; virtual;
    function IsFindPanelVisible: Boolean; virtual;
    function IsPanArea(const APoint: TPoint): Boolean; virtual;
    procedure RemoveEditCellViewInfo(AViewInfo: TcxEditCellViewInfo);
    procedure SetFullPaintRegion(ACanvas: TcxCanvas); virtual;
    procedure UpdateSelection; virtual;

    property FindPanelHeight: Integer read GetFindPanelHeight;
    property FindPanelPosition: TcxFindPanelPosition read GetFindPanelPosition;
    property FindPanelViewInfo: TcxControlFindPanelViewInfo read FFindPanelViewInfo;
    property FindPanelVisibleRect: TRect read GetFindPanelVisibleRect;
    property FindPanelWidth: Integer read GetFindPanelWidth;
    property IsDirty: Boolean index cvis_IsDirty read GetState write SetState;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property State[AMask: Integer]: Boolean read GetState write SetState;
  public
    ViewParams: TcxViewParams;
    constructor Create(AOwner: TcxEditingControl); virtual;
    destructor Destroy; override;
    procedure Calculate;
    procedure Invalidate(ARecalculate: Boolean = False); virtual;
    procedure ValidateDirty;

    property Bounds: TRect read FBounds write FBounds;
    property ClientRect: TRect read FClientRect;
    property Control: TcxEditingControl read FControl;
    property DefaultEditHeight: Integer read FDefaultEditHeight;
    property LookAndFeelPainter: TcxCustomLookAndFeelPainter read GetLookAndFeelPainter;
    property Painter: TcxCustomControlPainter read FPainter write FPainter;
  end;

  { TcxCustomControlCells }

  TcxCustomDrawCellEvent = procedure(ACanvas: TcxCanvas;
    ACell: TcxCustomViewInfoItem; var ADone: Boolean) of object;

  TcxCustomControlCells = class(TcxObjectList)
  private
    function GetItem(AIndex: Integer): TcxCustomViewInfoItem;
  public
    procedure BeforePaint;
    function CalculateHitTest(AHitTest: TcxCustomHitTestController): Boolean;
    procedure Clear; override;
    procedure DeleteAll;
    procedure ExcludeFromClipping(ACanvas: TcxCanvas);
    procedure Paint(ACanvas: TcxCanvas; AHandler: TcxCustomDrawCellEvent); virtual;

    property Items[Index: Integer]: TcxCustomViewInfoItem read GetItem; default;
  end;

  TcxCustomControlViewInfoClass = class of TcxCustomControlViewInfo;

  TcxExtEditingControlViewInfo = class(TcxCustomControlViewInfo)
  private
    FNavigatorSiteViewInfo: TcxcustomNavigatorSiteViewInfo;
    function GetControl: TcxExtEditingControl;
    function GetNavigatorSiteVisibleRect: TRect;
  protected
    procedure AddNavigatorSiteToPaintRegion(ACanvas: TcxCanvas);
    procedure AdjustClientBounds(var ABounds: TRect); virtual;
    procedure CalculateNavigator; virtual;
    function CanHScrollBarHide: Boolean; virtual;
    function GetBottomNonClientHeight: Integer; virtual;
    function GetRightNonClientWidth: Integer; virtual;
    procedure GetHScrollBarBounds(var ABounds: TRect); virtual;
    function GetNavigatorBounds: TRect; virtual;
    procedure GetVScrollBarBounds(var ABounds: TRect); virtual;
    function IsNavigatorSizeChanged: Boolean; virtual;
    function IsNavigatorVisible: Boolean; virtual;
    procedure NavigatorInvalidate; virtual;
    procedure NavigatorStateChanged; virtual;
    function GetNavigatorSiteViewInfoClass: TcxCustomNavigatorSiteViewInfoClass; virtual;
    function IsNavigatorSupported: Boolean; virtual;
    procedure SetFullPaintRegion(ACanvas: TcxCanvas); override;

    property NavigatorSiteViewInfo: TcxcustomNavigatorSiteViewInfo read FNavigatorSiteViewInfo;
    property NavigatorSiteVisibleRect: TRect read GetNavigatorSiteVisibleRect;
  public
    constructor Create(AOwner: TcxEditingControl); override;
    destructor Destroy; override;
    procedure Invalidate(ARecalculate: Boolean = False); override;
    property Control: TcxExtEditingControl read GetControl;
  end;

  { TcxCustomViewInfoItem }

  TcxCustomViewInfoItem = class(TcxIUnknownObject)
  private
    FHasClipping: Boolean;
    FOwner: TObject;
    FTransparent: Boolean;
    FVisibleInfoCalculated: Boolean;

    function GetBitmap: TBitmap;
    function GetControlViewInfo: TcxCustomControlViewInfo;
    function GetPainter: TcxCustomLookAndFeelPainter;
    function GetScaleFactor: TdxScaleFactor;
  protected
    ClipRect: TRect;
    ControlCanvas: TcxCanvas;
    DisplayRect: TRect;
    ItemViewParams: TcxViewParams;
    ItemVisible: Boolean;
    VisibleBounds: TRect;

    procedure AfterCustomDraw(ACanvas: TcxCanvas); virtual;
    procedure BeforeCustomDraw(ACanvas: TcxCanvas); virtual;
    procedure CheckClipping(const ADisplayRect, AAvailableRect: TRect); overload; virtual;
    procedure CheckClipping(const ADisplayRect: TRect); overload; virtual;
    procedure DoCalculate; virtual;
    procedure DoDraw(ACanvas: TcxCanvas); virtual;
    procedure DoHorzOffset(AShift: Integer); virtual;
    procedure DoVertOffset(AShift: Integer); virtual;
    function DrawBackgroundHandler(ACanvas: TcxCanvas; const ABounds: TRect): Boolean;
    function GetControl: TcxEditingControl; virtual;
    function GetHitTest(AHitTest: TcxCustomHitTestController): Boolean; virtual;
    function IsPersistent: Boolean; virtual;
    function IsTransparent: Boolean; virtual;
    function ExcludeFromPaint(ACanvas: TcxCanvas): Boolean;
    procedure Scroll(const DX, DY: Integer); virtual;
    procedure UpdateEditRect;

    property Owner: TObject read FOwner;
    property ControlViewInfo: TcxCustomControlViewInfo read GetControlViewInfo;
  public
    constructor Create(AOwner: TObject); virtual;
    procedure Assign(Source: TcxCustomViewInfoItem); virtual;
    procedure CheckVisibleInfo;
    class function CustomDrawID: Integer; virtual;
    procedure Draw(ACanvas: TcxCanvas);
    procedure Invalidate(ARecalculate: Boolean = False); overload;
    procedure Invalidate(const R: TRect; AEraseBackground: Boolean = False); overload; virtual;

    property Bitmap: TBitmap read GetBitmap;
    property BoundsRect: TRect read DisplayRect;
    property Control: TcxEditingControl read GetControl;
    property HasClipping: Boolean read FHasClipping;
    property Painter: TcxCustomLookAndFeelPainter read GetPainter;
    property LookAndFeelPainterClass: TcxCustomLookAndFeelPainter read GetPainter; // todo: deprecated, for backward capability only
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property Transparent: Boolean read FTransparent write FTransparent;
    property Visible: Boolean read ItemVisible;
    property VisibleInfoCalculated: Boolean read FVisibleInfoCalculated write FVisibleInfoCalculated;
    property VisibleRect: TRect read ClipRect;
    property ViewParams: TcxViewParams read ItemViewParams;
  end;

  { TcxEditCellViewInfo }

  TcxEditCellViewInfo = class(TcxCustomViewInfoItem, IcxHotTrackElement, IcxHintableObject, IcxEditOwner)
  private
    procedure AfterDrawCellBackgroundHandler(ACanvas: TcxCanvas);
    procedure AfterDrawCellValueHandler(ACanvas: TcxCanvas);
    procedure CalculateEditorBoundsHandler(AViewInfo: TcxCustomEditViewInfo; var R: TRect);
    procedure CanDrawEditValueHandler(Sender: TcxCustomEditViewInfo; var Allow: Boolean);
    function GetTransparent: Boolean;
    procedure SetTransparent(Value: Boolean);
  protected
    CellBorders: TcxBorders;
    CellContentRect: TRect;
    CellEditRect: TRect;
    CellHeight: Integer;
    CellTransparent: Boolean;
    CellValue: Variant;
    IsViewDataCreated: Boolean;
    Properties: TcxCustomEditProperties;
    ViewInfo: TcxCustomEditViewInfo;
    ViewData: TcxCustomEditViewData;
    // IcxHotTrackElement
    function GetHintBounds: TRect; virtual;
    function IsNeedHint(ACanvas: TcxCanvas; const P: TPoint;
      out AText: TCaption; out AIsMultiLine: Boolean; out ATextRect: TRect;
      var IsNeedOffsetHint: Boolean): Boolean; virtual;
    procedure UpdateHotTrackState(const APoint: TPoint); virtual;
    // IcxHintableObject
    function HasHintPoint(const P: TPoint): Boolean;
    function IsHintAtMousePos: Boolean;
    function UseHintHidePause: Boolean;
    // IcxEditOwner
    function GetViewData(out AIsViewDataCreated: Boolean): TcxCustomEditViewData;
    procedure IcxEditOwner.Invalidate = EditOwnerInvalidate;
    procedure EditOwnerInvalidate(const R: TRect; AEraseBackground: Boolean);

    procedure AfterDrawCellBackground(ACanvas: TcxCanvas); virtual;
    procedure AfterDrawCellValue(ACanvas: TcxCanvas); virtual;
    procedure CalculateCellEditorBounds(AViewInfo: TcxCustomEditViewInfo; var R: TRect); virtual;
    procedure CanDrawCellValue(var Allow: Boolean); virtual;

    function CalculateEditHeight: Integer;
    function CalculateEditWidth: Integer;
    function ChangedHeight(APrevHeight, ANewHeight: Integer): Boolean; virtual;
    procedure CheckClipping(const ADisplayRect, AAvailableRect: TRect); override;
    function ContentOffset: TRect; virtual;
    function CorrectHotTrackPoint(const APoint: TPoint): TPoint; virtual;
    procedure DoCalculate; override;
    function GetButtonTransparency: TcxEditButtonTransparency; virtual;
    function GetCellOrg: TPoint; virtual;
    function GetControl: TcxEditingControl; override;
    function GetDisplayValue: Variant; virtual;
    function GetEditContainer: TcxCustomInplaceEditContainer; virtual;
    function GetEditRect: TRect; virtual;
    function GetEditViewParams: TcxViewParams; virtual;
    function GetFindBKColor: Integer; virtual;
    function GetFindTextColor: Integer; virtual;
    procedure GetFindTextPosition(out AStart, ALength: Integer); virtual;
    function GetFocused: Boolean; virtual;
    function GetInplaceEditPosition: TcxInplaceEditPosition;
    function GetMaxLineCount: Integer; virtual;
    function GetRecordIndex: TdxNativeInt; virtual;
    function GetSelectedTextColor: Integer; virtual;
    function GetSelectedBKColor: Integer; virtual;
    function GetViewInfoData: Pointer; virtual;
    function FormatDisplayValue(AValue: Variant): Variant; virtual;
    function GetIncSearchText: string;
    procedure InitFindTextSelection; virtual;
    procedure InitIncSearchTextSelection; virtual;
    procedure InitTextSelection; virtual;
    function IsAutoHeight: Boolean; virtual;
    function IsEndEllipsis: Boolean; virtual;
    function IsSupportedHotTrack: Boolean; virtual;
    function NeedHighlightFindText: Boolean; virtual;
    function NeedHighlightIncSearchText: Boolean; virtual;
    procedure SetBounds(const ABounds: TRect; const ADisplayRect: TRect);

    property EditContainer: TcxCustomInplaceEditContainer read GetEditContainer;
    property EditRect: TRect read GetEditRect;
  public
    destructor Destroy; override;
    procedure Assign(Source: TcxCustomViewInfoItem); override;
    function Refresh(ARecalculate: Boolean): Boolean; virtual;

    property Borders: TcxBorders read CellBorders;
    property ContentRect: TRect read CellContentRect;
    property DisplayValue: Variant read CellValue;
    property EditViewInfo: TcxCustomEditViewInfo read ViewInfo;
    property Focused: Boolean read GetFocused;
    property MaxLineCount: Integer read GetMaxLineCount;
    property RecordIndex: TdxNativeInt read GetRecordIndex;
    property Transparent: Boolean read GetTransparent write SetTransparent;
    property BoundsRect;
    property Control;
    property ViewParams;
    property VisibleRect;
  end;

  TcxExtEditingControlNavigatorViewInfo = class(TcxInplaceNavigatorViewInfo)
  private
    FOwnerControl: TcxExtEditingControl;
  protected
    function GetControl: TcxControl; override;
    function GetNavigatorOffset: Integer; override;
    procedure UpdateNavigatorSiteBounds(const ABounds: TRect); override;
  public
    constructor Create(AOwnerControl: TcxExtEditingControl); reintroduce; virtual;
  end;

  TcxCustomNavigatorSiteViewInfo = class(TcxCustomViewInfoItem, IcxHotTrackElement)
  private
    FNavigatorViewInfo: TcxExtEditingControlNavigatorViewInfo;
    function GetOwnerControl: TcxExtEditingControl;
  protected
    procedure Calculate;
    procedure DoCalculate; override;
    procedure DoDraw(ACanvas: TcxCanvas); override;
    procedure DrawEx(ACanvas: TcxCanvas);
    function GetControl: TcxEditingControl; override;
    function GetHeight: Integer;
    function GetHitTest(AHitTest: TcxCustomHitTestController): Boolean; override;
    function GetNavigatorBounds: TRect;
    function GetWidth: Integer;
    function IsNavigatorSizeChanged: Boolean;
    procedure NavigatorStateChanged;
    procedure UpdateBounds(const ABounds: TRect);

    // IcxHotTrackElement
    function GetHintBounds: TRect;
    function IsNeedHint(ACanvas: TcxCanvas; const P: TPoint;
      out AText: TCaption;
      out AIsMultiLine: Boolean;
      out ATextRect: TRect; var IsNeedOffsetHint: Boolean): Boolean;
    procedure UpdateHotTrackState(const APoint: TPoint);

    procedure MouseDown(AButton: TMouseButton; X, Y: Integer);
    procedure MouseLeave;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseUp(AButton: TMouseButton; X, Y: Integer);

    property OwnerControl: TcxExtEditingControl read GetOwnerControl;
  public
    constructor Create(AOwner: TObject); override;
    destructor Destroy; override;
  end;

  { TcxControlFindPanelItemViewInfo }

  TcxControlFindPanelItemViewInfo = class(TcxCustomViewInfoItem,
    IcxMouseCaptureObject,
    IcxMouseTrackingCaller,
    IcxMouseTrackingCaller2)
  private
    FFindPanelViewInfo: TcxControlFindPanelViewInfo;
    FState: TcxButtonState;

    function GetFindPanel: TcxControlFindPanel;
    function GetMouseCapture: Boolean;
    function GetState: TcxButtonState;
    procedure SetMouseCapture(AValue: Boolean);
    procedure SetState(AValue: TcxButtonState);
  protected
    { IcxMouseCaptureObject }
    procedure DoCancelMode; virtual;
    { IcxMouseTrackingCaller }
    procedure TrackingMouseLeave;
    procedure IcxMouseTrackingCaller.MouseLeave = TrackingMouseLeave;
    { IcxMouseTrackingCaller2 }
    procedure MouseLeave; virtual;
    function PtInCaller(const P: TPoint): Boolean; virtual;

    procedure Click; virtual;
    procedure DoCalculate; override;
    procedure DoDraw(ACanvas: TcxCanvas); override;
    function GetControl: TcxEditingControl; override;
    function GetFocused: Boolean; virtual; abstract;
    function GetFocusRect(ACanvas: TcxCanvas): TRect; virtual;
    function GetHeight: Integer; virtual; abstract;
    function GetWidth: Integer; virtual; abstract;
    function HasPoint(const APoint: TPoint): Boolean; virtual;

    property FindPanel: TcxControlFindPanel read GetFindPanel;
    property FindPanelViewInfo: TcxControlFindPanelViewInfo read FFindPanelViewInfo;
    property Focused: Boolean read GetFocused;
    property Height: Integer read GetHeight;
    property MouseCapture: Boolean read GetMouseCapture write SetMouseCapture;
    property State: TcxButtonState read GetState write SetState;
    property Width: Integer read GetWidth;
  public
    constructor Create(AFindPanelViewInfo: TcxControlFindPanelViewInfo); reintroduce; virtual;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
  end;

  { TcxControlFindPanelCloseButtonViewInfo }

  TcxControlFindPanelCloseButtonViewInfo = class(TcxControlFindPanelItemViewInfo)
  protected
    procedure Click; override;
    procedure DoDraw(ACanvas: TcxCanvas); override;
    function GetFocused: Boolean; override;
    function GetHeight: Integer; override;
    function GetWidth: Integer; override;
  end;

  { TcxControlFindPanelButtonViewInfo }

  TcxControlFindPanelButtonViewInfo = class(TcxControlFindPanelItemViewInfo)
  private
    function GetTextHeight: Integer;
    function GetTextWidth: Integer;
  protected
    procedure DoDraw(ACanvas: TcxCanvas); override;
    function GetHeight: Integer; override;
    function GetText: string; virtual; abstract;
    function GetWidth: Integer; override;

    property Text: string read GetText;
    property TextHeight: Integer read GetTextHeight;
    property TextWidth: Integer read GetTextWidth;
  end;

  { TcxControlFindPanelFindButtonViewInfo }

  TcxControlFindPanelFindButtonViewInfo = class(TcxControlFindPanelButtonViewInfo)
  protected
    procedure Click; override;
    function GetFocused: Boolean; override;
    function GetText: string; override;
  end;

  { TcxControlFindPanelClearButtonViewInfo }

  TcxControlFindPanelClearButtonViewInfo = class(TcxControlFindPanelButtonViewInfo)
  protected
    procedure Click; override;
    function GetFocused: Boolean; override;
    function GetText: string; override;
  end;

  { TcxControlFindPanelEditViewInfo }

  TcxControlFindPanelEditViewInfo = class(TcxControlFindPanelItemViewInfo)
  protected
    procedure DoCalculate; override;
    procedure DoDraw(ACanvas: TcxCanvas); override;
    function GetFocused: Boolean; override;
    function GetHeight: Integer; override;
    function GetWidth: Integer; override;

    procedure ShowEdit;
    procedure HideEdit;
  end;

  { TcxControlFindPanelViewInfo }

  TcxControlFindPanelViewInfo = class(TcxCustomViewInfoItem)
  private
    FClearButtonViewInfo: TcxControlFindPanelClearButtonViewInfo;
    FCloseButtonViewInfo: TcxControlFindPanelCloseButtonViewInfo;
    FEditViewInfo: TcxControlFindPanelEditViewInfo;
    FFindButtonViewInfo: TcxControlFindPanelFindButtonViewInfo;

    function GetControlViewInfo: TcxCustomControlViewInfo;
    function GetEditHeight: Integer;
    function GetEditWidth: Integer;
    function GetFindPanel: TcxControlFindPanel;
  protected
    procedure CalculateClearButton; virtual;
    procedure CalculateCloseButton; virtual;
    procedure CalculateEdit; virtual;
    procedure CalculateFindButton; virtual;
    procedure CalculateViewParams; virtual;
    procedure CheckClipping(const ADisplayRect: TRect; const AAvailableRect: TRect); override;
    procedure DoCalculate; override;
    procedure DoDraw(ACanvas: TcxCanvas); override;
    procedure DrawBackground(ACanvas: TcxCanvas); virtual;
    procedure DrawBorders(ACanvas: TcxCanvas); virtual;
    procedure DrawItems(ACanvas: TcxCanvas); virtual;
    function GetBorders: TcxBorders; virtual;
    function GetControl: TcxEditingControl; override;
    function GetFirstOffset: Integer; virtual;
    function GetHeight: Integer; virtual;
    function GetHitTest(AHitTest: TcxCustomHitTestController): Boolean; override;
    function GetItemsOffset: Integer; virtual;
    function GetItemFromPoint(const APoint: TPoint): TcxControlFindPanelItemViewInfo; virtual;
    function GetWidth: Integer; virtual;
    function IsClearButtonVisible: Boolean; virtual;
    function IsCloseButtonVisible: Boolean; virtual;
    function IsFindButtonVisible: Boolean; virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;

    property Borders: TcxBorders read GetBorders;
    property ControlViewInfo: TcxCustomControlViewInfo read GetControlViewInfo;
    property ClearButtonViewInfo: TcxControlFindPanelClearButtonViewInfo read FClearButtonViewInfo;
    property CloseButtonViewInfo: TcxControlFindPanelCloseButtonViewInfo read FCloseButtonViewInfo;
    property EditHeight: Integer read GetEditHeight;
    property EditViewInfo: TcxControlFindPanelEditViewInfo read FEditViewInfo;
    property EditWidth: Integer read GetEditWidth;
    property FindButtonViewInfo: TcxControlFindPanelFindButtonViewInfo read FFindButtonViewInfo;
    property FindPanel: TcxControlFindPanel read GetFindPanel;
    property FirstOffset: Integer read GetFirstOffset;
    property Height: Integer read GetHeight;
    property ItemsOffset: Integer read GetItemsOffset;
    property Width: Integer read GetWidth;
  public
    constructor Create(AOwner: TObject); override;
    destructor Destroy; override;
  end;

  { TcxCustomControlPainter }

  TcxCustomDrawViewInfoItemEvent = procedure(Sender: TObject; Canvas: TcxCanvas;
    AViewInfo: TcxCustomViewInfoItem; var ADone: Boolean) of object;

  TcxCustomControlPainter = class
  strict private
    FCanvas: TcxCanvas;
    FControl: TcxEditingControl;
    FSaveViewParams: TcxViewParams;

    function GetPainter: TcxCustomLookAndFeelPainter;
    function GetScaleFactor: TdxScaleFactor;
    function GetViewInfo: TcxCustomControlViewInfo;
  protected
    procedure AfterCustomDraw(AViewInfo: TcxCustomViewInfoItem); overload; virtual;
    procedure BeforeCustomDraw(AViewInfo: TcxCustomViewInfoItem); overload; virtual;
    function DoCustomDraw(AViewInfoItem: TcxCustomViewInfoItem; AEvent: TcxCustomDrawViewInfoItemEvent): Boolean;
    procedure DoPaintEditCell(ACellViewInfo: TcxEditCellViewInfo; AIsExcludeRect: Boolean = True); virtual;
    procedure DoPaint; virtual;
    procedure DrawFindPanel; virtual;
  public
    constructor Create(AOwner: TcxEditingControl); virtual;
    procedure Paint(ACanvas: TcxCanvas); virtual;

    property Canvas: TcxCanvas read FCanvas write FCanvas;
    property Control: TcxEditingControl read FControl;
    property Painter: TcxCustomLookAndFeelPainter read GetPainter;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property ViewInfo: TcxCustomControlViewInfo read GetViewInfo;
  end;

  TcxCustomControlPainterClass = class of TcxCustomControlPainter;

  TcxExtEditingControlPainter = class(TcxCustomControlPainter)
  private
    function GetViewInfo: TcxExtEditingControlViewInfo;
  protected
    procedure DrawNavigator; virtual;
    property ViewInfo: TcxExtEditingControlViewInfo read GetViewInfo;
  end;

  { TcxCustomControlStyles }

  TcxCustomControlStylesClass = class of TcxCustomControlStyles;

  TcxCustomControlStyles = class(TcxStyles)
  private
    FOnGetContentStyle: TcxOnGetContentStyleEvent;
    function GetControl: TcxEditingControl;
    function GetPainter: TcxCustomLookAndFeelPainter;
  protected
    procedure Changed(AIndex: Integer); override;
    procedure GetDefaultViewParams(Index: Integer; AData: TObject;
      out AParams: TcxViewParams); override;
    function GetFindPanelDefaultColor: TColor; virtual;
    function GetFindPanelDefaultTextColor: TColor; virtual;

    property Navigator: TcxStyle index ecs_Navigator read GetValue write SetValue;
    property NavigatorInfoPanel: TcxStyle index ecs_NavigatorInfoPanel read GetValue write SetValue;
  public
    procedure Assign(Source: TPersistent); override;
    function GetBackgroundParams: TcxViewParams;
    function GetFindPanelParams: TcxViewParams;
    function GetSearchResultHighlight: TcxViewParams;
    function GetSelectionParams: TcxViewParams;
    property Control: TcxEditingControl read GetControl;
    property LookAndFeelPainter: TcxCustomLookAndFeelPainter read GetPainter;
  published
    property Background: TcxStyle index ecs_Background read GetValue write SetValue;
    property Content: TcxStyle index ecs_Content read GetValue write SetValue;
    property FindPanel: TcxStyle index ecs_FindPanel read GetValue write SetValue;
    property Inactive: TcxStyle index ecs_Inactive read GetValue write SetValue;
    property SearchResultHighlight: TcxStyle index ecs_SearchResultHighlight read GetValue write SetValue;
    property Selection: TcxStyle index ecs_Selection read GetValue write SetValue;
    property OnGetContentStyle: TcxOnGetContentStyleEvent read FOnGetContentStyle write FOnGetContentStyle;
    property StyleSheet;
  end;

  { TcxEditingControl }

  IcxEditingControlOptions = interface
  ['{6A041541-53E2-413B-8377-0D249356B5DF}']
    function GetOptionsBehavior: TcxControlOptionsBehavior;
    function GetOptionsData: TcxControlOptionsData;
    function GetOptionsFindPanel: TcxControlOptionsFindPanel;
    function GetOptionsView: TcxControlOptionsView;
    property OptionsBehavior: TcxControlOptionsBehavior read GetOptionsBehavior;
    property OptionsData: TcxControlOptionsData read GetOptionsData;
    property OptionsFindPanel: TcxControlOptionsFindPanel read GetOptionsFindPanel;
    property OptionsView: TcxControlOptionsView read GetOptionsView;
  end;

  TcxecEditingEvent = procedure(Sender, AItem: TObject; var Allow: Boolean) of object;
  TcxecInitEditEvent = procedure(Sender, AItem: TObject; AEdit: TcxCustomEdit) of object;
  TcxecInitEditValueEvent = procedure(Sender, AItem: TObject; AEdit: TcxCustomEdit; var AValue: TcxEditValue) of object;
  TcxecItemEvent = procedure(Sender: TObject; AItem: TcxCustomInplaceEditContainer) of object;
  TcxecFindPanelVisibilityChangedEvent = procedure(Sender: TObject; const AVisible: Boolean) of object;

  TcxEditingControl = class(TcxControl, IcxMouseTrackingCaller)
  private
    FBrushCache: TcxBrushCache;
    FChangesCount: Integer;
    FContainerList: TList;
    FDesignSelectionHelper: TcxCustomDesignSelectionHelper;
    FDragHelper: TcxDragImageHelper;
    FDragPos: TPoint;
    FEditStyle: TcxCustomEditStyle;
    FStyles: TcxCustomControlStyles;
    FSubClassesCreated: Boolean;
    FViewInfo: TcxCustomControlViewInfo;
    FOnCustomDrawCell: TcxCustomDrawViewInfoItemEvent;
    FOnEditChanged: TcxecItemEvent;
    FOnEdited: TcxecItemEvent;
    FOnEditing: TcxecEditingEvent;
    FOnEditValueChanged: TcxecItemEvent;
    FOnFindPanelVisibilityChanged: TcxecFindPanelVisibilityChangedEvent;
    FOnInitEdit: TcxecInitEditEvent;
    FOnInitEditValue: TcxecInitEditValueEvent;
    procedure IcxMouseTrackingCaller.MouseLeave = DoMouseLeave;
    function GetBufferedPaint: Boolean;
    function GetPainter: TcxCustomControlPainter;
    procedure DoMouseLeave;
    procedure SetBufferedPaint(Value: Boolean);
    procedure SetEditStyle(Value: TcxCustomEditStyle);
    procedure SetStyles(Value: TcxCustomControlStyles);
    procedure WMCancelMode(var Message: TWMCancelMode); message WM_CANCELMODE;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SetCursor;
  protected
    FController: TcxCustomControlController;
    FDataController: TcxCustomDataController;
    FLockUpdate: Integer;
    procedure AfterLayoutChanged; virtual;
    procedure BeginAutoDrag; override;
    procedure BeforeUpdate; virtual;
    function CanUpdateScrollBars: Boolean; override;
    procedure CheckCreateDesignSelectionHelper; virtual;
    procedure CreateSubClasses; virtual;
    procedure ControlUpdateData(AInfo: TcxUpdateControlInfo); virtual;
    procedure DataChanged; virtual;
    procedure DataLayoutChanged; virtual;
    procedure DestroyDesignSelectionHelper;
    procedure DestroySubClasses; virtual;
    procedure DoBeginUpdate; virtual;
    procedure DoEndUpdate; virtual;
    procedure DoEditChanged(AItem: TcxCustomInplaceEditContainer); virtual;
    procedure DoEdited(AItem: TcxCustomInplaceEditContainer); virtual;
    function DoEditing(AItem: TcxCustomInplaceEditContainer): Boolean; virtual;
    procedure DoEditValueChanged(AItem: TcxCustomInplaceEditContainer); virtual;
    procedure DoFindPanelVisibilityChanged(AVisible: Boolean); virtual;
    procedure DoGetCellHint(ACell: TObject; var AText: string; var ANeedShow: Boolean); virtual;
    procedure DoInitEdit(AItem: TcxCustomInplaceEditContainer; AEdit: TcxCustomEdit); virtual;
    procedure DoInitEditValue(AItem: TcxCustomInplaceEditContainer; AEdit: TcxCustomEdit; var AValue: TcxEditValue); virtual;
    procedure DoInplaceEditContainerItemAdded(AItem: TcxCustomInplaceEditContainer); virtual;
    procedure DoInplaceEditContainerItemRemoved(AItem: TcxCustomInplaceEditContainer); virtual;
    procedure DoLayoutChanged; virtual;
    function NeedCallChangedOnItemRemoved(AItem: TcxCustomInplaceEditContainer): Boolean; virtual;
    function NeedHighlightFindText: Boolean;

    function GetControllerClass: TcxCustomControlControllerClass; virtual;    // TODO: need overriding
    function GetControlStylesClass: TcxCustomControlStylesClass; virtual;
    function GetDataControllerClass: TcxCustomDataControllerClass; virtual;
    function GetDragImageHelperClass: TcxDragImageHelperClass; virtual;
    function GetEditStyleClass: TcxCustomEditStyleClass; virtual;
    function GetEditingControllerClass: TcxEditingControllerClass; virtual;
    function GetHitTestControllerClass: TcxHitTestControllerClass; virtual;
    function GetHotTrackControllerClass: TcxHotTrackControllerClass; virtual;
    function GetViewInfoClass: TcxCustomControlViewInfoClass; virtual;
    function GetOptions: IcxEditingControlOptions; virtual;
    function GetPainterClass: TcxCustomControlPainterClass; virtual;

    function GetHintHidePause: Integer; virtual;
    function IsDoubleBufferedNeeded: Boolean; override;
    function IsLocked: Boolean; virtual;
    procedure RecreateViewInfo; virtual;
    procedure SelectionChanged(AInfo: TcxSelectionChangedInfo); virtual;
    procedure UpdateIndexes;
    procedure UpdateViewStyles;
    procedure UpdateData; virtual;
    // VCL methods
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure DoExit; override;
    procedure DblClick; override;
    procedure FocusChanged; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseEnter(AControl: TControl); override;
    procedure MouseLeave(AControl: TControl); override;
    procedure DoPaint; override;
    procedure WndProc(var Message: TMessage); override;

    // cxControl's
    procedure AfterMouseDown(AButton: TMouseButton; X, Y: Integer); override;
    procedure BoundsChanged; override;
    function CanDrag(X, Y: Integer): Boolean; override;
    procedure DoCancelMode; override;
    procedure FontChanged; override;
    function GetCurrentCursor(X, Y: Integer): TCursor; override;
    function GetDesignHitTest(X, Y: Integer; Shift: TShiftState): Boolean; override;
    function GetIsFocused: Boolean; override;
    function GetMouseWheelScrollingKind: TcxMouseWheelScrollingKind; override;
    procedure InitControl; override;
    function IsPanArea(const APoint: TPoint): Boolean; override;
    function IsPixelScrollBar(AKind: TScrollBarKind): Boolean; override;
    procedure LookAndFeelChanged(Sender: TcxLookAndFeel;
      AChangedValues: TcxLookAndFeelValues); override;
    function MayFocus: Boolean; override;
    // drag'n'drop
    procedure DoEndDrag(Target: TObject; X, Y: Integer); override;
    procedure DoStartDrag(var DragObject: TDragObject); override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean); override;
    function DragDropImageDisplayRect: TRect; virtual;
    procedure DrawDragDropImage(ADragBitmap: TBitmap; ACanvas: TcxCanvas); virtual;
    procedure FinishDragImages;
    function HasDragDropImages: Boolean; virtual;
    // scrollbars
    function GetMainScrollBarsClass: TcxControlCustomScrollBarsClass; override;
    function GetScrollContentForegroundColor: TColor; override;
    procedure InitScrollBarsParameters; override;
    procedure Scroll(AScrollBarKind: TScrollBarKind; AScrollCode: TScrollCode;
      var AScrollPos: Integer); override;

    procedure DragAndDrop(const P: TPoint; var Accepted: Boolean); override;
    procedure EndDragAndDrop(Accepted: Boolean); override;
    function GetDragAndDropObjectClass: TcxDragAndDropObjectClass; override;
    function StartDragAndDrop(const P: TPoint): Boolean; override;

    property BrushCache: TcxBrushCache read FBrushCache;
    property ContainerList: TList read FContainerList;
    property Controller: TcxCustomControlController read FController;
    property ChangesCount: Integer read FChangesCount;
    property DragPos: TPoint read FDragPos write FDragPos;
    property DataController: TcxCustomDataController read FDataController;
    property DesignSelectionHelper: TcxCustomDesignSelectionHelper read FDesignSelectionHelper;
    property DragHelper: TcxDragImageHelper read FDragHelper;
    property EditStyle: TcxCustomEditStyle read FEditStyle write SetEditStyle;
    property Options: IcxEditingControlOptions read GetOptions;
    property Painter: TcxCustomControlPainter read GetPainter;
    property Styles: TcxCustomControlStyles read FStyles write SetStyles;
    property SubClassesCreated: Boolean read FSubClassesCreated;
    property ViewInfo: TcxCustomControlViewInfo read FViewInfo write FViewInfo;
    property OnCustomDrawCell: TcxCustomDrawViewInfoItemEvent read FOnCustomDrawCell write FOnCustomDrawCell;
    property OnEditChanged: TcxecItemEvent read FOnEditChanged write FOnEditChanged;
    property OnEdited: TcxecItemEvent read FOnEdited write FOnEdited;
    property OnEditing: TcxecEditingEvent read FOnEditing write FOnEditing;
    property OnEditValueChanged: TcxecItemEvent read FOnEditValueChanged write FOnEditValueChanged;
    property OnFindPanelVisibilityChanged: TcxecFindPanelVisibilityChangedEvent read FOnFindPanelVisibilityChanged
      write FOnFindPanelVisibilityChanged;
    property OnInitEdit: TcxecInitEditEvent read FOnInitEdit write FOnInitEdit;
    property OnInitEditValue: TcxecInitEditValueEvent read FOnInitEditValue write FOnInitEditValue;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate;
    procedure BeginDragAndDrop; override;
    procedure CancelUpdate;
    procedure EndUpdate;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    procedure DragDrop(Source: TObject; X, Y: Integer); override;
    procedure LayoutChanged;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    property BufferedPaint: Boolean read GetBufferedPaint write SetBufferedPaint stored False;
    property LockUpdate: Integer read FLockUpdate;
    property DragCursor default crDefault;
    property TabStop default True;
  published
    property BorderStyle default cxcbsDefault;
  end;

  { TcxExtEditingControl }

  TcxExtEditingControl = class(TcxEditingControl,  IcxEditingControlOptions,
    IcxNavigatorOwner, IcxNavigatorOwner2, IcxNavigatorRecordPosition)
  private
    FFindPanel: TcxControlOptionsFindPanel;
    FNavigator: TcxControlNavigator;
    FNavigatorEvents: TNotifyEvent;
    FOptionsBehavior: TcxControlOptionsBehavior;
    FOptionsData: TcxControlOptionsData;
    FOptionsView: TcxControlOptionsView;
    // IcxEditingControlOptions
    function GetOptionsBehavior: TcxControlOptionsBehavior;
    function GetOptionsData: TcxControlOptionsData;
    function GetOptionsFindPanel: TcxControlOptionsFindPanel;
    function GetOptionsView: TcxControlOptionsView;
    function GetViewInfo: TcxExtEditingControlViewInfo;

    procedure SetFindPanel(AValue: TcxControlOptionsFindPanel);
    procedure SetNavigator(Value: TcxControlNavigator);
    procedure SetOptionsBehavior(Value: TcxControlOptionsBehavior);
    procedure SetOptionsData(Value: TcxControlOptionsData);
    procedure SetOptionsView(Value: TcxControlOptionsView);
  protected
    function AllowTouchScrollUIMode: Boolean; override;
    procedure ChangeScaleEx(M, D: Integer; isDpiChange: Boolean); override;
    function GetClientBounds: TRect; override;
    function GetHScrollBarBounds: TRect; override;
    function GetNavigatorButtonsControl: IcxNavigator; virtual;
    function GetVScrollBarBounds: TRect; override;
    function HasScrollBarArea: Boolean; override;
    procedure SetPaintRegion; override;
    // IcxNavigatorOwner
    procedure NavigatorChanged(AChangeType: TcxNavigatorChangeType); virtual;
    function GetNavigatorBounds: TRect; virtual;
    function GetNavigatorButtons: TcxCustomNavigatorButtons; virtual;
    function GetNavigatorCanvas: TCanvas; virtual;
    function GetNavigatorControl: TWinControl; virtual;
    function GetNavigatorFocused: Boolean; virtual;
    function GetNavigatorLookAndFeel: TcxLookAndFeel; virtual;
    function GetNavigatorOwner: TComponent; virtual;
    function GetNavigatorShowHint: Boolean; virtual;
    function GetNavigatorTabStop: Boolean; virtual;
    procedure NavigatorStateChanged; virtual;
    procedure RefreshNavigator; virtual;
    // IcxNavigatorOwner2
    function GetNavigatorInfoPanel: TcxCustomNavigatorInfoPanel; virtual;
    // IcxNavigatorRecordPosition
    function IcxNavigatorRecordPosition.GetRecordCount = NavigatorGetRecordCount;
    function IcxNavigatorRecordPosition.GetRecordIndex = NavigatorGetRecordIndex;
    function NavigatorGetRecordCount: Integer; virtual;
    function NavigatorGetRecordIndex: Integer; virtual;

    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    function GetFindPanelOptionsClass: TcxControlOptionsFindPanelClass; virtual;
    function GetHintHidePause: Integer; override;
    function GetNavigatorClass: TcxControlNavigatorClass; virtual;
    function GetOptions: IcxEditingControlOptions; override;
    function GetOptionsBehaviorClass: TcxControlOptionsBehaviorClass; virtual;
    function GetOptionsDataClass: TcxControlOptionsDataClass; virtual;
    function GetOptionsViewClass: TcxControlOptionsViewClass; virtual;
    function GetPainterClass: TcxCustomControlPainterClass; override;
    function GetViewInfoClass: TcxCustomControlViewInfoClass; override;

    property FindPanel: TcxControlOptionsFindPanel read FFindPanel write SetFindPanel;
    property Navigator: TcxControlNavigator read FNavigator write SetNavigator;
    property NavigatorEvents: TNotifyEvent read FNavigatorEvents write FNavigatorEvents;
    property OptionsBehavior: TcxControlOptionsBehavior read GetOptionsBehavior write SetOptionsBehavior;
    property OptionsData: TcxControlOptionsData read GetOptionsData write SetOptionsData;
    property OptionsView: TcxControlOptionsView read GetOptionsView write SetOptionsView;
    property ViewInfo: TcxExtEditingControlViewInfo read GetViewInfo;
  end;

procedure cxAssignEditStyle(AViewInfo: TcxEditCellViewInfo);
function cxPtInViewInfoItem(AItem: TcxCustomViewInfoItem; const APoint: TPoint): Boolean;

function cxInRange(Value: Integer; AMin, AMax: Integer): Boolean;
function cxRange(var Value: Integer; AMin, AMax: Integer): Boolean;
function cxSetValue(Condition: Boolean; ATrueValue, AFalseValue: Integer): Integer;

function cxConfirmMessageBox(const AText, ACaption: string): Boolean;

const
  cxIntOffs: array[Boolean] of Integer = (-1, 1);
  cxDesignSelectionHelperClass: TcxCustomDesignSelectionHelperClass = nil;

implementation

uses
  Math, dxHooks, dxDPIAwareUtils;

const
  cxControlFindPanelItemsOffset = 4;
  cxControlFindPanelItemsFirstOffset = 12;
  cxControlFindPanelEditMinWidth = 52;
  cxControlFindPanelEditMaxWidth = 348;
  cxControlFindPanelButtonMinWidth = 60;
  cxControlFindPanelButtonMinHeight = 22;

type
  TControlAccess = class(TControl);
  TcxControlAccess = class(TcxControl);
  TcxCustomEditAccess = class(TcxCustomEdit);
  TcxCustomEditStyleAccess = class(TcxCustomEditStyle);
  TcxCustomEditViewDataAccess = class(TcxCustomEditViewData);
  TcxDragAndDropObjectAccess = class(TcxDragAndDropObject);

  PIntArray = ^TIntArray;
  TIntArray = array[0..MaxInt div SizeOf(Integer) - 1] of Integer;

var
  cxDragControl: TcxEditingControl;

procedure cxAssignEditStyle(AViewInfo: TcxEditCellViewInfo);
var
  AStyle: TcxCustomEditStyleAccess;
begin
  AStyle := TcxCustomEditStyleAccess(AViewInfo.Control.EditStyle);
  with AViewInfo do
  begin
    AStyle.FAssignedValues := AStyle.FAssignedValues - [svFont] + [svColor, svButtonTransparency];
    if ViewParams.Font = nil then
      AStyle.StyleData.Font := GetEditViewParams.Font
    else
      AStyle.StyleData.Font := ViewParams.Font;
    AStyle.StyleData.Color := ViewParams.Color;
    AStyle.StyleData.FontColor := ViewParams.TextColor;
    AStyle.ButtonTransparency := GetButtonTransparency;
    AStyle.Changed;
    ViewInfo.Transparent := IsTransparent;
  end;
end;

procedure cxDragMouseHook(ACode: Integer; wParam: WPARAM; lParam: LPARAM; var AHookResult: LRESULT);
begin
  if (cxDragControl <> nil) then
  begin
    case WParam of
      WM_MOUSEMOVE:
      begin
        with cxDragControl do
          if Dragging then
            DragHelper.DragAndDrop(PMouseHookStruct(LParam).Pt);
      end;
      WM_LBUTTONUP, WM_RBUTTONUP:
        cxDragControl.FinishDragImages;
    end;
  end;
end;

procedure cxInstallMouseHookForDragControl(AControl: TcxEditingControl);
begin
  cxDragControl := AControl;
  dxSetHook(htMouse, cxDragMouseHook);
end;

procedure cxResetMouseHookForDragControl;
begin
  dxReleaseHook(cxDragMouseHook);
  cxDragControl := nil;
end;

{ TcxControlFindPanel }

constructor TcxControlFindPanel.Create(AController: TcxCustomControlController);
begin
  FController := AController;
  inherited Create;
end;

procedure TcxControlFindPanel.Changed;
begin
  EditingControl.LayoutChanged;
end;

procedure TcxControlFindPanel.ApplyText(const AText: string);
begin
  Controller.ApplyFindFilterText(AText);
end;

procedure TcxControlFindPanel.ClearText;
begin
  Controller.ClearFindFilterText;
end;

procedure TcxControlFindPanel.FocusChanged;
begin
  EditingControl.FocusChanged;
end;

procedure TcxControlFindPanel.FocusControl;
begin
  EditingControl.SetFocus;
end;

function TcxControlFindPanel.FocusData: Boolean;
begin
  Controller.FocusedRecordIndex := 0;
  Result := Controller.FocusedRecordIndex = 0;
end;

procedure TcxControlFindPanel.GetContentViewParams(var AParams: TcxViewParams);
begin
  EditingControl.Styles.GetViewParams(ecs_Content, nil, nil, AParams);
end;

function TcxControlFindPanel.GetEditLookAndFeel: TcxLookAndFeel;
begin
  Result := EditingControl.LookAndFeel;
end;

function TcxControlFindPanel.GetOwner: TComponent;
begin
  Result := EditingControl;
end;

function TcxControlFindPanel.GetParent: TWinControl;
begin
  Result := EditingControl;
end;

function TcxControlFindPanel.GetText: string;
begin
  Result := Controller.GetFindFilterText;
end;

function TcxControlFindPanel.GetUseExtendedSyntax: Boolean;
begin
  Result := EditingControl.DataController.UseExtendedFindFilterTextSyntax;
end;

procedure TcxControlFindPanel.GetViewParams(var AParams: TcxViewParams);
begin
  AParams := EditingControl.Styles.GetFindPanelParams;
end;

procedure TcxControlFindPanel.VisibilityChanged;
begin
  inherited VisibilityChanged;
  if not Controller.GetGoToNextCellOnTab then
    if Visible then
      EditingControl.Keys := EditingControl.Keys + [kTab]
    else
      EditingControl.Keys := EditingControl.Keys - [kTab];
  EditingControl.DoFindPanelVisibilityChanged(Visible);
end;

procedure TcxControlFindPanel.SetUseExtendedSyntax(AValue: Boolean);
begin
  EditingControl.DataController.UseExtendedFindFilterTextSyntax := AValue;
end;

function TcxControlFindPanel.GetEditingControl: TcxEditingControl;
begin
  Result := Controller.EditingControl;
end;

{ TcxControlOptionsFindPanel }

procedure TcxControlOptionsFindPanel.Assign(Source: TPersistent);
var
  AOptions: TcxControlOptionsFindPanel;
begin
  inherited Assign(Source);
  if Source is TcxControlOptionsFindPanel then
  begin
    AOptions := TcxControlOptionsFindPanel(Source);
    Options := AOptions.Options;
  end;
end;

function TcxControlOptionsFindPanel.GetApplyInputDelay: Integer;
begin
  Result := Options.ApplyInputDelay;
end;

function TcxControlOptionsFindPanel.GetClearFindFilterTextOnClose: Boolean;
begin
  Result := Options.ClearOnClose;
end;

function TcxControlOptionsFindPanel.GetDisplayMode: TcxFindPanelDisplayMode;
begin
  Result := Options.DisplayMode;
end;

function TcxControlOptionsFindPanel.GetEditingControl: TcxEditingControl;
begin
  Result := TcxEditingControl(Owner);
end;

function TcxControlOptionsFindPanel.GetFocusContentOnApplyFilter: Boolean;
begin
  Result := Options.FocusContentOnApply;
end;

function TcxControlOptionsFindPanel.GetHighlightSearchResults: Boolean;
begin
  Result := Options.HighlightSearchResults;
end;

function TcxControlOptionsFindPanel.GetInfoText: string;
begin
  Result := Options.InfoText;
end;

function TcxControlOptionsFindPanel.GetOptions: TcxFindPanelOptions;
begin
  Result := EditingControl.Controller.FindPanel.Options;
end;

function TcxControlOptionsFindPanel.GetMRUItems: TStrings;
begin
  Result := Options.MRUItems;
end;

function TcxControlOptionsFindPanel.GetMRUItemsListCount: Integer;
begin
  Result := Options.MRUItemsListCount;
end;

function TcxControlOptionsFindPanel.GetMRUItemsListDropDownCount: Integer;
begin
  Result := Options.MRUItemsListDropDownCount;
end;

function TcxControlOptionsFindPanel.GetPosition: TcxFindPanelPosition;
begin
  Result := Options.Position;
end;

function TcxControlOptionsFindPanel.GetShowClearButton: Boolean;
begin
  Result := Options.ShowClearButton;
end;

function TcxControlOptionsFindPanel.GetShowCloseButton: Boolean;
begin
  Result := Options.ShowCloseButton;
end;

function TcxControlOptionsFindPanel.GetShowFindButton: Boolean;
begin
  Result := Options.ShowFindButton;
end;

function TcxControlOptionsFindPanel.GetUseDelayedFind: Boolean;
begin
  Result := Options.UseDelayedFind;
end;

function TcxControlOptionsFindPanel.GetUseExtendedSyntax: Boolean;
begin
  Result := Options.UseExtendedSyntax;
end;

function TcxControlOptionsFindPanel.IsInfoTextStored: Boolean;
begin
  Result := Options.InfoTextAssigned;
end;

procedure TcxControlOptionsFindPanel.SetApplyInputDelay(AValue: Integer);
begin
  Options.ApplyInputDelay := AValue;
end;

procedure TcxControlOptionsFindPanel.SetClearFindFilterTextOnClose(AValue: Boolean);
begin
  Options.ClearOnClose := AValue;
end;

procedure TcxControlOptionsFindPanel.SetDisplayMode(AValue: TcxFindPanelDisplayMode);
begin
  Options.DisplayMode := AValue;
end;

procedure TcxControlOptionsFindPanel.SetFocusContentOnApplyFilter(AValue: Boolean);
begin
  Options.FocusContentOnApply := AValue;
end;

procedure TcxControlOptionsFindPanel.SetHighlightSearchResults(AValue: Boolean);
begin
  Options.HighlightSearchResults := AValue;
end;

procedure TcxControlOptionsFindPanel.SetInfoText(AValue: string);
begin
  Options.InfoText := AValue;
end;

procedure TcxControlOptionsFindPanel.SetOptions(AValue: TcxFindPanelOptions);
begin
  EditingControl.Controller.FindPanel.Options := AValue;
end;

procedure TcxControlOptionsFindPanel.SetMRUItems(AValue: TStrings);
begin
  Options.MRUItems := AValue;
end;

procedure TcxControlOptionsFindPanel.SetMRUItemsListCount(AValue: Integer);
begin
  Options.MRUItemsListCount := AValue;
end;

procedure TcxControlOptionsFindPanel.SetMRUItemsListDropDownCount(AValue: Integer);
begin
  Options.MRUItemsListDropDownCount := AValue;
end;

procedure TcxControlOptionsFindPanel.SetPosition(AValue: TcxFindPanelPosition);
begin
  Options.Position := AValue;
end;

procedure TcxControlOptionsFindPanel.SetShowClearButton(AValue: Boolean);
begin
  Options.ShowClearButton := AValue;
end;

procedure TcxControlOptionsFindPanel.SetShowCloseButton(AValue: Boolean);
begin
  Options.ShowCloseButton := AValue;
end;

procedure TcxControlOptionsFindPanel.SetShowFindButton(AValue: Boolean);
begin
  Options.ShowFindButton := AValue;
end;

procedure TcxControlOptionsFindPanel.SetUseExtendedSyntax(AValue: Boolean);
begin
  Options.UseExtendedSyntax := AValue;
end;

procedure TcxControlOptionsFindPanel.SetUseDelayedFind(AValue: Boolean);
begin
  Options.UseDelayedFind := AValue;
end;

{ TcxCustomItemDataBinding }

constructor TcxCustomItemDataBinding.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FDefaultValuesProvider := GetDefaultValuesProviderClass.Create(Self);
end;

destructor TcxCustomItemDataBinding.Destroy;
begin
  FreeAndNil(FDefaultValuesProvider);
  inherited Destroy;
end;

function TcxCustomItemDataBinding.DefaultRepositoryItem: TcxEditRepositoryItem;
begin
  Result := GetDefaultEditDataRepositoryItems.GetItem(GetValueTypeClass);
end;

function TcxCustomItemDataBinding.GetDefaultCaption: string;
begin
  Result := '';
end;

function TcxCustomItemDataBinding.GetDefaultValuesProvider(
  AProperties: TcxCustomEditProperties): IcxEditDefaultValuesProvider;
begin
  Result := DefaultValuesProvider;
end;

function TcxCustomItemDataBinding.GetDefaultValuesProviderClass: TcxCustomEditDefaultValuesProviderClass;
begin
  Result := TcxContainerItemDefaultValuesProvider;
end;

function TcxCustomItemDataBinding.GetFilterFieldName: string;
begin
  Result := '';
end;

function TcxCustomItemDataBinding.GetValueTypeClass: TcxValueTypeClass;
begin
  Result := TcxStringValueType;
end;

procedure TcxCustomItemDataBinding.Init;
begin
end;

function TcxCustomItemDataBinding.IsDisplayFormatDefined(
  AIsCurrencyValueAccepted: Boolean): Boolean;
begin
  Result :=
    DataController.IsDisplayFormatDefined(EditContainer.ItemIndex, not AIsCurrencyValueAccepted) or
    EditContainer.HasDataTextHandler;
end;

procedure TcxCustomItemDataBinding.ValueTypeClassChanged;
begin
  DataController.ChangeValueTypeClass(EditContainer.ItemIndex, GetValueTypeClass);
  EditContainer.InternalPropertiesChanged;
end;

function TcxCustomItemDataBinding.GetDataController: TcxCustomDataController;
begin
  Result := EditContainer.EditingControl.DataController;
end;

function TcxCustomItemDataBinding.GetEditContainer: TcxCustomInplaceEditContainer;
begin
  Result := TcxCustomInplaceEditContainer(GetOwner);
end;

{ TcxItemDataBinding }

procedure TcxItemDataBinding.Assign(Source: TPersistent);
begin
  if Source is TcxItemDataBinding then
  begin
    ValueType := TcxItemDataBinding(Source).ValueType;
    ValueTypeClass := TcxItemDataBinding(Source).ValueTypeClass;
  end;
end;

function TcxItemDataBinding.GetValueTypeClass: TcxValueTypeClass;
begin
  if FValueTypeClass = nil then
    Result := inherited GetValueTypeClass
  else
    Result := FValueTypeClass;
end;

function TcxItemDataBinding.IsValueTypeStored: Boolean;
begin
  Result := FValueTypeClass <> inherited GetValueTypeClass;
end;

function TcxItemDataBinding.GetValueType: string;
begin
  if ValueTypeClass = nil then
    Result := ''
  else
    Result := ValueTypeClass.Caption;
end;

procedure TcxItemDataBinding.SetValueType(const Value: string);
var
  ATypeClass: TcxValueTypeClass;
begin
  if ValueType <> Value then
  begin
    ATypeClass := cxValueTypeClassList.ItemByCaption(Value);
    if ATypeClass <> nil then
      ValueTypeClass := ATypeClass;
  end;
end;

procedure TcxItemDataBinding.SetValueTypeClass(Value: TcxValueTypeClass);
begin
  if ValueTypeClass <> Value then
  begin
    FValueTypeClass := Value;
    ValueTypeClassChanged;
  end;
end;

{ TcxControlDataController }

procedure TcxControlDataController.UpdateData;
begin
  GetControl.UpdateData;
end;

procedure TcxControlDataController.UpdateItemIndexes;
begin
  GetControl.UpdateIndexes;
  inherited UpdateItemIndexes;
end;

function TcxControlDataController.GetItem(Index: Integer): TObject;
begin
  Result := GetControl.FContainerList[Index];
end;

function TcxControlDataController.GetItemID(AItem: TObject): Integer;
begin
  if AItem is TcxCustomInplaceEditContainer then
    Result := TcxCustomInplaceEditContainer(AItem).ItemIndex
  else
    Result := -1;
end;

function TcxControlDataController.GetItemValueSource(
  AItemIndex: Integer): TcxDataEditValueSource;
begin
  with TcxCustomInplaceEditContainer(GetControl.FContainerList[AItemIndex]) do
    Result := PropertiesValue.GetEditValueSource(True);
end;

procedure TcxControlDataController.UpdateControl(AInfo: TcxUpdateControlInfo);
begin
  GetControl.ControlUpdateData(AInfo);
end;

function TcxControlDataController.GetControl: TcxEditingControl;
begin
  Result := TcxEditingControl(GetOwner);
end;

{ TcxContainerItemDefaultValuesProvider }

function TcxContainerItemDefaultValuesProvider.IsDisplayFormatDefined(
 AIsCurrencyValueAccepted: Boolean): Boolean;
begin
  Result := False;
end;

{ TcxCustomEditContainerItemOptions }

constructor TcxCustomEditContainerItemOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FMoving := True;
  FCustomizing := True;
  FSorting := True;
  FEditing := True;
  FFiltering := True;
  FFilteringWithFindPanel := True;
  FFocusing := True;
  FIncSearch := True;
  FShowEditButtons := eisbDefault;
  FTabStop := True;
end;

procedure TcxCustomEditContainerItemOptions.Assign(AOwner: TPersistent);
begin
  if AOwner is TcxCustomEditContainerItemOptions then
    with TcxCustomEditContainerItemOptions(AOwner) do
    begin
      Self.Customizing := Customizing;
      Self.Editing := Editing;
      Self.Filtering := Filtering;
      Self.FilteringWithFindPanel := FilteringWithFindPanel;
      Self.Focusing := Focusing;
      Self.IncSearch := IncSearch;
      Self.Moving := Moving;
      Self.ShowEditButtons := ShowEditButtons;
      Self.Sorting := Sorting;
      Self.TabStop := TabStop;
    end;
end;

procedure TcxCustomEditContainerItemOptions.Changed;
begin
  EditContainer.Changed;
end;

function TcxCustomEditContainerItemOptions.GetEditContainer: TcxCustomInplaceEditContainer;
begin
  Result := TcxCustomInplaceEditContainer(GetOwner);
end;

procedure TcxCustomEditContainerItemOptions.SetEditing(Value: Boolean);
begin
  if FEditing <> Value then
  begin
    FEditing := Value;
    if not Value then EditContainer.Editing := False;
  end;
end;

procedure TcxCustomEditContainerItemOptions.SetFiltering(Value: Boolean);
begin
  if FFiltering <> Value then
  begin
    FFiltering := Value;
    Changed;
  end;
end;

procedure TcxCustomEditContainerItemOptions.SetFilteringWithFindPanel(AValue: Boolean);
begin
  if AValue <> FFilteringWithFindPanel then
  begin
    FFilteringWithFindPanel := AValue;
    EditContainer.CheckUsingInFind;
  end;
end;

procedure TcxCustomEditContainerItemOptions.SetFocusing(Value: Boolean);
begin
  if FFocusing <> Value then
  begin
    FFocusing := Value;
    if not Value then EditContainer.Focused := False;
  end;
end;

procedure TcxCustomEditContainerItemOptions.SetIncSearch(Value: Boolean);
begin
  if FIncSearch <> Value then
  begin
    if not Value and EditContainer.IncSearching then
      EditContainer.CancelIncSearching;
    FIncSearch := Value;
  end;
end;

procedure TcxCustomEditContainerItemOptions.SetShowEditButtons(
  Value: TcxEditItemShowEditButtons);
begin
  if Value <> FShowEditButtons then
  begin
    FShowEditButtons := Value;
    Changed;
  end;
end;

{ TcxControlOptionsView }

constructor TcxControlOptionsView.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FShowEditButtons := GetDefaultShowEditButtons;
  FNavigatorOffset := cxInplaceNavigatorDefaultOffset;
end;

procedure TcxControlOptionsView.Assign(Source: TPersistent);
begin
  if Source is TcxControlOptionsView then
    with TcxControlOptionsView(Source) do
    begin
      Self.CellAutoHeight := CellAutoHeight;
      Self.CellEndEllipsis := CellEndEllipsis;
      Self.CellTextMaxLineCount := CellTextMaxLineCount;
      Self.ScrollBars := ScrollBars;
      Self.ShowEditButtons := ShowEditButtons;
      Self.NavigatorOffset := NavigatorOffset;
    end
end;

procedure TcxControlOptionsView.Changed;
begin
  EditingControl.LayoutChanged;
end;

procedure TcxControlOptionsView.ChangeScale(M, D: Integer);
begin
  NavigatorOffset := MulDiv(NavigatorOffset, M, D);
end;

function TcxControlOptionsView.GetDefaultShowEditButtons: TcxEditingControlEditShowButtons;
begin
  Result := ecsbNever;
end;

function TcxControlOptionsView.GetEditingControl: TcxEditingControl;
begin
  Result := TcxEditingControl(GetOwner);
end;

function TcxControlOptionsView.GetScrollBars: TcxScrollStyle;
begin
  Result := EditingControl.ScrollBars;
end;

function TcxControlOptionsView.IsShowEditButtonsStored: Boolean;
begin
  Result := ShowEditButtons <> GetDefaultShowEditButtons;
end;

procedure TcxControlOptionsView.SetCellAutoHeight(const Value: Boolean);
begin
  if FCellAutoHeight <> Value then
  begin
    FCellAutoHeight := Value;
    Changed;
  end;
end;

procedure TcxControlOptionsView.SetCellEndEllipsis(const Value: Boolean);
begin
  if FCellEndEllipsis <> Value then
  begin
    FCellEndEllipsis := Value;
    Changed;
  end;
end;

procedure TcxControlOptionsView.SetCellTextMaxLineCount(
  const Value: Integer);
begin
  if FCellTextMaxLineCount <> Value then
  begin
    FCellTextMaxLineCount := Value;
    Changed;
  end;
end;

procedure TcxControlOptionsView.SetNavigatorOffset(AValue: Integer);
begin
  if AValue < 0 then AValue := 0;
  if FNavigatorOffset <> AValue then
  begin
    FNavigatorOffset := AValue;
    Changed;
  end;
end;

procedure TcxControlOptionsView.SetScrollBars(const Value: TcxScrollStyle);
begin
  EditingControl.ScrollBars := Value;
end;

procedure TcxControlOptionsView.SetShowEditButtons(
  const Value: TcxEditingControlEditShowButtons);
begin
  if FShowEditButtons <> Value then
  begin
    FShowEditButtons := Value;
    Changed;
  end;
end;

{ TcxControlOptionsData }

constructor TcxControlOptionsData.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FCancelOnExit := True;
  FEditing := True;
end;

procedure TcxControlOptionsData.Assign(Source: TPersistent);
begin
  if Source is TcxControlOptionsData then
    with TcxControlOptionsData(Source) do
    begin
      Self.CancelOnExit := CancelOnExit;
      Self.Editing := Editing;
    end
end;

procedure TcxControlOptionsData.Changed;
begin
end;

function TcxControlOptionsData.GetEditingControl: TcxEditingControl;
begin
  Result := TcxEditingControl(GetOwner)
end;

procedure TcxControlOptionsData.SetEditing(Value: Boolean);
begin
  if FEditing <> Value then
  begin
    FEditing := Value;
    if not Value then
      EditingControl.Controller.EditingItem := nil;
    Changed;
  end;
end;

{ TcxControlOptionsBehavior }

constructor TcxControlOptionsBehavior.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FImmediateEditor := True;
end;

procedure TcxControlOptionsBehavior.Assign(Source: TPersistent);
begin
  if Source is TcxControlOptionsBehavior then
    with TcxControlOptionsBehavior(Source) do
    begin
      Self.AlwaysShowEditor := AlwaysShowEditor;
      Self.CellHints := CellHints;
      Self.FocusCellOnCycle := FocusCellOnCycle;
      Self.FocusFirstCellOnNewRecord := FocusFirstCellOnNewRecord;
      Self.GoToNextCellOnEnter := GoToNextCellOnEnter;
      Self.GoToNextCellOnTab := GoToNextCellOnTab;
      Self.HintHidePause := HintHidePause;
      Self.ImmediateEditor := ImmediateEditor;
      Self.NavigatorHints := NavigatorHints;
    end
end;

procedure TcxControlOptionsBehavior.Changed;
begin
  if EditingControl.Controller <> nil then
    EditingControl.Controller.BehaviorChanged;
end;

function TcxControlOptionsBehavior.GetEditingControl: TcxEditingControl;
begin
  Result := TcxEditingControl(GetOwner);
end;

procedure TcxControlOptionsBehavior.SetAlwaysShowEditor(Value: Boolean);
begin
  if FAlwaysShowEditor <> Value then
  begin
    FAlwaysShowEditor := Value;
    Changed;
  end;
end;

procedure TcxControlOptionsBehavior.SetCellHints(Value: Boolean);
begin
  if FCellHints <> Value then
  begin
    FCellHints := Value;
    Changed;
  end;
end;

procedure TcxControlOptionsBehavior.SetFocusCellOnCycle(Value: Boolean);
begin
  if FFocusCellOnCycle <> Value then
  begin
    FFocusCellOnCycle := Value;
    Changed;
  end;
end;

procedure TcxControlOptionsBehavior.SetFocusFirstCellOnNewRecord(
  Value: Boolean);
begin
  if FFocusFirstCellOnNewRecord <> Value then
  begin
    FFocusFirstCellOnNewRecord := Value;
    Changed;
  end;
end;

procedure TcxControlOptionsBehavior.SetGoToNextCellOnEnter(Value: Boolean);
begin
  if FGoToNextCellOnEnter <> Value then
  begin
    FGoToNextCellOnEnter := Value;
    Changed;
  end;
end;

procedure TcxControlOptionsBehavior.SetGoToNextCellOnTab(Value: Boolean);
begin
  if FGoToNextCellOnTab <> Value then
  begin
    FGoToNextCellOnTab := Value;
    if not EditingControl.Controller.IsFindPanelVisible then
      if Value then
        EditingControl.Keys := EditingControl.Keys + [kTab]
      else
        EditingControl.Keys := EditingControl.Keys - [kTab];
    Changed;
  end;
end;

procedure TcxControlOptionsBehavior.SetImmediateEditor(Value: Boolean);
begin
  if FImmediateEditor <> Value then
  begin
    FImmediateEditor := Value;
    Changed;
  end;
end;

procedure TcxControlOptionsBehavior.SetIncSearch(Value: Boolean);
begin
  if Value <> FIncSearch then
  begin
    FIncSearch := Value;
    if not Value then
      EditingControl.Controller.CancelIncSearching;
  end;
end;

procedure TcxControlOptionsBehavior.SetIncSearchItem(Value: TcxCustomInplaceEditContainer);
begin
  if Value <> FIncSearchItem then
  begin
    FIncSearchItem := Value;
    EditingControl.Controller.CancelIncSearching;
  end;
end;

{ TcxExtEditingControlNavigatorButtons }

constructor TcxExtEditingControlNavigatorButtons.Create(
  AControl: TcxExtEditingControl);
begin
  inherited Create(AControl);
  FControl := AControl;
  ConfirmDelete := False;
end;

function TcxExtEditingControlNavigatorButtons.IsButtonVisibleByDefault(
  AIndex: Integer): Boolean;
begin
  Result := inherited IsButtonVisibleByDefault(AIndex) and
    ((AIndex <> NBDI_FILTER) or Supports(Navigator, IcxFilterControl));
end;

{ TcxControlNavigatorInfoPanel }

constructor TcxControlNavigatorInfoPanel.Create(
  AControl: TcxExtEditingControl);
begin
  inherited Create(AControl);
  FControl := AControl;
end;

function TcxControlNavigatorInfoPanel.GetViewParams: TcxViewParams;
begin
  Control.Styles.GetViewParams(ecs_NavigatorInfoPanel, nil, nil, Result);
end;

{ TcxControlNavigator }

constructor TcxControlNavigator.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FButtons := GetNavigatorButtonsClass.Create(Control);
  FButtons.OnGetControl := Control.GetNavigatorButtonsControl;
  FInfoPanel := GetInfoPanelClass.Create(Control);
  FInfoPanel.OnGetIRecordPosition := GetIRecordPosition;
end;

destructor TcxControlNavigator.Destroy;
begin
  FreeAndNil(FInfoPanel);
  FreeAndNil(FButtons);
  inherited;
end;

procedure TcxControlNavigator.Assign(Source: TPersistent);
begin
  if Source is TcxControlNavigator then
  begin
    Buttons := TcxControlNavigator(Source).Buttons;
    InfoPanel := TcxControlNavigator(Source).InfoPanel;
    Visible := TcxControlNavigator(Source).Visible;
  end
  else
    inherited Assign(Source);
end;

function TcxControlNavigator.GetInfoPanelClass: TcxControlNavigatorInfoPanelClass;
begin
  Result := TcxControlNavigatorInfoPanel;
end;

function TcxControlNavigator.GetNavigatorButtonsClass: TcxExtEditingControlNavigatorButtonsClass;
begin
  Result := TcxExtEditingControlNavigatorButtons;
end;

function TcxControlNavigator.GetControl: TcxExtEditingControl;
begin
  Result := TcxExtEditingControl(GetOwner);
end;

function TcxControlNavigator.GetIRecordPosition: IcxNavigatorRecordPosition;
begin
  Supports(Control, IcxNavigatorRecordPosition, Result);
end;

procedure TcxControlNavigator.SetButtons(Value: TcxExtEditingControlNavigatorButtons);
begin
  FButtons.Assign(Value);
end;

procedure TcxControlNavigator.SetInfoPanel(Value: TcxControlNavigatorInfoPanel);
begin
  FInfoPanel.Assign(Value);
end;

procedure TcxControlNavigator.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Control.LayoutChanged;
  end;
end;

{ TcxEditContainerStyles }

procedure TcxEditContainerStyles.Assign(Source: TPersistent);
begin
  if Source is TcxEditContainerStyles then
    Content := TcxEditContainerStyles(Source).Content;
  inherited Assign(Source);
end;

procedure TcxEditContainerStyles.Changed(AIndex: Integer);
begin
  inherited Changed(AIndex);
  Control.UpdateViewStyles;
end;

function TcxEditContainerStyles.GetContainer: TcxCustomInplaceEditContainer;
begin
  Result := TcxCustomInplaceEditContainer(GetOwner);
end;

function TcxEditContainerStyles.GetControl: TcxEditingControl;
begin
  Result := Container.EditingControl;
end;

function TcxEditContainerStyles.GetControlStyles: TcxCustomControlStyles;
begin
  Result := Control.Styles;
end;

{ TcxCustomInplaceEditContainer }

constructor TcxCustomInplaceEditContainer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataBinding := GetDataBindingClass.Create(Self);
  FOptions := GetOptionsClass.Create(Self);
  FStyles := GetStylesClass.Create(Self);
end;

destructor TcxCustomInplaceEditContainer.Destroy;
begin
  if not EditingControl.IsDestroying and EditingControl.IsDesigning and
    (Controller.DesignSelectionHelper <> nil) then
      Controller.DesignSelectionHelper.UnselectObject(Self);
  RepositoryItem := nil;
  EditingControl := nil;
  FOptions.Free;
  FDataBinding.Free;
  FStyles.Free;
  DestroyProperties;
  inherited Destroy;
end;

procedure TcxCustomInplaceEditContainer.Assign(Source: TPersistent);
begin
  if Source is TcxCustomInplaceEditContainer then
    with TcxCustomInplaceEditContainer(Source) do
    begin
      Self.DataBinding := DataBinding;
      Self.PropertiesClassName := PropertiesClassName;
      Self.Properties := Properties;
      Self.RepositoryItem := RepositoryItem;
      Self.Styles := Styles;
      Self.OnGetEditProperties := OnGetEditProperties;
    end
end;

procedure TcxCustomInplaceEditContainer.CalculateEditViewInfo(
  const AValue: Variant; AEditViewInfo: TcxEditCellViewInfo; const APoint: TPoint);
var
  ACanvas: TcxCanvas;
begin
  ACanvas := GetControlCanvas;
  cxAssignEditStyle(AEditViewInfo);
  ValidateDrawValue(AValue, AEditViewInfo);
  with AEditViewInfo do
  begin
    InitTextSelection;
    ViewData.MaxLineCount := AEditViewInfo.MaxLineCount;
    ViewData.InplaceEditParams.Position.RecordIndex := RecordIndex;
    ViewData.EditValueToDrawValue(AValue, ViewInfo);
    ViewData.ContentOffset := ContentOffset;
    DoCalculateEditViewInfo(AEditViewInfo);
    ViewData.CalculateEx(ACanvas, ContentRect, APoint, cxmbNone, [], ViewInfo, False);
  end;
end;

function TcxCustomInplaceEditContainer.CanEdit: Boolean;
begin
  Result := CanFocus and EditingControl.Options.OptionsData.Editing and
    FOptions.Editing and (dceoShowEdit in DataController.EditOperations) and
    (DataController.RecordCount > 0);
end;

function TcxCustomInplaceEditContainer.CanFocus: Boolean;
begin
  Result := Options.FFocusing;
end;

procedure TcxCustomInplaceEditContainer.CancelIncSearching;
begin
  Controller.CancelIncSearching;
end;

function TcxCustomInplaceEditContainer.CanFind: Boolean;
begin
  Result := Options.FilteringWithFindPanel;
end;

function TcxCustomInplaceEditContainer.CanInitEditing: Boolean;
begin
  Result := DataController.CanInitEditing(ItemIndex);
end;

function TcxCustomInplaceEditContainer.CanIncSearch: Boolean;
begin
  Result := (esoIncSearch in FPropertiesValue.GetSupportedOperations) and
    EditingControl.Options.OptionsBehavior.IncSearch and Options.IncSearch;
end;

function TcxCustomInplaceEditContainer.CanTabStop: Boolean;
begin
  Result := Options.TabStop;
end;

procedure TcxCustomInplaceEditContainer.Changed;
begin
  if EditingControl <> nil then
    EditingControl.UpdateViewStyles;
end;

procedure TcxCustomInplaceEditContainer.CheckUsingInFind;
begin
  if csDestroying in ComponentState then
    Exit;
  if CanFind then
    EditingControl.DataController.AddFindFilterItem(ItemIndex)
  else
    EditingControl.DataController.RemoveFindFilterItem(ItemIndex);
end;

function TcxCustomInplaceEditContainer.CreateEditViewData(
  AProperties: TcxCustomEditProperties; AEditStyleData: Pointer): TcxCustomEditViewData;
begin
  Result := AProperties.CreateViewData(GetEditStyle(AEditStyleData), True);
  Result.OnGetDisplayText := EditViewDataGetDisplayTextHandler;
  Result.ScaleFactor.Assign(ScaleFactor);
end;

procedure TcxCustomInplaceEditContainer.DataChanged;
begin
  FDataBinding.Init;
  InternalPropertiesChanged;
end;

procedure TcxCustomInplaceEditContainer.DoCalculateEditViewInfo(AEditViewInfo: TcxEditCellViewInfo);
begin
// do nothing
end;

procedure TcxCustomInplaceEditContainer.DoGetDisplayText(
  ARecordIndex: TdxNativeInt; var AText: string);
begin
end;

function TcxCustomInplaceEditContainer.DoGetEditProperties(
  AData: Pointer): TcxCustomEditProperties;
begin
  Result :=
    DoGetPropertiesFromEvent(FOnGetEditProperties, AData, FPropertiesValue);
end;

procedure TcxCustomInplaceEditContainer.DoGetEditingProperties(AData: Pointer;
  var AProperties: TcxCustomEditProperties);
begin
  AProperties :=
    DoGetPropertiesFromEvent(FOnGetEditingProperties, AData, AProperties);
end;

function TcxCustomInplaceEditContainer.DoGetPropertiesFromEvent(
  AEvent: TcxGetEditPropertiesEvent; AData: Pointer;
  AProperties: TcxCustomEditProperties): TcxCustomEditProperties;
begin
  Result := AProperties;
  if Assigned(AEvent) then
  begin
    AEvent(Self, AData, Result);
    if Result = nil then
      Result := AProperties;
  end;
  InitProperties(Result);
end;

procedure TcxCustomInplaceEditContainer.DoOnPropertiesChanged(Sender: TObject);
begin
  InternalPropertiesChanged;
end;

procedure TcxCustomInplaceEditContainer.EditViewDataGetDisplayTextHandler(
  Sender: TcxCustomEditViewData; var AText: string);
begin
  if Sender <> nil then
    DoGetDisplayText(Sender.InplaceEditParams.Position.RecordIndex, AText);
end;

function TcxCustomInplaceEditContainer.GetDefaultEditProperties: TcxCustomEditProperties;
begin
  if FRepositoryItem <> nil then
    Result := FRepositoryItem.Properties
  else
    if FProperties <> nil then
      Result := FProperties
    else
      Result := DataBinding.DefaultRepositoryItem.Properties;
end;

function TcxCustomInplaceEditContainer.GetControlCanvas: TcxCanvas;
begin
  if (EditingControl <> nil) and EditingControl.HandleAllocated then
    Result := EditingControl.Canvas
  else
    Result := cxScreenCanvas;
end;

function TcxCustomInplaceEditContainer.GetController: TcxCustomControlController;
begin
  Result := EditingControl.Controller;
end;

function TcxCustomInplaceEditContainer.GetCurrentValue: Variant;
begin
  with DataController do
    Result := Values[FocusedRecordIndex, ItemIndex];
end;

function TcxCustomInplaceEditContainer.GetDataBindingClass: TcxItemDataBindingClass;
begin
  Result := TcxItemDataBinding;
end;

function TcxCustomInplaceEditContainer.GetDefaultCaption: string;
begin
  Result := DataBinding.GetDefaultCaption;
end;

function TcxCustomInplaceEditContainer.GetDisplayValue(
  AProperties: TcxCustomEditProperties; ARecordIndex: Integer): Variant;
begin
  if AProperties.GetEditValueSource(False) = evsValue then
    Result := Values[ARecordIndex]
  else
    Result := DataController.DisplayTexts[ARecordIndex, ItemIndex];
end;

function TcxCustomInplaceEditContainer.GetEditDataValueTypeClass: TcxValueTypeClass;
begin
  Result := FDataBinding.GetValueTypeClass;
end;

function TcxCustomInplaceEditContainer.GetEditDefaultHeight(AFont: TFont): Integer;
var
  ASizeProp: TcxEditSizeProperties;
begin
  ASizeProp := cxDefaultEditSizeProperties;
  EditViewData.Style.Font := AFont;
  if AFont = nil then
    EditViewData.Style.Font := EditingControl.Font;
  EditViewData.ContentOffset := cxNullRect;
  EditViewData.InplaceEditParams.Position.RecordIndex := 0;
  Result := EditViewData.GetEditSize(GetControlCanvas, Null, ASizeProp).cy;
end;

function TcxCustomInplaceEditContainer.GetEditHeight(AEditViewInfo: TcxEditCellViewInfo): Integer;
var
  ASizeProp: TcxEditSizeProperties;
begin
  ASizeProp := cxDefaultEditSizeProperties;
  with AEditViewInfo do
  begin
    ViewData.Style.Font := ViewParams.Font;
    if ViewParams.Font = nil then
      EditViewData.Style.Font := EditingControl.Font;
    ViewData.ContentOffset := ContentOffset;
    ASizeProp.Width := cxRectWidth(ContentRect);
    ASizeProp.MaxLineCount := MaxLineCount;
    Result := ViewData.GetEditSize(GetControlCanvas, DisplayValue, ASizeProp).cy;
    Inc(Result, Byte(bBottom in Borders));
    Inc(Result, Byte(bTop in Borders));
  end;
end;

function TcxCustomInplaceEditContainer.GetEditWidth(AEditViewInfo: TcxEditCellViewInfo): Integer;
var
  ASizeProp: TcxEditSizeProperties;
begin
  ASizeProp := cxDefaultEditSizeProperties;
  with AEditViewInfo do
  begin
    ViewData.Style.Font := ViewParams.Font;
    ViewData.ContentOffset := ContentOffset;
    ASizeProp.MaxLineCount := MaxLineCount;
    Result := ViewData.GetEditSize(GetControlCanvas, DisplayValue, ASizeProp).cx;
  end;
end;

function TcxCustomInplaceEditContainer.GetOptionsClass: TcxCustomEditContainerItemOptionsClass;
begin
  Result := TcxCustomEditContainerItemOptions;
end;

function TcxCustomInplaceEditContainer.GetStylesClass: TcxEditContainerStylesClass;
begin
  Result := TcxEditContainerStyles;
end;

function TcxCustomInplaceEditContainer.GetValue(ARecordIndex: Integer): Variant;
begin
  Result := DataController.Values[ARecordIndex, ItemIndex];
end;

function TcxCustomInplaceEditContainer.GetValueCount: Integer;
begin
  if FEditingControl <> nil then
    Result := DataController.RecordCount
  else
    Result := 0;
end;

function TcxCustomInplaceEditContainer.HasDataTextHandler: Boolean;
begin
  Result := False;
end;

function TcxCustomInplaceEditContainer.GetEditing: Boolean;
begin
  Result := Controller.EditingItem = Self;
end;

function TcxCustomInplaceEditContainer.GetEditStyle(AData: Pointer): TcxCustomEditStyle;
begin
  Result := EditingControl.EditStyle
end;

function TcxCustomInplaceEditContainer.GetEditValue: Variant;
begin
  if Editing then
  begin
    if DataController.RecordCount = 0 then
      Result := Null
    else
      Result := DataController.GetEditValue(ItemIndex, FEditValueSource);
  end
  else
    Result := Unassigned;
end;

procedure TcxCustomInplaceEditContainer.PropertiesChanged;
begin
  Changed;
end;

procedure TcxCustomInplaceEditContainer.SetCurrentValue(const Value: Variant);
begin
  with DataController do
    Values[FocusedRecordIndex, ItemIndex] := Value;
end;

procedure TcxCustomInplaceEditContainer.SetEditing(Value: Boolean);
begin
  if Value then
    Controller.EditingItem := Self
  else
    if Editing then
      Controller.EditingItem := nil;
end;

procedure TcxCustomInplaceEditContainer.SetEditingControl(
  Value: TcxEditingControl);
begin
  if FEditingControl <> Value then
  begin
    if Value <> nil then
      Value.ViewInfo.State[cvis_StyleInvalid] := True;
    if FEditingControl <> nil then
      FEditingControl.DoInplaceEditContainerItemRemoved(Self);
    FEditingControl := Value;
    if FEditingControl <> nil then
    begin
      FEditingControl.BeginUpdate;
      try
        FEditingControl.DoInplaceEditContainerItemAdded(Self);
        DataBinding.ValueTypeClassChanged;
      finally
        FEditingControl.CancelUpdate;
        InternalPropertiesChanged;
      end;
    end;
  end;
end;

procedure TcxCustomInplaceEditContainer.SetEditValue(const Value: Variant);
begin
  if Editing then
    DataController.SetEditValue(ItemIndex, Value, FEditValueSource);
end;

procedure TcxCustomInplaceEditContainer.SetValue(
  ARecordIndex: Integer; const Value: Variant);
begin
  DataController.Values[ARecordIndex, ItemIndex] := Value;
end;

procedure TcxCustomInplaceEditContainer.ValidateDrawValue(const AValue: Variant;
  AEditViewInfo: TcxEditCellViewInfo);
begin
  AEditViewInfo.EditViewInfo.ErrorData.ErrorType := eetNone;
  AEditViewInfo.EditViewInfo.ErrorData.ErrorText := '';
  AEditViewInfo.EditViewInfo.ErrorData.ErrorIcon := nil;
end;

procedure TcxCustomInplaceEditContainer.ValidateEditData(
  AEditProperties: TcxCustomEditProperties);
begin
  if AEditProperties <> FLastEditingProperties then
  begin
    FLastEditingProperties := AEditProperties;
    FreeAndNil(FEditData);
  end;
  FEditValueSource := AEditProperties.GetEditValueSource(True);
end;

function TcxCustomInplaceEditContainer.GetDataController: TcxCustomDataController;
begin
  Result := FEditingControl.DataController;
end;

function TcxCustomInplaceEditContainer.GetFilterable: Boolean;
begin
  Result := Options.Filtering and (esoFiltering in PropertiesValue.GetSupportedOperations);
end;

function TcxCustomInplaceEditContainer.GetFocused: Boolean;
begin
  Result := Controller.FocusedItem = Self;
end;

function TcxCustomInplaceEditContainer.GetFocusedCellViewInfo: TcxEditCellViewInfo;
begin
  Result := Controller.GetFocusedCellViewInfo(Self);
end;

function TcxCustomInplaceEditContainer.GetIncSearching: Boolean;
begin
  Result := Controller.IncSearchingItem = Self;
end;

function TcxCustomInplaceEditContainer.GetProperties: TcxCustomEditProperties;
begin
  Result := FProperties;
end;

function TcxCustomInplaceEditContainer.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := FPropertiesClass;
end;

function TcxCustomInplaceEditContainer.GetPropertiesClassName: string;
begin
  if FProperties = nil then
    Result := ''
  else
    Result := FProperties.ClassName;
end;

function TcxCustomInplaceEditContainer.GetPropertiesValue: TcxCustomEditProperties;
begin
  Result := FPropertiesValue;
  Result.LockUpdate(True);
  if FDataBinding = nil then
    Result.IDefaultValuesProvider := nil
  else
    Result.IDefaultValuesProvider := FDataBinding.DefaultValuesProvider;
  Result.LockUpdate(False);
end;

function TcxCustomInplaceEditContainer.GetScaleFactor: TdxScaleFactor;
begin
  Result := dxGetScaleFactor(EditingControl);
end;

procedure TcxCustomInplaceEditContainer.SetDataBinding(Value: TcxCustomItemDataBinding);
begin
  FDataBinding.Assign(Value);
end;

procedure TcxCustomInplaceEditContainer.SetFocused(Value: Boolean);
begin
  if Value then
    Controller.FocusedItem := Self
  else
    if Focused and not (Controller.Navigator.FocusNextCell(True, False) or
      Controller.Navigator.FocusNextCell(False, False)) then
        Controller.FocusedItem := nil;
end;

procedure TcxCustomInplaceEditContainer.SetOptions(
  Value: TcxCustomEditContainerItemOptions);
begin
  FOptions.Assign(Value);
end;

procedure TcxCustomInplaceEditContainer.SetProperties(
  Value: TcxCustomEditProperties);
begin
  if (FProperties <> nil) and (Value <> nil) then
    FProperties.Assign(Value);
end;

procedure TcxCustomInplaceEditContainer.SetPropertiesClass(
  Value: TcxCustomEditPropertiesClass);
begin
  if FPropertiesClass <> Value then
  begin
    FPropertiesClass := Value;
    RecreateProperties;
  end;
end;

procedure TcxCustomInplaceEditContainer.SetPropertiesClassName(
  const Value: string);
begin
  if PropertiesClassName <> Value then
  begin
    with GetRegisteredEditProperties do
      PropertiesClass := TcxCustomEditPropertiesClass(FindByClassName(Value));
  end;
end;

procedure TcxCustomInplaceEditContainer.SetRepositoryItem(
  Value: TcxEditRepositoryItem);
begin
  if FRepositoryItem <> Value then
  begin
    Editing := False;
    if FRepositoryItem <> nil then
    begin
      FRepositoryItem.RemoveListener(Self);
      Controller.EditingController.RemoveEdit(FRepositoryItem.Properties);
    end;
    FRepositoryItem := Value;
    if FRepositoryItem <> nil then
      FRepositoryItem.AddListener(Self);
    InternalPropertiesChanged;
  end;
end;

procedure TcxCustomInplaceEditContainer.SetStyles(
  Value: TcxEditContainerStyles);
begin
  FStyles.Assign(Value);
end;

procedure TcxCustomInplaceEditContainer.CreateProperties;
begin
  if FPropertiesClass <> nil then
    FProperties := FPropertiesClass.Create(Self);
  InternalPropertiesChanged;
end;

procedure TcxCustomInplaceEditContainer.DestroyProperties;
begin
  FreeAndNil(FEditData);
  FreeAndNil(FEditViewData);
  FreeAndNil(FProperties);
end;

procedure TcxCustomInplaceEditContainer.InitEditViewInfo(
  AEditViewInfo: TcxEditCellViewInfo);

  procedure CheckOption(IsSetValue: Boolean; Value: TcxEditPaintOption);
  begin
    if IsSetValue then
      Include(AEditViewInfo.ViewData.PaintOptions, Value)
    else
      Exclude(AEditViewInfo.ViewData.PaintOptions, Value);
  end;

var
  AProp: TcxCustomEditProperties;
begin
  with AEditViewInfo do
  begin
    AProp := Properties;
    Properties := DoGetEditProperties(GetViewInfoData);
    CellValue := GetDisplayValue;
    ItemViewParams := GetEditViewParams;
    CellValue := FormatDisplayValue(CellValue);
    if (AProp = nil) or (AProp <> Properties) then
    begin
      try
        if IsViewDataCreated then
          FreeAndNil(ViewData);
        FreeAndNil(ViewInfo);
      finally
        if Properties = FPropertiesValue then
          ViewData := EditViewData
        else
          ViewData := CreateEditViewData(Properties, GetViewInfoData);
        IsViewDataCreated := ViewData <> EditViewData;
        ViewInfo := TcxCustomEditViewInfo(Properties.GetViewInfoClass.Create);
        ViewInfo.Owner := AEditViewInfo;
        ViewInfo.OnAfterDrawBackground.Add(AEditViewInfo.AfterDrawCellBackgroundHandler);
        ViewInfo.OnAfterDrawValue.Add(AEditViewInfo.AfterDrawCellValueHandler);
        ViewInfo.OnCanDrawEditValue.Add(AEditViewInfo.CanDrawEditValueHandler);
        ViewInfo.OnCalculateEditorBounds.Add(AEditViewInfo.CalculateEditorBoundsHandler);
        if not IsViewDataCreated then
          TcxCustomEditViewDataAccess(ViewData).InitCacheData;
      end;
    end
    else
      if not IsViewDataCreated then ViewData := EditViewData;
    CheckOption(IsAutoHeight, epoAutoHeight);
    CheckOption(IsEndEllipsis, epoShowEndEllipsis);
    ViewData.InplaceEditParams.Position.RecordIndex := RecordIndex;
    ViewData.InplaceEditParams.Position.Item := Self;
  end;
end;

procedure TcxCustomInplaceEditContainer.InitProperties(
  AProperties: TcxCustomEditProperties);
begin
  with AProperties do
  begin
    LockUpdate(True);
    try
      IDefaultValuesProvider := DataBinding.GetDefaultValuesProvider(AProperties);
    finally
      LockUpdate(False);
    end;
  end;
end;

procedure TcxCustomInplaceEditContainer.InternalPropertiesChanged;
begin
  if IsDestroying then Exit;
  Controller.ViewInfoChanged;
  if not Controller.IsEditing and not Controller.FEditingController.EditHiding then
    FreeAndNil(FEditData);
  FreeAndNil(FEditViewData);
  FPropertiesValue := GetDefaultEditProperties;
  InitProperties(FPropertiesValue);
  if EditingControl <> nil then
    FEditViewData := CreateEditViewData(FPropertiesValue, nil);
  with FPropertiesValue do
  begin
    if not Assigned(OnPropertiesChanged) then
      OnPropertiesChanged := DoOnPropertiesChanged;
  end;
  PropertiesChanged;
end;

function TcxCustomInplaceEditContainer.IsDestroying: Boolean;
begin
  Result := csDestroying in ComponentState;
end;

function TcxCustomInplaceEditContainer.IsEditPartVisible: Boolean;
begin
  Result := (FocusedCellViewInfo <> nil) and
    not IsRectEmpty(FocusedCellViewInfo.VisibleRect);
end;

procedure TcxCustomInplaceEditContainer.RecreateProperties;
begin
  DestroyProperties;
  CreateProperties;
end;

procedure TcxCustomInplaceEditContainer.RepositoryItemPropertiesChanged(
  Sender: TcxEditRepositoryItem);
begin
  DoOnPropertiesChanged(Sender);
end;

procedure TcxCustomInplaceEditContainer.RepositoryItemRemoved(Sender: TcxEditRepositoryItem);
begin
  RepositoryItem := nil;
end;

{ TcxInplaceContainerHintHelper }

constructor TcxInplaceContainerHintHelper.Create(
  AController: TcxHotTrackController);
begin
  inherited Create;
  FController := AController;
end;

procedure TcxInplaceContainerHintHelper.CorrectHintWindowRect(var ARect: TRect);
begin
  inherited CorrectHintWindowRect(ARect);
  if FController.IsNeedOffsetHint then
    OffsetRect(ARect, 0, cxGetCursorSize.cy);
end;

function TcxInplaceContainerHintHelper.GetHintHidePause: Integer;
begin
  Result := FController.Control.GetHintHidePause;
end;

function TcxInplaceContainerHintHelper.GetOwnerControl: TcxControl;
begin
  Result := FController.Control;
end;

{ TcxHotTrackController }

constructor TcxHotTrackController.Create(AControl: TcxEditingControl);
begin
  FControl := AControl;
  FHintHelper := TcxInplaceContainerHintHelper.Create(Self);
end;

destructor TcxHotTrackController.Destroy;
begin
  FreeAndNil(FHintHelper);
  inherited Destroy;
end;

procedure TcxHotTrackController.CancelHint;
begin
  FHintHelper.CancelHint;
end;

procedure TcxHotTrackController.Clear;
begin
  PrevHitPoint := cxInvalidPoint;
  PrevElement := nil;
end;

procedure TcxHotTrackController.SetHotElement(AElement: TObject;
  const APoint: TPoint);

  procedure CalculateHotState(AObject: TObject; const P: TPoint);
  var
    AIntf: IcxHotTrackElement;
  begin
    if Supports(AObject, IcxHotTrackElement, AIntf) then
      AIntf.UpdateHotTrackState(P);
  end;

begin
  if Control.IsLocked then
    Clear
  else
    try
      if AElement <> PrevElement then
      begin
        HintElement := PrevElement;
        CalculateHotState(PrevElement, cxInvalidPoint);
        CalculateHotState(AElement, APoint);
      end
      else
        if Int64(PrevHitPoint) <> Int64(APoint) then
          CalculateHotState(AElement, APoint);
    finally
      PrevHitPoint := APoint;
      PrevElement := AElement;
      if AElement <> HintElement then
        CancelHint;
      CheckHint;
    end;
end;

function TcxHotTrackController.CanShowHint: Boolean;
begin
  Result := FShowHint and Control.Controller.CanShowHint;
  if Result then
  begin
    Result := cxCanShowHint(Control) and
     not Control.IsDesigning and not Control.Dragging and
     (Control.DragAndDropState = ddsNone) and
     not ((Control.Controller.GetEditingViewInfo = PrevElement) and Control.Controller.IsEditing);
    if Result then
      Result := Control.HandleAllocated and IsWindowVisible(Control.Handle) and
        (FindVCLWindow(GetMouseCursorPos) = Control);
  end;
end;

procedure TcxHotTrackController.CheckDestroyingElement(AElement: TObject);
begin
  if (AElement = PrevElement) or (AElement = HintElement) then
  begin
    if AElement = PrevElement then
      PrevElement := nil;
    if AElement = HintElement then
    begin
      CancelHint;
      HintElement := nil;
    end;
    SetHotElement(nil, cxInvalidPoint);
  end;
end;

procedure TcxHotTrackController.CheckHint;

  procedure CheckHintBounds(var AHintBounds, ATextRect: TRect);
  var
    ATextBounds, ATextOffsets: TRect;
  begin
    ATextOffsets := Rect(ATextRect.Left - AHintBounds.Left, ATextRect.Top - AHintBounds.Top,
      AHintBounds.Right - ATextRect.Right, AHintBounds.Bottom - ATextRect.Bottom);
    ATextBounds := cxRectContent(Control.ClientBounds, ATextOffsets);
    IntersectRect(AHintBounds, AHintBounds, Control.ClientBounds);
    IntersectRect(ATextRect, ATextRect, ATextBounds);
  end;

var
  AIHotTrackElement: IcxHotTrackElement;
  ACanShowHint: Boolean;
  ATextRect: TRect;
  AHintText: TCaption;
  AHintIsMultiLine: Boolean;
  AHintBounds: TRect;
begin
  if Supports(PrevElement, IcxHotTrackElement, AIHotTrackElement) and CanShowHint then
  begin
    IsNeedOffsetHint := False;
    ACanShowHint := AIHotTrackElement.IsNeedHint(cxScreenCanvas, PrevHitPoint,
      AHintText, AHintIsMultiLine, ATextRect, IsNeedOffsetHint);
    AHintBounds := AIHotTrackElement.GetHintBounds;
    if not ACanShowHint then
      ATextRect := cxRectOffset(AHintBounds, cxTextOffset, cxTextOffset);
    Control.DoGetCellHint(PrevElement, string(AHintText), ACanShowHint);
    if ACanShowHint then
    begin
      HintElement := PrevElement;
      CheckHintBounds(AHintBounds, ATextRect);
      FHintHelper.ShowHint(AHintBounds, ATextRect, AHintText,
        AHintIsMultiLine, HintElement, cxScreenCanvas.Font);
    end;
    cxScreenCanvas.Dormant;
  end;
end;

{ TcxEditingController }

constructor TcxEditingController.Create(AController: TcxCustomControlController);
begin
  inherited Create(AController.EditingControl);
  FController := AController;
end;

function TcxEditingController.GetEditingCellViewInfo: TcxEditCellViewInfo;
begin
  Result := EditingItem.FocusedCellViewInfo;
end;

function TcxEditingController.GetEditingControl: TcxEditingControl;
begin
  Result := FController.EditingControl;
end;

function TcxEditingController.GetEditingProperties: TcxCustomEditProperties;
begin
  if IsEditing and not EditingControl.IsDestroying then
    with EditingCellViewInfo do
    begin
      Result := EditContainer.DoGetEditProperties(GetViewInfoData);
      EditContainer.DoGetEditingProperties(GetViewInfoData, Result);
    end
  else
    Result := nil;
end;

function TcxEditingController.GetIsDragging: Boolean;
begin
  with EditingControl do
    Result := Dragging or (DragAndDropState = ddsInProcess);
end;

procedure TcxEditingController.SetEditingItem(Value: TcxCustomInplaceEditContainer);
begin
  if FEditingItem <> Value then
  begin
    if FEditingItemSetting then Exit;
    FEditingItemSetting := True;
    try
      if Value <> nil then
      begin
        if not Value.CanEdit or not EditingControl.DoEditing(Value) then Exit;
        Value.Focused := True;
      end;
      HideEdit(False);
      FEditingItem := Value;
      if IsEditing then
        try
          ShowEdit(Value);
          if not FEditPreparing and (FEdit = nil) then
            FEditingItem := nil;
        except
          FEditingItem := nil;
          raise;
        end;
    finally
      FEditingItemSetting := False;
    end;
  end;
end;

function TcxEditingController.CanHideEdit: Boolean;
begin
  Result := inherited CanHideEdit and not EditingControl.IsDestroying;
end;

function TcxEditingController.CanInitEditing: Boolean;
begin
  Result := (EditingItem <> nil) and EditingItem.CanInitEditing;
end;

function TcxEditingController.CanUpdateEditValue: Boolean;
begin
  Result := inherited CanUpdateEditValue and (EditingCellViewInfo <> nil);
end;

procedure TcxEditingController.ClearEditingItem;
begin
  EditingItem := nil;
end;

procedure TcxEditingController.DoHideEdit(Accept: Boolean);
var
  AEditViewInfo: TcxEditCellViewInfo;
  AItem: TcxCustomInplaceEditContainer;
begin
  if Accept then
  begin
    FEdit.Deactivate; 
    EditingControl.DataController.PostEditingData;
    if FController.IsImmediatePost then
      EditingControl.DataController.Post;
    if FEditingItem = nil then Exit;
    AEditViewInfo := EditingCellViewInfo;
    if AEditViewInfo <> nil then
      FEdit.InternalProperties.Update(AEditViewInfo.Properties);
  end;
  AItem := EditingItem;
  if not EditingControl.IsDestroying then
    EditingControl.DoEdited(AItem);
  EditingItem := nil;
  Controller.RefreshFocusedCellViewInfo(AItem);
  if Edit <> nil then
  begin
    UninitEdit;
    Edit.EditModified := False;
    if NeedFocusControlOnHideEdit then
      FocusControlOnHideEdit;
  end;
end;

procedure TcxEditingController.DoUpdateEdit;
var
  AEditViewInfo: TcxEditCellViewInfo;
begin
  CancelEditUpdatePost;
  if IsEditing and (Edit <> nil) then
  begin
    Controller.BeforeShowEdit;
    AEditViewInfo := EditingCellViewInfo;
    if (AEditViewInfo = nil) or not AEditViewInfo.Visible or cxRectIsEmpty(AEditViewInfo.EditRect) then
      Edit.Left := cxInvisibleCoordinate
    else
    begin
      if EditPreparing then
      begin
        AEditViewInfo.Refresh(False);
        cxAssignEditStyle(AEditViewInfo);
        Edit.Style.Assign(EditingControl.EditStyle);
        EditingControl.DoInitEdit(FEditingItem, FEdit);
        FEditPlaceBounds := AEditViewInfo.EditRect;
      end
      else
        Edit.BoundsRect := AEditViewInfo.EditRect;
      Edit.Visible := True;
    end;
  end;
end;

procedure TcxEditingController.FocusControlOnHideEdit;
begin
  FController.AllowCheckEdit := False;
  try
    FController.SetFocus;
  finally
    FController.AllowCheckEdit := True;
  end;
end;

function TcxEditingController.GetCancelEditingOnExit: Boolean;
begin
  Result := FController.GetCancelEditingOnExit;
end;

function TcxEditingController.GetEditParent: TWinControl;
begin
  Result := EditingControl;
end;

function TcxEditingController.GetFocusedCellBounds: TRect;
var
  ACellViewInfo: TcxEditCellViewInfo;
begin
  ACellViewInfo := EditingCellViewInfo;
  if ACellViewInfo = nil then
    Result := cxNullRect
  else
    Result := ACellViewInfo.EditRect;
 end;

function TcxEditingController.GetHideEditOnExit: Boolean;
begin
  Result := not Controller.GetAlwaysShowEditor or Controller.EditingControl.IsFocused;
end;

function TcxEditingController.GetHideEditOnFocusedRecordChange: Boolean;
begin
//TODO
  Result := not FController.GetAlwaysShowEditor or
    (FEditingItem <> nil) and Assigned(FEditingItem.OnGetEditProperties) {or FEditingItem.ShowButtons(False)} or
//  (esoAlwaysHotTrack in FEditingItem.FocusedCellViewInfo.Properties.GetSupportedOperations)) or  // TODO: HitTestController
    Assigned(EditingControl.OnEditing) or Assigned(EditingControl.OnInitEdit);
end;

function TcxEditingController.GetIsEditing: Boolean;
begin
  Result := FEditingItem <> nil;
end;

procedure TcxEditingController.HideInplaceEditor;
begin
  Edit.Visible := False;
end;

function TcxEditingController.NeedFocusControlOnHideEdit: Boolean;
begin
  Result := not Controller.FindPanel.IsEditFocused;
end;

function TcxEditingController.PrepareEdit(AItem: TcxCustomInplaceEditContainer;
  AIsMouseEvent: Boolean): Boolean;
var
  AEditCellViewInfo: TcxEditCellViewInfo;
  AProperties: TcxCustomEditProperties;
  AAssignRepositoryItem: Boolean;
begin
  Result := False;
  Controller.CancelCheckEditPost;
  if EditPreparing or EditHiding or (AItem = nil) or IsDragging then Exit;
  if AItem.Editing and not FEditingItemSetting then
  begin
    Result := (Edit <> nil) and (FController.EditingControl.Focused and
      not Edit.IsFocused or AIsMouseEvent);
    Exit;
  end;
  EditingControl.ViewInfo.ValidateDirty;
  FEditPreparing := True;
  try
    Result := FController.EditingControl.Focused;
    if not Result then Exit;
    Controller.BeforeShowEdit;
    AEditCellViewInfo := Controller.GetFocusedCellViewInfo(AItem);
    Result := AEditCellViewInfo <> nil;
    if Result then
    begin
      AItem.Editing := True;
      Result := AItem.Editing;
    end;
    EditingControl.ViewInfo.ValidateDirty;
    if not Result then Exit;
    try
      AProperties := EditingProperties;
      AItem.ValidateEditData(AProperties);
      AAssignRepositoryItem := NeedAssignRepositoryItem(AItem.Properties,
        AItem.RepositoryItem, AProperties);
      FEdit := EditList.GetEdit(AProperties);
      if AAssignRepositoryItem then
        Edit.RepositoryItem := AItem.RepositoryItem;
      Edit.Visible := False;
      Edit.Parent := nil;
    except
      AItem.Editing := False;
    {$IFNDEF DELPHI102TOKYO}
      Result := False;
    {$ENDIF}
      raise;
    end;
    if Edit <> nil then
    begin
      EditingCellViewInfo.Invalidate;
      InitEdit;
    end
    else
      Result := False;
  finally
    FEditPreparing := False;
  end;
end;

procedure TcxEditingController.StartEditingByTimer;
begin
  FEditShowingTimerItem.Editing := True;
  Controller.FEditingBeforeDrag := Controller.IsEditing;
end;

procedure TcxEditingController.UpdateInplaceParamsPosition;
var
  ACellViewInfo: TcxEditCellViewInfo;
begin
  ACellViewInfo := EditingCellViewInfo;
  if ACellViewInfo <> nil then
    Edit.InplaceParams.Position := ACellViewInfo.GetInplaceEditPosition;
end;

function TcxEditingController.GetValue: TcxEditValue;
begin
  Result := EditingItem.EditValue;
  EditingControl.DoInitEditValue(EditingItem, Edit, Result);
end;

procedure TcxEditingController.SetValue(const AValue: TcxEditValue);
begin
  FEditingItem.EditValue := AValue;
end;

procedure TcxEditingController.EditAfterKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if FController.IsKeyForController(Key, Shift) then
    FController.KeyDown(Key, Shift);
end;

procedure TcxEditingController.EditChanged(Sender: TObject);
begin
  inherited;
  EditingControl.DoEditChanged(FEditingItem);
end;

procedure TcxEditingController.EditDblClick(Sender: TObject);
begin
  Controller.DoEditDblClick(Sender);
end;

procedure TcxEditingController.EditExit(Sender: TObject);
begin
  ClearErrorState;
  inherited;
  FController.EditingControl.FocusChanged;
end;

procedure TcxEditingController.EditFocusChanged(Sender: TObject);
begin
  Controller.FFocused := EditingControl.IsFocused or
    (IsEditing and (Edit <> nil) and Edit.Focused);
  Controller.EditingControl.ViewInfo.UpdateSelection;
end;

procedure TcxEditingController.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  AModified: Boolean;
begin
  if Assigned(EditingControl.OnKeyDown) then
    EditingControl.OnKeyDown(EditingControl, Key, Shift);
  with FController do
  begin
    BeforeEditKeyDown(Key, Shift);
    if not EditingControl.IsScrollingContent and IsKeyForController(Key, Shift) then
      FController.MakeFocusedItemVisible;
  end;
  case Key of
    VK_RETURN:
      begin
        HideEdit(True);
        if FController.GetGoToNextCellOnEnter then
        begin
          FController.BlockRecordKeyboardHandling := True;
          try
            FController.KeyDown(Key, Shift);
          finally
            FController.BlockRecordKeyboardHandling := False;
          end;
          ShowEdit;
        end
        else
          FController.CheckEdit;
        Key := 0;
      end;
    VK_ESCAPE:
      begin
        AModified := FEdit.EditModified;
        HideEdit(False);
        FController.CheckEdit;
        if AModified then Key := 0;
      end;
    VK_DELETE:
      if (Shift = [ssCtrl]) and FController.CanHandleDeleteRecordKeys then
      begin
        FController.KeyDown(Key, Shift);
        Key := 0;
      end;
  end;
end;

procedure TcxEditingController.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if Assigned(EditingControl.OnKeyPress) then
    EditingControl.OnKeyPress(EditingControl, Key);
  if Key = #27 then Key := #0;
  FController.MakeFocusedItemVisible;
end;

procedure TcxEditingController.EditKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Assigned(EditingControl.OnKeyUp) then
    EditingControl.OnKeyUp(EditingControl, Key, Shift);
end;

procedure TcxEditingController.EditValueChanged(Sender: TObject);
begin
  inherited;
  EditingControl.DoEditValueChanged(FEditingItem);
end;

procedure TcxEditingController.HideEdit(Accept: Boolean);
begin
  FController.CancelCheckEditPost;
  try
    inherited HideEdit(Accept and not Controller.DataController.IsCancelling);
  finally
    if EditingControl.ViewInfo.IsDirty then
      EditingControl.LayoutChanged;
  end;
end;

procedure TcxEditingController.ShowEdit;
begin
  ShowEdit(nil);
end;

procedure TcxEditingController.ShowEdit(AItem: TcxCustomInplaceEditContainer);
begin
  if AItem = nil then
    AItem := FController.FocusedItem;
  if PrepareEdit(AItem, False) then
    FEdit.Activate(AItem.FEditData);
end;

procedure TcxEditingController.ShowEdit(AItem: TcxCustomInplaceEditContainer; Key: Char);
begin
  if PrepareEdit(AItem, False) then
    FEdit.ActivateByKey(Key, AItem.FEditData);
end;

procedure TcxEditingController.ShowEdit(AItem: TcxCustomInplaceEditContainer;
  Shift: TShiftState; X, Y: Integer);
begin
  if PrepareEdit(AItem, True) then
  begin
    EditingControl.HideTouchScrollUI(EditingControl, True);
    FEdit.ActivateByMouse(Shift, X, Y, AItem.FEditData);
  end;
end;

procedure TcxEditingController.StartEditShowingTimer(AItem: TcxCustomInplaceEditContainer);
begin
  FEditShowingTimerItem := AItem;
  inherited StartEditShowingTimer;
end;

{ TcxSizingDragAndDropObject }

procedure TcxSizingDragAndDropObject.BeginDragAndDrop;
begin
  if (DragItem = nil) or (DragSizing = nil) then
    raise EAbort.Create('');
  FDirection := Controller.GetResizeDirection;
  FDragBounds := DragSizing.GetSizingBoundsRect(FDirection);
  FSizeDelta := DragSizing.GetSizingIncrement(FDirection);
  FStartPos := CurMousePos;
  FDragPos := GetDragPos(CurMousePos);
  FDynamicUpdate := DragSizing.IsDynamicUpdate;
  inherited BeginDragAndDrop;
end;

procedure TcxSizingDragAndDropObject.DirtyChanged;
begin
  if not DynamicUpdate and cxRectIntersect(GetSizingMarkBounds, Control.ClientBounds) then
    Canvas.InvertRect(GetSizingMarkBounds);
  inherited DirtyChanged;
end;

procedure TcxSizingDragAndDropObject.DragAndDrop(
  const P: TPoint; var Accepted: Boolean);
var
  ADragPos: TPoint;
begin
  Accepted := True;
  ADragPos := GetDragPos(P);
  with FDragBounds do
    if (DragCoord[P] < DragCoord[TopLeft]) or (DragCoord[P] > DragCoord[BottomRight]) then Exit;
  if not DynamicUpdate then
    FDelta := Round((DragCoord[P] - DragCoord[StartPos]) / SizeDelta)
  else
    FDelta := Trunc((DragCoord[P] - DragCoord[StartPos]) / SizeDelta);
  if (FDelta = 0) and (DragCoord[ADragPos] = DragCoord[DragPos]) then Exit;
  Dirty := True;
  FDragPos := ADragPos;
  if DynamicUpdate then
  begin
     DragSizing.SetSizeDelta(Direction, Delta);
     FStartPos := P;
  end;
  inherited DragAndDrop(P, Accepted);
end;

procedure TcxSizingDragAndDropObject.EndDragAndDrop(Accepted: Boolean);
begin
  inherited EndDragAndDrop(Accepted);
  if Accepted and not DynamicUpdate and (Delta <> 0) and not Controller.FDragCancel then
    DragSizing.SetSizeDelta(Direction, Delta);
end;

function TcxSizingDragAndDropObject.GetDragAndDropCursor(
  Accepted: Boolean): TCursor;
begin
  if IsHorzSizing then
    Result := crHSplit
  else
    Result := crVSplit;
end;

function TcxSizingDragAndDropObject.GetDragCoord(APoint: TPoint): Integer;
begin
  if IsHorzSizing then
    Result := APoint.X
  else
    Result := APoint.Y;
end;

function TcxSizingDragAndDropObject.GetDragPos(const APoint: TPoint): TPoint;
begin
  Result := FStartPos;
  with Result do
  begin
    if IsHorzSizing then
      Inc(X, Round((DragCoord[APoint] - X) / SizeDelta) * SizeDelta)
    else
      Inc(Y, Round((DragCoord[APoint] - Y) / SizeDelta) * SizeDelta);
  end;
end;

function TcxSizingDragAndDropObject.GetImmediateStart: Boolean;
begin
  Result := True;
end;

function TcxSizingDragAndDropObject.GetSizingMarkBounds: TRect;
begin
  if IsHorzSizing then
    Result := cxRectSetLeft(FDragBounds,
      DragPos.X - cxSizingMarkWidth div 1, cxSizingMarkWidth)
  else
    Result := cxRectSetTop(FDragBounds,
      DragPos.Y - cxSizingMarkWidth div 1, cxSizingMarkWidth);
end;

function TcxSizingDragAndDropObject.GetCanvas: TcxCanvas;
begin
  Result := TcxEditingControl(Control).Canvas;
end;

function TcxSizingDragAndDropObject.GetController: TcxCustomControlController;
begin
  Result := TcxEditingControl(Control).Controller;
end;

function TcxSizingDragAndDropObject.GetDragItem: TObject;
begin
  Result := Controller.DragItem;
end;

function TcxSizingDragAndDropObject.GetDragSizing: IcxDragSizing;
begin
  Supports(DragItem, IcxDragSizing, Result);
end;

function TcxSizingDragAndDropObject.GetIsSizingKind(Index: Integer): Boolean;
begin
  Result := TcxDragSizingDirection(Index) = FDirection;
end;

{ TcxCustomAutoScrollingObject }

constructor TcxCustomAutoScrollingObject.Create(AOwner: TObject);
begin
  FOwner := AOwner;
  FTimer := cxCreateTimer(TimerHandler, cxScrollWidthDragInterval, False);
end;

destructor TcxCustomAutoScrollingObject.Destroy;
begin
  UpdateTimer(False);
  FreeAndNil(FTimer);
  inherited Destroy;
end;

function TcxCustomAutoScrollingObject.Check(APos: TPoint): Boolean;
begin
  Result := cxRectPtIn(FArea, APos);
  UpdateTimer(Result);
end;

procedure TcxCustomAutoScrollingObject.SetParams(
  const Area: TRect; AKind: TScrollBarKind; ACode: TScrollCode; AIncrement: Integer);
begin
  FArea := Area;
  FCode := ACode;
  FKind := AKind;
  if ACode = scLineUp then
    AIncrement := -AIncrement;
  FIncrement := AIncrement;
end;

procedure TcxCustomAutoScrollingObject.Stop;
begin
  UpdateTimer(False);
end;

procedure TcxCustomAutoScrollingObject.DoScrollInspectingControl;
var
  AMin, AMax, APos, ANewPos: Integer;
begin
  GetScrollBarParams(AMin, AMax, APos);
  ANewPos := APos + FIncrement;
  if ANewPos < AMin then
    ANewPos := AMin
  else
    if ANewPos > AMax then ANewPos := AMax;
  if HasScrollBar and (ANewPos <> APos) then
    Scroll(FKind, FCode, ANewPos)
  else
    Scroll(FKind, scEndScroll, ANewPos);
end;

function TcxCustomAutoScrollingObject.GetControl: TcxControl;
begin
  Result := nil;
end;

function TcxCustomAutoScrollingObject.GetHasScrollBar: Boolean;
begin
  Result := TcxControlAccess(Control).IsScrollBarActive(FKind);
end;

function TcxCustomAutoScrollingObject.GetScrollBar(AKind: TScrollBarKind): IcxControlScrollBar;
begin
  if AKind = sbHorizontal then
    Result := TcxControlAccess(Control).HScrollBar
  else
    Result := TcxControlAccess(Control).VScrollBar;
end;

procedure TcxCustomAutoScrollingObject.GetScrollBarParams(var AMin, AMax, APos: Integer);
begin
  with GetScrollBar(FKind) do
  begin
    AMin := Min;
    AMax := Max - PageSize + 1;
    APos := Position;
  end;
end;

procedure TcxCustomAutoScrollingObject.Scroll(
  AKind: TScrollBarKind; ACode: TScrollCode; var APosition: Integer);
begin
end;

procedure TcxCustomAutoScrollingObject.TimerHandler(Sender: TObject);
begin
  DoScrollInspectingControl;
end;

procedure TcxCustomAutoScrollingObject.UpdateTimer(AValue: Boolean);
begin
  if Timer.Enabled <> AValue then
  begin
    FTimer.Enabled := AValue;
    if AValue then
      TcxControlAccess(Control).ShowTouchScrollUI(Control)
    else
      TcxControlAccess(Control).HideTouchScrollUI(Control);
  end;
end;

{ TcxAutoScrollingEditingControlObject }

procedure TcxAutoScrollingEditingControlObject.Scroll(
  AKind: TScrollBarKind; ACode: TScrollCode; var APosition: Integer);
begin

  TcxEditingControl(Control).Controller.Scroll(AKind, ACode, APosition);
end;

{ TcxDragDropAutoScrollingObject }

function TcxDragDropObjectAutoScrollingObject.GetControl: TcxControl;
begin
  Result := TcxEditingControl(TcxDragAndDropObjectAccess(FOwner).Control);
end;

{ TcxControllerAutoScrollingObject }

function TcxControllerAutoScrollingObject.CheckBounds(APos: TPoint): Boolean;
begin
  FDirections := [];
  Result := not cxRectPtIn(FArea, APos);
  if Result then
  begin
    if FCheckHorz then
      if APos.X <= FArea.Left then
        Include(FDirections, nLeft)
      else
        if APos.X >= FArea.Right then
          Include(FDirections, nRight);
    if FCheckVert then
      if APos.Y <= FArea.Top then
        Include(FDirections, nTop)
      else
        if APos.Y >= FArea.Bottom then
          Include(FDirections, nBottom);
    Result := Result and (FDirections <> []);
  end;
  UpdateTimer(Result);
end;

procedure TcxControllerAutoScrollingObject.SetBoundsParams(
  const AClientArea: TRect; ACheckHorz, ACheckVert: Boolean; AIncrement: Integer);
begin
  FArea := AClientArea;
  FCheckHorz := ACheckHorz;
  FCheckVert := ACheckVert;
  FIncrement := AIncrement;
  FBoundsMode := True;
end;

procedure TcxControllerAutoScrollingObject.DoScrollInspectingControl;

  procedure CheckDirection(ADir: TcxNeighbor);
  const
    Kinds: array[Boolean] of TScrollBarKind = (sbVertical, sbHorizontal);
    Codes: array[Boolean] of TScrollCode = (scLineDown, scLineUp);
  var
    AMin, AMax, APos, ANewPos: Integer;
    AKind: TScrollBarKind;
    ACode: TScrollCode;
  begin
    AKind := Kinds[ADir in [nLeft, nRight]];
    with GetScrollBar(AKind) do
    begin
      if Visible then
      begin
        AMin := Min;
        AMax := Max - PageSize + 1;
        APos := Position;
        ACode := Codes[ADir in [nLeft, nTop]];
        if ACode = scLineDown then
          ANewPos := APos + FIncrement
        else
          ANewPos := APos - FIncrement;
        if ANewPos < AMin then ANewPos := AMin
        else
          if ANewPos > AMax then ANewPos := AMax;
        if ANewPos <> APos then
          TcxEditingControl(Self.Control).Controller.Scroll(AKind, ACode, ANewPos);
      end;
    end;
  end;

var
  I: TcxNeighbor;
begin
  if not FBoundsMode then
    inherited DoScrollInspectingControl
  else
    for I := nLeft to nBottom do
      if I in FDirections then
        CheckDirection(I);
end;

function TcxControllerAutoScrollingObject.GetControl: TcxControl;
begin
  Result := TcxCustomControlController(FOwner).EditingControl;
end;

{ TcxPlaceArrows }

constructor TcxPlaceArrows.CreateArrows(AColor: TColor; ABorderColor: TColor = clDefault);
begin
  inherited Create;
  FArrow1 := TcxDragAndDropArrow.Create(True);
  FArrow1.BorderColor := ABorderColor;
  FArrow1.Color := AColor;
  FArrow2 := TcxDragAndDropArrow.Create(True);
  FArrow2.BorderColor := ABorderColor;
  FArrow2.Color := AColor;
end;

destructor TcxPlaceArrows.Destroy;
begin
  FreeAndNil(FArrow1);
  FreeAndNil(FArrow2);
  inherited;
end;

function TcxPlaceArrows.MoveTo(ARect: TRect; ASide: TcxBorder): Boolean;
const
  Arrow1PlaceMap: array[Boolean] of TcxArrowPlace = (apLeft, apTop);
  Arrow2PlaceMap: array[Boolean] of TcxArrowPlace = (apRight, apBottom);
var
  AOrigin: TPoint;
  AVertical: Boolean;
begin
  Result := not EqualRect(ARect, FPrevRect) or (ASide <> FPrevSide) or not Visible;
  if Result then
  begin
    FPrevRect := ARect;
    FPrevSide := ASide;
    AVertical := ASide in [bLeft, bRight];
    case ASide of
      bLeft:
        ARect := cxRectSetWidth(ARect, 0);
      bTop:
        ARect := cxRectSetHeight(ARect, 0);
      bRight:
        ARect := cxRectSetRight(ARect, ARect.Right, 0);
      bBottom:
        ARect := cxRectSetBottom(ARect, ARect.Bottom, 0);
    end;
    AOrigin := ARect.TopLeft;
    ARect := cxRectSetNullOrigin(ARect);
    FArrow1.Init(AOrigin, ARect, ARect, Arrow1PlaceMap[AVertical]);
    FArrow2.Init(AOrigin, ARect, ARect, Arrow2PlaceMap[AVertical]);
    Visible := True;
  end;
end;

procedure TcxPlaceArrows.Hide;
begin
  Visible := False;
end;

function TcxPlaceArrows.GetVisible: Boolean;
begin
  Result := FArrow1.Visible or FArrow2.Visible;
end;

procedure TcxPlaceArrows.SetVisible(AValue: Boolean);
begin
  FArrow1.Visible := AValue;
  FArrow2.Visible := AValue;
end;

{ TcxBaseDragAndDropObject }

function TcxBaseDragAndDropObject.GetDragAndDropCursor(
  Accepted: Boolean): TCursor;
begin
  if Accepted then
    Result := EditingControl.DragCursor
  else
    Result := crNoDrop;
end;

function TcxBaseDragAndDropObject.GetEditingControl: TcxEditingControl;
begin
  Result := TcxEditingControl(Control);
end;

{ TcxCustomControlDragAndDropObject }

constructor TcxCustomControlDragAndDropObject.Create(AControl: TcxControl);
begin
  inherited Create(AControl);
  FAutoScrollObjects := TList.Create;
end;

destructor TcxCustomControlDragAndDropObject.Destroy;
var
  I: Integer;
begin
  for I := 0 to FAutoScrollObjects.Count - 1 do
    TObject(FAutoScrollObjects.List[I]).Free;
  FreeAndNil(FAutoScrollObjects);
  FreeAndNil(FDragImage);
  inherited Destroy;
end;

procedure TcxCustomControlDragAndDropObject.AddAutoScrollingObject(
  const ARect: TRect; AKind: TScrollBarKind;  ACode: TScrollCode);
var
  AObj: TcxCustomAutoScrollingObject;
begin
  AObj := GetAutoScrollingObjectClass.Create(Self);
  if AKind = sbHorizontal then
    AObj.SetParams(ARect, AKind, ACode, GetHorzScrollInc)
  else
    AObj.SetParams(ARect, AKind, ACode, GetVertScrollInc);
  FAutoScrollObjects.Add(AObj);
end;

procedure TcxCustomControlDragAndDropObject.BeginDragAndDrop;
begin
  inherited BeginDragAndDrop;
  DrawDragImage;
end;

procedure TcxCustomControlDragAndDropObject.DragAndDrop(const P: TPoint;
  var Accepted: Boolean);
var
  R: TRect;
begin
  inherited DragAndDrop(P, Accepted);
  R := cxRectOffset(PictureSize, [OrgOffset, HotSpot, CurMousePos]);
  DrawImage(R.TopLeft);
//lcm
//  if not CheckScrolling(P) then
//    Accepted := cxRectPtIn(GetAcceptedRect, P);
  FCanDrop := Accepted;
end;

procedure TcxCustomControlDragAndDropObject.DrawDragImage;
var
  AOrg: TRect;
begin
  AOrg := DisplayRect;
  with AOrg do
    FPictureSize := Rect(0, 0, Right - Left, Bottom - Top);

  FDragImage := TcxDragImage.Create;
  FDragImage.SetBounds(0, 0, FPictureSize.Right, FPictureSize.Bottom);

  FHotSpot.X := AOrg.Left - CurMousePos.X;
  FHotSpot.Y := AOrg.Top - CurMousePos.Y;
  AOrg.TopLeft := Canvas.WindowOrg;
  Canvas.WindowOrg := AOrg.TopLeft;
  FOrgOffset := Control.ClientToScreen(FOrgOffset);
  try
    Paint;
  finally
    Canvas.WindowOrg := AOrg.TopLeft;
  end;
end;

procedure TcxCustomControlDragAndDropObject.DrawImage(
  const APoint: TPoint);
begin
  DragImage.MoveTo(APoint);
  DragImage.Show;
end;

procedure TcxCustomControlDragAndDropObject.EndDragAndDrop(
  Accepted: Boolean);
begin
  StopScrolling;
  inherited EndDragAndDrop(Accepted);
end;

function TcxCustomControlDragAndDropObject.GetAcceptedRect: TRect;
begin
  Result := cxNullRect;
end;

function TcxCustomControlDragAndDropObject.GetAutoScrollingObjectClass: TcxCustomAutoScrollingObjectClass;
begin
  Result := TcxDragDropObjectAutoScrollingObject;
end;

function TcxCustomControlDragAndDropObject.GetDisplayRect: TRect;
begin
  dxAbstractError;
end;

function TcxCustomControlDragAndDropObject.GetDragAndDropCursor(
  Accepted: Boolean): TCursor;
const
  DragCursors: array[Boolean] of TCursor = (crcxNoDrop, crDefault);
begin
  Result := DragCursors[Accepted];
end;

function TcxCustomControlDragAndDropObject.GetHorzScrollInc: Integer;
begin
  Result := 1;
end;

function TcxCustomControlDragAndDropObject.GetVertScrollInc: Integer;
begin
  Result := 1;
end;

procedure TcxCustomControlDragAndDropObject.OwnerImageChanged;
begin
  DrawImage(cxPointOffset(cxPointOffset(CurMousePos, FOrgOffset), HotSpot));
end;

procedure TcxCustomControlDragAndDropObject.OwnerImageChanging;
begin
end;

procedure TcxCustomControlDragAndDropObject.Paint;
begin
  dxAbstractError;
end;

procedure TcxCustomControlDragAndDropObject.StopScrolling;
var
  I: Integer;
begin
  for I := 0 to AutoScrollObjectCount - 1 do
    AutoScrollObjects[I].Stop;
end;

function TcxCustomControlDragAndDropObject.GetAutoScrollObject(
  Index: Integer): TcxCustomAutoScrollingObject;
begin
  Result := TcxCustomAutoScrollingObject(FAutoScrollObjects[Index]);
end;

function TcxCustomControlDragAndDropObject.GetAutoScrollObjectCount: Integer;
begin
  Result := FAutoScrollObjects.Count;
end;

function TcxCustomControlDragAndDropObject.GetCanvas: TcxCanvas;
begin
  Result := FDragImage.Canvas;
end;

function TcxCustomControlDragAndDropObject.GetHitTestController: TcxCustomHitTestController;
begin
  Result := TcxEditingControl(Control).Controller.HitTestController;
end;

constructor TcxDragImageHelper.Create(AControl: TcxEditingControl;
  ADragPos: TPoint);
begin
  FDragControl := AControl;
  FDragPos := ADragPos;
  InitDragImage;
end;

destructor TcxDragImageHelper.Destroy;
begin
  if DragImageVisible then Hide;
  FreeAndNil(DragImage);
  inherited Destroy;
end;

procedure TcxDragImageHelper.Hide;
begin
  FDragImageVisible := False;
  DragImage.Hide;
end;

procedure TcxDragImageHelper.Show;
begin
  FDragImageVisible := True;
  DrawImage(MousePos);
  DragImage.Show;
end;

procedure TcxDragImageHelper.DragAndDrop(const P: TPoint);
var
  R: TRect;
begin
  R := cxRectOffset(DragPictureBounds, [HotSpot, P]);
  MousePos := R.TopLeft;
  DrawImage(MousePos);
end;

function TcxDragImageHelper.GetDisplayRect: TRect;
begin
  Result := DragControl.DragDropImageDisplayRect;
end;

procedure TcxDragImageHelper.InitDragImage;
begin
  DragPictureBounds := GetDisplayRect;
  HotSpot := DragPictureBounds.TopLeft;
  DragPictureBounds := cxRectOffset(DragPictureBounds, cxPointInvert(HotSpot));
  with FDragPos do
    HotSpot := cxPoint(HotSpot.X - X,  HotSpot.Y - Y);
  DragImage := TcxDragImage.Create;
  with cxRectSize(DragPictureBounds) do
    DragImage.SetBounds(0, 0, Cx, Cy);
  DragControl.DrawDragDropImage(DragImage.Image, DragImage.Canvas);
end;

procedure TcxDragImageHelper.DrawImage(
  const APoint: TPoint);
begin
  DragImage.MoveTo(APoint);
  if not DragImage.Visible then
    DragImage.Show;
end;

function TcxDragImageHelper.GetImageRect: TRect;
begin
  Result := cxRectOffset(DragPictureBounds, MousePos)
end;

procedure TcxDragImageHelper.SetDragImageVisible(Value: Boolean);
begin
  if Value <> FDragImageVisible then
  begin
    FDragImageVisible := Value;
    if Value then
      Show
    else
      Hide;
  end;
end;

{ TcxCustomHitTestController }

constructor TcxCustomHitTestController.Create(AOwner: TcxCustomControlController);
begin
  FController := AOwner;
  FHitPoint := cxInvalidPoint;
end;

procedure TcxCustomHitTestController.ReCalculate;
begin
  Recalculate(FHitPoint);
end;

procedure TcxCustomHitTestController.ReCalculate(const APoint: TPoint);
begin
  ClearState;
  if Control.IsLocked then Exit;
  FHitPoint := APoint;
  ViewInfo.ValidateDirty;
  DoCalculate;
end;

function TcxCustomHitTestController.AllowDesignMouseEvents(
  X, Y: Integer; AShift: TShiftState): Boolean;
begin
  RecalculateOnMouseEvent(X, Y, AShift);
  Result := False;
end;

function TcxCustomHitTestController.CanShowHint(AItem: TObject): Boolean;
begin
  Result := Control.Options.OptionsBehavior.CellHints;
end;

procedure TcxCustomHitTestController.ClearState;
begin
  FHitState := FHitState and echc_IsMouseEvent;
end;

procedure TcxCustomHitTestController.CheckDestroyingItem(AItem: TObject);
begin
  if FHitTestItem = AItem then
  begin
    FHitTestItem := nil;
    ClearState;
  end;
  HotTrackController.CheckDestroyingElement(AItem);
end;

procedure TcxCustomHitTestController.DoCalculate;
var
  I: Integer;
  AItem: TcxEditCellViewInfo;
begin
  with ViewInfo do
    for I := 0 to FEditCellViewInfoList.Count - 1 do
    begin
      AItem := FEditCellViewInfoList.List[I];
      if AItem.Visible and cxRectPtIn(AItem.ClipRect, HitPoint) then
      begin
        HitTestItem := AItem;
        Exit;
      end;
    end;
  HitTestItem := nil;
end;

function TcxCustomHitTestController.GetCurrentCursor: TCursor;
begin
  Result := crDefault;
end;

function TcxCustomHitTestController.GetHitAtFindPanel: Boolean;
begin
  Result := False;
end;

function TcxCustomHitTestController.GetHitAtNavigator: Boolean;
begin
  Result := False;
end;

procedure TcxCustomHitTestController.HitCodeChanged(APrevCode: Integer);
begin
end;

procedure TcxCustomHitTestController.HitTestItemChanged(APrevHitTestItem: TObject);
begin
end;

procedure TcxCustomHitTestController.RecalculateOnMouseEvent(X, Y: Integer; AShift: TShiftState);
begin
  FShift := AShift;
  IsMouseEvent := True;
  try
    ReCalculate(cxPoint(X, Y));
  finally
    IsMouseEvent := False;
  end;
end;

function TcxCustomHitTestController.GetControl: TcxEditingControl;
begin
  Result := Controller.EditingControl;
end;

function TcxCustomHitTestController.GetCoordinate(AIndex: Integer): Integer;
begin
  Result := PIntArray(@FHitPoint)^[AIndex];
end;

function TcxCustomHitTestController.GetEditCellViewInfo: TcxEditCellViewInfo;
begin
  if IsItemEditCell then
    Result := TcxEditCellViewInfo(FHitTestItem)
  else
    Result := nil;
end;

function TcxCustomHitTestController.GetHasCode(Mask: TcxHitCode): Boolean;
begin
  Result := FHitState and Mask <> 0;
end;

function TcxCustomHitTestController.GetHotTrackController: TcxHotTrackController;
begin
  Result := FController.HotTrackController;
end;

function TcxCustomHitTestController.GetIsItemEditCell: Boolean;
begin
  Result := FHitTestItem is TcxEditCellViewInfo;
end;

function TcxCustomHitTestController.GetIsMouseEvent: Boolean;
begin
  Result := FHitState and echc_IsMouseEvent <> 0;
end;

function TcxCustomHitTestController.GetViewInfo: TcxCustomControlViewInfo;
begin
  Result := Control.ViewInfo;
end;

procedure TcxCustomHitTestController.SetCoordinate(AIndex: Integer; Value: Integer);
begin
  PIntArray(@FHitPoint)^[AIndex] := Value;
  Recalculate;
end;

procedure TcxCustomHitTestController.SetHasCode(ACode: TcxHitCode; AValue: Boolean);
var
  APrevState: TcxHitCode;
begin
  if (FHitState and ACode <> 0) <> AValue then
  begin
    APrevState := FHitState;
    if AValue then
      FHitState := FHitState or ACode
    else
      FHitState := FHitState and not ACode;
    HitCodeChanged(APrevState);
  end;
end;

procedure TcxCustomHitTestController.SetHitPoint(const APoint: TPoint);
begin
  Recalculate(APoint);
end;

procedure TcxCustomHitTestController.SetHitTestItem(AItem: TObject);
var
  APrevItem: TObject;
begin
  APrevItem := FHitTestItem;
  FHitTestItem := AItem;
  if IsMouseEvent then
    with Controller.HotTrackController do
    begin
      ShowHint := Self.CanShowHint(AItem);
      SetHotElement(AItem, HitPoint);
    end;
  if APrevItem <> AItem then
    HitTestItemChanged(APrevItem);
end;

procedure TcxCustomHitTestController.SetIsMouseEvent(Value: Boolean);
begin
  if Value then
    FHitState := FHitState or echc_IsMouseEvent
  else
    FHitState := FHitState and not echc_IsMouseEvent;
end;

{ TcxCustomCellNavigator }

constructor TcxCustomCellNavigator.Create(AController: TcxCustomControlController);
begin
  FController := AController;
end;

function TcxCustomCellNavigator.FocusNextCell(AForward, ANextRow: Boolean;
  AShift: TShiftState = []): Boolean;
var
  APrevRowIndex, APrevCellIndex, ARowIndex, ACellIndex: Integer;

  function IsValidCellIndex(ACount: Integer): Boolean;
  begin
    Result := cxInRange(ACellIndex, 0, ACount - 1) or
      (MayFocusedEmptyRow(ARowIndex) and (ACount = 0));
  end;

begin
  Init(APrevRowIndex, APrevCellIndex, RowCount);
  ARowIndex := APrevRowIndex;
  ACellIndex := APrevCellIndex;
  if ANextRow then
    CalcNextRow(AForward, ARowIndex, ACellIndex)
  else
    ACellIndex := APrevCellIndex + cxIntOffs[AForward];
  SelectCell(AForward, ANextRow, ARowIndex, ACellIndex);
  if not IsValidCellIndex(Count[ARowIndex]) then
  begin
    ACellIndex := APrevCellIndex;
    ARowIndex := APrevRowIndex;
  end;
  Result := (ARowIndex <> APrevRowIndex) or (ACellIndex <> APrevCellIndex);
  if Result then
    SetFocusCell(ARowIndex, ACellIndex, AShift);
end;

procedure TcxCustomCellNavigator.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_LEFT, VK_RIGHT:
      begin
        FocusNextCell(Key = VK_RIGHT, False, Shift);
        Key := 0;
      end;
    VK_RETURN, VK_F2:
      if (Controller.FocusedItem <> nil) and (Shift = []) then
      begin
        Controller.FocusedItem.Editing := True;
        if Controller.FocusedItem.Editing then
          Key := 0;
      end;
    VK_UP, VK_DOWN:
      begin
        FocusNextCell(Key = VK_DOWN, True, Shift);
        Key := 0;
      end;
  end;
end;

procedure TcxCustomCellNavigator.KeyPress(var Key: Char);
begin
  if IsEditStartChar(Key) and (Controller.FocusedItem <> nil) then
  begin
    Controller.EditingController.ShowEdit(Controller.FocusedItem, Key);
    Key := #0;
  end;
end;

procedure TcxCustomCellNavigator.Refresh;
begin
  {Init(ARowIndex, ACellIndex, ARowCount);
  SetFocusCell(ARowIndex, ACellIndex);}
end;

function TcxCustomCellNavigator.SelectCell(AForward, ANextRow: Boolean;
  var ARowIndex, ACellIndex: Integer): TcxCustomInplaceEditContainer;
var
  ACurRow, ACurCell, ARow: Integer;
  AItemFound: Boolean;
begin
  Result := nil;
  ACurRow := ARowIndex;
  ACurCell := ACellIndex;
  repeat
    AItemFound := False;
    while not AItemFound do
    begin
      Result := GetCellContainer(ACurRow, ACurCell);
      AItemFound := (Result = nil) or Result.CanFocus and Result.CanTabStop;
      if not AItemFound then Inc(ACurCell, cxIntOffs[AForward]);
    end;
    if Result = nil then
    begin
      ACurCell := ACellIndex;
      ARow := ACurRow;
      if Controller.GetFocusCellOnCycle and not ANextRow then
        CalcNextRow(AForward, ACurRow, ACurCell);
      if (ARow <> ACurRow) and not ((Count[ACurRow] = 0) and MayFocusedEmptyRow(ACurRow)) then
        ACurCell := cxSetValue(AForward, 0, Count[ACurRow] - 1)
      else
        break;
    end
    else
      if MayFocusedEmptyRow(ARowIndex) then break;
  until Result <> nil;
  ARowIndex := ACurRow;
  ACellIndex := ACurCell;
end;

procedure TcxCustomCellNavigator.CalcNextRow(AForward: Boolean;
  var ARowIndex, ACellIndex: Integer);
begin
  dxAbstractError;
end;

function TcxCustomCellNavigator.GetCellContainer(
  ARowIndex, ACellIndex: Integer): TcxCustomInplaceEditContainer;
begin
  Result := nil;
  dxAbstractError;
end;

function TcxCustomCellNavigator.GetCount(ARowIndex: Integer): Integer;
begin
  Result := -1;
  dxAbstractError;
end;

procedure TcxCustomCellNavigator.Init(
  var ARowIndex, ACellIndex, ARowCount: Integer);
begin
  dxAbstractError;
end;

function TcxCustomCellNavigator.MayFocusedEmptyRow(ARowIndex: Integer): Boolean;
begin
  Result := False
end;

procedure TcxCustomCellNavigator.SetFocusCell(
  ARowIndex, ACellIndex: Integer; AShift: TShiftState);
begin
  dxAbstractError;
end;

procedure TcxCustomCellNavigator.DoKeyPress(var Key: Char);
begin
  if FEatKeyPress then
    FEatKeyPress := False
  else
    KeyPress(Key);
end;

function TcxCustomCellNavigator.GetDataController: TcxCustomDataController;
begin
  Result := FController.DataController;
end;

{ TcxCustomDesignSelectionHelper }

constructor TcxCustomDesignSelectionHelper.Create(AControl: TcxEditingControl);
begin
  inherited Create;
  FControl := AControl;
end;

function TcxCustomDesignSelectionHelper.GetController: TcxCustomControlController;
begin
  Result := FControl.Controller;
end;

{ TcxCustomControlController }

constructor TcxCustomControlController.Create(AOwner: TcxEditingControl);
begin
  inherited Create;
  FEditingControl := AOwner;
  FAllowCheckEdit := True;
  with EditingControl do
  begin
    FEditingController := GetEditingControllerClass.Create(Self);
    FHitTestController := GetHitTestControllerClass.Create(Self);
    FHotTrackController := GetHotTrackControllerClass.Create(FEditingControl);
  end;
  FNavigator := GetNavigatorClass.Create(Self);
  FFindPanel := GetFindPanelClass.Create(Self);
end;

destructor TcxCustomControlController.Destroy;
begin
  FreeAndNil(FFindPanel);
  FreeAndNil(FNavigator);
  FreeAndNil(FEditingController);
  FreeAndNil(FHotTrackController);
  FreeAndNil(FHitTestController);
  inherited Destroy;
end;

procedure TcxCustomControlController.Clear;
begin
  HitTestController.ClearState;
  HotTrackController.Clear;
end;

procedure TcxCustomControlController.DblClick;
begin
end;

function TcxCustomControlController.GetCursor(X, Y: Integer): TCursor;
begin
  Result := crDefault;
end;

procedure TcxCustomControlController.KeyDown(var Key: Word; Shift: TShiftState);
var
  ARemoveFocus: Boolean;
begin
  if FindPanel.IsFocused then
  begin
    FindPanel.KeyDown(Key, Shift);
    Exit;
  end;
  if not BlockRecordKeyboardHandling then
  begin
    if IsIncSearching then
      Key := IncSearchKeyDown(Key, Shift);
    FNavigator.KeyDown(Key, Shift);
  end;
  case Key of
    VK_PRIOR, VK_NEXT:
      DoNextPage(Key = VK_NEXT, Shift);

    VK_ESCAPE:
      EditingControl.DataController.Cancel;

    VK_RETURN, VK_TAB:
      if ((Shift = []) or (Shift = [ssShift])) and
        ((Key = VK_RETURN) and GetGoToNextCellOnEnter or (Key = VK_TAB) and (GetGoToNextCellOnTab or IsFindPanelVisible)) then
      begin
        ARemoveFocus := False;
        if (Key = VK_TAB) and IsFindPanelVisible and not GetGoToNextCellOnTab then
          ARemoveFocus := not IsEditing
        else
          if Shift + [ssShift] = [ssShift] then
            if Navigator.FocusNextCell(Shift = [], Navigator.DownOnTab, Shift) then
              Key := 0
            else
              ARemoveFocus := not EditingController.IsEditing
          else
            ARemoveFocus := (Key = VK_TAB) and (Shift + [ssShift, ssCtrl] = [ssShift, ssCtrl]);
        if ARemoveFocus and EditingControl.IsFocused then
          PostMessage(GetParentForm(EditingControl).Handle, WM_NEXTDLGCTL, WPARAM(ssShift in Shift), LPARAM(False));
      end;
    Ord('F'):
      if Shift = [ssCtrl] then
      begin
        ShowFindPanel;
        Key := 0;
      end;
  end;
end;

procedure TcxCustomControlController.KeyPress(var Key: Char);
begin
  if FindPanel.IsFocused then
  begin
    FindPanel.KeyPress(Key);
    Exit;
  end;
  if FEatKeyPress then
  begin
    FEatKeyPress := False;
    Exit;
  end;
  if IsIncSearchStartChar(Key) and
    (ItemForIncSearching <> nil) and ItemForIncSearching.CanIncSearch and
    (DataController.EditState * [dceInsert, dceEdit] = []) then
  begin
    if Key <> #8 then
      IncSearchingText := IncSearchingText + Key;
    Key := #0;
  end;
  FNavigator.DoKeyPress(Key);
end;

procedure TcxCustomControlController.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if FindPanel.IsFocused then
  begin
    FindPanel.KeyUp(Key, Shift);
    Exit;
  end;
end;

procedure TcxCustomControlController.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if HitTestController.HitAtFindPanel then
    EditingControl.ViewInfo.FindPanelViewInfo.MouseDown(Button, Shift, X, Y);
end;

procedure TcxCustomControlController.MouseMove(
  Shift: TShiftState; X, Y: Integer);
begin
  if HitTestController.HitAtFindPanel then
    EditingControl.ViewInfo.FindPanelViewInfo.MouseMove(Shift, X, Y);
end;

procedure TcxCustomControlController.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if HitTestController.HitAtFindPanel then
    EditingControl.ViewInfo.FindPanelViewInfo.MouseUp(Button, Shift, X, Y);
  if HitTestController.HitAtNavigator then
    (HitTestController.HitTestItem as TcxCustomNavigatorSiteViewInfo).MouseUp(Button, X, Y);
end;

procedure TcxCustomControlController.Reset;
begin
  EditingController.PostEditUpdate;
  FHitTestController.ClearState;
  FHitTestController.FHitTestItem := nil;
  FHotTrackController.Clear;
end;

function TcxCustomControlController.HandleMessage(var Message: TMessage): Boolean;
begin
  case Message.Msg of
    WM_IME_STARTCOMPOSITION:
      Result := EditingController.IMEStartComposition;
    WM_IME_COMPOSITION:
      Result := EditingController.IMEComposition(Message);
  else
    Result := False;
  end;
end;

// drag'n'drop
procedure TcxCustomControlController.BeginDragAndDrop;
begin
  EditingController.HideEdit(True);
end;

procedure TcxCustomControlController.DragAndDrop(const P: TPoint; var Accepted: Boolean);
begin
end;

procedure TcxCustomControlController.EndDragAndDrop(Accepted: Boolean);
begin
  if EditingControl.DragAndDropState = ddsNone then
    CheckEdit;
end;

function TcxCustomControlController.StartDragAndDrop(
  const P: TPoint): Boolean;
begin
  Result := False;
end;

procedure TcxCustomControlController.MouseEnter;
begin
  HitTestController.ReCalculate;
end;

procedure TcxCustomControlController.MouseLeave;
begin
  HideHint;
  HitTestController.IsMouseEvent := True;
  HitTestController.HitTestItem := nil;
  HitTestController.IsMouseEvent := False;
end;

procedure TcxCustomControlController.DoCancelMode;
begin
  FocusChanged;
end;

procedure TcxCustomControlController.AfterPaint;
begin
  with EditingControl do
  begin
    if DragAndDropState = ddsInProcess then
      if DragAndDropObject is TcxCustomControlDragAndDropObject then
        TcxCustomControlDragAndDropObject(DragAndDropObject).OwnerImageChanged;
  end;
  ProcessCheckEditPost;
end;

procedure TcxCustomControlController.BeforeEditKeyDown(var Key: Word;
  var Shift: TShiftState);
begin
end;

procedure TcxCustomControlController.BeforeMouseDown(
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FEditingBeforeDrag := IsEditing;
  EditingController.ClearErrorState;
end;

procedure TcxCustomControlController.BeforePaint;
begin
  with EditingControl do
  begin
    EditingController.CheckEditUpdatePost;
    if DragAndDropState = ddsInProcess then
      if DragAndDropObject is TcxCustomControlDragAndDropObject then
        TcxCustomControlDragAndDropObject(DragAndDropObject).OwnerImageChanging;
  end;
end;

procedure TcxCustomControlController.BeforeShowEdit;
begin
end;

procedure TcxCustomControlController.BehaviorChanged;
begin
  EditingControl.ViewInfo.UpdateSelection;
end;

procedure TcxCustomControlController.CancelCheckEditPost;
begin
  FCheckEditNeeded := False;
end;

function TcxCustomControlController.CanHandleDeleteRecordKeys: Boolean;
begin
  Result := False;
end;

function TcxCustomControlController.CanFocusedRecordIndex(
  AIndex: TdxNativeInt): Boolean;
begin
  Result := True;
end;

function TcxCustomControlController.CanShowHint: Boolean;
begin
  Result := not Assigned(EditingController.EditShowingTimer);
end;

procedure TcxCustomControlController.CancelIncSearching;
var
  AItem: TcxCustomInplaceEditContainer;
begin
  AItem := ItemForIncSearching;
  DataController.Search.Cancel;
  if (AItem <> nil) and (AItem.FocusedCellViewInfo <> nil) then
    AItem.FocusedCellViewInfo.Refresh(True);
end;

function TcxCustomControlController.GetIncSearchingItem: TcxCustomInplaceEditContainer;
begin
  if IsIncSearching then
    Result := TcxCustomInplaceEditContainer(EditingControl.ContainerList[DataController.Search.ItemIndex])
  else
    Result := nil;
end;

function TcxCustomControlController.GetIncSearchingText: string;
begin
  Result := DataController.Search.SearchText;
end;

function TcxCustomControlController.GetIsIncSearching: Boolean;
begin
  Result := DataController.Search.Searching
end;

procedure TcxCustomControlController.SearchLocate(
  AItem: TcxCustomInplaceEditContainer; const Value: string);
begin
   DataController.Search.Locate(AItem.ItemIndex, Value);
end;

procedure TcxCustomControlController.SearchLocateNext(
  AItem: TcxCustomInplaceEditContainer; AForward: Boolean);
begin
  DataController.Search.LocateNext(AForward);
end;

procedure TcxCustomControlController.UpdateRecord(ARecordIndex: TdxNativeInt);
begin
  EditingController.UpdateEditValue;
end;

procedure TcxCustomControlController.ViewInfoChanged;
begin
  HitTestController.FHitTestItem := nil;
  HotTrackController.SetHotElement(nil, HitTestController.HitPoint);
end;

procedure TcxCustomControlController.CheckEdit;
begin
  CancelCheckEditPost;
  if FAllowCheckEdit and GetAlwaysShowEditor then
    FEditingController.ShowEdit;
end;

procedure TcxCustomControlController.HandleNonContentMouseDown(
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if HitTestController.HitAtNavigator then
    (HitTestController.HitTestItem as TcxCustomNavigatorSiteViewInfo).MouseDown(Button, X, Y);
end;

procedure TcxCustomControlController.DoEditDblClick(Sender: TObject);
begin
  EditingControl.DblClick;
end;

procedure TcxCustomControlController.DoMouseDown(
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  APrevFocusedRecord: Integer;
  APrevFocusedItem: TcxCustomInplaceEditContainer;
  APrevEditViewInfo, AEditViewInfo: TcxEditCellViewInfo;
  AButtonClick: Boolean;

  procedure DoShowEdit;
  begin
    if Button <> mbLeft then Exit;
    with FEditingController, AEditViewInfo do
    begin
      if AButtonClick then
        ShowEdit(EditContainer, Shift, X, Y)
      else
        ShowEdit(EditContainer, [], -1, -1)
    end;
  end;

begin
  FindPanel.FocusedItem := fpfiNone;
  APrevFocusedRecord := FocusedRecordIndex;
  APrevFocusedItem := FocusedItem;
  FIsDblClick := ssDouble in Shift;
  FWasFocusedBeforeClick := False;
  with HitTestController do
  begin
    AButtonClick := HitTestController.IsItemEditCell and
      EditCellViewInfo.ViewInfo.IsHotTrack(Point(X, Y)) {and (EditingControl.DragMode = dmManual)};
    if AButtonClick then
      APrevEditViewInfo := EditCellViewInfo
    else
      APrevEditViewInfo := nil;
  end;
  MouseDown(Button, Shift, X, Y);
  HitTestController.RecalculateOnMouseEvent(X, Y, Shift);
  if (Button <> mbMiddle) and HitTestController.IsItemEditCell then
  begin
    AEditViewInfo := HitTestController.EditCellViewInfo;
    SetFocusedRecordItem(AEditViewInfo.RecordIndex, AEditViewInfo.EditContainer);
    HitTestController.RecalculateOnMouseEvent(X, Y, Shift);
    if HitTestController.IsItemEditCell then
    begin
      AEditViewInfo := HitTestController.EditCellViewInfo;
      if GetImmediateEditor then
        DoShowEdit
      else
      begin
        if AButtonClick and (AEditViewInfo = APrevEditViewInfo) then
          DoShowEdit
        else
        begin
          FWasFocusedBeforeClick := (APrevFocusedRecord = FocusedRecordIndex) and
            (APrevFocusedItem = FocusedItem) and (FocusedItem <> nil);
          if not FWasFocusedBeforeClick  and (FocusedItem <> nil) then
            FocusedItem.CancelIncSearching;
        end;
      end;
    end;
  end;
end;

procedure TcxCustomControlController.DoMouseMove(
  Shift: TShiftState; X, Y: Integer);
begin
  MouseMove(Shift, X, Y);
  HitTestController.RecalculateOnMouseEvent(X, Y, Shift);
  if HitTestController.HitAtNavigator then
    (HitTestController.HitTestItem as TcxCustomNavigatorSiteViewInfo).MouseMove(Shift, X, Y);
end;

procedure TcxCustomControlController.DoMouseUp(
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MouseUp(Button, Shift, X, Y);
  if WasFocusedBeforeClick then
  begin
    with HitTestController do
      if not IsEditing and not IsDblClick and IsItemEditCell and (Button = mbLeft) then
        FEditingController.StartEditShowingTimer(EditCellViewInfo.EditContainer);
  end;
  HitTestController.RecalculateOnMouseEvent(X, Y, Shift);
  with HitTestController do
  begin
    if not IsEditing and not IsDblClick and IsItemEditCell and GetImmediateEditor then
    begin
       FEditingController.StopEditShowingTimer;
       if Button = mbLeft then
         FEditingController.ShowEdit(EditCellViewInfo.EditContainer)
    end;
  end;
end;

procedure TcxCustomControlController.DoNextPage(AForward: Boolean; Shift: TShiftState);
begin
end;

function TcxCustomControlController.GetEditingViewInfo: TcxEditCellViewInfo;
begin
  Result := GetFocusedCellViewInfo(EditingItem);
end;

function TcxCustomControlController.GetFindPanelClass: TcxControlFindPanelClass;
begin
  Result := TcxControlFindPanel;
end;

function TcxCustomControlController.GetFindStartPosition(ARecordIndex: TdxNativeInt;
  AItemIndex: Integer; out AHighlightedText: string): Integer;
begin
  Result := DataController.GetFindFilterTextStartPosition(ARecordIndex, AItemIndex, AHighlightedText);
end;

function TcxCustomControlController.GetFocused: Boolean;
begin
  Result := FFocused;
end;

function TcxCustomControlController.GetFocusedCellViewInfo(
 AEditContainer: TcxCustomInplaceEditContainer): TcxEditCellViewInfo;
begin
  Result := nil;
  dxAbstractError;
end;

function TcxCustomControlController.GetFocusedRecordIndex: TdxNativeInt;
begin
  Result := EditingControl.DataController.GetFocusedRecordIndex;
end;

function TcxCustomControlController.GetResizeDirection: TcxDragSizingDirection;
begin
  Result := dsdHorz;
end;

procedure TcxCustomControlController.FocusedItemChanged(
  APrevFocusedItem: TcxCustomInplaceEditContainer);

  procedure RefreshCells(APrevViewInfo, ACurViewInfo: TcxEditCellViewInfo);
  begin
     if (APrevViewInfo = ACurViewInfo) or DisableCellsRefresh then Exit;
     if APrevViewInfo <> nil then
       APrevViewInfo.Refresh(False);
     if ACurViewInfo <> nil then
       ACurViewInfo.Refresh(False);
  end;

begin
  if EditingControl.ComponentState * [csLoading, csDestroying] <> [] then Exit;
  CancelIncSearching;
  MakeFocusedItemVisible;
  RefreshCells(GetFocusedCellViewInfo(APrevFocusedItem),
    GetFocusedCellViewInfo(FocusedItem));
  Navigator.Refresh;
end;

procedure TcxCustomControlController.FocusedRecordChanged(
  APrevFocusedRecordIndex, AFocusedRecordIndex: Integer);
begin
  with EditingController do
    if HideEditOnFocusedRecordChange then HideEdit(True);
  CheckEdit;
  EditingController.UpdateEditValue;
end;

function TcxCustomControlController.HasFocusedControls: Boolean;
begin
  Result := (EditingController.Edit <> nil) and EditingController.Edit.IsFocused or FindPanel.IsEditFocused;
end;

procedure TcxCustomControlController.HideHint;
begin
  HotTrackController.CancelHint;
end;

function TcxCustomControlController.IncSearchKeyDown(AKey: Word; AShift: TShiftState): Word;
begin
  if ItemForIncSearching = nil then
  begin
    Result := AKey;
    Exit;
  end
  else
    Result := 0;
  case AKey of
    VK_ESCAPE:
      ItemForIncSearching.CancelIncSearching;
    VK_BACK:
      IncSearchingText := Copy(IncSearchingText, 1, Length(IncSearchingText) - 1);
    VK_UP, VK_DOWN:
      if AShift = [ssCtrl] then
        SearchLocateNext(ItemForIncSearching, AKey = VK_DOWN)
      else
        Result := AKey;
  else
    Result := AKey;
  end;
end;

procedure TcxCustomControlController.InternalSetFocusedItem(
  Value: TcxCustomInplaceEditContainer);
begin
  FFocusedItem := Value;
end;

function TcxCustomControlController.IsImmediatePost: Boolean;
begin
  Result := False;
end;

function TcxCustomControlController.IsKeyForController(
  AKey: Word; AShift: TShiftState): Boolean;
begin
  Result := ((AKey = VK_TAB) and GetGoToNextCellOnTab) or
    (AKey = VK_UP) or (AKey = VK_DOWN) or (AKey = VK_PRIOR) or (AKey = VK_NEXT) or
    (AKey = VK_INSERT) or (AKey = VK_ESCAPE) or (AKey = VK_LEFT) or (AKey = VK_RIGHT) or
    (AKey = Ord('F')) and (AShift = [ssCtrl]) and FindPanel.CanShow;
end;

procedure TcxCustomControlController.PostCheckEdit;
begin
  if FAllowCheckEdit then FCheckEditNeeded := True;
end;

procedure TcxCustomControlController.ProcessCheckEditPost;
begin
  if FCheckEditNeeded then CheckEdit;
end;

procedure TcxCustomControlController.PostShowEdit;
begin
  with EditingControl.Options.OptionsBehavior do
  begin
    if not IsEditing and (ImmediateEditor or AlwaysShowEditor) and
      (EditingControl.DragAndDropState = ddsNone) then
      if HitTestController.IsItemEditCell then PostCheckEdit;
  end;
end;

procedure TcxCustomControlController.RefreshFocusedCellViewInfo(
  AItem: TcxCustomInplaceEditContainer);
var
  ACellViewInfo: TcxEditCellViewInfo;
begin
  if DisableCellsRefresh then Exit;
  ACellViewInfo := GetFocusedCellViewInfo(AItem);
  if (ACellViewInfo <> nil) and (ACellViewInfo.Refresh(True)) then
    EditingControl.LayoutChanged;
end;

procedure TcxCustomControlController.RefreshFocusedRecord;
var
  I: Integer;
  ANeedUpdate: Boolean;
  ACellViewInfo: TcxEditCellViewInfo;
begin
  with EditingControl do
  begin
    Inc(FLockUpdate);
    ANeedUpdate := False;
    try
      for I := 0 to FContainerList.Count - 1 do
        with TcxCustomInplaceEditContainer(FContainerList.List[I]) do
        begin
          ACellViewInfo := FocusedCellViewInfo;
          ANeedUpdate := ANeedUpdate or ((ACellViewInfo <> nil) and ACellViewInfo.Refresh(True));
        end;
    finally
      Dec(FLockUpdate);
      if ANeedUpdate and not IsLocked then
      begin
        BeforeUpdate;
        LayoutChanged;
      end;
    end;
  end;
end;

procedure TcxCustomControlController.SetFocused(Value: Boolean);
begin
  FFocused := Value;
end;

procedure TcxCustomControlController.SetFocusedItem(
  Value: TcxCustomInplaceEditContainer);
var
  APrevFocusedItem: TcxCustomInplaceEditContainer;
begin
  if (Value <> nil) and not Value.CanFocus then
  begin
    MakeFocusedRecordVisible;
    Exit;
  end;
  if FFocusedItem <> Value then
  begin
    APrevFocusedItem := FFocusedItem;
    if (FFocusedItem <> nil) and not FEditingController.FEditingItemSetting then
      FEditingController.HideEdit(True);
    FFocusedItem := Value;
    FocusedItemChanged(APrevFocusedItem);
  end
  else
    if Assigned(Value) then
      MakeFocusedItemVisible;
  PostCheckEdit;
end;

procedure TcxCustomControlController.SetFocusedRecordIndex(
  Value: TdxNativeInt);
var
  AIndexesAreEqual: Boolean;
begin
  with DataController do
  begin
    if cxInRange(Value, 0, RecordCount - 1) and
      not (CanFocusedRecordIndex(Value) and ChangeFocusedRowIndex(Value)) then Exit;
  end;
  AIndexesAreEqual := FocusedRecordIndex = Value;
  if AIndexesAreEqual then MakeFocusedRecordVisible;
end;

function TcxCustomControlController.GetAlwaysShowEditor: Boolean;
begin
  Result := EditingControl.Options.OptionsBehavior.AlwaysShowEditor;
end;

function TcxCustomControlController.GetCancelEditingOnExit: Boolean;
begin
  with EditingControl do
    Result := Options.OptionsData.CancelOnExit and
     (DataController.EditState * [dceInsert, dceChanging, dceModified] = [dceInsert]);
end;

function TcxCustomControlController.GetFocusCellOnCycle: Boolean;
begin
  Result := EditingControl.Options.OptionsBehavior.FocusCellOnCycle;
end;

function TcxCustomControlController.GetGoToNextCellOnEnter: Boolean;
begin
  Result := EditingControl.Options.OptionsBehavior.GoToNextCellOnEnter;
end;

function TcxCustomControlController.GetGoToNextCellOnTab: Boolean;
begin
  Result := EditingControl.Options.OptionsBehavior.GoToNextCellOnTab;
end;

function TcxCustomControlController.GetImmediateEditor: Boolean;
begin
  with EditingControl.Options.OptionsBehavior do
    Result := (ImmediateEditor or AlwaysShowEditor) and (EditingControl.DragMode = dmManual);
end;

procedure TcxCustomControlController.BeforeStartDrag;
begin
end;

function TcxCustomControlController.CanDrag(X, Y: Integer): Boolean;
begin
  Result := False;
end;

procedure TcxCustomControlController.DragDrop(Source: TObject; X, Y: Integer);
begin
end;

procedure TcxCustomControlController.DragOver(Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  EditingController.HideEdit(True);
end;

procedure TcxCustomControlController.EndDrag(Target: TObject; X, Y: Integer);
begin
  HitTestController.ReCalculate(Point(X, Y));
  if FEditingBeforeDrag or
    EditingControl.Options.OptionsBehavior.AlwaysShowEditor then
      EditingController.ShowEdit;
end;

function TcxCustomControlController.GetDragAndDropObject: TcxCustomControlDragAndDropObject;
begin
  Result := EditingControl.DragAndDropObject as TcxCustomControlDragAndDropObject;
end;

function TcxCustomControlController.GetDragAndDropObjectClass: TcxDragAndDropObjectClass;
begin
  Result := nil;
end;

function TcxCustomControlController.GetIsDragging: Boolean;
begin
  Result := False;
end;

function TcxCustomControlController.GetNavigatorClass: TcxCustomCellNavigatorClass;
begin
  Result := TcxCustomCellNavigator;
end;

procedure TcxCustomControlController.StartDrag(var DragObject: TDragObject);
begin
end;

function TcxCustomControlController.GetMouseWheelScrollingKind: TcxMouseWheelScrollingKind;
begin
  Result := mwskNone;
end;

function TcxCustomControlController.IsPixelScrollBar(
  AKind: TScrollBarKind): Boolean;
begin
  Result := False;
end;

procedure TcxCustomControlController.InitScrollBarsParameters;
begin
end;

procedure TcxCustomControlController.Scroll(AScrollBarKind: TScrollBarKind;
  AScrollCode: TScrollCode; var AScrollPos: Integer);
begin
end;

procedure TcxCustomControlController.SetFocusedRecordItem(
  ARecordIndex: TdxNativeInt; AItem: TcxCustomInplaceEditContainer);
begin
  AllowCheckEdit := False;
  try
    DisableCellsRefresh := (FocusedRecordIndex = ARecordIndex);
    FocusedRecordIndex := ARecordIndex;
    DisableCellsRefresh := DisableCellsRefresh and (FocusedItem = AItem);
    FocusedItem := AItem;
  finally
    AllowCheckEdit := True;
    CheckEdit;
    DisableCellsRefresh := False;
  end;
end;

procedure TcxCustomControlController.SetScrollBarInfo(
  AScrollBarKind: TScrollBarKind; AMin, AMax, AStep, APage, APos: Integer;
  AAllowShow, AAllowHide: Boolean);
begin
  EditingControl.SetScrollBarInfo(AScrollBarKind, AMin,
    AMax, AStep, APage, APos, AAllowShow, AAllowHide);
end;

procedure TcxCustomControlController.MakeFocusedItemVisible;
begin
  dxAbstractError;
end;

procedure TcxCustomControlController.MakeFocusedRecordVisible;
begin
  dxAbstractError;
end;

procedure TcxCustomControlController.ApplyFindFilterText(const AText: string);
begin
  DataController.FindFilterText := AText;
end;

procedure TcxCustomControlController.ClearFindFilterText;
begin
  DataController.ClearFindFilterText;
end;

function TcxCustomControlController.GetFindFilterText: string;
begin
  Result := DataController.FindFilterText;
end;

procedure TcxCustomControlController.HideFindPanel;
begin
  FindPanel.Hide;
end;

function TcxCustomControlController.IsFindPanelVisible: Boolean;
begin
  Result := FindPanel.Visible;
end;

procedure TcxCustomControlController.ShowFindPanel;
begin
  FindPanel.Show;
end;

procedure TcxCustomControlController.FocusChanged;
var
  AFocused: Boolean;
begin
  AFocused := EditingControl.IsFocused;
  with EditingController do
  begin
    AFocused := AFocused or (IsEditing and (Edit <> nil) and Edit.Focused);
    if AFocused then
    begin
      CheckEdit;
      if IsEditing and (Edit <> nil) and GetAlwaysShowEditor and not Edit.Focused and Edit.CanFocus then
        Edit.SetFocus
      else
        if (Edit <> nil) and not Edit.Focused and not GetAlwaysShowEditor then
          HideEdit(True)
        else
          if GetAlwaysShowEditor and not IsEditing and GetImmediateEditor then ShowEdit;
    end;
  end;
  if FFocused <> AFocused then
  begin
    FFocused := AFocused;
    ControlFocusChanged;
  end;
end;

procedure TcxCustomControlController.DoEnter;
begin
end;

procedure TcxCustomControlController.DoExit;
begin
  if GetCancelEditingOnExit then
    EditingControl.DataController.Cancel
  else
  begin
    EditingControl.DataController.PostEditingData;
    if IsImmediatePost then
      EditingControl.DataController.Post;
  end;
end;

function TcxCustomControlController.MayFocus: Boolean;
begin
  Result := not EditingControl.IsFocused or not IsEditing or
    (not GetAlwaysShowEditor and
     not (HitTestController.HitAtNavigator) and
     TcxCustomEditAccess(FEditingController.Edit).InternalValidateEdit);
end;

procedure TcxCustomControlController.RemoveFocus;
begin
end;

procedure TcxCustomControlController.SetFocus;
begin
  if not FEditingController.CanRemoveEditFocus then Exit;
  with EditingControl do
    if CanFocusEx and IsFocused then
      SetFocus;
  PostCheckEdit;
end;

procedure TcxCustomControlController.ControlFocusChanged;
begin
  with EditingController do
    if not Self.Focused and HideEditOnExit then HideEdit(True);
  EditingControl.ViewInfo.UpdateSelection;
  FindPanel.ControlFocusChanged(EditingControl.IsFocused);
end;

function TcxCustomControlController.GetDataController: TcxCustomDataController;
begin
  Result := EditingControl.DataController;
end;

function TcxCustomControlController.GetDesignSelectionHelper: TcxCustomDesignSelectionHelper;
begin
  Result := EditingControl.DesignSelectionHelper;
end;

function TcxCustomControlController.GetEditingItem: TcxCustomInplaceEditContainer;
begin
  Result := FEditingController.EditingItem;
end;

function TcxCustomControlController.GetIsEditing: Boolean;
begin
  Result := FEditingController.IsEditing;
end;

procedure TcxCustomControlController.SetEditingItem(
  Value: TcxCustomInplaceEditContainer);
begin
  FEditingController.EditingItem := Value;
end;

function TcxCustomControlController.GetItemForIncSearching: TcxCustomInplaceEditContainer;
begin
  Result := nil;
  if EditingControl.Options.OptionsBehavior.IncSearch then
    Result := EditingControl.Options.OptionsBehavior.IncSearchItem;
  if Result = nil then
    Result := FocusedItem;
end;

procedure TcxCustomControlController.SetIncSearchingText(const Value: string);
var
  AItem: TcxCustomInplaceEditContainer;

  function GetItemIndex: Integer;
  begin
    AItem := nil;
    if IsIncSearching then
      AItem := IncSearchingItem
    else
      AItem := ItemForIncSearching;
    if AItem <> nil then
      Result := AItem.ItemIndex
    else
      Result := -1;
  end;

begin
  if (IncSearchingText = Value) or (GetItemIndex = -1) then Exit;
  if Value = '' then
    CancelIncSearching
  else
    SearchLocate(AItem, Value);
  if (ItemForIncSearching <> nil) and (ItemForIncSearching.FocusedCellViewInfo <> nil) then
    ItemForIncSearching.FocusedCellViewInfo.Invalidate(True);
end;

{ TcxCustomControlViewInfo }

constructor TcxCustomControlViewInfo.Create(AOwner: TcxEditingControl);
begin
  FControl := AOwner;
  FState := FState or cvis_StyleInvalid;
  CreatePainter;
  FFindPanelViewInfo := GetFindPanelViewInfoClass.Create(Control);
  FEditCellViewInfoList := TList.Create;
  FEditCellViewInfoList.Capacity := 1024;
  Brush := TBrush.Create;
  SelectionBrush := TBrush.Create;
end;

destructor TcxCustomControlViewInfo.Destroy;
begin
  with FControl do
    if Assigned(FController) then FController.Reset;
  FreeAndNil(FFindPanelViewInfo);
  FPainter.Free;
  FEditCellViewInfoList.Free;
  Brush.Free;
  SelectionBrush.Free;
  inherited Destroy;
end;

procedure TcxCustomControlViewInfo.Calculate;
begin
  with Control.FBrushCache do
  begin
    BeginUpdate;
    try
      if State[cvis_StyleInvalid] then
      begin
        State[cvis_StyleInvalid] := False;
        CalculateDefaultHeights;
        ViewParams := Control.Styles.GetBackgroundParams;
        Brush.Color := ViewParams.Color;
        UpdateSelectionParams;
        Control.Invalidate;
      end;
      FBounds := Control.ClientBounds;
      FClientRect := CalculateClientRect;
      DoCalculate;
      IsDirty := False;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcxCustomControlViewInfo.Invalidate(ARecalculate: Boolean = False);
begin
  if ARecalculate then
    Control.LayoutChanged
  else
    Control.InvalidateRect(Bounds, False);
end;

procedure TcxCustomControlViewInfo.ValidateDirty;
begin
  if IsDirty then
    Calculate;
end;

function TcxCustomControlViewInfo.AddEditCellViewInfo(
  AViewInfoClass: TcxEditCellViewInfoClass;
  AEditContainer: TcxCustomInplaceEditContainer): TcxEditCellViewInfo;
begin
  Result := AViewInfoClass.Create(AEditContainer);
  FEditCellViewInfoList.Add(Result);
  IsDirty := True;
end;

function TcxCustomControlViewInfo.CalculateClientRect: TRect;
begin
  Result := Control.ClientBounds;
end;

function TcxCustomControlViewInfo.CalculateDefaultEditHeight: Integer;
begin
  Result := -1;
  dxAbstractError;
end;

procedure TcxCustomControlViewInfo.CalculateDefaultHeights;
begin
  FDefaultEditHeight := CalculateDefaultEditHeight;
end;

procedure TcxCustomControlViewInfo.CalculateFindPanel;
var
  ATop: Integer;
  ARect: TRect;
begin
  FindPanelViewInfo.CalculateViewParams;
  ARect.Left := Bounds.Left;
  ARect := cxRectSetWidth(ARect, FindPanelWidth);
  if FindPanelPosition = fppTop then
    ATop := Bounds.Top
  else
    ATop := Bounds.Bottom - FindPanelHeight;
  ARect := cxRectSetTop(ARect, ATop, FindPanelHeight);
  FindPanelViewInfo.CheckClipping(ARect, ARect);
  FindPanelViewInfo.VisibleInfoCalculated := False;
end;

procedure TcxCustomControlViewInfo.ClearEditCellViewInfos;
var
  I: Integer;
begin
  for I := 0 to FEditCellViewInfoList.Count - 1 do
    TcxEditCellViewInfo(FEditCellViewInfoList.List[I]).Free;
  FEditCellViewInfoList.Clear;
  IsDirty := True;
end;

procedure TcxCustomControlViewInfo.CreatePainter;
begin
  FPainter := Control.GetPainterClass.Create(Control);
end;

procedure TcxCustomControlViewInfo.DoCalculate;
var
  I: Integer;
begin
  Control.Controller.ViewInfoChanged;
  for I := 0 to FEditCellViewInfoList.Count - 1 do
    with TcxEditCellViewInfo(FEditCellViewInfoList.List[I]) do
      if Visible then DoCalculate;
end;

function TcxCustomControlViewInfo.GetFindPanelViewInfoClass: TcxControlFindPanelViewInfoClass;
begin
  Result := TcxControlFindPanelViewInfo;
end;

function TcxCustomControlViewInfo.IsFindPanelVisible: Boolean;
begin
  Result := Control.Controller.FindPanel.Visible;
end;

function TcxCustomControlViewInfo.IsPanArea(const APoint: TPoint): Boolean;
begin
  Result := False;
end;

procedure TcxCustomControlViewInfo.RemoveEditCellViewInfo(
  AViewInfo: TcxEditCellViewInfo);
begin
  FEditCellViewInfoList.Remove(AViewInfo);
  AViewInfo.Free;
  IsDirty := True;
end;

procedure TcxCustomControlViewInfo.SetFullPaintRegion(ACanvas: TcxCanvas);
begin
  ACanvas.SetClipRegion(TcxRegion.Create(ClientRect), roSet);
end;

procedure TcxCustomControlViewInfo.UpdateSelection;
begin
  UpdateSelectionParams;
end;

function TcxCustomControlViewInfo.GetFindPanelHeight: Integer;
begin
  if IsFindPanelVisible then
    Result := FindPanelViewInfo.Height
  else
    Result := 0;
end;

function TcxCustomControlViewInfo.GetFindPanelPosition: TcxFindPanelPosition;
begin
  Result := Control.Options.OptionsFindPanel.Position;
end;

function TcxCustomControlViewInfo.GetFindPanelVisibleRect: TRect;
begin
  if IsFindPanelVisible then
    Result := FindPanelViewInfo.VisibleRect
  else
    Result := cxNullRect;
end;

function TcxCustomControlViewInfo.GetFindPanelWidth: Integer;
begin
  if IsFindPanelVisible then
    Result := FindPanelViewInfo.Width
  else
    Result := 0;
end;

function TcxCustomControlViewInfo.GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
begin
  Result := FPainter.Painter;
end;

function TcxCustomControlViewInfo.GetScaleFactor: TdxScaleFactor;
begin
  Result := FControl.ScaleFactor;
end;

function TcxCustomControlViewInfo.GetState(AMask: Integer): Boolean;
begin
  Result := FState and AMask = AMask;
end;

procedure TcxCustomControlViewInfo.SetState(AMask: Integer; Value: Boolean);
begin
  if Value then
    FState := FState or AMask
  else
    FState := FState and not AMask;
end;

procedure TcxCustomControlViewInfo.UpdateSelectionParams;
begin
  SelectionParams := Control.Styles.GetSelectionParams;
  SelectionBrush.Color := SelectionParams.Color;
end;

{ TcxCustomControlCells }

procedure TcxCustomControlCells.BeforePaint;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].CheckVisibleInfo;
end;

function TcxCustomControlCells.CalculateHitTest(
  AHitTest: TcxCustomHitTestController): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := Count - 1 downto 0 do
  begin
    Result := Items[I].GetHitTest(AHitTest);
    if Result then Exit;
  end;
end;

procedure TcxCustomControlCells.Clear;
var
  I: Integer;
begin
  if OwnObjects then
  begin
    for I := 0 to Count - 1 do
      if (Items[I] = nil) or Items[I].IsPersistent then
        Continue
      else
        Items[I].Free;
  end;
  SetCount(0);
  SetCapacity(0);
end;

procedure TcxCustomControlCells.DeleteAll;
begin
  SetCount(0);
end;

procedure TcxCustomControlCells.ExcludeFromClipping(ACanvas: TcxCanvas);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].ExcludeFromPaint(ACanvas);
end;

procedure TcxCustomControlCells.Paint(ACanvas: TcxCanvas;
  AHandler: TcxCustomDrawCellEvent);

  procedure DoDrawItem(AItem: TcxCustomViewInfoItem);
  var
    ADone: Boolean;
  begin
    AItem.BeforeCustomDraw(ACanvas);
    AHandler(ACanvas, AItem, ADone);
    if not ADone then
    begin
      AItem.AfterCustomDraw(ACanvas);
      AItem.Draw(ACanvas);
    end;
  end;

var
  I: Integer;
  AClipRgn: TcxRegion;
  AItem: TcxCustomViewInfoItem;
begin
  for I := 0 to Count - 1 do
  begin
    AItem := Items[I];
    AItem.CheckVisibleInfo;
    if AItem.Visible and ACanvas.RectVisible(AItem.ClipRect) then
      if AItem.HasClipping then
      begin
        AClipRgn := ACanvas.GetClipRegion;
        ACanvas.IntersectClipRect(AItem.ClipRect);
        DoDrawItem(AItem);
        ACanvas.SetClipRegion(AClipRgn, roSet);
      end
      else
        DoDrawItem(AItem);
  end;
end;

function TcxCustomControlCells.GetItem(AIndex: Integer): TcxCustomViewInfoItem;
begin
  Result := TcxCustomViewInfoItem(List[AIndex]);
end;

{ TcxExtEditingControlViewInfo }

constructor TcxExtEditingControlViewInfo.Create(AOwner: TcxEditingControl);
begin
  inherited Create(AOwner);
  FNavigatorSiteViewInfo := GetNavigatorSiteViewInfoClass.Create(Control);
end;

destructor TcxExtEditingControlViewInfo.Destroy;
begin
  FreeAndNil(FNavigatorSiteViewInfo);
  inherited Destroy;
end;

procedure TcxExtEditingControlViewInfo.Invalidate(ARecalculate: Boolean = False);
begin
  inherited Invalidate(ARecalculate);
  if not ARecalculate and IsNavigatorVisible then
    NavigatorSiteViewInfo.Invalidate;
end;

procedure TcxExtEditingControlViewInfo.AddNavigatorSiteToPaintRegion(ACanvas: TcxCanvas);
begin
  ACanvas.SetClipRegion(TcxRegion.Create(NavigatorSiteVisibleRect), roAdd);
end;

procedure TcxExtEditingControlViewInfo.AdjustClientBounds(var ABounds: TRect);
begin
  Dec(ABounds.Right, GetRightNonClientWidth);
  Dec(ABounds.Bottom, GetBottomNonClientHeight);
end;

procedure TcxExtEditingControlViewInfo.CalculateNavigator;
begin
  if IsNavigatorVisible then
    FNavigatorSiteViewInfo.Calculate;
end;

function TcxExtEditingControlViewInfo.CanHScrollBarHide: Boolean;
begin
  Result := not IsNavigatorVisible or (Control.GetScrollbarMode <> sbmClassic);
end;

function TcxExtEditingControlViewInfo.GetBottomNonClientHeight: Integer;
begin
  if IsNavigatorVisible then
    Result := FNavigatorSiteViewInfo.GetHeight
  else
    if not Control.IsPopupScrollBars and Control.IsScrollBarActive(sbHorizontal) then
      Result := Control.GetScrollBarSize.cy
    else
      Result := 0;
end;

function TcxExtEditingControlViewInfo.GetRightNonClientWidth: Integer;
begin
  if not Control.IsPopupScrollBars and Control.IsScrollBarActive(sbVertical) then
    Result := Control.VScrollBar.Width
  else
    Result := 0;
end;

procedure TcxExtEditingControlViewInfo.GetHScrollBarBounds(var ABounds: TRect);
begin
  case Control.GetScrollbarMode of
    sbmClassic:
      begin
        ABounds.Top := ABounds.Bottom;
        ABounds.Bottom := ABounds.Top + GetBottomNonClientHeight;
        if IsNavigatorVisible then
          Inc(ABounds.Left, FNavigatorSiteViewInfo.GetWidth);
      end
  else
    ABounds.Top := ABounds.Bottom - Control.GetScrollBarSize.cy;
    if Control.IsScrollBarActive(sbVertical) then
      ABounds.Right := ABounds.Right - Control.GetScrollBarSize.cx;
  end;
end;

function TcxExtEditingControlViewInfo.GetNavigatorBounds: TRect;
begin
  Result := FNavigatorSiteViewInfo.GetNavigatorBounds;
end;

procedure TcxExtEditingControlViewInfo.GetVScrollBarBounds(var ABounds: TRect);
begin
  if Control.GetScrollbarMode = sbmHybrid then
  begin
    ABounds := Control.ClientBounds;
    ABounds.Left := ABounds.Right  - Control.GetScrollBarSize.cx;
    if Control.IsScrollBarActive(sbHorizontal) then
      ABounds.Bottom := ABounds.Bottom - Control.GetScrollBarSize.cy;
  end;
end;

function TcxExtEditingControlViewInfo.IsNavigatorSizeChanged: Boolean;
begin
  Result := FNavigatorSiteViewInfo.IsNavigatorSizeChanged;
end;

function TcxExtEditingControlViewInfo.IsNavigatorVisible: Boolean;
begin
  Result := IsNavigatorSupported and Control.Navigator.Visible;
end;

procedure TcxExtEditingControlViewInfo.NavigatorInvalidate;
begin
  FNavigatorSiteViewInfo.Invalidate;
end;

procedure TcxExtEditingControlViewInfo.NavigatorStateChanged;
begin
  FNavigatorSiteViewInfo.NavigatorStateChanged;
end;

function TcxExtEditingControlViewInfo.GetNavigatorSiteViewInfoClass: TcxCustomNavigatorSiteViewInfoClass;
begin
  Result := TcxCustomNavigatorSiteViewInfo;
end;

function TcxExtEditingControlViewInfo.GetNavigatorSiteVisibleRect: TRect;
begin
  if IsNavigatorVisible then
    Result := NavigatorSiteViewInfo.VisibleRect
  else
    Result := cxNullRect;
end;

function TcxExtEditingControlViewInfo.IsNavigatorSupported: Boolean;
begin
  Result := Control.GetNavigatorButtonsControl <> nil;
end;

procedure TcxExtEditingControlViewInfo.SetFullPaintRegion(ACanvas: TcxCanvas);
begin
  inherited SetFullPaintRegion(ACanvas);
  if IsNavigatorVisible then
    AddNavigatorSiteToPaintRegion(ACanvas);
end;

function TcxExtEditingControlViewInfo.GetControl: TcxExtEditingControl;
begin
  Result := TcxExtEditingControl(inherited Control);
end;

{ TcxCustomViewInfoItem }

constructor TcxCustomViewInfoItem.Create(AOwner: TObject);
begin
  FOwner := AOwner;
end;

procedure TcxCustomViewInfoItem.Assign(Source: TcxCustomViewInfoItem);
begin
  DisplayRect := Source.DisplayRect;
  ClipRect := Source.ClipRect;
  ItemVisible := Source.ItemVisible;
  ItemViewParams := Source.ItemViewParams;
end;

procedure TcxCustomViewInfoItem.CheckVisibleInfo;
begin
  if Visible and not FVisibleInfoCalculated then
  begin
    DoCalculate;
    FVisibleInfoCalculated := True;
  end;
end;

class function TcxCustomViewInfoItem.CustomDrawID: Integer;
begin
  Result := 0;
end;

procedure TcxCustomViewInfoItem.Draw(ACanvas: TcxCanvas);
var
  FPrevCanvas: TcxCanvas;
begin
  CheckVisibleInfo;
  FPrevCanvas := ControlCanvas;
  try
    ControlCanvas := ACanvas;
    DoDraw(ControlCanvas);
  finally
    ControlCanvas := FPrevCanvas;
  end;
end;

procedure TcxCustomViewInfoItem.Invalidate(ARecalculate: Boolean = False);
begin
  if ARecalculate then
    DoCalculate;
  Invalidate(VisibleRect);
end;

procedure TcxCustomViewInfoItem.CheckClipping(const ADisplayRect: TRect);
begin
  CheckClipping(ADisplayRect, ControlViewInfo.FClientRect);
end;

procedure TcxCustomViewInfoItem.DoCalculate;
begin
  dxAbstractError;
end;

procedure TcxCustomViewInfoItem.DoDraw(ACanvas: TcxCanvas);
begin
  if not Transparent then
    ACanvas.FillRect(ClipRect, ViewParams);
end;

procedure TcxCustomViewInfoItem.DoHorzOffset(AShift: Integer);
begin
  dxAbstractError;
end;

procedure TcxCustomViewInfoItem.DoVertOffset(AShift: Integer);
begin
  dxAbstractError;
end;

function TcxCustomViewInfoItem.DrawBackgroundHandler(
  ACanvas: TcxCanvas; const ABounds: TRect): Boolean;
begin
  Result := (Bitmap <> nil) and not Bitmap.Empty;
  if Result and not Transparent then
    ACanvas.FillRect(ABounds, Bitmap)
  else
    Result := Transparent;
end;

function TcxCustomViewInfoItem.ExcludeFromPaint(
  ACanvas: TcxCanvas): Boolean;
begin
  Result := Visible;
  if Result then
    ACanvas.ExcludeClipRect(ClipRect);
end;

function TcxCustomViewInfoItem.GetControl: TcxEditingControl;
begin
  Result := nil;
  dxAbstractError;
end;

function TcxCustomViewInfoItem.GetHitTest(
  AHitTest: TcxCustomHitTestController): Boolean;
begin
  Result := False;
end;

procedure TcxCustomViewInfoItem.Invalidate(const R: TRect; AEraseBackground: Boolean);
begin
  if Visible then
    Control.InvalidateRect(R, AEraseBackground);
end;

function TcxCustomViewInfoItem.IsPersistent: Boolean;
begin
  Result := False;
end;

function TcxCustomViewInfoItem.IsTransparent: Boolean;
begin
  with ItemViewParams do
    Result := (Bitmap <> nil) and not Bitmap.Empty;
end;

procedure TcxCustomViewInfoItem.Scroll(const DX, DY: Integer);
begin
  if (DX = 0) and (DY = 0) then Exit;
  OffsetRect(DisplayRect, DX, DY);
  CheckClipping(DisplayRect, VisibleBounds);
  VisibleInfoCalculated := False;
end;

procedure TcxCustomViewInfoItem.UpdateEditRect;
begin
  CheckClipping(DisplayRect);
end;

procedure TcxCustomViewInfoItem.AfterCustomDraw(ACanvas: TcxCanvas);
begin
  ItemViewParams.Color := ACanvas.Brush.Color;
  ItemViewParams.TextColor := ACanvas.Font.Color;
end;

procedure TcxCustomViewInfoItem.BeforeCustomDraw(ACanvas: TcxCanvas);
begin
  ACanvas.SetParams(ViewParams);
end;

procedure TcxCustomViewInfoItem.CheckClipping(
  const ADisplayRect, AAvailableRect: TRect);
begin
  DisplayRect := ADisplayRect;
  VisibleBounds := AAvailableRect;
  ItemVisible := cxRectIntersect(ClipRect, AAvailableRect, DisplayRect);
  FHasClipping := not cxRectIsEqual(ClipRect, DisplayRect);
end;

function TcxCustomViewInfoItem.GetBitmap: TBitmap;
begin
  Result := ViewParams.Bitmap;
end;

function TcxCustomViewInfoItem.GetControlViewInfo: TcxCustomControlViewInfo;
begin
  Result := Control.ViewInfo;
end;

function TcxCustomViewInfoItem.GetPainter: TcxCustomLookAndFeelPainter;
begin
  Result := Control.LookAndFeelPainter;
end;

function TcxCustomViewInfoItem.GetScaleFactor: TdxScaleFactor;
begin
  Result := Control.ScaleFactor;
end;

{ TcxEditCellViewInfo }

destructor TcxEditCellViewInfo.Destroy;
begin
  if (EditContainer <> nil) and not EditContainer.IsDestroying then
    Control.Controller.HitTestController.CheckDestroyingItem(Self);
  FreeAndNil(ViewInfo);
  if IsViewDataCreated then
    FreeAndNil(ViewData);
  inherited Destroy;
end;

procedure TcxEditCellViewInfo.Assign(Source: TcxCustomViewInfoItem);
begin
  if Source is TcxCustomViewInfoItem then
  begin
    CellEditRect := TcxEditCellViewInfo(Source).CellEditRect;
    CellContentRect := TcxEditCellViewInfo(Source).CellContentRect;
    CellBorders := TcxEditCellViewInfo(Source).CellBorders;
  end;
  inherited Assign(Source);
end;

function TcxEditCellViewInfo.Refresh(ARecalculate: Boolean): Boolean;
begin
  Result := False;
  if EditContainer = nil then Exit;
  if ARecalculate then
  begin
    if IsAutoHeight then
      Result := ChangedHeight(CellHeight, CalculateEditHeight);
    if not Result then DoCalculate;
  end
  else
    if ViewInfo <> nil then
    begin
      ItemViewParams := GetEditViewParams;
      ViewInfo.TextColor := ItemViewParams.TextColor;
      ViewInfo.Font := ItemViewParams.Font;
      ViewInfo.BackgroundColor := ItemViewParams.Color;
      ViewInfo.Transparent := IsTransparent;
    end;
  if not Result then Invalidate;
end;

function TcxEditCellViewInfo.GetHintBounds: TRect;
begin
  Result := ClipRect;
end;

function TcxEditCellViewInfo.IsNeedHint(ACanvas: TcxCanvas; const P: TPoint;
  out AText: TCaption; out AIsMultiLine: Boolean; out ATextRect: TRect;
  var IsNeedOffsetHint: Boolean): Boolean;
begin
  Result := Visible and
    ViewInfo.NeedShowHint(ACanvas, P, GetControl.ClientBounds,  AText, AIsMultiLine, ATextRect, GetMaxLineCount);
  IsNeedOffsetHint := False;
end;

procedure TcxEditCellViewInfo.UpdateHotTrackState(const APoint: TPoint);
var
  P: TPoint;
  ATempViewInfo: TcxCustomEditViewInfo;
begin
  if not IsSupportedHotTrack then Exit;
  ATempViewInfo := TcxCustomEditViewInfo(Properties.GetViewInfoClass.Create);
  try
    ATempViewInfo.Assign(ViewInfo);
    cxAssignEditStyle(Self);
    ViewData.ContentOffset := ContentOffset;
    ViewData.CalculateEx(EditContainer.GetControlCanvas, ContentRect,
      cxPointOffset(APoint, cxPointInvert(GetCellOrg)), cxmbNone, [], ViewInfo, False);
    P := ViewInfo.SetOrigin(cxPointOffset(BoundsRect.TopLeft, GetCellOrg));
    if (EditContainer <> nil) and (EditContainer.EditingControl.DragAndDropState = ddsNone) then
      ViewInfo.Repaint(Control, ATempViewInfo);
    ViewInfo.SetOrigin(P);
  finally
    ATempViewInfo.Free;
  end;
end;

function TcxEditCellViewInfo.HasHintPoint(const P: TPoint): Boolean;
begin
  Result := PtInRect(cxRectOffset(ClipRect, GetCellOrg), P);
end;

function TcxEditCellViewInfo.IsHintAtMousePos: Boolean;
begin
  Result := False;
end;

function TcxEditCellViewInfo.UseHintHidePause: Boolean;
begin
  Result := True;
end;

function TcxEditCellViewInfo.CalculateEditHeight: Integer;
begin
  if IsAutoHeight then
  begin
    with EditContainer do
    begin
      InitEditViewInfo(Self);
      Result := GetEditHeight(Self);
    end;
  end
  else
    Result := ControlViewInfo.DefaultEditHeight;
end;

function TcxEditCellViewInfo.CalculateEditWidth: Integer;
begin
  Result := EditContainer.GetEditHeight(Self);
end;

function TcxEditCellViewInfo.ChangedHeight(APrevHeight, ANewHeight: Integer): Boolean;
begin
  Result := APrevHeight <> ANewHeight;
  CellHeight := ANewHeight;
end;

procedure TcxEditCellViewInfo.CheckClipping(const ADisplayRect, AAvailableRect: TRect);
begin
  inherited CheckClipping(ADisplayRect, AAvailableRect);
  CellContentRect := DisplayRect;
  if CellBorders = [] then
    CellEditRect := cxRectContent(VisibleRect, ContentOffset)
  else
  begin
    with CellContentRect do
    begin
      Inc(Left, Byte(bLeft in CellBorders));
      Inc(Top, Byte(bTop in CellBorders));
      Dec(Right, Byte(bRight in CellBorders));
      Dec(Bottom, Byte(bBottom in CellBorders));
    end;
    if cxRectIntersect(CellEditRect, VisibleRect, CellContentRect) then
      CellEditRect := cxRectContent(CellEditRect, ContentOffset);
  end;
end;

function TcxEditCellViewInfo.ContentOffset: TRect;
begin
  Result := cxSimpleRect;
end;

function TcxEditCellViewInfo.CorrectHotTrackPoint(
  const APoint: TPoint): TPoint;
begin
  Result := APoint;
end;

procedure TcxEditCellViewInfo.DoCalculate;
begin
  with EditContainer do
  begin
    if IsAutoHeight then
    begin
      ViewData.InplaceEditParams.Position.RecordIndex := RecordIndex;
      ViewData.InplaceEditParams.Position.Item := Self;
    end
    else
      InitEditViewInfo(Self);

    CalculateEditViewInfo(CellValue, Self, cxInvalidPoint);
  end;
end;

procedure TcxEditCellViewInfo.EditOwnerInvalidate(const R: TRect; AEraseBackground: Boolean);
begin
  Invalidate(cxRectOffset(R, CellContentRect.TopLeft), AEraseBackground);
end;

procedure TcxEditCellViewInfo.AfterDrawCellBackground(ACanvas: TcxCanvas);
begin
// do nothing
end;

procedure TcxEditCellViewInfo.AfterDrawCellValue(ACanvas: TcxCanvas);
begin
// do nothing
end;

procedure TcxEditCellViewInfo.CalculateCellEditorBounds(AViewInfo: TcxCustomEditViewInfo; var R: TRect);
begin
// do nothing
end;

procedure TcxEditCellViewInfo.CanDrawCellValue(var Allow: Boolean);
begin
// do nothing
end;

function TcxEditCellViewInfo.GetButtonTransparency: TcxEditButtonTransparency;
var
  B1: TcxEditingControlEditShowButtons;
  B2: TcxEditItemShowEditButtons;
begin
  B1 := Control.Options.OptionsView.ShowEditButtons;
  B2 := EditContainer.Options.ShowEditButtons;
  if (B2 = eisbAlways) or (B2 = eisbDefault) and
   ((B1 = ecsbAlways) or (B1 = ecsbFocused) and Focused) then
    Result := ebtNone
  else
    Result := ebtHideInactive;
end;

function TcxEditCellViewInfo.GetCellOrg: TPoint;
begin
  Result := cxNullPoint;
end;

function TcxEditCellViewInfo.GetControl: TcxEditingControl;
begin
  if EditContainer = nil then
    Result := nil
  else
    Result := EditContainer.EditingControl;
end;

function TcxEditCellViewInfo.GetDisplayValue: Variant;
begin
  with EditContainer.DataController do
  begin
    if (RecordIndex >= 0) and (RecordIndex < RecordCount) then
      Result := EditContainer.GetDisplayValue(Properties, RecordIndex)
    else
      Result := Null
  end;
end;

function TcxEditCellViewInfo.GetEditContainer: TcxCustomInplaceEditContainer;
begin
  Result := TcxCustomInplaceEditContainer(Owner);
end;

function TcxEditCellViewInfo.GetEditRect: TRect;
begin
  cxRectIntersect(Result, CellEditRect, EditContainer.FEditingControl.ClientBounds);
end;

function TcxEditCellViewInfo.GetEditViewParams: TcxViewParams;
begin
  Result := Control.Styles.GetBackgroundParams;
end;

function TcxEditCellViewInfo.GetFindBKColor: Integer;
begin
  Result := Control.Styles.GetSearchResultHighlight.Color;
end;

function TcxEditCellViewInfo.GetFindTextColor: Integer;
begin
  Result := Control.Styles.GetSearchResultHighlight.TextColor;
end;

procedure TcxEditCellViewInfo.GetFindTextPosition(out AStart, ALength: Integer);
var
  AText: string;
begin
  AStart := Control.Controller.GetFindStartPosition(RecordIndex, EditContainer.ItemIndex, AText);
  ALength := Length(AText);
end;

function TcxEditCellViewInfo.GetFocused: Boolean;
begin
  with EditContainer do
    Result := (FocusedCellViewInfo = Self) and (DataController.FocusedRecordIndex = RecordIndex);
end;

function TcxEditCellViewInfo.GetInplaceEditPosition: TcxInplaceEditPosition;
begin
  Result.Item := EditContainer;
  Result.RecordIndex := RecordIndex;
end;

function TcxEditCellViewInfo.GetMaxLineCount: Integer;
begin
  Result := Control.Options.OptionsView.CellTextMaxLineCount;
end;

function TcxEditCellViewInfo.GetRecordIndex: TdxNativeInt;
begin
  Result := 0;
end;

function TcxEditCellViewInfo.GetSelectedTextColor: Integer;
begin
  Result := $FFFFFF xor ColorToRgb(ViewParams.TextColor);
end;

function TcxEditCellViewInfo.GetSelectedBKColor: Integer;
begin
  Result := $FFFFFF xor ColorToRgb(ViewParams.Color);
end;

function TcxEditCellViewInfo.GetViewData(out AIsViewDataCreated: Boolean): TcxCustomEditViewData;
begin
  AIsViewDataCreated := False;
  Result := ViewData;
end;

function TcxEditCellViewInfo.GetViewInfoData: Pointer;
begin
  Result := Pointer(RecordIndex);
end;

function TcxEditCellViewInfo.FormatDisplayValue(AValue: Variant): Variant;
begin
  Result := AValue;
end;

function TcxEditCellViewInfo.GetIncSearchText: string;
begin
  Result := Control.Controller.IncSearchingText;
end;

procedure TcxEditCellViewInfo.InitFindTextSelection;
begin
  ViewData.SelTextColor := GetFindTextColor;
  ViewData.SelBackgroundColor := GetFindBKColor;
  GetFindTextPosition(ViewData.SelStart, ViewData.SelLength);
end;

procedure TcxEditCellViewInfo.InitIncSearchTextSelection;
begin
  ViewData.SelTextColor := GetSelectedTextColor;
  ViewData.SelBackgroundColor := GetSelectedBKColor;
  ViewData.SelStart := 0;
  ViewData.SelLength := Length(GetIncSearchText);
end;

procedure TcxEditCellViewInfo.InitTextSelection;
begin
  if NeedHighlightIncSearchText then
    InitIncSearchTextSelection
  else
    if NeedHighlightFindText then
      InitFindTextSelection
    else
      ViewData.SelLength := 0;
end;

function TcxEditCellViewInfo.IsAutoHeight: Boolean;
begin
  Result := Control.Options.OptionsView.CellAutoHeight;
end;

function TcxEditCellViewInfo.IsEndEllipsis: Boolean;
begin
  Result := Control.Options.OptionsView.CellEndEllipsis;
end;

function TcxEditCellViewInfo.IsSupportedHotTrack: Boolean;
begin
  Result := not Control.IsDesigning and
    (esoHotTrack in Properties.GetSupportedOperations) and
    ViewData.Style.LookAndFeel.Painter.IsButtonHotTrack;
end;

function TcxEditCellViewInfo.NeedHighlightFindText: Boolean;
begin
  Result := Control.NeedHighlightFindText and EditContainer.CanFind;
end;

function TcxEditCellViewInfo.NeedHighlightIncSearchText: Boolean;
begin
  Result := Control.Controller.IsIncSearching and EditContainer.IncSearching and
    (Control.Controller.FocusedRecordIndex = RecordIndex);
end;

procedure TcxEditCellViewInfo.SetBounds(const ABounds: TRect; const ADisplayRect: TRect);
begin
  CheckClipping(ABounds, ADisplayRect);
  DoCalculate;
end;

procedure TcxEditCellViewInfo.AfterDrawCellBackgroundHandler(ACanvas: TcxCanvas);
begin
  AfterDrawCellBackground(ACanvas);
end;

procedure TcxEditCellViewInfo.AfterDrawCellValueHandler(ACanvas: TcxCanvas);
begin
  AfterDrawCellValue(ACanvas);
end;

procedure TcxEditCellViewInfo.CalculateEditorBoundsHandler(AViewInfo: TcxCustomEditViewInfo; var R: TRect);
begin
  CalculateCellEditorBounds(AViewInfo, R);
end;

procedure TcxEditCellViewInfo.CanDrawEditValueHandler(Sender: TcxCustomEditViewInfo; var Allow: Boolean);
begin
  CanDrawCellValue(Allow);
end;

function TcxEditCellViewInfo.GetTransparent: Boolean;
begin
  Result := ViewInfo.Transparent or CellTransparent;
end;

procedure TcxEditCellViewInfo.SetTransparent(Value: Boolean);
begin
  CellTransparent := Value;
  ViewInfo.Transparent := Value;
end;

{ TcxExtEditingControlNavigatorHelper }

constructor TcxExtEditingControlNavigatorViewInfo.Create(
  AOwnerControl: TcxExtEditingControl);
begin
  inherited Create(AOwnerControl);
  FOwnerControl := AOwnerControl;
end;

function TcxExtEditingControlNavigatorViewInfo.GetControl: TcxControl;
begin
  Result := FOwnerControl;
end;

function TcxExtEditingControlNavigatorViewInfo.GetNavigatorOffset: Integer;
begin
  Result := FOwnerControl.OptionsView.NavigatorOffset;
end;

procedure TcxExtEditingControlNavigatorViewInfo.UpdateNavigatorSiteBounds(const ABounds: TRect);
begin
  FOwnerControl.ViewInfo.NavigatorSiteViewInfo.UpdateBounds(ABounds);
end;

{ TcxCustomNavigatorSiteViewInfo }

constructor TcxCustomNavigatorSiteViewInfo.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  FNavigatorViewInfo := TcxExtEditingControlNavigatorViewInfo.Create(GetOwnerControl);
end;

destructor TcxCustomNavigatorSiteViewInfo.Destroy;
begin
  FreeAndNil(FNavigatorViewInfo);
  inherited;
end;

procedure TcxCustomNavigatorSiteViewInfo.Calculate;
begin
  FNavigatorViewInfo.Calculate;
end;

procedure TcxCustomNavigatorSiteViewInfo.DoCalculate;
begin
end;

procedure TcxCustomNavigatorSiteViewInfo.DoDraw(ACanvas: TcxCanvas);
begin
  ACanvas.FillRect(BoundsRect, ViewParams);
end;

procedure TcxCustomNavigatorSiteViewInfo.DrawEx(ACanvas: TcxCanvas);
begin
  Draw(ACanvas);
  FNavigatorViewInfo.Paint;
end;

function TcxCustomNavigatorSiteViewInfo.GetControl: TcxEditingControl;
begin
  Result := TcxEditingControl(Owner);
end;

function TcxCustomNavigatorSiteViewInfo.GetHeight: Integer;
begin
  Result := FNavigatorViewInfo.GetHeight;
end;

function TcxCustomNavigatorSiteViewInfo.GetHitTest(AHitTest: TcxCustomHitTestController): Boolean;
begin
  Result := PtInRect(BoundsRect, AHitTest.HitPoint);
  if Result then
    AHitTest.HitTestItem := Self;
end;

function TcxCustomNavigatorSiteViewInfo.GetNavigatorBounds: TRect;
begin
  Result := FNavigatorViewInfo.GetNavigatorBounds;
end;

function TcxCustomNavigatorSiteViewInfo.GetWidth: Integer;
begin
  Result := FNavigatorViewInfo.GetWidth;
end;

function TcxCustomNavigatorSiteViewInfo.IsNavigatorSizeChanged: Boolean;
begin
  Result := FNavigatorViewInfo.IsNavigatorSizeChanged;
end;

procedure TcxCustomNavigatorSiteViewInfo.NavigatorStateChanged;
begin
  FNavigatorViewInfo.Update;
end;

procedure TcxCustomNavigatorSiteViewInfo.UpdateBounds(const ABounds: TRect);
var
  AVisibleBounds: TRect;
begin
  cxRectIntersect(AVisibleBounds, ABounds, cxRectInflate(Control.Bounds, -Control.BorderSize));
  CheckClipping(ABounds, AVisibleBounds);
  OwnerControl.Styles.GetViewParams(ecs_Navigator, nil, nil, ItemViewParams);
end;

// IcxHotTrackElement
function TcxCustomNavigatorSiteViewInfo.GetHintBounds: TRect;
begin
  Result := cxNullRect;
end;

function TcxCustomNavigatorSiteViewInfo.IsNeedHint(ACanvas: TcxCanvas;
  const P: TPoint; out AText: TCaption; out AIsMultiLine: Boolean;
  out ATextRect: TRect; var IsNeedOffsetHint: Boolean): Boolean;
begin
  Result := False;
end;

procedure TcxCustomNavigatorSiteViewInfo.UpdateHotTrackState(
  const APoint: TPoint);
begin
  if not PtInRect(BoundsRect, APoint) then
    FNavigatorViewInfo.MouseLeave;
end;

procedure TcxCustomNavigatorSiteViewInfo.MouseDown(AButton: TMouseButton; X,
  Y: Integer);
begin
  FNavigatorViewInfo.MouseDown(X, Y);
end;

procedure TcxCustomNavigatorSiteViewInfo.MouseLeave;
begin
  FNavigatorViewInfo.MouseLeave;
end;

procedure TcxCustomNavigatorSiteViewInfo.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  FNavigatorViewInfo.MouseMove(X, Y);
end;

procedure TcxCustomNavigatorSiteViewInfo.MouseUp(AButton: TMouseButton; X,
  Y: Integer);
begin
  FNavigatorViewInfo.MouseUp(AButton, X, Y);
end;

function TcxCustomNavigatorSiteViewInfo.GetOwnerControl: TcxExtEditingControl;
begin
  Result := TcxExtEditingControl(Owner);
end;

{ TcxControlFindPanelItemViewInfo }

constructor TcxControlFindPanelItemViewInfo.Create(AFindPanelViewInfo: TcxControlFindPanelViewInfo);
begin
  FFindPanelViewInfo := AFindPanelViewInfo;
  inherited Create(FindPanelViewInfo.Owner);
  FState := cxbsNormal;
end;

procedure TcxControlFindPanelItemViewInfo.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  State := cxbsPressed;
end;

procedure TcxControlFindPanelItemViewInfo.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if MouseCapture then
    State := cxbsPressed
  else
    State := cxbsHot
end;

procedure TcxControlFindPanelItemViewInfo.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AIsClick: Boolean;
begin
  AIsClick := (State = cxbsPressed) and (Button = mbLeft);
  State := cxbsNormal;
  if AIsClick then
    Click;
end;

procedure TcxControlFindPanelItemViewInfo.DoCancelMode;
begin
  State := cxbsNormal;
end;

procedure TcxControlFindPanelItemViewInfo.TrackingMouseLeave;
begin
  MouseLeave;
end;

procedure TcxControlFindPanelItemViewInfo.MouseLeave;
begin
  State := cxbsNormal;
end;

function TcxControlFindPanelItemViewInfo.PtInCaller(const P: TPoint): Boolean;
begin
  Result := HasPoint(P);
end;

procedure TcxControlFindPanelItemViewInfo.Click;
begin
//do nothing
end;

procedure TcxControlFindPanelItemViewInfo.DoCalculate;
begin
//do nothing
end;

procedure TcxControlFindPanelItemViewInfo.DoDraw(ACanvas: TcxCanvas);
begin
  if Focused then
    ACanvas.DrawFocusRect(GetFocusRect(ACanvas));
end;

function TcxControlFindPanelItemViewInfo.GetControl: TcxEditingControl;
begin
  Result := TcxEditingControl(Owner);
end;

function TcxControlFindPanelItemViewInfo.GetFocusRect(ACanvas: TcxCanvas): TRect;
begin
  Result := Painter.ScaledButtonFocusRect(ACanvas, BoundsRect, ScaleFactor);
end;

function TcxControlFindPanelItemViewInfo.HasPoint(const APoint: TPoint): Boolean;
begin
  Result := Visible and PtInRect(BoundsRect, APoint);
end;

function TcxControlFindPanelItemViewInfo.GetFindPanel: TcxControlFindPanel;
begin
  Result := FindPanelViewInfo.FindPanel;
end;

function TcxControlFindPanelItemViewInfo.GetMouseCapture: Boolean;
begin
  Result := Control.MouseCaptureObject = Self;
end;

function TcxControlFindPanelItemViewInfo.GetState: TcxButtonState;
begin
  if Focused then
    Result := cxbsDefault
  else
    Result := FState;
end;

procedure TcxControlFindPanelItemViewInfo.SetMouseCapture(AValue: Boolean);
begin
  if MouseCapture <> AValue then
    if AValue then
      Control.MouseCaptureObject := Self
    else
      Control.MouseCaptureObject := nil;
end;

procedure TcxControlFindPanelItemViewInfo.SetState(AValue: TcxButtonState);
begin
  if FState <> AValue then
  begin
    FState := AValue;
    Invalidate;
    case State of
      cxbsNormal:
        EndMouseTracking(Self);
      cxbsHot:
        BeginMouseTracking(Control, VisibleRect, Self);
      cxbsPressed:
        MouseCapture := True;
    end;
  end;
end;

{ TcxControlFindPanelCloseButtonViewInfo }

procedure TcxControlFindPanelCloseButtonViewInfo.Click;
begin
  inherited Click;
  FindPanel.CloseButtonExecute;
end;

procedure TcxControlFindPanelCloseButtonViewInfo.DoDraw(ACanvas: TcxCanvas);
begin
  Painter.DrawScaledFilterCloseButton(ACanvas, BoundsRect, State, ScaleFactor);
  inherited DoDraw(ACanvas);
end;

function TcxControlFindPanelCloseButtonViewInfo.GetFocused: Boolean;
begin
  Result := (FindPanel.FocusedItem = fpfiCloseButton) and Control.IsFocused;
end;

function TcxControlFindPanelCloseButtonViewInfo.GetHeight: Integer;
begin
  Result := Painter.ScaledFilterCloseButtonSize(ScaleFactor).Y;
end;

function TcxControlFindPanelCloseButtonViewInfo.GetWidth: Integer;
begin
  Result := Painter.ScaledFilterCloseButtonSize(ScaleFactor).X;
end;

{ TcxControlFindPanelButtonViewInfo }

procedure TcxControlFindPanelButtonViewInfo.DoDraw(ACanvas: TcxCanvas);
begin
  Painter.DrawScaledButton(ACanvas, BoundsRect, Text, State, ScaleFactor);
  inherited DoDraw(ACanvas);
end;

function TcxControlFindPanelButtonViewInfo.GetHeight: Integer;
begin
  Result := TextHeight + 2 * Painter.ButtonBorderSize + 2 * Painter.ScaledButtonTextOffset(ScaleFactor);
  Result := Max(Result, cxControlFindPanelButtonMinHeight);
end;

function TcxControlFindPanelButtonViewInfo.GetWidth: Integer;
begin
  Result := TextWidth + 2 * Painter.ButtonBorderSize + 2 * Painter.ScaledButtonTextOffset(ScaleFactor);
  Result := Max(Result, cxControlFindPanelButtonMinWidth);
end;

function TcxControlFindPanelButtonViewInfo.GetTextHeight: Integer;
begin
  Result := cxTextHeight(FindPanelViewInfo.ItemViewParams.Font);
end;

function TcxControlFindPanelButtonViewInfo.GetTextWidth: Integer;
begin
  Result := cxTextWidth(FindPanelViewInfo.ItemViewParams.Font, Text);
end;

{ TcxControlFindPanelFindButtonViewInfo }

procedure TcxControlFindPanelFindButtonViewInfo.Click;
begin
  inherited Click;
  FindPanel.FindButtonExecute;
end;

function TcxControlFindPanelFindButtonViewInfo.GetFocused: Boolean;
begin
  Result := (FindPanel.FocusedItem = fpfiFindButton) and Control.IsFocused;
end;

function TcxControlFindPanelFindButtonViewInfo.GetText: string;
begin
  Result := FindPanel.FindButtonCaption;
end;

{ TcxControlFindPanelClearButtonViewInfo }

procedure TcxControlFindPanelClearButtonViewInfo.Click;
begin
  inherited Click;
  FindPanel.ClearButtonExecute;
end;

function TcxControlFindPanelClearButtonViewInfo.GetFocused: Boolean;
begin
  Result := (FindPanel.FocusedItem = fpfiClearButton) and Control.IsFocused;
end;

function TcxControlFindPanelClearButtonViewInfo.GetText: string;
begin
  Result := FindPanel.ClearButtonCaption;
end;

{ TcxControlFindPanelEditViewInfo }

procedure TcxControlFindPanelEditViewInfo.DoCalculate;
begin
  inherited DoCalculate;
  FindPanel.UpdateEditTextHint;
  ShowEdit;
  FindPanel.UpdateEditBounds(BoundsRect);
end;

procedure TcxControlFindPanelEditViewInfo.DoDraw(ACanvas: TcxCanvas);
begin
//do nothing
end;

function TcxControlFindPanelEditViewInfo.GetFocused: Boolean;
begin
  Result := FindPanel.IsEditFocused;
end;

function TcxControlFindPanelEditViewInfo.GetHeight: Integer;
begin
  Result := FindPanelViewInfo.EditHeight;
end;

function TcxControlFindPanelEditViewInfo.GetWidth: Integer;
begin
  Result := FindPanelViewInfo.EditWidth;
end;

procedure TcxControlFindPanelEditViewInfo.ShowEdit;
begin
  FindPanel.ShowEdit;
end;

procedure TcxControlFindPanelEditViewInfo.HideEdit;
begin
  FindPanel.HideEdit;
end;

{ TcxControlFindPanelViewInfo }

constructor TcxControlFindPanelViewInfo.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  FClearButtonViewInfo := TcxControlFindPanelClearButtonViewInfo.Create(Self);
  FCloseButtonViewInfo := TcxControlFindPanelCloseButtonViewInfo.Create(Self);
  FEditViewInfo := TcxControlFindPanelEditViewInfo.Create(Self);
  FFindButtonViewInfo := TcxControlFindPanelFindButtonViewInfo.Create(Self);
end;

destructor TcxControlFindPanelViewInfo.Destroy;
begin
  FreeAndNil(FFindButtonViewInfo);
  FreeAndNil(FEditViewInfo);
  FreeAndNil(FCloseButtonViewInfo);
  FreeAndNil(FClearButtonViewInfo);
  inherited Destroy;
end;

procedure TcxControlFindPanelViewInfo.CalculateClearButton;
var
  ABounds: TRect;
begin
  ABounds := cxRectCenterVertically(BoundsRect, ClearButtonViewInfo.Height);
  if IsFindButtonVisible then
    ABounds.Left := FindButtonViewInfo.BoundsRect.Right
  else
    ABounds.Left := EditViewInfo.BoundsRect.Right;
  Inc(ABounds.Left, ItemsOffset);
  ABounds := cxRectSetWidth(ABounds, ClearButtonViewInfo.Width);
  ABounds := cxRectSetHeight(ABounds, ClearButtonViewInfo.Height);
  ClearButtonViewInfo.CheckClipping(ABounds, ABounds);
  ClearButtonViewInfo.VisibleInfoCalculated := False;
end;

procedure TcxControlFindPanelViewInfo.CalculateCloseButton;
var
  ABounds: TRect;
begin
  ABounds := cxRectCenterVertically(BoundsRect, CloseButtonViewInfo.Height);
  ABounds.Left := BoundsRect.Left + FirstOffset;
  ABounds := cxRectSetWidth(ABounds, CloseButtonViewInfo.Width);
  ABounds := cxRectSetHeight(ABounds, CloseButtonViewInfo.Height);
  CloseButtonViewInfo.CheckClipping(ABounds, ABounds);
  CloseButtonViewInfo.VisibleInfoCalculated := False;
end;

procedure TcxControlFindPanelViewInfo.CalculateEdit;
var
  ABounds: TRect;
begin
  ABounds := cxRectCenterVertically(BoundsRect, EditViewInfo.Height);
  if IsCloseButtonVisible then
    ABounds.Left := CloseButtonViewInfo.BoundsRect.Right + ItemsOffset
  else
    ABounds.Left := BoundsRect.Left + FirstOffset;
  ABounds := cxRectSetWidth(ABounds, EditViewInfo.Width);
  ABounds := cxRectSetHeight(ABounds, EditViewInfo.Height);
  EditViewInfo.CheckClipping(ABounds, ABounds);
  EditViewInfo.VisibleInfoCalculated := False;
end;

procedure TcxControlFindPanelViewInfo.CalculateFindButton;
var
  ABounds: TRect;
begin
  ABounds := cxRectCenterVertically(BoundsRect, FindButtonViewInfo.Height);
  ABounds.Left := EditViewInfo.BoundsRect.Right + ItemsOffset;
  ABounds := cxRectSetWidth(ABounds, FindButtonViewInfo.Width);
  ABounds := cxRectSetHeight(ABounds, FindButtonViewInfo.Height);
  FindButtonViewInfo.CheckClipping(ABounds, ABounds);
  FindButtonViewInfo.VisibleInfoCalculated := False;
end;

procedure TcxControlFindPanelViewInfo.CalculateViewParams;
begin
  ItemViewParams := Control.Styles.GetFindPanelParams;
end;

procedure TcxControlFindPanelViewInfo.CheckClipping(const ADisplayRect: TRect; const AAvailableRect: TRect);
begin
  inherited CheckClipping(ADisplayRect, AAvailableRect);
  if not Visible then
    EditViewInfo.HideEdit;
end;

procedure TcxControlFindPanelViewInfo.DoCalculate;
begin
  if IsCloseButtonVisible then
    CalculateCloseButton;
  CalculateEdit;
  if IsFindButtonVisible then
    CalculateFindButton;
  if IsClearButtonVisible then
    CalculateClearButton;
end;

procedure TcxControlFindPanelViewInfo.DoDraw(ACanvas: TcxCanvas);
begin
  DrawBackground(ACanvas);
  DrawBorders(ACanvas);
  DrawItems(ACanvas);
end;

procedure TcxControlFindPanelViewInfo.DrawBackground(ACanvas: TcxCanvas);
begin
  Painter.DrawFindPanel(ACanvas, BoundsRect, ViewParams.Bitmap <> nil, ViewParams.Color, ViewParams.Bitmap);
end;

procedure TcxControlFindPanelViewInfo.DrawBorders(ACanvas: TcxCanvas);
begin
  Painter.DrawFindPanelBorder(ACanvas, BoundsRect, Borders);
end;

procedure TcxControlFindPanelViewInfo.DrawItems(ACanvas: TcxCanvas);
begin
  if IsCloseButtonVisible then
    CloseButtonViewInfo.Draw(ACanvas);
  EditViewInfo.Draw(ACanvas);
  if IsFindButtonVisible then
    FindButtonViewInfo.Draw(ACanvas);
  if IsClearButtonVisible then
    ClearButtonViewInfo.Draw(ACanvas);
end;

function TcxControlFindPanelViewInfo.GetBorders: TcxBorders;
begin
  if ControlViewInfo.FindPanelPosition = fppTop then
    Result := Result + [bBottom]
  else
    Result := Result + [bTop];
end;

function TcxControlFindPanelViewInfo.GetControl: TcxEditingControl;
begin
  Result := TcxEditingControl(Owner);
end;

function TcxControlFindPanelViewInfo.GetFirstOffset: Integer;
begin
  Result := cxControlFindPanelItemsFirstOffset;
end;

function TcxControlFindPanelViewInfo.GetHeight: Integer;
begin
  CalculateViewParams;
  Result := EditViewInfo.Height;
  if IsCloseButtonVisible then
    Result := Max(Result, CloseButtonViewInfo.Height);
  if IsFindButtonVisible then
    Result := Max(Result, FindButtonViewInfo.Height);
  if IsClearButtonVisible then
    Result := Max(Result, ClearButtonViewInfo.Height);
  Inc(Result, 2 * FirstOffset);
end;

function TcxControlFindPanelViewInfo.GetHitTest(AHitTest: TcxCustomHitTestController): Boolean;
begin
  Result := PtInRect(VisibleRect, AHitTest.HitPoint);
  if Result then
    AHitTest.HitTestItem := Self;
end;

function TcxControlFindPanelViewInfo.GetItemsOffset: Integer;
begin
  Result := cxControlFindPanelItemsOffset;
end;

function TcxControlFindPanelViewInfo.GetItemFromPoint(const APoint: TPoint): TcxControlFindPanelItemViewInfo;
begin
  Result := nil;
  if CloseButtonViewInfo.HasPoint(APoint) then
    Exit(CloseButtonViewInfo);
  if EditViewInfo.HasPoint(APoint) then
    Exit(EditViewInfo);
  if FindButtonViewInfo.HasPoint(APoint) then
    Exit(FindButtonViewInfo);
  if ClearButtonViewInfo.HasPoint(APoint) then
    Exit(ClearButtonViewInfo);
end;

function TcxControlFindPanelViewInfo.GetWidth: Integer;
begin
  Result := cxRectWidth(ControlViewInfo.Bounds);
end;

function TcxControlFindPanelViewInfo.IsClearButtonVisible: Boolean;
begin
  Result := FindPanel.Options.ShowClearButton;
end;

function TcxControlFindPanelViewInfo.IsCloseButtonVisible: Boolean;
begin
  Result := FindPanel.Options.IsCloseButtonVisible;
end;

function TcxControlFindPanelViewInfo.IsFindButtonVisible: Boolean;
begin
  Result := FindPanel.Options.ShowFindButton;
end;

procedure TcxControlFindPanelViewInfo.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AItem: TcxControlFindPanelItemViewInfo;
begin
  AItem := GetItemFromPoint(Point(X, Y));
  if AItem <> nil then
    AItem.MouseDown(Button, Shift, X, Y);
end;

procedure TcxControlFindPanelViewInfo.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  AItem: TcxControlFindPanelItemViewInfo;
begin
  AItem := GetItemFromPoint(Point(X, Y));
  if AItem <> nil then
    AItem.MouseMove(Shift, X, Y);
end;

procedure TcxControlFindPanelViewInfo.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AItem: TcxControlFindPanelItemViewInfo;
begin
  AItem := GetItemFromPoint(Point(X, Y));
  if AItem <> nil then
    AItem.MouseUp(Button, Shift, X, Y);
end;

function TcxControlFindPanelViewInfo.GetControlViewInfo: TcxCustomControlViewInfo;
begin
  Result := TcxCustomControlViewInfo(inherited ControlViewInfo);
end;

function TcxControlFindPanelViewInfo.GetEditHeight: Integer;
begin
  Result := FindPanel.EditHeight;
end;

function TcxControlFindPanelViewInfo.GetEditWidth: Integer;
begin
  Result := Width;
  Dec(Result, 2 * FirstOffset);
  if IsCloseButtonVisible then
    Dec(Result, CloseButtonViewInfo.Width + ItemsOffset);
  if IsFindButtonVisible then
    Dec(Result, FindButtonViewInfo.Width + ItemsOffset);
  if IsClearButtonVisible then
    Dec(Result, ClearButtonViewInfo.Width + ItemsOffset);
  Result := EnsureRange(Result, ScaleFactor.Apply(cxControlFindPanelEditMinWidth),
    ScaleFactor.Apply(cxControlFindPanelEditMaxWidth));
end;

function TcxControlFindPanelViewInfo.GetFindPanel: TcxControlFindPanel;
begin
  Result := Control.Controller.FindPanel;
end;

{ TcxCustomControlPainter }

constructor TcxCustomControlPainter.Create(AOwner: TcxEditingControl);
begin
  FControl := AOwner;
end;

procedure TcxCustomControlPainter.Paint(ACanvas: TcxCanvas);
var
  APrevCanvas: TcxCanvas;
begin
  APrevCanvas := FCanvas;
  try
    FCanvas := ACanvas;
    DoPaint;
  finally
    FCanvas := APrevCanvas;
  end;
end;

procedure TcxCustomControlPainter.AfterCustomDraw(AViewInfo: TcxCustomViewInfoItem);
begin
  AViewInfo.ItemViewParams := FSaveViewParams;
  // synchronize EditViewInfo with ViewParams
  if AViewInfo is TcxEditCellViewInfo then
    with TcxEditCellViewInfo(AViewInfo).EditViewInfo do
    begin
      Font := FSaveViewParams.Font;
      TextColor := FSaveViewParams.TextColor;
      BackgroundColor := FSaveViewParams.Color;
    end;
end;

procedure TcxCustomControlPainter.BeforeCustomDraw(AViewInfo: TcxCustomViewInfoItem);
begin
  with AViewInfo do
  begin
    FSaveViewParams := ItemViewParams;
    Canvas.SetParams(ItemViewParams);
    ItemViewParams.Font := Canvas.Font;
    Transparent := IsTransparent;
  end;
  if AViewInfo is TcxEditCellViewInfo then
    TcxEditCellViewInfo(AViewInfo).EditViewInfo.Font :=
      AViewInfo.ItemViewParams.Font;
end;

function TcxCustomControlPainter.DoCustomDraw(
 AViewInfoItem: TcxCustomViewInfoItem; AEvent: TcxCustomDrawViewInfoItemEvent): Boolean;
begin
  if (AViewInfoItem <> nil) and AViewInfoItem.Visible
    and Canvas.RectVisible(AViewInfoItem.VisibleRect) then
  begin
    Result := False;
    if Assigned(AEvent) then
    begin
//      BeforeCustomDraw(AViewInfoItem);
      AEvent(Control, Canvas, AViewInfoItem, Result);
//      AfterCustomDraw(AViewInfoItem);
    end;
  end
  else
    Result := True;
end;

procedure TcxCustomControlPainter.DoPaintEditCell(
  ACellViewInfo: TcxEditCellViewInfo; AIsExcludeRect: Boolean = True);
begin
  if not DoCustomDraw(ACellViewInfo, Control.OnCustomDrawCell) then
    ACellViewInfo.ViewInfo.PaintEx(Canvas);
  if AIsExcludeRect then
    Canvas.ExcludeClipRect(ACellViewInfo.ClipRect);
end;

procedure TcxCustomControlPainter.DoPaint;
begin
  with ViewInfo do
  begin
    FCanvas.Brush.Assign(Brush);
    FCanvas.FillRect(ClientRect);
  end;
end;

procedure TcxCustomControlPainter.DrawFindPanel;
begin
  if ViewInfo.IsFindPanelVisible then
    ViewInfo.FindPanelViewInfo.Draw(Canvas);
end;

function TcxCustomControlPainter.GetPainter: TcxCustomLookAndFeelPainter;
begin
  Result := Control.LookAndFeelPainter;
end;

function TcxCustomControlPainter.GetScaleFactor: TdxScaleFactor;
begin
  Result := Control.ScaleFactor;
end;

function TcxCustomControlPainter.GetViewInfo: TcxCustomControlViewInfo;
begin
  Result := Control.FViewInfo;
end;

{ TcxExtEditingControlPainter }

procedure TcxExtEditingControlPainter.DrawNavigator;
begin
  if ViewInfo.IsNavigatorVisible then
    ViewInfo.NavigatorSiteViewInfo.DrawEx(Canvas);
end;

function TcxExtEditingControlPainter.GetViewInfo: TcxExtEditingControlViewInfo;
begin
  Result := TcxExtEditingControlViewInfo(inherited ViewInfo);
end;

{ TcxCustomControlStyles }
procedure TcxCustomControlStyles.Assign(Source: TPersistent);
var
  I: Integer;
begin
  if Source is TcxCustomControlStyles then
  begin
    for I := ecs_Content to ecs_Selection do
      SetValue(I, TcxCustomControlStyles(Source).GetValue(I));
  end;
  inherited Assign(Source);
  Changed(ecs_Content);
end;

function TcxCustomControlStyles.GetBackgroundParams: TcxViewParams;
begin
  GetViewParams(ecs_Background, nil, nil, Result);
end;

function TcxCustomControlStyles.GetFindPanelParams: TcxViewParams;
begin
  GetViewParams(ecs_FindPanel, nil, nil, Result);
end;

function TcxCustomControlStyles.GetSearchResultHighlight: TcxViewParams;
begin
  GetViewParams(ecs_SearchResultHighlight, nil, nil, Result);
end;

function TcxCustomControlStyles.GetSelectionParams: TcxViewParams;
const
  AStyleIndexes: array[Boolean] of Integer = (ecs_Inactive, ecs_Selection);
begin
  GetViewParams(AStyleIndexes[Control.Controller.Focused or Control.IsFocused], nil, nil, Result);
end;

procedure TcxCustomControlStyles.Changed(AIndex: Integer);
begin
  inherited Changed(AIndex);
  if GetOwner is TcxEditingControl then
    Control.UpdateViewStyles;
end;

procedure TcxCustomControlStyles.GetDefaultViewParams(
 Index: Integer; AData: TObject; out AParams: TcxViewParams);
begin
  inherited GetDefaultViewParams(Index, AData, AParams);
  with AParams, LookAndFeelPainter do
  begin
    Font := Control.Font;
    TextColor := Font.Color;
    case Index of
      ecs_Background, ecs_Content:
        begin
          Color := DefaultContentColor;
          TextColor := DefaultContentTextColor;
        end;
      ecs_Selection:
        begin
          Color := DefaultSelectionColor;
          TextColor := DefaultSelectionTextColor;
        end;
      ecs_Inactive:
        begin
          Color := DefaultInactiveColor;
          TextColor := DefaultInactiveTextColor;
        end;
      ecs_Navigator:
        begin
          Color := DefaultGridDetailsSiteColor;
          TextColor := DefaultHeaderTextColor;
        end;
      ecs_NavigatorInfoPanel:
        begin
          Color := DefaultContentColor;
          TextColor := DefaultContentTextColor;
        end;
      ecs_SearchResultHighlight:
        begin
          Color := clDefault;
          TextColor := clDefault;
        end;
      ecs_FindPanel:
        begin
          Color := GetFindPanelDefaultColor;
          TextColor := GetFindPanelDefaultTextColor;
        end;
    end;
  end;
end;

function TcxCustomControlStyles.GetFindPanelDefaultColor: TColor;
begin
  Result := LookAndFeelPainter.DefaultFilterBoxColor;
end;

function TcxCustomControlStyles.GetFindPanelDefaultTextColor: TColor;
begin
  Result := LookAndFeelPainter.DefaultContentTextColor;
end;

function TcxCustomControlStyles.GetControl: TcxEditingControl;
begin
  Result := TcxEditingControl(GetOwner);
end;

function TcxCustomControlStyles.GetPainter: TcxCustomLookAndFeelPainter;
begin
  Result := Control.LookAndFeelPainter;
end;

{ TcxEditingControl }

constructor TcxEditingControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FContainerList := TList.Create;
  CreateSubClasses;
  FSubClassesCreated := True;
  Keys := [kArrows, kChars];
  BorderStyle := cxcbsDefault;
  DragCursor := crDefault;
end;

destructor TcxEditingControl.Destroy;
begin
  DestroyDesignSelectionHelper;
  EndMouseTracking(Self);
  DestroySubClasses;
  FreeAndNil(FContainerList);
  inherited Destroy;
end;

procedure TcxEditingControl.BeginUpdate;
begin
  DoBeginUpdate;
end;

procedure TcxEditingControl.BeginDragAndDrop;
begin
  Controller.BeginDragAndDrop;
  inherited;
end;

procedure TcxEditingControl.CancelUpdate;
begin
  DataController.EndUpdate;
  Dec(FLockUpdate);
end;

procedure TcxEditingControl.EndUpdate;
begin
  DoEndUpdate;
end;

function TcxEditingControl.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or
    DataController.ExecuteAction(Action);
end;

procedure TcxEditingControl.DragDrop(Source: TObject; X, Y: Integer);
begin
  Controller.DragDrop(Source, X, Y);
  inherited DragDrop(Source, X, Y);
end;

procedure TcxEditingControl.LayoutChanged;
begin
  if ViewInfo <> nil then ViewInfo.IsDirty := True;
  if IsLocked then Exit;
  Inc(FChangesCount);
  Controller.Reset;
  BeginUpdate;
  try
    DoLayoutChanged;
  finally
    ViewInfo.IsDirty := False;
    CancelUpdate;
    SetInternalControlsBounds;  //TODO: need validation scrollbars visible
    UpdateScrollBars;
    Dec(FChangesCount);
    if FChangesCount = 0 then
    begin
      Controller.HitTestController.ReCalculate;
      Controller.EditingController.PostEditUpdate;
      AfterLayoutChanged;
      Invalidate;
    end;
  end;
end;

function TcxEditingControl.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or
    DataController.UpdateAction(Action);
end;

procedure TcxEditingControl.AfterLayoutChanged;
begin
end;

procedure TcxEditingControl.BeginAutoDrag;
begin
  Controller.HideHint;
  if Controller.IsEditing then
    Controller.EditingController.HideEdit(True);
//  ControlState := ControlState - [csLButtonDown];
  BeginDrag(False, Mouse.DragThreshold);
//  ControlState := ControlState + [csLButtonDown];
end;

procedure TcxEditingControl.BeforeUpdate;
begin
end;

function TcxEditingControl.CanUpdateScrollBars: Boolean;
begin
  Result := FLockUpdate = 0;
end;

procedure TcxEditingControl.CheckCreateDesignSelectionHelper;
begin
  if (FDesignSelectionHelper = nil) and (cxDesignSelectionHelperClass <> nil) and IsDesigning then
    FDesignSelectionHelper := cxDesignSelectionHelperClass.Create(Self);
end;

procedure TcxEditingControl.CreateSubClasses;
begin
  FStyles := GetControlStylesClass.Create(Self);
  FBrushCache := TcxBrushCache.Create;
  FEditStyle := GetEditStyleClass.Create(nil, True);
  FEditStyle.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  FController := GetControllerClass.Create(Self);
  FDataController := GetDataControllerClass.Create(Self);
  RecreateViewInfo;
end;

procedure TcxEditingControl.ControlUpdateData(AInfo: TcxUpdateControlInfo);
begin
  if AInfo is TcxDataChangedInfo then
    DataChanged
  else
    if AInfo is TcxLayoutChangedInfo then
      DataLayoutChanged
    else
      if AInfo is TcxFocusedRecordChangedInfo then
        with TcxFocusedRecordChangedInfo(AInfo) do
        begin
          // need use row index instead of record index
          Controller.FocusedRecordChanged(PrevFocusedRowIndex, FocusedRowIndex);
          Controller.Navigator.Refresh;
        end
      else
        if AInfo is TcxSelectionChangedInfo then
          SelectionChanged(TcxSelectionChangedInfo(AInfo))
        else
          if AInfo is TcxUpdateRecordInfo then
            Controller.UpdateRecord(TcxUpdateRecordInfo(AInfo).RecordIndex)
          else
            if AInfo is TcxFindFilterChangedInfo then
              Controller.FindPanel.FindChanged;
end;

procedure TcxEditingControl.DataChanged;
var
  I: Integer;
begin
  Inc(FLockUpdate);
  try
    for I := 0 to FContainerList.Count - 1 do
      TcxCustomInplaceEditContainer(FContainerList.List[I]).DataChanged;
  finally
    Dec(FLockUpdate);
    if not IsLocked then Controller.RefreshFocusedRecord;
  end;
end;

procedure TcxEditingControl.DataLayoutChanged;
begin
  Controller.EditingController.UpdateEditValue;
  Controller.RefreshFocusedRecord;
end;

procedure TcxEditingControl.DestroyDesignSelectionHelper;
begin
  FreeAndNil(FDesignSelectionHelper);
end;

procedure TcxEditingControl.DestroySubClasses;
begin
  FreeAndNil(FViewInfo);
  FreeAndNil(FBrushCache);
  FreeAndNil(FController);
  FreeAndNil(FEditStyle);
  FreeAndNil(FDataController);
  FreeAndNil(FStyles);
end;

procedure TcxEditingControl.DoBeginUpdate;
begin
  Inc(FLockUpdate);
  DataController.BeginUpdate;
end;

procedure TcxEditingControl.DoEndUpdate;
begin
  DataController.EndUpdate;
  Dec(FLockUpdate);
  if FLockUpdate = 0 then BeforeUpdate;
  LayoutChanged;
end;

procedure TcxEditingControl.DoEditChanged(
  AItem: TcxCustomInplaceEditContainer);
begin
  if Assigned(FOnEditChanged) then FOnEditChanged(Self, AItem);
end;

procedure TcxEditingControl.DoEdited(
  AItem: TcxCustomInplaceEditContainer);
begin
  if Assigned(FOnEdited) then FOnEdited(Self, AItem);
end;

function TcxEditingControl.DoEditing(
  AItem: TcxCustomInplaceEditContainer): Boolean;
begin
  Result := True;
  if Assigned(FOnEditing) then
    FOnEditing(Self, AItem, Result);
end;

procedure TcxEditingControl.DoEditValueChanged(
  AItem: TcxCustomInplaceEditContainer);
begin
  if Assigned(FOnEditValueChanged) then FOnEditValueChanged(Self, AItem);
end;

procedure TcxEditingControl.DoFindPanelVisibilityChanged(AVisible: Boolean);
begin
  if Assigned(FOnFindPanelVisibilityChanged) then
    FOnFindPanelVisibilityChanged(Self, AVisible);
end;

procedure TcxEditingControl.DoGetCellHint(ACell: TObject; var AText: string;
  var ANeedShow: Boolean);
begin
end;

procedure TcxEditingControl.DoInitEdit(
  AItem: TcxCustomInplaceEditContainer; AEdit: TcxCustomEdit);
begin
  if Assigned(FOnInitEdit) then FOnInitEdit(Self, AItem, AEdit);
end;

procedure TcxEditingControl.DoInitEditValue(AItem: TcxCustomInplaceEditContainer;
  AEdit: TcxCustomEdit; var AValue: TcxEditValue);
begin
  if Assigned(FOnInitEditValue) then FOnInitEditValue(Self, AItem, AEdit, AValue);
end;

procedure TcxEditingControl.DoInplaceEditContainerItemAdded(
  AItem: TcxCustomInplaceEditContainer);
begin
  try
    ContainerList.Add(AItem);
    UpdateIndexes;
    DataController.AddItem(AItem);
    AItem.CheckUsingInFind;
  finally
    LayoutChanged;
  end;
end;

procedure TcxEditingControl.DoInplaceEditContainerItemRemoved(
  AItem: TcxCustomInplaceEditContainer);
begin
  try
    ContainerList.Remove(AItem);
    DataController.RemoveItem(AItem);
    UpdateIndexes;
    AItem.CheckUsingInFind;
  finally
    if NeedCallChangedOnItemRemoved(AItem) then
      LayoutChanged;
  end;
end;

procedure TcxEditingControl.DoLayoutChanged;
begin
  ViewInfo.Calculate;
end;

function TcxEditingControl.NeedCallChangedOnItemRemoved(AItem: TcxCustomInplaceEditContainer): Boolean;
begin
  Result := True;
end;

function TcxEditingControl.NeedHighlightFindText: Boolean;
begin
  Result := DataController.IsFindFiltering and Options.OptionsFindPanel.HighlightSearchResults;
end;

function TcxEditingControl.GetControllerClass: TcxCustomControlControllerClass;
begin
  Result := TcxCustomControlController;
end;

function TcxEditingControl.GetControlStylesClass: TcxCustomControlStylesClass;
begin
  Result := TcxCustomControlStyles;
end;

function TcxEditingControl.GetDataControllerClass: TcxCustomDataControllerClass;
begin
  Result := TcxControlDataController;
end;

function TcxEditingControl.GetDragImageHelperClass: TcxDragImageHelperClass;
begin
  Result := TcxDragImageHelper;
end;

function TcxEditingControl.GetEditStyleClass: TcxCustomEditStyleClass;
begin
  Result := TcxEditStyle;
end;

function TcxEditingControl.GetEditingControllerClass: TcxEditingControllerClass;
begin
  Result := TcxEditingController;
end;

function TcxEditingControl.GetHitTestControllerClass: TcxHitTestControllerClass;
begin
  Result := TcxCustomHitTestController;
end;

function TcxEditingControl.GetHotTrackControllerClass: TcxHotTrackControllerClass;
begin
  Result := TcxHotTrackController;
end;

function TcxEditingControl.GetViewInfoClass: TcxCustomControlViewInfoClass;
begin
  Result := TcxCustomControlViewInfo;
end;

function TcxEditingControl.GetOptions: IcxEditingControlOptions;
begin
  dxAbstractError;
end;

function TcxEditingControl.GetPainterClass: TcxCustomControlPainterClass;
begin
  Result := TcxCustomControlPainter;
end;

function TcxEditingControl.GetHintHidePause: Integer;
begin
  Result := 0; 
end;

function TcxEditingControl.IsDoubleBufferedNeeded: Boolean;
begin
  Result := True;
end;

function TcxEditingControl.IsLocked: Boolean;
begin
  Result := (FLockUpdate <> 0) or IsLoading or IsDestroying or not HandleAllocated;
end;

procedure TcxEditingControl.RecreateViewInfo;
begin
  if Controller <> nil then
  begin
    Controller.EditingController.EditingItem := nil;
    Controller.Clear;
  end;
  FreeAndNil(FViewInfo);
  FViewInfo := GetViewInfoClass.Create(Self);
end;

procedure TcxEditingControl.SelectionChanged(AInfo: TcxSelectionChangedInfo);
begin
end;

procedure TcxEditingControl.UpdateIndexes;
var
  I: Integer;
begin
  for I := 0 to FContainerList.Count - 1 do
    TcxCustomInplaceEditContainer(FContainerList.List[I]).FItemIndex := I;
end;

procedure TcxEditingControl.UpdateViewStyles;
begin
  Controller.FindPanel.StylesChanged;
  if ViewInfo <> nil then
    ViewInfo.State[cvis_StyleInvalid] := True;
  LayoutChanged;
end;

procedure TcxEditingControl.UpdateData;
begin
  Controller.EditingController.UpdateValue;
end;

procedure TcxEditingControl.AlignControls(AControl: TControl; var Rect: TRect);
begin
  if not (AControl is TcxCustomEdit) then
    inherited AlignControls(AControl, Rect);
end;

procedure TcxEditingControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TcxEditingControl.CreateWnd;
begin
  DestroyDesignSelectionHelper;
  inherited CreateWnd;
  CheckCreateDesignSelectionHelper;
end;

procedure TcxEditingControl.DestroyWnd;
begin
  DestroyDesignSelectionHelper;
  inherited DestroyWnd;
end;

procedure TcxEditingControl.DoExit;
begin
  if Controller <> nil then
    Controller.DoExit;
  inherited DoExit;
end;

procedure TcxEditingControl.DblClick;
begin
  Controller.DblClick;
  inherited DblClick;
end;

procedure TcxEditingControl.KeyDown(var Key: Word; Shift: TShiftState);
begin
  Controller.FDragCancel := Key = VK_ESCAPE;
  try
    inherited KeyDown(Key, Shift);
    Controller.KeyDown(Key, Shift);
  finally
    Controller.FDragCancel := False;
  end;
end;

procedure TcxEditingControl.FocusChanged;
begin
  inherited FocusChanged;
  if not IsDestroying then
    Controller.FocusChanged;
end;

procedure TcxEditingControl.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  Controller.KeyPress(Key);
end;

procedure TcxEditingControl.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key, Shift);
  Controller.KeyUp(Key, Shift);
end;

procedure TcxEditingControl.Loaded;
begin
  inherited Loaded;
  DataController.Loaded;
  LayoutChanged;
  CheckCreateDesignSelectionHelper;
end;

procedure TcxEditingControl.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  with Controller do
  begin
    HotTrackController.HintHelper.MouseDown;
    BeforeMouseDown(Button, Shift, X, Y);
    inherited MouseDown(Button, Shift, X, Y);
    HitTestController.RecalculateOnMouseEvent(X, Y, Shift);
    EditingController.StopEditShowingTimer;
    HandleNonContentMouseDown(Button, Shift, X, Y);
    if EditingController.IsErrorOnPost then
      EditingController.ClearErrorState
    else
      DoMouseDown(Button, Shift, X, Y);
  end;
end;

procedure TcxEditingControl.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  BeginMouseTracking(Self, Bounds, Self);
  Controller.HitTestController.RecalculateOnMouseEvent(X, Y, Shift);
  if DragAndDropState = ddsNone then //???
    Controller.DoMouseMove(Shift, X, Y);
end;

procedure TcxEditingControl.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Controller.HitTestController.RecalculateOnMouseEvent(X, Y, Shift);
  if DragAndDropState = ddsNone then
  begin
    Controller.DoMouseUp(Button, Shift, X, Y);
    inherited MouseUp(Button, Shift, X, Y);
  end
  else
  begin
    inherited MouseUp(Button, Shift, X, Y);
    Controller.DoMouseUp(Button, Shift, X, Y);
  end;
  Controller.PostShowEdit;
end;

procedure TcxEditingControl.MouseEnter(AControl: TControl);
begin
  inherited MouseEnter(AControl);
  BeginMouseTracking(Self, Bounds, Self);
  Controller.MouseEnter;
end;

procedure TcxEditingControl.MouseLeave(AControl: TControl);
begin
  EndMouseTracking(Self);
  Controller.MouseLeave;
  inherited MouseLeave(AControl);
end;

procedure TcxEditingControl.DoPaint;
begin
  Controller.BeforePaint;
  try
    inherited DoPaint; 
    Painter.Paint(Canvas);
  finally
    Controller.AfterPaint;
  end;
end;

procedure TcxEditingControl.WndProc(var Message: TMessage);
begin
  if not ((Controller <> nil) and Controller.HandleMessage(Message)) then
    inherited WndProc(Message);
end;

procedure TcxEditingControl.AfterMouseDown(AButton: TMouseButton; X, Y: Integer);
begin
  FDragPos := cxPoint(X, Y);
  inherited AfterMouseDown(AButton, X, Y);
end;

procedure TcxEditingControl.BoundsChanged;
begin
  LayoutChanged;
  inherited BoundsChanged;
end;

function TcxEditingControl.CanDrag(X, Y: Integer): Boolean;
begin
  if Controller <> nil then
    Result := Controller.CanDrag(X, Y)
  else
    Result := False;
end;

procedure TcxEditingControl.DoCancelMode;
begin
  inherited DoCancelMode;
  Controller.DoCancelMode;
end;

procedure TcxEditingControl.FontChanged;
begin
  inherited FontChanged;
  UpdateViewStyles;
end;

function TcxEditingControl.GetCurrentCursor(X, Y: Integer): TCursor;
begin
  Result := Controller.GetCursor(X, Y);
  if Result = crDefault then
    Result := inherited GetCurrentCursor(X, Y);
end;

function TcxEditingControl.GetDesignHitTest(
  X, Y: Integer; Shift: TShiftState): Boolean;
begin
  Result := inherited GetDesignHitTest(X, Y, Shift) or
    Controller.HitTestController.AllowDesignMouseEvents(X, Y, Shift);
end;

function TcxEditingControl.GetIsFocused: Boolean;
begin
  Result := inherited GetIsFocused or Controller.HasFocusedControls;
end;

function TcxEditingControl.GetMouseWheelScrollingKind: TcxMouseWheelScrollingKind;
begin
  Result := inherited GetMouseWheelScrollingKind;
  if Result = mwskNone then
    Result := Controller.GetMouseWheelScrollingKind;
end;

procedure TcxEditingControl.InitControl;
begin
  inherited InitControl;
  LayoutChanged;
end;

function TcxEditingControl.IsPanArea(const APoint: TPoint): Boolean;
begin
  Result := ViewInfo.IsPanArea(APoint);
end;

function TcxEditingControl.IsPixelScrollBar(AKind: TScrollBarKind): Boolean;
begin
  Result := Controller.IsPixelScrollBar(AKind);
end;

procedure TcxEditingControl.LookAndFeelChanged(Sender: TcxLookAndFeel;
  AChangedValues: TcxLookAndFeelValues);
var
  I: Integer;
  AIsEditing: Boolean;
begin
  AIsEditing := (Controller <> nil) and Controller.IsEditing;
  if AIsEditing then
    Controller.EditingController.HideEdit(True);
  inherited LookAndFeelChanged(Sender, AChangedValues);
  BeginUpdate;
  try
    for I := 0 to FContainerList.Count - 1 do
      TcxCustomInplaceEditContainer(FContainerList[I]).InternalPropertiesChanged;
  finally
    UpdateViewStyles;
    EndUpdate;
    if AIsEditing then
      Controller.EditingController.ShowEdit;
  end;
end;

function TcxEditingControl.MayFocus: Boolean;
begin
  Result := inherited MayFocus;
  if Controller <> nil then
    Result := Result and Controller.MayFocus;
end;

// drag'n'drop
procedure TcxEditingControl.DoEndDrag(Target: TObject; X, Y: Integer);
begin
  Controller.EndDrag(Target, X, Y);
  inherited DoEndDrag(Target, X, Y);
  Controller.PostShowEdit;
  FinishDragImages;
  FDragPos := cxNullPoint;
end;

procedure TcxEditingControl.DoStartDrag(var DragObject: TDragObject);
begin
  Controller.HitTestController.HitPoint := FDragPos;
  Controller.BeforeStartDrag;
  inherited DoStartDrag(DragObject);
  Controller.StartDrag(DragObject);
  FinishDragImages;
  if HasDragDropImages then
  begin
    FDragHelper := GetDragImageHelperClass.Create(Self, FDragPos);
    cxInstallMouseHookForDragControl(Self);
  end;
end;

procedure TcxEditingControl.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  inherited DragOver(Source, X, Y, State, Accept);
  Controller.DragOver(Source, X, Y, State, Accept);
end;

function TcxEditingControl.DragDropImageDisplayRect: TRect;
begin
  Result := cxNullRect;
end;

procedure TcxEditingControl.DrawDragDropImage(
  ADragBitmap: TBitmap; ACanvas: TcxCanvas);
begin
end;

procedure TcxEditingControl.FinishDragImages;
begin
  if FDragHelper <> nil then
  begin
    cxResetMouseHookForDragControl;
    FreeAndNil(FDragHelper);
  end;
end;

function TcxEditingControl.HasDragDropImages: Boolean;
begin
  Result := Options.OptionsBehavior.DragDropText;
end;

// scrollbars

function TcxEditingControl.GetMainScrollBarsClass: TcxControlCustomScrollBarsClass;
begin
  if IsPopupScrollbars then
    Result := inherited GetMainScrollBarsClass
  else
    Result := TcxControlScrollBars;
end;

function TcxEditingControl.GetScrollContentForegroundColor: TColor;
begin
  Result := LookAndFeelPainter.GridLikeControlContentTextColor;
end;

procedure TcxEditingControl.InitScrollBarsParameters;
begin
  if Controller <> nil then
    Controller.InitScrollBarsParameters;
end;

procedure TcxEditingControl.Scroll(AScrollBarKind: TScrollBarKind;
  AScrollCode: TScrollCode; var AScrollPos: Integer);
begin
  Controller.EditingController.PostEditUpdate;
  Controller.Scroll(AScrollBarKind, AScrollCode, AScrollPos);
end;

procedure TcxEditingControl.DragAndDrop(const P: TPoint;
  var Accepted: Boolean);
begin
  inherited DragAndDrop(P, Accepted);
  Controller.DragAndDrop(P, Accepted);
end;

procedure TcxEditingControl.EndDragAndDrop(Accepted: Boolean);
begin
  inherited EndDragAndDrop(Accepted);
  Controller.EndDragAndDrop(Accepted);
  FDragPos := cxNullPoint;
end;

function TcxEditingControl.GetDragAndDropObjectClass: TcxDragAndDropObjectClass;
begin
  Result := Controller.GetDragAndDropObjectClass;
end;

function TcxEditingControl.StartDragAndDrop(const P: TPoint): Boolean;
begin
  Result := Controller.StartDragAndDrop(P);
  if Result then
    Controller.HideHint;
end;

function TcxEditingControl.GetBufferedPaint: Boolean;
begin
  Result := True; 
end;

function TcxEditingControl.GetPainter: TcxCustomControlPainter;
begin
  Result := ViewInfo.FPainter;
end;

procedure TcxEditingControl.DoMouseLeave;
begin
  MouseLeave(Self);
end;

procedure TcxEditingControl.SetBufferedPaint(Value: Boolean);
begin
end;

procedure TcxEditingControl.SetEditStyle(Value: TcxCustomEditStyle);
begin
  FEditStyle.Assign(Value);
end;

procedure TcxEditingControl.SetStyles(Value: TcxCustomControlStyles);
begin
  FStyles.Assign(Value);
end;

procedure TcxEditingControl.WMCancelMode(var Message: TWMCancelMode);
begin
  Controller.FDragCancel := True;
  try
    inherited;
  finally
    Controller.FDragCancel := False;
  end;
end;

procedure TcxEditingControl.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if Controller.FindPanel.IsFocused then
    Message.Result := Message.Result or DLGC_WANTALLKEYS;
end;

procedure TcxEditingControl.WMSetCursor(var Message: TWMSetCursor);
var
  P: TPoint;
begin
  GetCursorPos(P);
  P := ScreenToClient(P);
  with Controller.HitTestController do
  begin
    if IsDesigning and (DragAndDropState = ddsNone) and
       AllowDesignMouseEvents(P.X, P.Y, [ssLeft]) then
         SetCursor(Screen.Cursors[GetCurrentCursor])
    else
      inherited;
  end;
end;

{ TcxExtEditingControl }

function TcxExtEditingControl.AllowTouchScrollUIMode: Boolean;
begin
  Result := not IsDesigning;
end;

procedure TcxExtEditingControl.ChangeScaleEx(M, D: Integer; isDpiChange: Boolean);
begin
  inherited ChangeScaleEx(M, D, isDpiChange);
  OptionsView.ChangeScale(M, D);
end;

function TcxExtEditingControl.GetClientBounds: TRect;
begin
  Result := Bounds;
  InflateRect(Result, -BorderSize, -BorderSize);
  ViewInfo.AdjustClientBounds(Result);
end;

function TcxExtEditingControl.GetHScrollBarBounds: TRect;
begin
  Result := ClientBounds;
  ViewInfo.GetHScrollBarBounds(Result);
end;

function TcxExtEditingControl.GetNavigatorButtonsControl: IcxNavigator;
begin
  Result := nil;
end;

function TcxExtEditingControl.GetVScrollBarBounds: TRect;
begin
  Result := inherited GetVScrollBarBounds;
  ViewInfo.GetVScrollBarBounds(Result);
end;

function TcxExtEditingControl.HasScrollBarArea: Boolean;
begin
  Result := GetScrollbarMode in [sbmClassic, sbmHybrid];
end;

procedure TcxExtEditingControl.SetPaintRegion;
var
  AIsNavigatorSiteVisible: Boolean;
begin
  AIsNavigatorSiteVisible := Canvas.RectVisible(ViewInfo.NavigatorSiteVisibleRect);
  inherited SetPaintRegion;
  if AIsNavigatorSiteVisible then
    ViewInfo.AddNavigatorSiteToPaintRegion(Canvas);
end;

// IcxNavigatorOwner
procedure TcxExtEditingControl.NavigatorChanged(AChangeType: TcxNavigatorChangeType);
begin
  LayoutChanged;  // to do
end;

function TcxExtEditingControl.GetNavigatorBounds: TRect;
begin
  Result := ViewInfo.GetNavigatorBounds;
end;

function TcxExtEditingControl.GetNavigatorButtons: TcxCustomNavigatorButtons;
begin
  Result := Navigator.Buttons;
end;

function TcxExtEditingControl.GetNavigatorCanvas: TCanvas;
begin
  Result := ActiveCanvas.Canvas;
end;

function TcxExtEditingControl.GetNavigatorControl: TWinControl;
begin
  Result := Self;
end;

function TcxExtEditingControl.GetNavigatorFocused: Boolean;
begin
  Result := False;
end;

function TcxExtEditingControl.GetNavigatorLookAndFeel: TcxLookAndFeel;
begin
  Result := LookAndFeel;
end;

function TcxExtEditingControl.GetNavigatorOwner: TComponent;
begin
  Result := Self;
end;

function TcxExtEditingControl.GetNavigatorShowHint: Boolean;
begin
  Result := OptionsBehavior.NavigatorHints;
end;

function TcxExtEditingControl.GetNavigatorTabStop: Boolean;
begin
  Result := False;
end;

procedure TcxExtEditingControl.NavigatorStateChanged;
begin
  ViewInfo.NavigatorStateChanged;
end;

procedure TcxExtEditingControl.RefreshNavigator;
begin
  if not IsLocked then
    if ViewInfo.IsNavigatorSizeChanged then
      LayoutChanged
    else
      ViewInfo.NavigatorInvalidate;
end;

// IcxNavigatorOwner2
function TcxExtEditingControl.GetNavigatorInfoPanel: TcxCustomNavigatorInfoPanel;
begin
  Result := Navigator.InfoPanel;
end;

// IcxNavigatorRecordPosition
function TcxExtEditingControl.NavigatorGetRecordCount: Integer;
begin
  Result := 0;
end;

function TcxExtEditingControl.NavigatorGetRecordIndex: Integer;
begin
  Result := 0;
end;

procedure TcxExtEditingControl.CreateSubClasses;
begin
  FOptionsBehavior := GetOptionsBehaviorClass.Create(Self);
  FOptionsData := GetOptionsDataClass.Create(Self);
  FOptionsView := GetOptionsViewClass.Create(Self);
  FNavigator := GetNavigatorClass.Create(Self);
  FFindPanel := GetFindPanelOptionsClass.Create(Self);

  inherited CreateSubClasses;
end;

procedure TcxExtEditingControl.DestroySubClasses;
begin
  inherited DestroySubClasses;
  FreeAndNil(FFindPanel);
  FreeAndNil(FNavigator);
  FreeAndNil(FOptionsBehavior);
  FreeAndNil(FOptionsData);
  FreeAndNil(FOptionsView);
end;

function TcxExtEditingControl.GetFindPanelOptionsClass: TcxControlOptionsFindPanelClass;
begin
  Result := TcxControlOptionsFindPanel;
end;

function TcxExtEditingControl.GetHintHidePause: Integer;
begin
  Result := OptionsBehavior.HintHidePause;
end;

function TcxExtEditingControl.GetNavigatorClass: TcxControlNavigatorClass;
begin
  Result := TcxControlNavigator;
end;

function TcxExtEditingControl.GetOptions: IcxEditingControlOptions;
begin
  Result := Self;
end;

function TcxExtEditingControl.GetOptionsBehaviorClass: TcxControlOptionsBehaviorClass;
begin
  Result := TcxControlOptionsBehavior;
end;

function TcxExtEditingControl.GetOptionsDataClass: TcxControlOptionsDataClass;
begin
  Result := TcxControlOptionsData;
end;

function TcxExtEditingControl.GetOptionsViewClass: TcxControlOptionsViewClass;
begin
  Result := TcxControlOptionsView;
end;

function TcxExtEditingControl.GetPainterClass: TcxCustomControlPainterClass;
begin
  Result := TcxExtEditingControlPainter;
end;

function TcxExtEditingControl.GetViewInfoClass: TcxCustomControlViewInfoClass;
begin
  Result := TcxExtEditingControlViewInfo;
end;

function TcxExtEditingControl.GetOptionsBehavior: TcxControlOptionsBehavior;
begin
  Result := FOptionsBehavior;
end;

function TcxExtEditingControl.GetOptionsData: TcxControlOptionsData;
begin
  Result := FOptionsData;
end;

function TcxExtEditingControl.GetOptionsFindPanel: TcxControlOptionsFindPanel;
begin
  Result := FFindPanel;
end;

function TcxExtEditingControl.GetOptionsView: TcxControlOptionsView;
begin
  Result := FOptionsView;
end;

function TcxExtEditingControl.GetViewInfo: TcxExtEditingControlViewInfo;
begin
  Result := TcxExtEditingControlViewInfo(inherited ViewInfo);
end;

procedure TcxExtEditingControl.SetFindPanel(AValue: TcxControlOptionsFindPanel);
begin
  FindPanel.Assign(AValue);
end;

procedure TcxExtEditingControl.SetNavigator(Value: TcxControlNavigator);
begin
  FNavigator.Assign(Value);
end;

procedure TcxExtEditingControl.SetOptionsBehavior(
  Value: TcxControlOptionsBehavior);
begin
  FOptionsBehavior.Assign(Value);
end;

procedure TcxExtEditingControl.SetOptionsData(
  Value: TcxControlOptionsData);
begin
  FOptionsData.Assign(Value);
end;

procedure TcxExtEditingControl.SetOptionsView(
  Value: TcxControlOptionsView);
begin
  FOptionsView.Assign(Value);
end;

function cxPtInViewInfoItem(AItem: TcxCustomViewInfoItem; const APoint: TPoint): Boolean;
begin
  Result := (AItem <> nil) and AItem.Visible and cxRectPtIn(AItem.ClipRect, APoint);
end;

function cxInRange(Value: Integer; AMin, AMax: Integer): Boolean;
begin
  Result := (Value >= AMin) and (Value <= AMax);
end;

function cxRange(var Value: Integer; AMin, AMax: Integer): Boolean;
begin
  Result := (Value >= AMin) and (Value <= AMax);
  if not Result then
  begin
    if Value < AMin then
      Value := AMin
    else
      Value := AMax
  end;
end;

function cxSetValue(Condition: Boolean; ATrueValue, AFalseValue: Integer): Integer;
begin
  if Condition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

function cxConfirmMessageBox(const AText, ACaption: string): Boolean;
begin
  Result := Application.MessageBox(PChar(AText), PChar(ACaption),
    MB_ICONQUESTION or MB_OKCANCEL) = ID_OK
end;

initialization

finalization
  cxResetMouseHookForDragControl;

end.
