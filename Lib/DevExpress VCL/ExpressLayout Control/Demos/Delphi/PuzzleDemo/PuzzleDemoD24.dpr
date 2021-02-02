program PuzzleDemoD24;

uses
  Forms,
  Puzzle in 'Puzzle.pas' {frmPuzzle};

  {$R *.res}
  {$R WindowsXP.res}


begin
  Application.Initialize;
  Application.Title := 'PuzzleDemoD24';
  Application.CreateForm(TfrmPuzzle, frmPuzzle);
  Application.Run;
end.
