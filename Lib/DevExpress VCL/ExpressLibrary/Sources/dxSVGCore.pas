{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Express Cross Platform Library graphics classes          }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCROSSPLATFORMLIBRARY AND ALL   }
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

unit dxSVGCore;

{$I cxVer.inc}

interface

uses
  Types, TypInfo, Windows, Classes, Variants, Rtti, Graphics, Generics.Collections, Generics.Defaults, Contnrs,
  dxCore, dxSmartImage, dxXMLDoc, dxCoreGraphics, cxGraphics, cxGeometry, dxGDIPlusAPI, dxGDIPlusClasses,
  dxDPIAwareUtils;

type
  TdxSVGAdapterValueClass = class of TdxSVGAdapterValue;
  TdxSVGAdapterValue = class;
  TdxSVGElementRoot = class;

  TdxSVGContentUnits = (cuUserSpaceOnUse, cuObjectBoundingBox);
  TdxSVGFillMode = (fmNonZero, fmEvenOdd, fmInherit);
  TdxSVGLineCapStyle = (lcsDefault, lcsButt, lcsSquare, lcsRound);
  TdxSVGTextAnchor = (taStart, taMiddle, taEnd, taInherit);
  TdxSVGUnitsType = (utPx, utMm, utCm, utIn, utPc, utPt, utPercents);

  { SVGAlias }

  SVGAlias = class(TCustomAttribute)
  strict private
    FAdapter: TdxSVGAdapterValueClass;
    FName: TdxXMLString;
  public
    constructor Create(const AName: TdxXMLString); overload;
    constructor Create(const AName: TdxXMLString; AAdapter: TdxSVGAdapterValueClass); overload;
    //
    property Adapter: TdxSVGAdapterValueClass read FAdapter;
    property Name: TdxXMLString read FName;
  end;

  { TdxSVGFill }

  TdxSVGFill = record
    Data: Variant;

    class function Create(const AColor: TdxAlphaColor): TdxSVGFill; overload; static;
    class function Create(const AReference: string): TdxSVGFill; overload; static;
    class function Default: TdxSVGFill; static;
    function IsDefault: Boolean;
    function IsReference: Boolean;
    function AsColor: TdxAlphaColor;
    function AsReference: string;
  end;

  { TdxSVGValue }

  TdxSVGValue = record
    Data: Single;
    UnitsType: TdxSVGUnitsType;

    class function Create(const AValue: Single; AUnitsType: TdxSVGUnitsType): TdxSVGValue; static;
    function IsEmpty: Boolean; inline;
    function ToPixels(ATargetDPI: Integer = dxDefaultDPI): Single; overload;
    function ToPixels(const AParentSize: Single; ATargetDPI: Integer = dxDefaultDPI): Single; overload;
    function ToValue: TValue; inline;
  end;

  { TdxSVGList<T> }

  TdxSVGList<T> = class(TList<T>)
  public
    procedure Assign(AValues: TdxSVGList<T>);
  {$IFNDEF DELPHIXE}
    function ToArray: TArray<T>;
  {$ENDIF}
  end;

  { TdxSVGValues }

  TdxSVGValues = class(TdxSVGList<Single>);

  { TdxSVGPoints }

  TdxSVGPoints = class(TdxSVGList<TdxPointF>);

  { TdxSVGRect }

  TdxSVGRect = class
  strict private
    FValue: TdxRectF;

    function GetHeight: Single; inline;
    function GetWidth: Single; inline;
  public
    property Height: Single read GetHeight;
    property Width: Single read GetWidth;
    property Value: TdxRectF read FValue write FValue;
  end;

{$REGION 'Value Adapters'}

  { TdxSVGAdapterValue }

  TdxSVGAdapterValue = class
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string); virtual;
  end;

  { TdxSVGAdapterColorValue }

  TdxSVGAdapterColorValue = class(TdxSVGAdapterValue)
  protected
    class function StringToAlphaColor(const AValue: string): TdxAlphaColor;
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string); override;
  end;

  { TdxSVGAdapterContentUnitsValue }

  TdxSVGAdapterContentUnitsValue = class(TdxSVGAdapterValue)
  strict private
    class function StringToContentUnits(const S: string): TdxSVGContentUnits;
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string); override;
  end;

  { TdxSVGAdapterFillValue }

  TdxSVGAdapterFillValue = class(TdxSVGAdapterColorValue)
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string); override;
  end;

  { TdxSVGAdapterFillRuleValue }

  TdxSVGAdapterFillRuleValue = class(TdxSVGAdapterValue)
  strict private
    class function StringToFillRule(const S: string): TdxSVGFillMode;
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string); override;
  end;

  { TdxSVGAdapterFontStyleValue  }

  TdxSVGAdapterFontStyleValue = class(TdxSVGAdapterValue)
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string); override;
  end;

  { TdxSVGAdapterLineCap }

  TdxSVGAdapterLineCap = class(TdxSVGAdapterValue)
  strict private
    class function StringToLineCap(const S: string): TdxSVGLineCapStyle;
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string); override;
  end;

  { TdxSVGAdapterLineJoin }

  TdxSVGAdapterLineJoin = class(TdxSVGAdapterValue)
  strict private
    class function StringToLineJoin(const S: string): TdxGpLineJoin;
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string); override;
  end;

  { TdxSVGAdapterNumbersValue }

  TdxSVGAdapterNumbersValue = class(TdxSVGAdapterValue)
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string); override;
  end;

  { TdxSVGAdapterPathValue }

  TdxSVGAdapterPathValue = class(TdxSVGAdapterValue)
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string); override;
  end;

  { TdxSVGAdapterPointsValue }

  TdxSVGAdapterPointsValue = class(TdxSVGAdapterValue)
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string); override;
  end;

  { TdxSVGAdapterRectValue }

  TdxSVGAdapterRectValue = class(TdxSVGAdapterValue)
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string); override;
  end;

  { TdxSVGAdapterReferenceValue }

  TdxSVGAdapterReferenceValue = class(TdxSVGAdapterValue)
  protected const
    URLPart1 = 'url(';
    URLPart2 = ')';
  protected
    class function TryStringToReference(S: string; out AReference: string): Boolean;
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string); override;
  end;

  { TdxSVGAdapterSizeValue }

  TdxSVGAdapterSizeValue = class(TdxSVGAdapterValue)
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const S: string); override;
  end;

  { TdxSVGAdapterTextAnchorValue }

  TdxSVGAdapterTextAnchorValue = class(TdxSVGAdapterValue)
  strict private
    class function StringToTextAnchor(const S: string): TdxSVGTextAnchor;
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const S: string); override;
  end;

  { TdxSVGAdapterTransformValue }

  TdxSVGAdapterTransformValue = class(TdxSVGAdapterValue)
  public
    class procedure Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string); override;
  end;

{$ENDREGION}

{$REGION 'Renderers'}

  { TdxSVGBrush }

  TdxSVGBrush = class(TdxGPBrush)
  strict private
    FGradientAutoScale: Boolean;
    FGradientLine: TdxRectF;
  protected
    procedure CreateGradientBrushHandle(out AHandle: Pointer); override;
    function NeedRecreateHandleOnTargetRectChange: Boolean; override;
  public
    property GradientAutoScale: Boolean read FGradientAutoScale write FGradientAutoScale;
    property GradientLine: TdxRectF read FGradientLine write FGradientLine;
  end;

  { TdxSVGPen }

  TdxSVGPen = class(TdxGpPen)
  strict private
    function GetBrush: TdxSVGBrush;
  protected
    function CreateBrush: TdxGPBrush; override;
  public
    property Brush: TdxSVGBrush read GetBrush;
  end;

  { TdxSVGCustomRenderer }

  TdxSVGCustomRenderer = class abstract
  strict private
    FBrush: TdxSVGBrush;
    FOpacity: Single;
    FOpacityAssigned: Boolean;
    FPalette: IdxColorPalette;
    FPen: TdxSVGPen;
  protected
    function ApplyOpacity(AColor: TdxAlphaColor): TdxAlphaColor;
    function TransformPenWidth(AWidth: Single): Single; virtual;
  public
    constructor Create(APalette: IdxColorPalette = nil);
    destructor Destroy; override;
    // Primitives
    procedure Ellipse(const ACenterX, ACenterY, ARadiusX, ARadiusY: Single); virtual; abstract;
    procedure Line(const X1, Y1, X2, Y2: Single); virtual; abstract;
    procedure Path(APath: TdxGPPath); virtual; abstract;
    procedure Polygon(const APoints: array of TdxPointF); virtual; abstract;
    procedure Polyline(const APoints: array of TdxPointF); virtual; abstract;
    procedure Rectangle(const X, Y, AWidth, AHeight: Single); virtual; abstract;
    procedure RoundRect(const X, Y, AWidth, AHeight, ARadiusX, ARadiusY: Single); virtual; abstract;
    procedure TextOut(const X, Y: Single; const AText: string; AFont: TdxGPFont); virtual; abstract;
    // Opacity
    function ModifyOpacity(const AOpacity: Single): Single; virtual;
    procedure SetOpacity(const AOpacity: Single); virtual;
    // State
    procedure RestoreClipRegion; virtual; abstract;
    procedure SaveClipRegion; virtual; abstract;
    procedure SetClipRegion(APath: TdxGPPath; AMode: TdxGPCombineMode = gmIntersect); virtual; abstract;
    // WorldTransform
    procedure ModifyWorldTransform(const AMatrix: TXForm); virtual; abstract;
    procedure RestoreWorldTransform; virtual; abstract;
    procedure SaveWorldTransform; virtual; abstract;
    //
    property Brush: TdxSVGBrush read FBrush;
    property Pen: TdxSVGPen read FPen;
    property Palette: IdxColorPalette read FPalette;
  end;

  { TdxSVGRenderer }

  TdxSVGRenderer = class(TdxSVGCustomRenderer)
  strict private
    FCanvas: TdxGPCanvas;
  protected
    function TransformPenWidth(AWidth: Single): Single; override;
  public
    constructor Create(ACanvas: TdxGPCanvas; APalette: IdxColorPalette = nil);
    // Primitives
    procedure Ellipse(const ACenterX, ACenterY, ARadiusX, ARadiusY: Single); override;
    procedure Line(const X1, Y1, X2, Y2: Single); override;
    procedure Path(APath: TdxGPPath); override;
    procedure Polygon(const APoints: array of TdxPointF); override;
    procedure Polyline(const APoints: array of TdxPointF); override;
    procedure Rectangle(const X, Y, AWidth, AHeight: Single); override;
    procedure RoundRect(const X, Y, AWidth, AHeight, ARadiusX, ARadiusY: Single); override;
    procedure TextOut(const X, Y: Single; const AText: string; AFont: TdxGPFont); override;
    // State
    procedure RestoreClipRegion; override;
    procedure SaveClipRegion; override;
    procedure SetClipRegion(APath: TdxGPPath; AMode: TdxGPCombineMode = gmIntersect); override;
    // WorldTransform
    procedure ModifyWorldTransform(const AMatrix: TXForm); override;
    procedure RestoreWorldTransform; override;
    procedure SaveWorldTransform; override;
  end;

  { TdxSVGRendererClipPath }

  TdxSVGRendererClipPath = class(TdxSVGCustomRenderer)
  strict private
    FClipPath: TdxGPPath;
    FSavedTransforms: TList<Integer>;
    FTransforms: TObjectList<TdxGPMatrix>;
  public
    constructor Create;
    destructor Destroy; override;
    // Primitives
    procedure Ellipse(const ACenterX, ACenterY, ARadiusX, ARadiusY: Single); override;
    procedure Line(const X1, Y1, X2, Y2: Single); override;
    procedure Path(APath: TdxGPPath); override;
    procedure Polygon(const APoints: array of TdxPointF); override;
    procedure Polyline(const APoints: array of TdxPointF); override;
    procedure Rectangle(const X, Y, AWidth, AHeight: Single); override;
    procedure RoundRect(const X, Y, AWidth, AHeight, ARadiusX, ARadiusY: Single); override;
    procedure TextOut(const X, Y: Single; const AText: string; AFont: TdxGPFont); override;
    // State
    procedure RestoreClipRegion; override;
    procedure SaveClipRegion; override;
    procedure SetClipRegion(APath: TdxGPPath; AMode: TdxGPCombineMode = gmIntersect); override;
    // WorldTransform
    procedure ModifyWorldTransform(const AMatrix: TXForm); override;
    procedure RestoreWorldTransform; override;
    procedure SaveWorldTransform; override;
    //
    property ClipPath: TdxGPPath read FClipPath;
  end;

