unit dxSkinTheBezier;

  {$I cxVer.inc}

interface

uses
  Classes, dxCore, dxCoreGraphics, dxGDIPlusApi, cxLookAndFeelPainters, dxSkinsCore, dxSkinsLookAndFeelPainter;

type

  { TdxSkinTheBezierPainter }

  TdxSkinTheBezierPainter = class(TdxSkinLookAndFeelPainter)
  public
    function LookAndFeelName: string; override;
  end;

implementation

{$R dxSkinTheBezier.res}

const
  SkinsCount = 1;
  SkinNames: array[0..SkinsCount - 1] of string = (
    'TheBezier'
  );
  SkinPainters: array[0..SkinsCount - 1] of TdxSkinLookAndFeelPainterClass = (
    TdxSkinTheBezierPainter
  );


{ TdxSkinTheBezierPainter }

function TdxSkinTheBezierPainter.LookAndFeelName: string;
begin
  Result := 'TheBezier';
end;

//

procedure RegisterPainters;
var
  I: Integer;
begin
  if CheckGdiPlus then
  begin
    for I := 0 to SkinsCount - 1 do
      cxLookAndFeelPaintersManager.Register(SkinPainters[I].Create(SkinNames[I], HInstance));
  end;
end;

procedure UnregisterPainters;
var
  I: Integer;
begin
  if cxLookAndFeelPaintersManager <> nil then
  begin
    for I := 0 to SkinsCount - 1 do
      cxLookAndFeelPaintersManager.Unregister(SkinNames[I]);
  end;
end;

{$IFNDEF DXSKINDYNAMICLOADING}
initialization
  dxUnitsLoader.AddUnit(@RegisterPainters, @UnregisterPainters);
finalization
  dxUnitsLoader.RemoveUnit(@UnregisterPainters);
{$ENDIF}
end.
