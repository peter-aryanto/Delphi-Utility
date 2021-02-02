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

unit dxSVGImage;

{$I cxVer.inc}

interface

uses
  Types, Windows, Classes, Graphics, dxCore, cxGeometry, dxCoreGraphics, ZLib,
  dxXMLDoc, dxGDIPlusClasses, dxGDIPlusAPI, dxSmartImage, dxSVGCore;

type

  { TdxSVGImageHandle }

  TdxSVGImageHandle = class(TdxSmartImageCustomHandle,
    IdxImageDataFormatEx,
    IdxVectorImage)
  strict private const
    RasterizedImageMaxBufferSize = 2048;
    RasterizedImageMinScaleFactor = 1;
    RasterizedImageMaxScaleFactor = 32;
    PixelOffsetMode = PixelOffsetModeHalf;
  strict private
    FCachedImage: TdxGPImageHandle;
    FCachedImagePaletteID: TGUID;
    FElements: TdxSVGElement;
    FInterpolationMode: TdxGPInterpolationMode;
    FSmoothingMode: TdxGPSmoothingMode;
    FSourceData: TdxGPMemoryStream;

    function GetInterpolationMode: TdxGPInterpolationMode;
    function GetPaletteID(APalette: IdxColorPalette): TGUID;
    function GetSmoothingMode: TdxGPSmoothingMode;
    function GetViewBox: TdxRectF; inline;
  protected
    FRoot: TdxSVGElementRoot;

    procedure DrawCore(ACanvas: TdxGPCanvas; const R: TdxRectF; APalette: IdxColorPalette); overload;
    procedure DrawCore(ATarget: TdxGPImageHandle; APalette: IdxColorPalette); overload;
    procedure FlushCache;
    function GetSize: TSize; override;
    // IdxImageDataFormatEx
    function GetImageFormat: TdxSmartImageCodecClass;
    //
    property Elements: TdxSVGElement read FElements;
    property SourceData: TdxGPMemoryStream read FSourceData;
    property ViewBox: TdxRectF read GetViewBox;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Draw(DC: HDC; const ADest, ASource: TdxRectF; AAlpha: Byte = 255; APalette: IdxColorPalette = nil); override;
    procedure Draw(DC: HDC; const ADest, ASource: TRect; AAlpha: Byte = 255; APalette: IdxColorPalette = nil); override;
    function GetAlphaState: TdxAlphaState; override;
    function GetAsBitmap: TBitmap; override;
    function GetRasterizedImage(ASize: TSize; APalette: IdxColorPalette): TdxGPImageHandle;
    //
    property InterpolationMode: TdxGPInterpolationMode read GetInterpolationMode write FInterpolationMode;
    property SmoothingMode: TdxGPSmoothingMode read GetSmoothingMode write FSmoothingMode;
  end;

  { TdxSVGImage }

  TdxSVGImage = class(TdxCustomSmartImage)
  public
    procedure SaveToStream(Stream: TStream); override;
  end;

  { TdxSVGImageCodec }

  TdxSVGImageCodec = class(TdxSmartImageCodec)
  public
    class function CanLoadStream(AStream: TStream): Boolean; override;
    class function CanSaveImage(AHandle: TdxSmartImageCustomHandle): Boolean; override;
    class function Ext: string; override;
    class function GetSize(AStream: TStream; out ASize: TSize): Boolean; override;
    class function Load(AStream: TStream; out AHandle: TdxSmartImageCustomHandle): Boolean; overload; override;
    class function Load(const ADocument: TdxXMLDocument; out AHandle: TdxSmartImageCustomHandle): Boolean; overload;
    class function Load(const AFileName: string; out AHandle: TdxSmartImageCustomHandle): Boolean; overload;
    class function Save(AStream: TStream; AHandle: TdxSmartImageCustomHandle): Boolean; override;
  end;

implementation

uses
  SysUtils, Math, cxGraphics;

{ TdxSVGImageHandle }

constructor TdxSVGImageHandle.Create;
begin
  inherited Create;
  FElements := TdxSVGElement.Create;
  FSourceData := TdxGPMemoryStream.Create;
end;

destructor TdxSVGImageHandle.Destroy;
begin
  FlushCache;
  FreeAndNil(FSourceData);
  FreeAndNil(FElements);
  inherited Destroy;
end;

procedure TdxSVGImageHandle.Draw(DC: HDC; const ADest, ASource: TdxRectF; AAlpha: Byte; APalette: IdxColorPalette);
var
  ADestRect: TRect;
  AImage: TdxGPImageHandle;