{$ENDREGION}

{$REGION 'Elements'}

  { TdxSVGElement }

  TdxSVGElementClass = class of TdxSVGElement;
  TdxSVGElement = class(TPersistent)
  strict private
    FChildren: TObjectList;
    FClipPath: string;
    FFill: TdxSVGFill;
    FFillMode: TdxSVGFillMode;
    FID: string;
    FOpacity: Single;
    FStroke: TdxSVGFill;
    FStrokeDashArray: TdxSVGValues;
    FStrokeDashOffset: Single;
    FStrokeLineCap: TdxSVGLineCapStyle;
    FStrokeLineJoin: TdxGpLineJoin;
    FStrokeMiterLimit: Single;
    FStrokeSize: Single;
    FStyleName: string;
    FTransform: TdxMatrix;

    function GetCount: Integer;
    function GetElement(Index: Integer): TdxSVGElement;
    procedure SetOpacity(const Value: Single);
  protected
    FParent: TdxSVGElement;

    procedure Add(AElement: TdxSVGElement);
    function GetRoot: TdxSVGElementRoot; virtual;
    // Clipping
    procedure ApplyClipping(ARenderer: TdxSVGCustomRenderer);
    function HasClipping: Boolean;
    // Drawing
    procedure InitializeBrush(ARenderer: TdxSVGCustomRenderer); virtual;
    procedure InitializePen(ARenderer: TdxSVGCustomRenderer); virtual;
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); virtual;
    procedure DrawCoreAndChildren(ARenderer: TdxSVGCustomRenderer);
    // Relative Coordinates and Sizes
    function GetX(const X: TdxSVGValue): Single; inline;
    function GetY(const Y: TdxSVGValue): Single; inline;
    // Actual Values
    function GetActualFill(APalette: IdxColorPalette): TdxSVGFill;
    function GetActualFillMode: TdxGPFillMode;
    function GetActualStroke(APalette: IdxColorPalette): TdxSVGFill;
    function GetActualStrokeDashArray: TdxSVGValues;
    function GetActualStrokeDashOffset: Single;
    function GetActualStrokeLineCap: TdxSVGLineCapStyle;
    function GetActualStrokeSize: Single;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Draw(ARenderer: TdxSVGCustomRenderer); virtual;
    function FindByID(const ID: string; out AElement: TdxSVGElement): Boolean; virtual;
    //
    property Count: Integer read GetCount;
    property Elements[Index: Integer]: TdxSVGElement read GetElement; default;
    property Parent: TdxSVGElement read FParent;
    property Root: TdxSVGElementRoot read GetRoot;
  public
    [SVGAlias('id')]
    property ID: string read FID write FID;
    [SVGAlias('clip-path', TdxSVGAdapterReferenceValue)]
    property ClipPath: string read FClipPath write FClipPath;
    [SVGAlias('fill', TdxSVGAdapterFillValue)]
    property Fill: TdxSVGFill read FFill write FFill;
    [SVGAlias('fill-rule', TdxSVGAdapterFillRuleValue)]
    property FillMode: TdxSVGFillMode read FFillMode write FFillMode;
    [SVGAlias('opacity')]
    property Opacity: Single read FOpacity write SetOpacity;
    [SVGAlias('stroke', TdxSVGAdapterFillValue)]
    property Stroke: TdxSVGFill read FStroke write FStroke;
    [SVGAlias('stroke-dasharray', TdxSVGAdapterNumbersValue)]
    property StrokeDashArray: TdxSVGValues read FStrokeDashArray;
    [SVGAlias('stroke-dashoffset')]
    property StrokeDashOffset: Single read FStrokeDashOffset write FStrokeDashOffset;
    [SVGAlias('stroke-width', TdxSVGAdapterSizeValue)]
    property StrokeSize: Single read FStrokeSize write FStrokeSize;
    [SVGAlias('stroke-linecap', TdxSVGAdapterLineCap)]
    property StrokeLineCap: TdxSVGLineCapStyle read FStrokeLineCap write FStrokeLineCap;
    [SVGAlias('stroke-linejoin', TdxSVGAdapterLineJoin)]
    property StrokeLineJoin: TdxGpLineJoin read FStrokeLineJoin write FStrokeLineJoin;
    [SVGAlias('stroke-miterlimit')]
    property StrokeMiterLimit: Single read FStrokeMiterLimit write FStrokeMiterLimit;
    [SVGAlias('class')]
    property StyleName: string read FStyleName write FStyleName;
    [SVGAlias('transform', TdxSVGAdapterTransformValue)]
    property Transform: TdxMatrix read FTransform;
  end;

  { TdxSVGElementGroup }

  TdxSVGElementGroup = class(TdxSVGElement);

  { TdxSVGElementCircle }

  TdxSVGElementCircle = class(TdxSVGElement)
  strict private
    FRadius: TdxSVGValue;
    FCenterX: TdxSVGValue;
    FCenterY: TdxSVGValue;
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
  public
    [SVGAlias('cx', TdxSVGAdapterSizeValue)]
    property CenterX: TdxSVGValue read FCenterX write FCenterX;
    [SVGAlias('cy', TdxSVGAdapterSizeValue)]
    property CenterY: TdxSVGValue read FCenterY write FCenterY;
    [SVGAlias('r', TdxSVGAdapterSizeValue)]
    property Radius: TdxSVGValue read FRadius write FRadius;
  end;

  { TdxSVGElementEllipse }

  TdxSVGElementEllipse = class(TdxSVGElement)
  strict private
    FCenterX: TdxSVGValue;
    FCenterY: TdxSVGValue;
    FRadiusX: TdxSVGValue;
    FRadiusY: TdxSVGValue;
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
  public
    [SVGAlias('cx', TdxSVGAdapterSizeValue)]
    property CenterX: TdxSVGValue read FCenterX write FCenterX;
    [SVGAlias('cy', TdxSVGAdapterSizeValue)]
    property CenterY: TdxSVGValue read FCenterY write FCenterY;
    [SVGAlias('rx', TdxSVGAdapterSizeValue)]
    property RadiusX: TdxSVGValue read FRadiusX write FRadiusX;
    [SVGAlias('ry', TdxSVGAdapterSizeValue)]
    property RadiusY: TdxSVGValue read FRadiusY write FRadiusY;
  end;

  { TdxSVGElementLine }

  TdxSVGElementLine = class(TdxSVGElement)
  strict private
    FX2: TdxSVGValue;
    FY2: TdxSVGValue;
    FX1: TdxSVGValue;
    FY1: TdxSVGValue;
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
  public
    [SVGAlias('x1', TdxSVGAdapterSizeValue)]
    property X1: TdxSVGValue read FX1 write FX1;
    [SVGAlias('x2', TdxSVGAdapterSizeValue)]
    property X2: TdxSVGValue read FX2 write FX2;
    [SVGAlias('y1', TdxSVGAdapterSizeValue)]
    property Y1: TdxSVGValue read FY1 write FY1;
    [SVGAlias('y2', TdxSVGAdapterSizeValue)]
    property Y2: TdxSVGValue read FY2 write FY2;
  end;

  { TdxSVGElementPath }

  TdxSVGElementPath = class(TdxSVGElement)
  strict private
    FPath: TdxGPPath;
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
  public
    constructor Create; override;
    destructor Destroy; override;
  public
    [SVGAlias('d', TdxSVGAdapterPathValue)]
    property Path: TdxGPPath read FPath;
  end;

  { TdxSVGElementPolygon }

  TdxSVGElementPolygon = class(TdxSVGElement)
  strict private
    FPoints: TdxSVGPoints;
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    [SVGAlias('points', TdxSVGAdapterPointsValue)]
    property Points: TdxSVGPoints read FPoints;
  end;

  { TdxSVGElementPolyline }

  TdxSVGElementPolyline = class(TdxSVGElementPolygon)
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
  end;

  { TdxSVGElementRectangle }

  TdxSVGElementRectangle = class(TdxSVGElement)
  strict private
    FCornerRadiusX: TdxSVGValue;
    FCornerRadiusY: TdxSVGValue;
    FHeight: TdxSVGValue;
    FWidth: TdxSVGValue;
    FX: TdxSVGValue;
    FY: TdxSVGValue;
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
  public
    [SVGAlias('x', TdxSVGAdapterSizeValue)]
    property X: TdxSVGValue read FX write FX;
    [SVGAlias('y', TdxSVGAdapterSizeValue)]
    property Y: TdxSVGValue read FY write FY;
    [SVGAlias('height', TdxSVGAdapterSizeValue)]
    property Height: TdxSVGValue read FHeight write FHeight;
    [SVGAlias('width', TdxSVGAdapterSizeValue)]
    property Width: TdxSVGValue read FWidth write FWidth;
    [SVGAlias('rx', TdxSVGAdapterSizeValue)]
    property CornerRadiusX: TdxSVGValue read FCornerRadiusX write FCornerRadiusX;
    [SVGAlias('ry', TdxSVGAdapterSizeValue)]
    property CornerRadiusY: TdxSVGValue read FCornerRadiusY write FCornerRadiusY;
  end;

  { TdxSVGElementText }

  TdxSVGElementText = class(TdxSVGElement)
  strict private
    FDX: TdxSVGValue;
    FDY: TdxSVGValue;
    FFontName: string;
    FFontSize: Single;
    FFontStyles: TFontStyles;
    FText: string;
    FTextAnchor: TdxSVGTextAnchor;
    FX: TdxSVGValue;
    FY: TdxSVGValue;

    function GetFontAsStyleString: string;
    procedure SetFontAsStyleString(const AValue: string);
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
    function TryCreateFont(out AFont: TdxGpFont): Boolean;
  public
    constructor Create; override;
  public
    [SVGAlias('x', TdxSVGAdapterSizeValue)]
    property X: TdxSVGValue read FX write FX;
    [SVGAlias('y', TdxSVGAdapterSizeValue)]
    property Y: TdxSVGValue read FY write FY;
    [SVGAlias('dx', TdxSVGAdapterSizeValue)]
    property DX: TdxSVGValue read FDX write FDX;
    [SVGAlias('dy', TdxSVGAdapterSizeValue)]
    property DY: TdxSVGValue read FDY write FDY;
    [SVGAlias('font')]
    property FontAsStyleString: string read GetFontAsStyleString write SetFontAsStyleString;
    [SVGAlias('font-family')]
    property FontName: string read FFontName write FFontName;
    [SVGAlias('font-size', TdxSVGAdapterSizeValue)]
    property FontSize: Single read FFontSize write FFontSize;
    [SVGAlias('font-weight', TdxSVGAdapterFontStyleValue), SVGAlias('font-style', TdxSVGAdapterFontStyleValue)]
    property FontStyles: TFontStyles read FFontStyles write FFontStyles;
    [SVGAlias('text-anchor', TdxSVGAdapterTextAnchorValue)]
    property TextAnchor: TdxSVGTextAnchor read FTextAnchor write FTextAnchor;
    [SVGAlias('_nodeText')]
    property Text: string read FText write FText;
  end;

  { TdxSVGElementRoot }

  TdxSVGElementRoot = class(TdxSVGElement)
  strict private
    FBackground: TdxSVGRect;
    FHeight: TdxSVGValue;
    FViewBox: TdxSVGRect;
    FWidth: TdxSVGValue;

    function GetSize: TdxSizeF;
  protected
    function GetRoot: TdxSVGElementRoot; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    property Size: TdxSizeF read GetSize;
  public
    [SVGAlias('height', TdxSVGAdapterSizeValue)]
    property Height: TdxSVGValue read FHeight write FHeight;
    [SVGAlias('width', TdxSVGAdapterSizeValue)]
    property Width: TdxSVGValue read FWidth write FWidth;
    [SVGAlias('enable-background', TdxSVGAdapterRectValue)]
    property Background: TdxSVGRect read FBackground;
    [SVGAlias('viewBox', TdxSVGAdapterRectValue)]
    property ViewBox: TdxSVGRect read FViewBox;
  end;

  { TdxSVGElementUse }

  TdxSVGElementUse = class(TdxSVGElement)
  strict private
    FReference: string;
    FX: TdxSVGValue;
    FY: TdxSVGValue;
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
  public
    [SVGAlias('x', TdxSVGAdapterSizeValue)]
    property X: TdxSVGValue read FX write FX;
    [SVGAlias('y', TdxSVGAdapterSizeValue)]
    property Y: TdxSVGValue read FY write FY;
    [SVGAlias('href', TdxSVGAdapterReferenceValue), SVGAlias('xlink:href', TdxSVGAdapterReferenceValue)]
    property Reference: string read FReference write FReference;
  end;

