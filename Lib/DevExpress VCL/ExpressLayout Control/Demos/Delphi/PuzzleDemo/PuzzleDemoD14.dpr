program PuzzleDemoD14;

uses
  Forms,
  Puzzle in 'Puzzle.pas' {frmPuzzle};

  {$R *.res}
  {$R WindowsXP.res}


begin
  Application.Initialize;
  Application.Title := 'PuzzleDemoD14';
  Application.CreateForm(TfrmPuzzle, frmPuzzle);
  Application.Run;
end.