begin
  if not Empty then
  begin
    ADestRect := cxRect(ADest, False);
    dxGPPaintCanvas.BeginPaint(DC, ADestRect);
    try
      AImage := GetRasterizedImage(cxSize(ADestRect), APalette);
      dxGPPaintCanvas.InterpolationMode := InterpolationMode;
      dxGPPaintCanvas.PixelOffsetMode := PixelOffsetMode;
      dxGpDrawImage(dxGPPaintCanvas.Handle, ADest, cxRectScale(ASource, AImage.Width / Width), AImage.Handle, AAlpha);
    finally
      dxGPPaintCanvas.EndPaint;
    end;
  end;
end;

procedure TdxSVGImageHandle.Draw(DC: HDC; const ADest, ASource: TRect; AAlpha: Byte; APalette: IdxColorPalette);
begin
  Draw(DC, dxRectF(ADest), dxRectF(ASource), AAlpha, APalette);
end;

function TdxSVGImageHandle.GetAsBitmap: TBitmap;
begin
  Result := TcxBitmap32.CreateSize(Width, Height, True);
  Draw(Result.Canvas.Handle, TcxBitmap32(Result).ClientRect, ClientRect);
end;

function TdxSVGImageHandle.GetAlphaState: TdxAlphaState;
begin
  Result := asSemitransparent;
end;

procedure TdxSVGImageHandle.DrawCore(ACanvas: TdxGPCanvas; const R: TdxRectF; APalette: IdxColorPalette);
var
  ARender: TdxSVGRenderer;
begin
  ACanvas.SmoothingMode := SmoothingMode;
  ACanvas.TranslateWorldTransform(R.Left, R.Top);
  ACanvas.ScaleWorldTransform(R.Width / ViewBox.Width, R.Height / ViewBox.Height);
  ACanvas.TranslateWorldTransform(-ViewBox.Left, -ViewBox.Top);

  ARender := TdxSVGRenderer.Create(ACanvas, APalette);
  try
    FRoot.Draw(ARender);
  finally
    ARender.Free;
  end;
end;

procedure TdxSVGImageHandle.DrawCore(ATarget: TdxGPImageHandle; APalette: IdxColorPalette);
var
  ACanvas: TdxGPCanvas;
begin
  ACanvas := ATarget.CreateCanvas;
  try
    DrawCore(ACanvas, dxRectF(ATarget.ClientRect), APalette);
  finally
    ACanvas.Free;
  end;
end;

procedure TdxSVGImageHandle.FlushCache;
begin
  FreeAndNil(FCachedImage);
end;

function TdxSVGImageHandle.GetSize: TSize;
begin
  if FRoot <> nil then
    Result := cxSize(FRoot.Size, False)
  else
    Result := cxNullSize;
end;

function TdxSVGImageHandle.GetImageFormat: TdxSmartImageCodecClass;
begin
  Result := TdxSVGImageCodec;
end;

function TdxSVGImageHandle.GetSmoothingMode: TdxGPSmoothingMode;
begin
  if FSmoothingMode <> smDefault then
    Result := FSmoothingMode
  else
    Result := smNone;
end;

function TdxSVGImageHandle.GetRasterizedImage(ASize: TSize; APalette: IdxColorPalette): TdxGPImageHandle;
var
  AScaleFactor: Single;
begin
  ASize := cxSize(cxGetImageRect(cxRect(ASize), cxSize(ViewBox.Size, False), ifmFill));
  if not IsEqualGUID(FCachedImagePaletteID, GetPaletteID(APalette)) then
    FlushCache;
  if (FCachedImage <> nil) and ((FCachedImage.Width <> ASize.cx) or (FCachedImage.Height <> ASize.cy)) then
    FlushCache;
  if FCachedImage = nil then
  begin
    AScaleFactor := Min(RasterizedImageMaxBufferSize / ViewBox.Width, RasterizedImageMaxBufferSize / ViewBox.Height);
    AScaleFactor := Max(Min(AScaleFactor, RasterizedImageMaxScaleFactor), RasterizedImageMinScaleFactor);
    FCachedImage := TdxGPImageHandle.Create(nil);
    FCachedImage.Size := cxSizeScale(cxSize(ViewBox.Size), AScaleFactor);
    FCachedImagePaletteID := GetPaletteID(APalette);
    DrawCore(FCachedImage, APalette);
    FCachedImage.Resize(ASize, InterpolationMode, PixelOffsetMode);
  end;
  Result := FCachedImage;
end;

function TdxSVGImageHandle.GetInterpolationMode: TdxGPInterpolationMode;
begin
  if FInterpolationMode <> imDefault then
    Result := FInterpolationMode
  else
    if IsWinSevenOrLater then
      Result := imBilinear
    else
      Result := imHighQualityBilinear;
end;

function TdxSVGImageHandle.GetPaletteID(APalette: IdxColorPalette): TGUID;
begin
  if APalette <> nil then
    Result := APalette.GetID
  else
    FillChar(Result, SizeOf(Result), 0);
end;