{$ENDREGION}

{$REGION 'NeverRendered Elements'}

  { TdxSVGElementNeverRendered }

  TdxSVGElementNeverRendered = class(TdxSVGElement)
  public
    procedure Draw(ARenderer: TdxSVGCustomRenderer); override;
  end;

  { TdxSVGElementClipPath }

  TdxSVGElementClipPath = class(TdxSVGElementNeverRendered)
  public
    procedure ApplyTo(ARenderer: TdxSVGCustomRenderer; AElement: TdxSVGElement);
  end;

  { TdxSVGElementLinearGradientStop }

  TdxSVGElementLinearGradientStop = class(TdxSVGElementNeverRendered)
  strict private
    FColor: TdxAlphaColor;
    FColorOpacity: Single;
    FOffset: TdxSVGValue;
  public
    procedure AfterConstruction; override;
  public
    [SVGAlias('stop-color', TdxSVGAdapterColorValue)]
    property Color: TdxAlphaColor read FColor write FColor;
    [SVGAlias('stop-opacity', TdxSVGAdapterSizeValue)]
    property ColorOpacity: Single read FColorOpacity write FColorOpacity;
    [SVGAlias('offset', TdxSVGAdapterSizeValue)]
    property Offset: TdxSVGValue read FOffset write FOffset;
  end;

  { TdxSVGElementLinearGradient }

  TdxSVGElementLinearGradient = class(TdxSVGElementNeverRendered)
  strict private
    FUnitsType: TdxSVGContentUnits;
    FX1: TdxSVGValue;
    FX2: TdxSVGValue;
    FY1: TdxSVGValue;
    FY2: TdxSVGValue;

    function GetElement(Index: Integer): TdxSVGElementLinearGradientStop;
    //
    function CalculateGradientLine(const APatternRect: TdxRectF): TdxRectF;
    procedure CalculateGradinentOffsets(const APatternRect, AGradientLine: TdxRectF;
      out AStartOffset, AFinishOffset: Single; out AInvertOrder: Boolean);
    procedure PopulateGradientPoints(APoints: TdxGPBrushGradientPoints; AStartOffset, AFinishOffset: Single; AInvertOrder: Boolean);
  protected
    procedure InitializeBrush(ARenderer: TdxSVGCustomRenderer); override;
    procedure InitializeBrushCore(ARenderer: TdxSVGCustomRenderer; ABrush: TdxSVGBrush);
    procedure InitializePen(ARenderer: TdxSVGCustomRenderer); override;
  public
    procedure AfterConstruction; override;
    //
    property Elements[Index: Integer]: TdxSVGElementLinearGradientStop read GetElement;
  public
    [SVGAlias('x1', TdxSVGAdapterSizeValue)]
    property X1: TdxSVGValue read FX1 write FX1;
    [SVGAlias('y1', TdxSVGAdapterSizeValue)]
    property Y1: TdxSVGValue read FY1 write FY1;
    [SVGAlias('x2', TdxSVGAdapterSizeValue)]
    property X2: TdxSVGValue read FX2 write FX2;
    [SVGAlias('y2', TdxSVGAdapterSizeValue)]
    property Y2: TdxSVGValue read FY2 write FY2;
    [SVGAlias('gradientUnits', TdxSVGAdapterContentUnitsValue)]
    property UnitsType: TdxSVGContentUnits read FUnitsType write FUnitsType;
  end;

{$ENDREGION}

  { TdxSVGStyle }

  TdxSVGStyle = class(TdxXMLNodeAttributes)
  strict private
    FName: string;
  public
    constructor Create(const AName: string);
    procedure Apply(AElement: TdxSVGElement);
    //
    property Name: string read FName;
  end;

  { TdxSVGStyles }

  TdxSVGStyles = class
  strict private const
    sInline = '_inline_%p';
  strict private
    FItems: TObjectDictionary<string, TdxSVGStyle>;

    function GetItem(const Name: string): TdxSVGStyle;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const AName: string): TdxSVGStyle;
    function AddInline(const AReference: TObject): TdxSVGStyle;
    procedure Apply(AElement: TdxSVGElement);
    function TryGetStyle(const AName: string; out AStyle: TdxSVGStyle): Boolean;
    //
    property Items[const Name: string]: TdxSVGStyle read GetItem; default;
  end;

  { TdxSVGLoader }

  TdxSVGLoader = class
  strict private const
    StyleAttrName = 'style';
  protected
    class var FElementMap: TDictionary<TdxXMLString, TdxSVGElementClass>;

    class procedure LoadCore(AParent: TdxSVGElement; AStyles: TdxSVGStyles; ANode: TdxXMLNode);
    class procedure LoadStyles(AStyles: TdxSVGStyles; ANode: TdxXMLNode);
    class procedure Initialize;
    class procedure Finalize;
  public
    class procedure ApplyAttribute(AObject: TObject; ARttiType: TRttiType; AAttribute: TdxXMLNodeAttribute); overload;
    class procedure ApplyAttribute(AObject: TObject; AAttribute: TdxXMLNodeAttribute); overload;
    class procedure ApplyAttributes(AObject: TObject; AAttributes: TdxXMLNodeAttributes);
    class procedure Load(AParent: TdxSVGElement; ADocument: TdxXMLDocument);
  end;

implementation

uses
  SysUtils, Math, StrUtils, Character, dxSVGCoreParsers, RTLConsts;

type
  TdxGPBrushGradientPointsAccess = class(TdxGPBrushGradientPoints);

function dxGpMeasureString(AFont: TdxGpFont; const AText: string): TdxSizeF;
begin
  dxGPPaintCanvas.BeginPaint(cxScreenCanvas.Handle, cxSimpleRect);
  try
    Result := dxGPPaintCanvas.MeasureString(AText, AFont);
  finally
    dxGPPaintCanvas.EndPaint;
    cxScreenCanvas.Dormant;
  end;
end;

function dxGpApplyOpacity(AColor: TdxAlphaColor; AOpacity: Single): TdxAlphaColor;
begin
  if (AOpacity < 1) and not TdxAlphaColors.IsTransparentOrEmpty(AColor) then
  begin
    with dxAlphaColorToRGBQuad(AColor) do
      Result := dxMakeAlphaColor(Trunc(rgbReserved * AOpacity), rgbRed, rgbGreen, rgbBlue);
  end
  else
    Result := AColor;
end;

{ SVGAlias }

constructor SVGAlias.Create(const AName: TdxXMLString);
begin
  Create(AName, nil);
end;

constructor SVGAlias.Create(const AName: TdxXMLString; AAdapter: TdxSVGAdapterValueClass);
begin
  FAdapter := AAdapter;
  FName := AName;
end;

{ TdxSVGFill }

class function TdxSVGFill.Create(const AColor: TdxAlphaColor): TdxSVGFill;
begin
  Result.Data := AColor;
end;

class function TdxSVGFill.Create(const AReference: string): TdxSVGFill;
begin
  Result.Data := AReference;
end;

class function TdxSVGFill.Default: TdxSVGFill;
begin
  Result := TdxSVGFill.Create(TdxAlphaColors.Default);
end;

function TdxSVGFill.IsDefault: Boolean;
begin
  Result := VarIsNumeric(Data) and (Data = TdxAlphaColors.Default);
end;

function TdxSVGFill.IsReference: Boolean;
begin
  Result := VarIsStr(Data);
end;

function TdxSVGFill.AsColor: TdxAlphaColor;
begin
  Result := Data;
end;

function TdxSVGFill.AsReference: string;
begin
  if IsReference then
    Result := Data
  else
    Result := '';
