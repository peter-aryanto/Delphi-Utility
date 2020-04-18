unit VclUtil;

interface

uses
  Vcl.Graphics
  ;

function CalculateTextAreaHeight(
  const AText: string;
  const AWidth: Integer;
  const ACanvas: TCanvas;
  const ASingleLineTextMinHeight: Integer = 0;
  const AFont: TFont = nil // Sometimes, canvas font has not been correctly set/assigned.
): Integer;

implementation

uses
  System.Types
  ;

function CalculateTextAreaHeight(
  const AText: string;
  const AWidth: Integer;
  const ACanvas: TCanvas;
  const ASingleLineTextMinHeight: Integer = 0;
  const AFont: TFont = nil
): Integer;
var
  LCalculatedTextArea: TRect;
  _Text: string;
begin
  if AText = '' then
  begin
    Result := 0;
    Exit;
  end;

  Result := ASingleLineTextMinHeight;

  LCalculatedTextArea := Default(TRect);
  LCalculatedTextArea.Right := AWidth;

  _Text := AText;

  if Assigned(AFont) then ACanvas.Font := AFont;

  ACanvas.TextRect(LCalculatedTextArea, _Text, [tfCalcRect, tfWordBreak]);

  if LCalculatedTextArea.Height > Result then
    Result := LCalculatedTextArea.Height;
end;

end.