function TdxSVGImageHandle.GetViewBox: TdxRectF;
begin
  Result := FRoot.ViewBox.Value;
  if IsZero(Result.Height) then
    Result.Height := FRoot.Height.ToPixels;
  if IsZero(Result.Width) then
    Result.Width := FRoot.Width.ToPixels;
end;

{ TdxSVGImage }

procedure TdxSVGImage.SaveToStream(Stream: TStream);
begin
  SaveToStreamByCodec(Stream, TdxSVGImageCodec);
end;

{ TdxSVGImageCodec }

class function TdxSVGImageCodec.CanLoadStream(AStream: TStream): Boolean;
var
  ASize: TSize;
begin
  Result := GetSize(AStream, ASize);
end;

class function TdxSVGImageCodec.CanSaveImage(AHandle: TdxSmartImageCustomHandle): Boolean;
begin
  Result := AHandle is TdxSVGImageHandle;
end;

class function TdxSVGImageCodec.Ext: string;
begin
  Result := '.svg';
end;

class function TdxSVGImageCodec.GetSize(AStream: TStream; out ASize: TSize): Boolean;
var
  ADocument: TdxXMLDocument;
  AElements: TdxSVGElement;
begin
  Result := False;
  try
    ADocument := TdxXMLDocument.Create(nil);
    try
      ADocument.LoadFromStream(AStream);
      if ADocument.Root.Count > 0 then
      begin
        AElements := TdxSVGElement.Create;
        try
          TdxSVGLoader.Load(AElements, ADocument);
          Result := (AElements.Count > 0) and (AElements[0] is TdxSVGElementRoot);
          if Result then
            ASize := cxSize(TdxSVGElementRoot(AElements[0]).Size, False);
        finally
          AElements.Free;
        end;
      end;
    finally
      ADocument.Free;
    end;
  except
    Result := False;
  end;
end;

class function TdxSVGImageCodec.Load(AStream: TStream; out AHandle: TdxSmartImageCustomHandle): Boolean;
var
  ADocument: TdxXMLDocument;
begin
  ADocument := TdxXMLDocument.Create(nil);
  try
    ADocument.LoadFromStream(AStream);
    Result := Load(ADocument, AHandle);
  finally
    ADocument.Free;
  end;
end;

class function TdxSVGImageCodec.Load(const ADocument: TdxXMLDocument; out AHandle: TdxSmartImageCustomHandle): Boolean;
var
  AImageHandle: TdxSVGImageHandle absolute AHandle;
  AStream: TStream;
begin
  AImageHandle := TdxSVGImageHandle.Create;
  try
    TdxSVGLoader.Load(AImageHandle.Elements, ADocument);
    if AImageHandle.Elements.Count > 0 then
    begin
      AImageHandle.FRoot := AImageHandle.Elements[0] as TdxSVGElementRoot;

      AStream := TMemoryStream.Create;
      try
        ADocument.AutoIndent := True;
        ADocument.SaveToStream(AStream);
        AStream.Position := 0;
        ZCompressStream(AStream, AImageHandle.SourceData, zcMax);
      finally
        AStream.Free;
      end;
    end
    else
      FreeAndNil(AImageHandle);
  except
    FreeAndNil(AImageHandle);
  end;
  Result := AImageHandle <> nil;
end;

class function TdxSVGImageCodec.Load(const AFileName: string; out AHandle: TdxSmartImageCustomHandle): Boolean;
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    Result := Load(AStream, AHandle);
  finally
    AStream.Free;
  end;
end;

class function TdxSVGImageCodec.Save(AStream: TStream; AHandle: TdxSmartImageCustomHandle): Boolean;
var
  AImageHandle: TdxSVGImageHandle;
begin
  Result := AHandle is TdxSVGImageHandle;
  if Result then
  begin
    AImageHandle := TdxSVGImageHandle(AHandle);
    if AImageHandle.SourceData.Size > 0 then
    begin
      AImageHandle.SourceData.Position := 0;
      ZDecompressStream(AImageHandle.SourceData, AStream);
    end;
  end;
end;

//-----------------------

procedure RegisterAssistants;
begin
  if CheckGdiPlus then
  begin
    TdxSmartImageCodecsRepository.Register(TdxSVGImageCodec);
    TPicture.RegisterFileFormat('', '', TdxSVGImage); 
  {$IFDEF DXREGISTERPNGIMAGE}
    TPicture.RegisterFileFormat('svg', TdxSVGImageCodec.Description, TdxSmartImage);
  {$ENDIF}
  end;
end;

procedure UnregisterAssistants;
begin
  TPicture.UnregisterGraphicClass(TdxSVGImage);
  TdxSmartImageCodecsRepository.Unregister(TdxSVGImageCodec);
end;

initialization
  dxUnitsLoader.AddUnit(@RegisterAssistants, @UnregisterAssistants);

finalization
  dxUnitsLoader.RemoveUnit(@UnregisterAssistants);
end.