end;

{ TdxSVGValue }

class function TdxSVGValue.Create(const AValue: Single; AUnitsType: TdxSVGUnitsType): TdxSVGValue;
begin
  Result.Data := AValue;
  Result.UnitsType := AUnitsType;
end;

function TdxSVGValue.IsEmpty: Boolean;
begin
  Result := IsZero(Data);
end;

function TdxSVGValue.ToPixels(ATargetDPI: Integer): Single;
begin
  if UnitsType = utPercents then
    raise EInvalidArgument.Create('TdxSVGValue.ToPixels');
  Result := ToPixels(0, ATargetDPI);
end;

function TdxSVGValue.ToPixels(const AParentSize: Single; ATargetDPI: Integer = dxDefaultDPI): Single;
const
  CMPerInch = 2.54;
begin
  case UnitsType of
    utCm:
      Result := Data / CMPerInch * ATargetDPI;
    utIn:
      Result := Data * ATargetDPI;
    utMm:
      Result := Data / (10 * CMPerInch) * ATargetDPI;
    utPc:
      Result := Data * 12 / 72 * ATargetDPI;
    utPt:
      Result := Data / 72 * ATargetDPI;
    utPercents:
      Result := Data / 100 * AParentSize;
  else // pixels
    Result := Data;
  end;
end;

function TdxSVGValue.ToValue: TValue;
begin
  Result := TValue.From<TdxSVGValue>(Self);
end;

{ TdxSVGList<T> }

procedure TdxSVGList<T>.Assign(AValues: TdxSVGList<T>);
begin
  Clear;
  Capacity := AValues.Count;
  AddRange(AValues);
end;

{$IFNDEF DELPHIXE}
function TdxSVGList<T>.ToArray: TArray<T>;
var
  I: Integer;
begin
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := Items[I];
end;
{$ENDIF}

{ TdxSVGBrush }

procedure TdxSVGBrush.CreateGradientBrushHandle(out AHandle: Pointer);
var
  AColors: PdxAlphaColor;
  ACount: Integer;
  AFinishPoint: TdxGpPointF;
  AOffsets: PSingle;
  AStartPoint: TdxGpPointF;
begin
  if (GradientPoints.Count = 0) or GradientAutoScale and ((FTargetRect.Width = 0) or (FTargetRect.Height = 0)) then
  begin
    CreateEmptyBrushHandle(AHandle);
    Exit;
  end;

  AStartPoint := MakePoint(FGradientLine.Left, FGradientLine.Top);
  AFinishPoint := MakePoint(FGradientLine.Right, FGradientLine.Bottom);

  if GradientAutoScale then
  begin
    AStartPoint.X := FTargetRect.X + AStartPoint.X * FTargetRect.Width;
    AStartPoint.Y := FTargetRect.Y + AStartPoint.Y * FTargetRect.Height;
    AFinishPoint.X := FTargetRect.X + AFinishPoint.X * FTargetRect.Width;
    AFinishPoint.Y := FTargetRect.Y + AFinishPoint.Y * FTargetRect.Height;
  end;

  TdxGPBrushGradientPointsAccess(GradientPoints).CalculateParams(AColors, AOffsets, ACount);
  GdipCheck(GdipCreateLineBrush(@AStartPoint, @AFinishPoint, 0, 0, WrapModeTileFlipX, AHandle));
  GdipCheck(GdipSetLinePresetBlend(AHandle, AColors, AOffsets, ACount));
end;

function TdxSVGBrush.NeedRecreateHandleOnTargetRectChange: Boolean;
begin
  Result := (Style = gpbsGradient) and GradientAutoScale;
end;

{ TdxSVGPen }

function TdxSVGPen.CreateBrush: TdxGpBrush;
begin
  Result := TdxSVGBrush.Create;
end;

function TdxSVGPen.GetBrush: TdxSVGBrush;
begin
  Result := inherited Brush as TdxSVGBrush;
end;

{ TdxSVGRect }

function TdxSVGRect.GetHeight: Single;
begin
  Result := Value.Height;
end;

function TdxSVGRect.GetWidth: Single;
begin
  Result := Value.Width;
end;

{ TdxSVGAdapterValue }

class procedure TdxSVGAdapterValue.Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string);
begin
  dxTestCheck(False, ClassName); 
end;

{ TdxSVGAdapterColorValue }

class procedure TdxSVGAdapterColorValue.Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string);
var
  AColor: TdxAlphaColor;
begin
  AColor := StringToAlphaColor(AValue);
  if AColor <> TdxAlphaColors.Default then
    AProperty.SetValue(AObject, TValue.From<TdxAlphaColor>(AColor));
end;

class function TdxSVGAdapterColorValue.StringToAlphaColor(const AValue: string): TdxAlphaColor;
const
  RGBMacro = 'rgb(';
var
  ARgbMacro: Integer;
  ARgbValues: TdxSVGValues;
begin
  ARgbMacro := Pos(RGBMacro, AValue);
  if ARgbMacro > 0 then
  begin
    ARgbValues := TdxSVGParserNumbers.AsNumbers(Copy(AValue, ARgbMacro + Length(RGBMacro), MaxInt));
    try
      if ARgbValues.Count = 3 then
        Result := TdxAlphaColors.FromArgb(MaxByte, Round(ARgbValues[0]), Round(ARgbValues[1]), Round(ARgbValues[2]))
      else
        Result := TdxAlphaColors.Default;
    finally
      ARgbValues.Free;
    end;
  end
  else
    if AValue = 'inherit' then
      Result := TdxAlphaColors.Default
    else
      Result := TdxAlphaColors.FromHtml(AValue);
end;

{ TdxSVGAdapterContentUnitsValue }

class procedure TdxSVGAdapterContentUnitsValue.Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string);
begin
  AProperty.SetValue(AObject, TValue.From<TdxSVGContentUnits>(StringToContentUnits(AValue)));
end;

class function TdxSVGAdapterContentUnitsValue.StringToContentUnits(const S: string): TdxSVGContentUnits;
const
  NameMap: array[TdxSVGContentUnits] of string = ('userSpaceOnUse', 'objectBoundingBox');
var
  AIndex: TdxSVGContentUnits;
begin
  for AIndex := Low(AIndex) to High(AIndex) do
  begin
    if NameMap[AIndex] = S then
      Exit(AIndex);
  end;
  Result := cuUserSpaceOnUse;
end;

{ TdxSVGAdapterFillValue }

class procedure TdxSVGAdapterFillValue.Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string);
var
  AFill: TdxSVGFill;
  AReference: string;
begin
  if StartsText(TdxSVGAdapterReferenceValue.URLPart1, Trim(AValue)) then
  begin
    if TdxSVGAdapterReferenceValue.TryStringToReference(AValue, AReference) then
      AFill := TdxSVGFill.Create(AReference)
    else
      AFill := TdxSVGFill.Default;
  end
  else
    AFill := TdxSVGFill.Create(StringToAlphaColor(AValue));

  if not AFill.IsDefault then
    AProperty.SetValue(AObject, TValue.From<TdxSVGFill>(AFill));
end;

{ TdxSVGAdapterFillRuleValue }

class procedure TdxSVGAdapterFillRuleValue.Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string);
begin
  AProperty.SetValue(AObject, TValue.From<TdxSVGFillMode>(StringToFillRule(AValue)));
end;

class function TdxSVGAdapterFillRuleValue.StringToFillRule(const S: string): TdxSVGFillMode;
const
  NameMap: array[TdxSVGFillMode] of string = ('nonzero', 'evenodd', 'inherit');
var
  ARule: TdxSVGFillMode;
begin
  for ARule := Low(TdxSVGFillMode) to High(TdxSVGFillMode) do
  begin
    if NameMap[ARule] = S then
      Exit(ARule);
  end;
  Result := fmInherit;
end;

{ TdxSVGAdapterFontStyleValue }

class procedure TdxSVGAdapterFontStyleValue.Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string);
var
  AStyle: TFontStyle;
begin
  if TdxSVGFontStyleString.TryStringToFontStyle(AValue, AStyle) then
    AProperty.SetValue(AObject, TValue.From<TFontStyles>(AProperty.GetValue(AObject).AsType<TFontStyles> + [AStyle]));
end;

{ TdxSVGAdapterLineCap }

class procedure TdxSVGAdapterLineCap.Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string);
begin
  AProperty.SetValue(AObject, TValue.From<TdxSVGLineCapStyle>(StringToLineCap(AValue)));
end;

class function TdxSVGAdapterLineCap.StringToLineCap(const S: string): TdxSVGLineCapStyle;
const
  NameMap: array[TdxSVGLineCapStyle] of string = ('', 'butt', 'square', 'round');
var
  AIndex: TdxSVGLineCapStyle;
begin
  for AIndex := Low(AIndex) to High(AIndex) do
  begin
    if NameMap[AIndex] = S then
      Exit(AIndex);
  end;
  Result := lcsDefault;
end;

{ TdxSVGAdapterLineJoin }

class procedure TdxSVGAdapterLineJoin.Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string);
begin
  AProperty.SetValue(AObject, TValue.From<TdxGpLineJoin>(StringToLineJoin(AValue)));
end;

class function TdxSVGAdapterLineJoin.StringToLineJoin(const S: string): TdxGpLineJoin;
const
  NameMap: array[TdxGpLineJoin] of string = ('miter', 'bevel', 'round', '');
var
  AIndex: TdxGpLineJoin;
begin
  for AIndex := Low(AIndex) to High(AIndex) do
  begin
    if NameMap[AIndex] = S then
      Exit(AIndex);
  end;
  Result := LineJoinMiter;
end;

{ TdxSVGAdapterNumbersValue }

class procedure TdxSVGAdapterNumbersValue.Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string);
var
  ASource: TdxSVGValues;
begin
  ASource := TdxSVGParserNumbers.AsNumbers(AValue);
  try
    (AProperty.GetValue(AObject).AsObject as TdxSVGValues).Assign(ASource);
  finally
    ASource.Free;
  end;
end;

{ TdxSVGAdapterPathValue }

class procedure TdxSVGAdapterPathValue.Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string);
var
  AParser: TdxSVGParserPath;
  APath: TdxGPPath;
  I: Integer;
begin
  AParser := TdxSVGParserPath.Create;
  try
    AParser.Parse(AValue);
    APath := AProperty.GetValue(AObject).AsObject as TdxGPPath;
    for I := 0 to AParser.CommandCount - 1 do
      AParser.Commands[I].Append(APath);
  finally
    AParser.Free;
  end;
end;

{ TdxSVGAdapterPointsValue }

class procedure TdxSVGAdapterPointsValue.Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string);
begin
  TdxSVGParserNumbers.AsPoints(AValue, AProperty.GetValue(AObject).AsObject as TdxSVGPoints);
end;

{ TdxSVGAdapterRectValue }

class procedure TdxSVGAdapterRectValue.Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string);
begin
  (AProperty.GetValue(AObject).AsObject as TdxSVGRect).Value := TdxSVGParserRect.Parse(AValue);
end;

{ TdxSVGAdapterReferenceValue }

class procedure TdxSVGAdapterReferenceValue.Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string);
var
  AReference: string;
begin
  if TryStringToReference(AValue, AReference) then
    AProperty.SetValue(AObject, TValue.From<string>(AReference));
end;

class function TdxSVGAdapterReferenceValue.TryStringToReference(S: string; out AReference: string): Boolean;
begin
  S := Trim(S);
  if StartsText(URLPart1, S) and EndsText(URLPart2, S)  then
    S := Copy(S, Length(URLPart1) + 1, Length(S) - Length(URLPart1) - Length(URLPart2));
  Result := StartsText('#', S);
  if Result then
    AReference := Copy(S, 2, MaxInt);
end;

{ TdxSVGAdapterSizeValue }

class procedure TdxSVGAdapterSizeValue.Load(AObject: TObject; AProperty: TRttiProperty; const S: string);
var
  AValue: TdxSVGValue;
begin
  if TdxSVGParserValue.Parse(S, AValue) then
  try
    if AProperty.PropertyType.IsRecord then
      AProperty.SetValue(AObject, AValue.ToValue)
    else
      AProperty.SetValue(AObject, AValue.ToPixels(0.0));
  except
     // conversion error, do nothing
  end;
end;

{ TdxSVGAdapterTextAnchorValue }

class procedure TdxSVGAdapterTextAnchorValue.Load(AObject: TObject; AProperty: TRttiProperty; const S: string);
begin
  AProperty.SetValue(AObject, TValue.From<TdxSVGTextAnchor>(StringToTextAnchor(S)));
end;

class function TdxSVGAdapterTextAnchorValue.StringToTextAnchor(const S: string): TdxSVGTextAnchor;
const
  NameMap: array[TdxSVGTextAnchor] of string = ('start', 'middle', 'end', 'inherit');
var
  AIndex: TdxSVGTextAnchor;
begin
  for AIndex := Low(AIndex) to High(AIndex) do
  begin
    if NameMap[AIndex] = S then
      Exit(AIndex);
  end;
  Result := taInherit;
end;

{ TdxSVGAdapterTransformValue }

class procedure TdxSVGAdapterTransformValue.Load(AObject: TObject; AProperty: TRttiProperty; const AValue: string);
begin
  TdxSVGParserTransform.Parse(AValue, AProperty.GetValue(AObject).AsObject as TdxMatrix);
end;

{ TdxSVGCustomRenderer }

constructor TdxSVGCustomRenderer.Create(APalette: IdxColorPalette);
begin
  FPalette := APalette;
  FPen := TdxSVGPen.Create;
  FBrush := TdxSVGBrush.Create;
  SetOpacity(1.0);
end;

destructor TdxSVGCustomRenderer.Destroy;
begin
  FreeAndNil(FBrush);
  FreeAndNil(FPen);
  inherited;
end;

function TdxSVGCustomRenderer.ModifyOpacity(const AOpacity: Single): Single;
begin
  Result := FOpacity;
  SetOpacity(Result * AOpacity);
end;

procedure TdxSVGCustomRenderer.SetOpacity(const AOpacity: Single);
begin
  FOpacity := AOpacity;
  FOpacityAssigned := not SameValue(FOpacity, 1.0);
end;

function TdxSVGCustomRenderer.ApplyOpacity(AColor: TdxAlphaColor): TdxAlphaColor;
begin
  if FOpacityAssigned then
    Result := dxGpApplyOpacity(AColor, FOpacity)
  else
    Result := AColor;
end;

function TdxSVGCustomRenderer.TransformPenWidth(AWidth: Single): Single;
begin
  Result := AWidth;
end;

{ TdxSVGRenderer }

constructor TdxSVGRenderer.Create(ACanvas: TdxGPCanvas; APalette: IdxColorPalette = nil);
begin
  inherited Create(APalette);
  FCanvas := ACanvas;
end;

procedure TdxSVGRenderer.Ellipse(const ACenterX, ACenterY, ARadiusX, ARadiusY: Single);
begin
  FCanvas.Ellipse(dxRectF(ACenterX - ARadiusX, ACenterY - ARadiusY, ACenterX + ARadiusX, ACenterY + ARadiusY), Pen, Brush);
end;

procedure TdxSVGRenderer.Line(const X1, Y1, X2, Y2: Single);
begin
  FCanvas.Line(X1, Y1, X2, Y2, Pen);
end;

procedure TdxSVGRenderer.Path(APath: TdxGPPath);
begin
  FCanvas.Path(APath, Pen, Brush);
end;

procedure TdxSVGRenderer.Polygon(const APoints: array of TdxPointF);
begin
  FCanvas.Polygon(APoints, Pen, Brush);
end;

procedure TdxSVGRenderer.Polyline(const APoints: array of TdxPointF);
begin
  FCanvas.Polyline(APoints, Pen);
end;

procedure TdxSVGRenderer.Rectangle(const X, Y, AWidth, AHeight: Single);
begin
  FCanvas.Rectangle(dxRectF(X, Y, X + AWidth, Y + AHeight), Pen, Brush);
end;

procedure TdxSVGRenderer.RoundRect(const X, Y, AWidth, AHeight, ARadiusX, ARadiusY: Single);
var
  APath: TdxGPPath;
begin
  APath := TdxGPPath.Create;
  try
    APath.AddRoundRect(dxRectF(X, Y, X + AWidth, Y + AHeight), ARadiusX, ARadiusY);
    Path(APath);
  finally
    APath.Free;
  end;
end;

procedure TdxSVGRenderer.TextOut(const X, Y: Single; const AText: string; AFont: TdxGPFont);
begin
  FCanvas.DrawString(AText, AFont, Brush, X, Y);
end;

procedure TdxSVGRenderer.RestoreClipRegion;
begin
  FCanvas.RestoreClipRegion;
end;

procedure TdxSVGRenderer.SaveClipRegion;
begin
  FCanvas.SaveClipRegion;
end;

procedure TdxSVGRenderer.SetClipRegion(APath: TdxGPPath; AMode: TdxGPCombineMode = gmIntersect);
begin
  FCanvas.SetClipPath(APath, AMode);
end;

procedure TdxSVGRenderer.ModifyWorldTransform(const AMatrix: TXForm);
var
  AGpMatrix: TdxGPMatrix;
begin
  AGpMatrix := TdxGPMatrix.CreateEx(AMatrix);
  try
    FCanvas.ModifyWorldTransform(AGpMatrix);
  finally
    AGpMatrix.Free;
  end;
end;

procedure TdxSVGRenderer.RestoreWorldTransform;
begin
  FCanvas.RestoreWorldTransform;
end;

procedure TdxSVGRenderer.SaveWorldTransform;
begin
  FCanvas.SaveWorldTransform;
end;

function TdxSVGRenderer.TransformPenWidth(AWidth: Single): Single;
var
  M11, M12, M21, M22, X: Single;
  APoint: TdxPointF;
begin
  if AWidth <= 0 then
    Exit(AWidth);

  with FCanvas.GetWorldTransform do
  try
    GetElements(M11, M12, M21, M22, X, X);
    SetElements(M11, M12, M21, M22, 0, 0);
    APoint := TransformPoint(dxPointF(AWidth, AWidth));
    Result := Sqrt(Abs(APoint.X * APoint.Y));
  finally
    Free;
  end;
end;

{ TdxSVGRendererClipPath }

constructor TdxSVGRendererClipPath.Create;
begin
  inherited Create(nil);
  FClipPath := TdxGPPath.Create;
end;

destructor TdxSVGRendererClipPath.Destroy;
begin
  FreeAndNil(FSavedTransforms);
  FreeAndNil(FTransforms);
  FreeAndNil(FClipPath);
  inherited;
end;

procedure TdxSVGRendererClipPath.Ellipse(const ACenterX, ACenterY, ARadiusX, ARadiusY: Single);
begin
  ClipPath.AddEllipse(dxRectF(ACenterX - ARadiusX, ACenterY - ARadiusY, ACenterX + ARadiusX, ACenterY + ARadiusY));
end;

procedure TdxSVGRendererClipPath.Line(const X1, Y1, X2, Y2: Single);
begin
  ClipPath.AddLine(X1, Y1, X2, Y2);
end;

procedure TdxSVGRendererClipPath.Path(APath: TdxGPPath);
begin
  ClipPath.AddPath(APath);
end;

procedure TdxSVGRendererClipPath.Polygon(const APoints: array of TdxPointF);
begin
  ClipPath.AddPolygon(APoints);
end;

procedure TdxSVGRendererClipPath.Polyline(const APoints: array of TdxPointF);
begin
  ClipPath.AddPolyline(APoints);
end;

procedure TdxSVGRendererClipPath.Rectangle(const X, Y, AWidth, AHeight: Single);
begin
  ClipPath.AddRect(dxRectF(X, Y, X + AWidth, Y + AHeight));
end;

procedure TdxSVGRendererClipPath.RoundRect(const X, Y, AWidth, AHeight, ARadiusX, ARadiusY: Single);
begin
  ClipPath.AddRoundRect(dxRectF(X, Y, X + AWidth, Y + AHeight), ARadiusX, ARadiusY);
end;

procedure TdxSVGRendererClipPath.TextOut(const X, Y: Single; const AText: string; AFont: TdxGPFont);
var
  ATextSize: TdxSizeF;
begin
  ATextSize := dxGpMeasureString(AFont, AText);
  ClipPath.AddString(PWideChar(AText), AFont, nil, dxRectF(X, Y, X + ATextSize.cx, Y + ATextSize.cy));
end;

procedure TdxSVGRendererClipPath.ModifyWorldTransform(const AMatrix: TXForm);
var
  AGpMatrix: TdxGPMatrix;
begin
  AGpMatrix := TdxGPMatrix.CreateEx(AMatrix);

  if FTransforms = nil then
    FTransforms := TObjectList<TdxGPMatrix>.Create;
  FTransforms.Add(AGpMatrix);

  ClipPath.Transform(AGpMatrix);
end;

procedure TdxSVGRendererClipPath.RestoreWorldTransform;
var
  AIndex, I: Integer;
begin
  if (FSavedTransforms <> nil) and (FSavedTransforms.Count > 0) then
  begin
    AIndex := FSavedTransforms.Last;
    FSavedTransforms.Delete(FSavedTransforms.Count - 1);
    for I := FTransforms.Count - 1 downto AIndex + 1 do
    begin
      FTransforms[I].Invert;
      ClipPath.Transform(FTransforms[I]);
      FTransforms.Delete(I);
    end;
  end;
end;

procedure TdxSVGRendererClipPath.SaveWorldTransform;
begin
  if FTransforms <> nil then
  begin
    if FSavedTransforms = nil then
      FSavedTransforms := TList<Integer>.Create;
    FSavedTransforms.Add(FTransforms.Count - 1);
  end;
end;

procedure TdxSVGRendererClipPath.RestoreClipRegion;
begin
  // do nothing
end;

procedure TdxSVGRendererClipPath.SaveClipRegion;
begin
  // do nothing
end;

procedure TdxSVGRendererClipPath.SetClipRegion(APath: TdxGPPath; AMode: TdxGPCombineMode);
begin
  // do nothing
end;

{ TdxSVGElement }

constructor TdxSVGElement.Create;
begin
  inherited Create;
  FOpacity := 1.0;
  FStrokeMiterLimit := 4;
  FStrokeDashOffset := -1; // default
  FStrokeDashArray := TdxSVGValues.Create;
  FTransform := TdxMatrix.Create;
  Stroke := TdxSVGFill.Default;
  Fill := TdxSVGFill.Default;
end;

destructor TdxSVGElement.Destroy;
begin
  FreeAndNil(FStrokeDashArray);
  FreeAndNil(FTransform);
  FreeAndNil(FChildren);
  inherited Destroy;
end;

procedure TdxSVGElement.Draw(ARenderer: TdxSVGCustomRenderer);
var
  AHasTransform: Boolean;
  APrevOpacity: Single;
begin
  APrevOpacity := ARenderer.ModifyOpacity(Opacity);
  AHasTransform := not Transform.IsIdentity;
  if AHasTransform then
  begin
    ARenderer.SaveWorldTransform;
    ARenderer.ModifyWorldTransform(Transform.XForm);
  end;

  InitializePen(ARenderer);
  InitializeBrush(ARenderer);

  if HasClipping then
  begin
    ARenderer.SaveClipRegion;
    try
      ApplyClipping(ARenderer);
      DrawCoreAndChildren(ARenderer);
    finally
      ARenderer.RestoreClipRegion;
    end;
  end
  else
    DrawCoreAndChildren(ARenderer);

  if AHasTransform then
    ARenderer.RestoreWorldTransform;
  ARenderer.SetOpacity(APrevOpacity);
end;

function TdxSVGElement.FindByID(const ID: string; out AElement: TdxSVGElement): Boolean;
var
  I: Integer;
begin
  if ID = '' then
    Exit(False);

  for I := 0 to Count - 1 do
    if dxSameText(Elements[I].ID, ID) then
    begin
      AElement := Elements[I];
      Exit(True);
    end;

  for I := 0 to Count - 1 do
  begin
    if Elements[I].FindByID(ID, AElement) then
      Exit(True);
  end;

  Result := False;
end;

procedure TdxSVGElement.Add(AElement: TdxSVGElement);
begin
  if AElement <> nil then
  begin
    AElement.FParent := Self;
    if FChildren = nil then
      FChildren := TObjectList.Create;
    FChildren.Add(AElement);
  end;
end;

function TdxSVGElement.GetRoot: TdxSVGElementRoot;
begin
  if Parent <> nil then
    Result := Parent.Root
  else
    Result := nil;
end;

procedure TdxSVGElement.ApplyClipping(ARenderer: TdxSVGCustomRenderer);

  function GetEffect(const ID: string; out AClipPath: TdxSVGElementClipPath): Boolean;
  var
    AElement: TdxSVGElement;
  begin
    Result := (ID <> '') and Root.FindByID(ID, AElement) and (AElement is TdxSVGElementClipPath);
    if Result then
      AClipPath := TdxSVGElementClipPath(AElement);
  end;

var
  AClipPath: TdxSVGElementClipPath;
begin
  if GetEffect(ClipPath, AClipPath) then
    AClipPath.ApplyTo(ARenderer, Self);
end;

function TdxSVGElement.HasClipping: Boolean;
begin
  Result := ClipPath <> '';
end;

procedure TdxSVGElement.InitializeBrush(ARenderer: TdxSVGCustomRenderer);
var
  AElement: TdxSVGElement;
  AFill: TdxSVGFill;
begin
  AFill := GetActualFill(ARenderer.Palette);
  if AFill.IsReference then
  begin
    if Root.FindByID(AFill.AsReference, AElement) then
      AElement.InitializeBrush(ARenderer);
  end
  else
  begin
    ARenderer.Brush.Style := gpbsSolid;
    ARenderer.Brush.Color := ARenderer.ApplyOpacity(AFill.AsColor);
  end;
end;

procedure TdxSVGElement.InitializePen(ARenderer: TdxSVGCustomRenderer);
const
  LineCapMap: array[TdxSVGLineCapStyle] of TdxGPPenLineCapStyle = (gpcsFlat, gpcsFlat, gpcsSquare, gpcsRound);
var
  ADashes: TArray<Single>;
  AElement: TdxSVGElement;
  AFill: TdxSVGFill;
  APen: TdxSVGPen;
  APenWidth: Single;
  I: Integer;
begin
  APen := ARenderer.Pen;
  AFill := GetActualStroke(ARenderer.Palette);
  if AFill.IsReference then
  begin
    if Root.FindByID(AFill.AsReference, AElement) then
      AElement.InitializePen(ARenderer);
  end
  else
  begin
    APen.Brush.Style := gpbsSolid;
    APen.Brush.Color := ARenderer.ApplyOpacity(AFill.AsColor);
  end;

  APenWidth := GetActualStrokeSize;

  APen.Style := gppsSolid;
  APen.LineJoin := StrokeLineJoin;
  APen.LineStartCapStyle := LineCapMap[GetActualStrokeLineCap];
  APen.LineEndCapStyle := APen.LineStartCapStyle;
  APen.MiterLimit := StrokeMiterLimit;
  APen.Width := ARenderer.TransformPenWidth(APenWidth);

  ADashes := GetActualStrokeDashArray.ToArray;
  if Length(ADashes) > 0 then
  begin
    for I := Low(ADashes) to High(ADashes) do
      ADashes[I] := ADashes[I] / APenWidth;

    APen.Style := gppsDash;
    GdipCheck(GdipSetPenDashArray(APen.Handle, @ADashes[0], Length(ADashes)));
    GdipCheck(GdipSetPenDashOffset(APen.Handle, GetActualStrokeDashOffset));
  end;
end;

procedure TdxSVGElement.DrawCore(ARenderer: TdxSVGCustomRenderer);
begin
  // do nothing
end;

procedure TdxSVGElement.DrawCoreAndChildren(ARenderer: TdxSVGCustomRenderer);
var
  I: Integer;
begin
  DrawCore(ARenderer);
  for I := 0 to Count - 1 do
    Elements[I].Draw(ARenderer);
end;

function TdxSVGElement.GetX(const X: TdxSVGValue): Single;
begin
  Result := X.ToPixels(Root.Size.cx);
end;

function TdxSVGElement.GetY(const Y: TdxSVGValue): Single;
begin
  Result := Y.ToPixels(Root.Size.cy);
end;

function TdxSVGElement.GetActualFill(APalette: IdxColorPalette): TdxSVGFill;
begin
  if APalette <> nil then
    Result := TdxSVGFill.Create(APalette.GetFillColor(StyleName))
  else
    Result := TdxSVGFill.Default;

  if Result.IsDefault then
    Result := Fill;

  if Result.IsDefault then
  begin
    if Parent <> nil then
      Result := Parent.GetActualFill(APalette)
    else
      Result := TdxSVGFill.Create(TdxAlphaColors.Black);
  end;
end;

function TdxSVGElement.GetActualFillMode: TdxGPFillMode;
begin
  case FillMode of
    fmEvenOdd:
      Result := gpfmAlternate;
    fmNonZero:
      Result := gpfmWinding;
  else
    // fmInherit
    if Parent <> nil then
      Result := Parent.GetActualFillMode
    else
      Result := gpfmWinding;
  end;
end;

function TdxSVGElement.GetActualStroke(APalette: IdxColorPalette): TdxSVGFill;
begin
  if (APalette <> nil) and not Stroke.IsDefault then
    Result := TdxSVGFill.Create(APalette.GetStrokeColor(StyleName))
  else
    Result := TdxSVGFill.Default;

  if Result.IsDefault then
    Result := Stroke;

  if Result.IsDefault then
  begin
    if Parent <> nil then
      Result := Parent.GetActualStroke(APalette)
    else
      Result := TdxSVGFill.Create(TdxAlphaColors.Empty);
  end;
end;

function TdxSVGElement.GetActualStrokeDashArray: TdxSVGValues;
begin
  Result := StrokeDashArray;
  if (Result.Count = 0) and (Parent <> nil) then
    Result := Parent.GetActualStrokeDashArray;
end;

function TdxSVGElement.GetActualStrokeDashOffset: Single;
begin
  Result := StrokeDashOffset;
  if Result < 0 then
  begin
    if Parent <> nil then
      Result := Parent.GetActualStrokeDashOffset
    else
      Result := 0;
  end;
end;

function TdxSVGElement.GetActualStrokeLineCap: TdxSVGLineCapStyle;
begin
  Result := StrokeLineCap;
  if (Result = lcsDefault) and (Parent <> nil) then
    Result := Parent.GetActualStrokeLineCap;
end;

function TdxSVGElement.GetActualStrokeSize: Single;
begin
  Result := StrokeSize;
  if Result = 0 then
  begin
    if Parent <> nil then
      Result := Parent.GetActualStrokeSize
    else
      Result := 1;
  end;
end;

function TdxSVGElement.GetCount: Integer;
begin
  if FChildren <> nil then
    Result := FChildren.Count
  else
    Result := 0;
end;

function TdxSVGElement.GetElement(Index: Integer): TdxSVGElement;
begin
  if FChildren <> nil then
    Result := TdxSVGElement(FChildren[Index])
  else
    raise EInvalidArgument.CreateFmt(SListIndexError, [Index]);
end;

procedure TdxSVGElement.SetOpacity(const Value: Single);
begin
  FOpacity := EnsureRange(Value, 0, 1);
end;

{ TdxSVGElementCircle }

procedure TdxSVGElementCircle.DrawCore(ARenderer: TdxSVGCustomRenderer);
begin
  ARenderer.Ellipse(GetX(CenterX), GetY(CenterY), GetX(Radius), GetX(Radius));
end;

{ TdxSVGElementEllipse }

procedure TdxSVGElementEllipse.DrawCore(ARenderer: TdxSVGCustomRenderer);
begin
  ARenderer.Ellipse(GetX(CenterX), GetY(CenterY), GetX(RadiusX), GetY(RadiusY));
end;

{ TdxSVGElementLine }

procedure TdxSVGElementLine.DrawCore(ARenderer: TdxSVGCustomRenderer);
begin
  ARenderer.Line(GetX(X1), GetY(Y1), GetX(X2), GetY(Y2));
end;

{ TdxSVGElementPath }

constructor TdxSVGElementPath.Create;
begin
  inherited Create;
  FPath := TdxGPPath.Create;
end;

destructor TdxSVGElementPath.Destroy;
begin
  FreeAndNil(FPath);
  inherited Destroy;
end;

procedure TdxSVGElementPath.DrawCore(ARenderer: TdxSVGCustomRenderer);
begin
  Path.FillMode := GetActualFillMode;
  ARenderer.Path(Path);
end;

{ TdxSVGElementPolygon }

constructor TdxSVGElementPolygon.Create;
begin
  inherited Create;
  FPoints := TdxSVGPoints.Create;
end;

destructor TdxSVGElementPolygon.Destroy;
begin
  FreeAndNil(FPoints);
  inherited Destroy;
end;

procedure TdxSVGElementPolygon.DrawCore(ARenderer: TdxSVGCustomRenderer);
begin
  ARenderer.Polygon(Points.ToArray);
end;

{ TdxSVGElementPolyline }

procedure TdxSVGElementPolyline.DrawCore(ARenderer: TdxSVGCustomRenderer);
begin
  ARenderer.Polyline(Points.ToArray);
end;

{ TdxSVGElementRectangle }

procedure TdxSVGElementRectangle.DrawCore(ARenderer: TdxSVGCustomRenderer);
begin
  if CornerRadiusX.IsEmpty and CornerRadiusY.IsEmpty then
    ARenderer.Rectangle(GetX(X), GetY(Y), GetX(Width), GetY(Height))
  else
    ARenderer.RoundRect(GetX(X), GetY(Y), GetX(Width), GetY(Height), GetX(CornerRadiusX), GetY(CornerRadiusY));
end;

{ TdxSVGElementText }

constructor TdxSVGElementText.Create;
begin
  inherited;
  FFontName := string(DefFontData.Name);
  FFontSize := 8;
end;

procedure TdxSVGElementText.DrawCore(ARenderer: TdxSVGCustomRenderer);
var
  AFont: TdxGPFont;
  AOffset: Single;
  APoint: TdxPointF;
  ATextSize: TdxSizeF;
begin
  if TryCreateFont(AFont) then
  try
    ATextSize := dxGpMeasureString(AFont, Text);
    AOffset := AFont.Size / AFont.FontFamily.GetEmHeight(AFont.Style) * AFont.FontFamily.GetCellAscent(AFont.Style);
    APoint := dxPointF(GetX(X), GetY(Y) - AOffset);
    case TextAnchor of
      taMiddle:
        APoint.X := APoint.X - ATextSize.cx / 2;
      taEnd:
        APoint.X := APoint.X - ATextSize.cx;
    end;
    ARenderer.TextOut(APoint.X + GetX(dX), APoint.Y + GetY(dY), Text, AFont);
  finally
    AFont.Free;
  end;
end;

function TdxSVGElementText.TryCreateFont(out AFont: TdxGpFont): Boolean;

  function DoTryCreateFont(const AFontName: string; out AFont: TdxGpFont): Boolean;
  begin
    try
      AFont := TdxGPFont.Create(AFontName, FontSize, TdxGPFontStyle(dxFontStylesToGpFontStyles(FontStyles)), guPixel);
      Result := True;
    except
      Result := False;
    end;
  end;

  function StripFontName(const S: string): string;
  var
    I, J: Integer;
  begin
    J := Length(S);
    if J = 0 then
      Exit('');

    I := 1;
    if dxCharInSet(S[I], ['''', '"']) then
      Inc(I);
    if dxCharInSet(S[J], ['''', '"']) then
      Dec(J);
    Result := Trim(Copy(S, I, J - I + 1));
  end;

var
  AFontName: string;
  APos: Integer;
begin
  AFontName := StripFontName(FontName);
  Result := DoTryCreateFont(AFontName, AFont);
  if not Result then
  repeat
    APos := LastDelimiter('-', AFontName);
    if APos > 0 then
    begin
      AFontName := Copy(AFontName, 1, APos - 1);
      Result := DoTryCreateFont(AFontName, AFont);
    end;
  until (APos = 0) or Result;
end;

function TdxSVGElementText.GetFontAsStyleString: string;
begin
  Result := TdxSVGFontStyleString.Build(FontName, FontSize, FontStyles);
end;

procedure TdxSVGElementText.SetFontAsStyleString(const AValue: string);
var
  AName: string;
  ASize: Single;
  AStyles: TFontStyles;
begin
  if TdxSVGFontStyleString.Parse(AValue, AName, ASize, AStyles) then
  begin
    FFontName := AName;
    FFontSize := ASize;
    FFontStyles := AStyles;
  end;
end;

{ TdxSVGElementRoot }

constructor TdxSVGElementRoot.Create;
begin
  inherited Create;
  FViewBox := TdxSVGRect.Create;
  FBackground := TdxSVGRect.Create;
end;

destructor TdxSVGElementRoot.Destroy;
begin
  FreeAndNil(FBackground);
  FreeAndNil(FViewBox);
  inherited Destroy;
end;

function TdxSVGElementRoot.GetRoot: TdxSVGElementRoot;
begin
  Result := Self;
end;

function TdxSVGElementRoot.GetSize: TdxSizeF;
begin
  Result := ViewBox.Value.Size;
  if not Width.IsEmpty and (Width.UnitsType <> utPercents) then
    Result.cx := Width.ToPixels;
  if not Height.IsEmpty and (Height.UnitsType <> utPercents) then
    Result.cy := Height.ToPixels;
end;

{ TdxSVGElementUse }

procedure TdxSVGElementUse.DrawCore(ARenderer: TdxSVGCustomRenderer);
var
  AElement: TdxSVGElement;
  APrevParent: TdxSVGElement;
begin
  if Root.FindByID(Reference, AElement) then
  begin
    ARenderer.SaveWorldTransform;
    try
      ARenderer.ModifyWorldTransform(TXForm.CreateTranslateMatrix(GetX(X), GetY(Y)));

      APrevParent := AElement.FParent;
      AElement.FParent := Self;
      AElement.Draw(ARenderer);
      AElement.FParent := APrevParent;
    finally
      ARenderer.RestoreWorldTransform;
    end;
  end;
end;

{ TdxSVGElementNeverRendered }

procedure TdxSVGElementNeverRendered.Draw(ARenderer: TdxSVGCustomRenderer);
begin
  // do nothing
end;

{ TdxSVGElementClipPath }

procedure TdxSVGElementClipPath.ApplyTo(ARenderer: TdxSVGCustomRenderer; AElement: TdxSVGElement);
var
  ABuilder: TdxSVGRendererClipPath;
begin
  ABuilder := TdxSVGRendererClipPath.Create;
  try
    DrawCoreAndChildren(ABuilder);
    ARenderer.SetClipRegion(ABuilder.ClipPath);
  finally
    ABuilder.Free;
  end;
end;

{ TdxSVGElementLinearGradientStop }

procedure TdxSVGElementLinearGradientStop.AfterConstruction;
begin
  inherited;
  FColorOpacity := 1.0;
end;

{ TdxSVGElementLinearGradient }

procedure TdxSVGElementLinearGradient.AfterConstruction;
begin
  inherited;
  FX2 := TdxSVGValue.Create(1, utPx);
  FUnitsType := cuObjectBoundingBox;
end;

procedure TdxSVGElementLinearGradient.InitializeBrush(ARenderer: TdxSVGCustomRenderer);
begin
  InitializeBrushCore(ARenderer, ARenderer.Brush);
end;

procedure TdxSVGElementLinearGradient.InitializeBrushCore(ARenderer: TdxSVGCustomRenderer; ABrush: TdxSVGBrush);
var
  AFinishOffset: Single;
  AInvertOrder: Boolean;
  APatternRect: TdxRectF;
  AStartOffset: Single;
  I: Integer;
begin
  ABrush.FreeHandle;

  APatternRect := dxRectF(GetX(X1), GetY(Y1), GetX(X2), GetY(Y2));
  ABrush.GradientAutoScale := UnitsType <> cuUserSpaceOnUse;
  ABrush.GradientLine := CalculateGradientLine(APatternRect);

  CalculateGradinentOffsets(APatternRect, ABrush.GradientLine, AStartOffset, AFinishOffset, AInvertOrder);
  PopulateGradientPoints(ABrush.GradientPoints, AStartOffset, AFinishOffset, False);
  for I := 0 to ABrush.GradientPoints.Count - 1 do
    ABrush.GradientPoints.Colors[I] := ARenderer.ApplyOpacity(ABrush.GradientPoints.Colors[I]);

  ABrush.Style := gpbsGradient;
  ABrush.HandleNeeded;
end;

procedure TdxSVGElementLinearGradient.InitializePen(ARenderer: TdxSVGCustomRenderer);
begin
  InitializeBrushCore(ARenderer, ARenderer.Pen.Brush);
end;

function TdxSVGElementLinearGradient.CalculateGradientLine(const APatternRect: TdxRectF): TdxRectF;

  procedure AdjustPoint(var X, Y: Single; const ACanvasRect: TdxRectF; ADeltaX, ADeltaY: Single);
  var
    ACount: Single;
  begin
    ACount := 0;
    if ADeltaX < 0 then
      ACount := Max(ACount, (ACanvasRect.Left - X) / ADeltaX);
    if ADeltaX > 0 then
      ACount := Max(ACount, (ACanvasRect.Right - X) / ADeltaX);
    if ADeltaY < 0 then
      ACount := Max(ACount, (ACanvasRect.Top - Y) / ADeltaY);
    if ADeltaY > 0 then
      ACount := Max(ACount, (ACanvasRect.Bottom - Y) / ADeltaY);
    X := X + ACount * ADeltaX;
    Y := Y + ACount * ADeltaY;
  end;

var
  ACanvasRect: TdxRectF;
  ADeltaX: Single;
  ADeltaY: Single;
  ALength: Single;
begin
  if UnitsType = cuUserSpaceOnUse then
  begin
    ACanvasRect := cxRectSetSizeF(Root.ViewBox.Value, Root.Size);

    ALength := Sqrt(Sqr(APatternRect.Width) + Sqr(APatternRect.Height));
    ADeltaX := APatternRect.Width / ALength;
    ADeltaY := APatternRect.Height / ALength;

    Result := APatternRect;
    AdjustPoint(Result.Left, Result.Top, ACanvasRect, -ADeltaX, -ADeltaY);
    AdjustPoint(Result.Right, Result.Bottom, ACanvasRect, ADeltaX, ADeltaY);
  end
  else
    Result := APatternRect;
end;

procedure TdxSVGElementLinearGradient.CalculateGradinentOffsets(
  const APatternRect, AGradientLine: TdxRectF; out AStartOffset, AFinishOffset: Single; out AInvertOrder: Boolean);

  function CalculatePosition(X, Y: Single): Single;
  begin
    Result := Sqrt(Sqr(X) + Sqr(Y));
  end;

var
  ALength: Single;
begin
  ALength := CalculatePosition(AGradientLine.Width, AGradientLine.Height);
  AFinishOffset := CalculatePosition(APatternRect.Right - AGradientLine.Left, APatternRect.Bottom - AGradientLine.Top) / ALength;
  AStartOffset := CalculatePosition(APatternRect.Left - AGradientLine.Left, APatternRect.Top - AGradientLine.Top) / ALength;
  AInvertOrder := False;
end;

procedure TdxSVGElementLinearGradient.PopulateGradientPoints(
  APoints: TdxGPBrushGradientPoints; AStartOffset, AFinishOffset: Single; AInvertOrder: Boolean);

  function GetActualColor(AElement: TdxSVGElementLinearGradientStop): TdxAlphaColor;
  begin
    Result := dxGpApplyOpacity(AElement.Color, AElement.ColorOpacity);
  end;

  function GetActualOffset(AElement: TdxSVGElementLinearGradientStop): Single;
  begin
    Result := AElement.Offset.ToPixels(1.0);
    if AInvertOrder then
      Result := 1 - Result;
    Result := AStartOffset + Result * (AFinishOffset - AStartOffset);
  end;

var
  AElement: TdxSVGElementLinearGradientStop;
  I: Integer;
begin
  APoints.Clear;
  if Count > 0 then
  begin
    AStartOffset := EnsureRange(AStartOffset, 0, 1);
    AFinishOffset := Max(EnsureRange(AFinishOffset, 0, 1), AStartOffset);

    AElement := Elements[IfThen(AInvertOrder, Count - 1)];
    if GetActualOffset(AElement) > 0 then
      APoints.Add(0, GetActualColor(AElement));

    for I := 0 to Count - 1 do
    begin
      AElement := Elements[I];
      APoints.Add(GetActualOffset(AElement), GetActualColor(AElement));
    end;

    AElement := Elements[IfThen(AInvertOrder, 0, Count - 1)];
    if GetActualOffset(AElement) < 1 then
      APoints.Add(1, GetActualColor(AElement));
  end;
end;

function TdxSVGElementLinearGradient.GetElement(Index: Integer): TdxSVGElementLinearGradientStop;
begin
  Result := inherited Elements[Index] as TdxSVGElementLinearGradientStop;
end;

{ TdxSVGStyle }

constructor TdxSVGStyle.Create(const AName: string);
begin
  inherited Create(nil);
  FName := AName;
end;

procedure TdxSVGStyle.Apply(AElement: TdxSVGElement);
begin
  TdxSVGLoader.ApplyAttributes(AElement, Self);
end;

{ TdxSVGStyles }

constructor TdxSVGStyles.Create;
begin
  inherited Create;
  FItems := TObjectDictionary<string, TdxSVGStyle>.Create([doOwnsValues]);
end;

destructor TdxSVGStyles.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

function TdxSVGStyles.Add(const AName: string): TdxSVGStyle;
begin
  Result := TdxSVGStyle.Create(AName);
  try
    FItems.Add(AName, Result);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

function TdxSVGStyles.AddInline(const AReference: TObject): TdxSVGStyle;
begin
  Result := Add(Format(sInline, [Pointer(AReference)]));
end;

procedure TdxSVGStyles.Apply(AElement: TdxSVGElement);
var
  AStyle: TdxSVGStyle;
  AStyles: TStringDynArray;
  I: Integer;
begin
  AStyles := SplitString(AElement.StyleName, ' ');
  for I := 0 to Length(AStyles) - 1 do
  begin
    if TryGetStyle(AStyles[I], AStyle) then
      AStyle.Apply(AElement);
  end;
  if TryGetStyle(Format(sInline, [Pointer(AElement)]), AStyle) then
    AStyle.Apply(AElement);
  for I := 0 to AElement.Count - 1 do
    Apply(AElement[I]);
end;

function TdxSVGStyles.TryGetStyle(const AName: string; out AStyle: TdxSVGStyle): Boolean;
begin
  Result := (AName <> '') and FItems.TryGetValue(AName, AStyle);
end;

function TdxSVGStyles.GetItem(const Name: string): TdxSVGStyle;
begin
  Result := FItems.Items[Name]
end;

{ TdxSVGLoader }

class procedure TdxSVGLoader.ApplyAttribute(AObject: TObject; ARttiType: TRttiType; AAttribute: TdxXMLNodeAttribute);

  function FindProperty(AType: TRttiType; out AProperty: TRttiProperty; out ALoader: TdxSVGAdapterValueClass): Boolean;
  var
    A: TCustomAttribute;
    P: TRttiProperty;
  begin
    Result := False;
    while AType <> nil do
    begin
      for P in AType.GetDeclaredProperties do
        for A in P.GetAttributes do
          if (A is SVGAlias) and (SVGAlias(A).Name = AAttribute.Name) then
          begin
            ALoader := SVGAlias(A).Adapter;
            AProperty := P;
            Exit(True);
          end;

      AType := AType.BaseType;
    end;
  end;

var
  ALoader: TdxSVGAdapterValueClass;
  AProperty: TRttiProperty;
begin
  if FindProperty(ARttiType, AProperty, ALoader) then
  begin
    if ALoader <> nil then
      ALoader.Load(AObject, AProperty, AAttribute.ValueAsString)
    else
      case (AProperty as TRttiInstanceProperty).PropInfo.PropType^.Kind of
        tkInteger:
          AProperty.SetValue(AObject, TValue.From<Integer>(AAttribute.ValueAsInteger));
        tkInt64:
          AProperty.SetValue(AObject, TValue.From<Int64>(AAttribute.ValueAsInt64));
        tkFloat:
          AProperty.SetValue(AObject, TValue.From<Single>(AAttribute.ValueAsFloat));
        tkString, tkUString, tkWString, tkLString:
          AProperty.SetValue(AObject, TValue.From<string>(AAttribute.ValueAsString));
      end;
  end;
end;

class procedure TdxSVGLoader.ApplyAttribute(AObject: TObject; AAttribute: TdxXMLNodeAttribute);
var
  AContext: TRttiContext;
  ARttiType: TRttiType;
begin
  AContext := TRttiContext.Create;
  try
    ARttiType := AContext.GetType(AObject.ClassInfo);
    if ARttiType <> nil then
      ApplyAttribute(AObject, ARttiType, AAttribute);
  finally
    AContext.Free;
  end;
end;

class procedure TdxSVGLoader.ApplyAttributes(AObject: TObject; AAttributes: TdxXMLNodeAttributes);
var
  AAttribute: TdxXMLNodeAttribute;
  AContext: TRttiContext;
  ARttiType: TRttiType;
begin
  AContext := TRttiContext.Create;
  try
    ARttiType := AContext.GetType(AObject.ClassInfo);
    if ARttiType <> nil then
    begin
      AAttribute := AAttributes.First;
      while AAttribute <> nil do
      begin
        ApplyAttribute(AObject, ARttiType, AAttribute);
        AAttribute := TdxXMLNodeAttribute(AAttribute.Next);
      end;
    end;
  finally
    AContext.Free;
  end;
end;

class procedure TdxSVGLoader.Load(AParent: TdxSVGElement; ADocument: TdxXMLDocument);
var
  ANode: TdxXMLNode;
  AStyles: TdxSVGStyles;
begin
  if ADocument.FindChild('svg', ANode) then
  begin
    AStyles := TdxSVGStyles.Create;
    try
      LoadCore(AParent, AStyles, ANode);
      AStyles.Apply(AParent);
    finally
      AStyles.Free;
    end;
  end;
end;

class procedure TdxSVGLoader.LoadCore(AParent: TdxSVGElement; AStyles: TdxSVGStyles; ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
  AElement: TdxSVGElement;
  AElementClass: TdxSVGElementClass;
begin
  if ANode.Name = StyleAttrName then
    LoadStyles(AStyles, ANode)
  else
    if FElementMap.TryGetValue(ANode.Name, AElementClass) then
    begin
      AElement := AElementClass.Create;
      AElement.StyleName := ANode.NameAsString;

      ApplyAttributes(AElement, ANode.Attributes);
      if ANode.Text <> '' then
      begin
        AAttr := TdxXMLNodeAttribute.Create;
        try
          AAttr.Name := '_nodeText';
          AAttr.Value := ANode.Text;
          ApplyAttribute(AElement, AAttr);
        finally
          AAttr.Free;
        end;
      end;

      if ANode.Attributes.Find(StyleAttrName, AAttr) then
        TdxSVGParserInlineStyle.Parse(AStyles.AddInline(AElement), AAttr.ValueAsString);

      AParent.Add(AElement);
      ANode.ForEach(
        procedure (ANode: TdxXMLNode; AUserData: Pointer)
        begin
          LoadCore(AElement, AStyles, ANode);
        end);
    end
end;

class procedure TdxSVGLoader.LoadStyles(AStyles: TdxSVGStyles; ANode: TdxXMLNode);
var
  AStyleName: string;
  AStyleParts: TStringDynArray;
  AStylesArray: TStringDynArray;
  I: Integer;
begin
  AStylesArray := SplitString(ANode.TextAsString, '}');
  for I := 0 to Length(AStylesArray) - 1 do
    if Pos('{', AStylesArray[I]) > 0 then
    begin
      AStyleParts := SplitString(Trim(AStylesArray[I]), '{');
      if Length(AStyleParts) = 2 then
      begin
        AStyleName := Trim(AStyleParts[0]);
        if (AStyleName <> '') and (AStyleName[1] = '.') then
          Delete(AStyleName, 1, 1);
        if AStyleName <> '' then
          TdxSVGParserInlineStyle.Parse(AStyles.Add(AStyleName), AStyleParts[1]);
      end;
    end;
end;

class procedure TdxSVGLoader.Initialize;
begin
  FElementMap := TDictionary<TdxXMLString, TdxSVGElementClass>.Create;
  FElementMap.Add('circle', TdxSVGElementCircle);
  FElementMap.Add('clipPath', TdxSVGElementClipPath);
  FElementMap.Add('defs', TdxSVGElementNeverRendered);
  FElementMap.Add('ellipse', TdxSVGElementEllipse);
  FElementMap.Add('g', TdxSVGElementGroup);
  FElementMap.Add('line', TdxSVGElementLine);
  FElementMap.Add('linearGradient', TdxSVGElementLinearGradient);
  FElementMap.Add('path', TdxSVGElementPath);
  FElementMap.Add('polygon', TdxSVGElementPolygon);
  FElementMap.Add('polyline', TdxSVGElementPolyline);
  FElementMap.Add('rect', TdxSVGElementRectangle);
  FElementMap.Add('stop', TdxSVGElementLinearGradientStop);
  FElementMap.Add('svg', TdxSVGElementRoot);
  FElementMap.Add('text', TdxSVGElementText);
  FElementMap.Add('use', TdxSVGElementUse);
end;

class procedure TdxSVGLoader.Finalize;
begin
  FreeAndNil(FElementMap);
end;

initialization
  TdxSVGLoader.Initialize;

finalization
  TdxSVGLoader.Finalize;
end.
