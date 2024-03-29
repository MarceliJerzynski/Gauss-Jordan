unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls, Unit1;

type
 TArray2d = array of array of Double;
 iTArray2d = array of array of interval;
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    RBn2: TRadioButton;
    RBn3: TRadioButton;
    RBn4: TRadioButton;
    RBn5: TRadioButton;
    Label30: TLabel;
    Button3: TButton;
    ResultsGrid: TStringGrid;
    Label1: TLabel;
    Memo: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    ResultsGrid2: TStringGrid;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure GaussJordanEliminationMethod(n : Integer; var Arr: TArray2d);
    procedure iGaussJordanEliminationMethod(n : Integer; var Iarr: iTArray2d);
    procedure AutoSizeCol(Grid: TStringGrid; Column: integer);
    procedure createEdits();
    procedure hideEdits();
    procedure FormCreate(Sender: TObject);
    procedure RBn5Click(Sender: TObject);
    procedure RBn4Click(Sender: TObject);
    procedure RBn3Click(Sender: TObject);
    procedure RBn2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
   distanceEEx = 110;
   distanceELx = 75;
   distanceELy = 2;
   distanceEEy = 50;
   firstLeft = 75;
   firstTop = 90;

var
  Form2: TForm2;
  n : Integer;
  have_a_result : Boolean;
  data_from_edit : Boolean;
  Edits : array of array of TEdit;
  Labels: array of array of TLabel;
implementation

{$R *.dfm}

//zmienne poczatkowe
procedure TForm2.FormCreate(Sender: TObject);
var
t : tgridrect;
Background: TImage;
begin
   n:=5;
   createEdits();
   t.Left := -1;
   t.right := -1;
   t.Bottom := -1;
   t.top := -1;
   ResultsGrid.selection := t;
   ResultsGrid2.selection := t;

   Background := TImage.Create(self);
   Background.Parent := self;
   Background.Left := 0;
   Background.Top := 0;
   Background.Width := self.Width;
   Background.Height:= self.Height;
   Background.Picture.LoadFromFile('background.bmp');
   Background.SendToBack();

end;
//ukryj edity
procedure TForm2.hideEdits();
var
i : Integer;
j : Integer;
begin
     for i := 0 to n-1 do  //n wierszy
       begin
         for j := 0 to n do  //n+1 kolumn
          begin
            Edits[i][j].Visible := false;
          end;
       end;

      for i := 0 to n-1 do  //n wierszy
       begin
         for j := 0 to n-1 do  //n+1 kolumn
          begin
            Labels[i][j].Visible := false;
          end;
       end;

       for i := 0 to n - 1 do
         begin
           Labels[i][n-1].Caption := 'x' + IntToStr(n-1) + ' = ';
         end;

     data_from_edit := False;
end;
//algorytm gaussa-jordana z pelnym wyborem elementu podstawowego
procedure TForm2.GaussJordanEliminationMethod(n : Integer; var Arr: TArray2d);
var
 i : Integer;
 j : Integer;
 k : Integer;
 help : Extended;
 max : Extended;
 colMax : Integer;
 rowMax : Integer;
begin
    have_a_result := True;
    SetLength(Arr, n, n+1);

     for i := 0 to n-1 do //dla kazdego wiersza
        begin
          max := Arr[i][i];
          colMax:=i;
          rowMax:=i;

          for j := i to n-1 do
            begin
             for k := i to n-1 do
              begin
               if max < Arr[j][k] then
                begin
                  max := Arr[j][k]; //tutaj mam maxa
                  colMax:=j;
                  rowMax:=k;
                end;
              end;
            end;

            if max = 0 then
            begin
                ShowMessage('Macierz jest osobliwa, a wi�c stop');
                have_a_result := False;
                break;
            end;



          for j := i to n do  //zamiana wierszy
            begin
              help := Arr[i][j];
              Arr[i][j] := Arr[colMax][j];
              Arr[colMax][j] := help;
            end;
           for j := i to n-1 do //zamiana kolumn
            begin
              help := Arr[j][i];
              Arr[j][i] := Arr[j][rowMax];
              Arr[j][rowMax] := help;
            end;


          help := Arr[i][i];
             for j := 0 to n do
               begin
                 Arr[i][j] := Arr[i][j]/help;   //w1' = w1/w1[0] i analogicznie
               end;

             for j := 0 to n-1 do      //dla kazdego wiersza
              begin
                if i <> j then          //roznego od tego, ktorym zmieniamy
                  begin
                    help:=Arr[j][i];
                     for k := 0 to n do //dla kazdego elementu w wierszu
                      begin
                        Arr[j][k] := Arr[j][k] - Arr[i][k]*help;
                      end;

                  end;
              end;
        end;
end;
//jw, tylko ze wykorzystujac arytmetyke przedzialowa
procedure TForm2.iGaussJordanEliminationMethod(n : Integer; var Iarr: iTArray2d);
var
 i : Integer;
 j : Integer;
 k : Integer;
 help : interval;
 max : interval;
 colMax : Integer;
 rowMax : Integer;
begin
    have_a_result := True;
    SetLength(Iarr, n, n+1);

     for i := 0 to n-1 do //dla kazdego wiersza
        begin
          max := Iarr[i][i];
          colMax:=i;
          rowMax:=i;

          for j := i to n-1 do
            begin
             for k := i to n-1 do
              begin
               if max.b < Iarr[j][k].a then
                begin
                  max := Iarr[j][k]; //tutaj mam maxa
                  colMax:=j;
                  rowMax:=k;
                end;
              end;
            end;

            if ( max.b>0 ) and ( max.a < 0 ) then
            begin
                ShowMessage('Macierz jest osobliwa, a wi�c stop');
                have_a_result := False;
                break;
            end;



          for j := i to n do  //zamiana wierszy
            begin
              help := Iarr[i][j];
              Iarr[i][j] := Iarr[colMax][j];
              Iarr[colMax][j] := help;
            end;
           for j := i to n-1 do //zamiana kolumn
            begin
              help := Iarr[j][i];
              Iarr[j][i] := Iarr[j][rowMax];
              Iarr[j][rowMax] := help;
            end;


          help := Iarr[i][i];
             for j := 0 to n do
               begin
                 Iarr[i][j] := Iarr[i][j]/help;   //w1' = w1/w1[0] i analogicznie
               end;

             for j := 0 to n-1 do      //dla kazdego wiersza
              begin
                if i <> j then          //roznego od tego, ktorym zmieniamy
                  begin
                    help:=Iarr[j][i];
                     for k := 0 to n do //dla kazdego elementu w wierszu
                      begin
                        Iarr[j][k] := Iarr[j][k] - Iarr[i][k]*help;
                      end;

                  end;
              end;
        end;
end;
//stworz edity
procedure TForm2.createEdits();
var
i : Integer;
j : Integer;
begin
     SetLength(Edits, n, n+1);
     SetLength(Labels, n , n);
     for i := 0 to n-1 do  //n wierszy
       begin
         for j := 0 to n do  //n+1 kolumn
          begin
            Edits[i][j] := TEdit.Create(self);
            Edits[i][j].Parent := self;
            Edits[i][j].Left := firstLeft + j*distanceEEx;
            Edits[i][j].Top := firstTop + i*distanceEEy;
            Edits[i][j].Width := 69;
            Edits[i][j].Height := 21;
            Edits[i][j].Alignment := taRightJustify;
          end;
       end;

      for i := 0 to n-1 do  //n wierszy
       begin
         for j := 0 to n-1 do  //n+1 kolumn
          begin
            Labels[i][j] := TLabel.Create(self);
            Labels[i][j].Parent := self;
            Labels[i][j].Left := firstLeft + distanceELx + j*distanceEEx;
            Labels[i][j].Top := firstTop + distanceELy + i*distanceEEy;
            Labels[i][j].Width := 69;
            Labels[i][j].Height := 21;
            Labels[i][j].Caption := 'x' + IntToStr(j) + ' + ';
          end;
       end;

       for i := 0 to n - 1 do
         begin
           Labels[i][n-1].Caption := 'x' + IntToStr(n-1) + ' = ';
         end;
       Memo.Visible := False;
       data_from_edit := True;

end;
//n = 2
procedure TForm2.RBn2Click(Sender: TObject);
begin
  hideEdits();
  n:=2;
  createEdits();
end;
//n = 3
procedure TForm2.RBn3Click(Sender: TObject);
begin
  hideEdits();
  n:=3;
  createEdits();
end;
// n = 4
procedure TForm2.RBn4Click(Sender: TObject);
begin
  hideEdits();
  n:=4;
  createEdits();
end;
// n = 5
procedure TForm2.RBn5Click(Sender: TObject);
begin
  hideEdits();
  n:=5;
  createEdits();

end;

procedure Step(var loop: integer; step: integer);
begin
  loop := loop + step - 1;
end;
//pobierz dane, odpal algorytm, wyswietl wyniki
procedure TForm2.Button1Click(Sender: TObject);   //licz
var
  i:Integer;
  j:Integer;
  k:Integer;
  l:Integer;
  line: string;
  P : PChar;
  S : TStrings;
  Arr: TArray2d;
  Iarr: iTArray2d;
  left: string;
  right: string;
begin

      SetLength(Arr, n, n+1);
    //  SetLength(Iarr, n, n+1);
      SetLength(Edits, n, n+1);

      try
       begin
//
//        if data_from_edit then     //wczytywanie danych z editow
//        begin
//         for i := 0 to n-1 do
//           begin
//             for j := 0 to n do
//               begin
//                 Arr[i][j] := StrToFloat(Edits[i][j].Text);
//               end;
//           end;
//        end
//        else
//        begin
                                    //wczytywanie danych z memo
//          i:=0;
//          with Memo do while i<Lines.Count-1 do if Lines[i]='' then Lines.Delete(i) else Inc(i);
//          n := Memo.Lines.Count;
//          for i := 0 to n-1 do
//          begin
//            line := Memo.Lines[i];
//            P := PChar(line);
//            S := TStringList.Create;
//            ExtractStrings([' '], [], P, S);
//            for j := 0 to S.Count-1 do
//            begin
//              Arr[i][j] := StrToFloat(S[j]);
//            end;
//
//          end;
//
//     end;
//
//
//           GaussJordanEliminationMethod(n, Arr);
//
//
//           if have_a_result then
//           begin
//             ResultsGrid.RowCount := n;
//             ResultsGrid.ColCount := 2;
//             j := 0;
//             for i := n-1 downto 0 do
//             begin
//               ResultsGrid.Cells[0,j] := 'x' + IntToStr(j) + ' = ';
//               str(Arr[i][n]:18:17, line);
//               ResultsGrid.Cells[1,j] := line;
//               j:=j+1;
//             end;
//             AutoSizeCol(ResultsGrid, 0);
//             AutoSizeCol(ResultsGrid, 1);
//           end;

       //-------------------------------------------------

        if data_from_edit then     //wczytywanie danych z editow
        begin
         for i := 0 to n-1 do
           begin
             for j := 0 to n do
               begin
                 Iarr[i][j] := StrToFloat(Edits[i][j].Text);
               end;
           end;
        end
         else
        begin
                                    //wczytywanie danych z memo
          i:=0;
          with Memo do while i<Lines.Count-1 do if Lines[i]='' then Lines.Delete(i) else Inc(i);
          n := Memo.Lines.Count;
          SetLength(Iarr, n, n+1);
          for i := 0 to n-1 do
          begin
            line := Memo.Lines[i];
            P := PChar(line);
            S := TStringList.Create;
            ExtractStrings([' '], [], P, S);

            j := 0;
            for l:=0 to n do
              begin
                   Iarr[i][l].a := left_read(S[j]);
                   j:=j+1;
                   Iarr[i][l].b := right_read(S[j]);
                   j:=j+1;
              end;
          end;
        end;

        iGaussJordanEliminationMethod(n, Iarr);

        if have_a_result then
           begin
             ResultsGrid2.RowCount := n+1;
             ResultsGrid2.ColCount := 2;
             j:=0;
             for i := n-1 downto 0 do
             begin
               iends_to_strings(Iarr[i][n], left, right);
               ResultsGrid2.Cells[0,j] := 'x' + IntToStr(j) + ' = ';
               ResultsGrid2.Cells[1,j] := '['+ left + ' ; ' + right + ']';
               j:=j+1;
             end;






             AutoSizeCol(ResultsGrid2, 0);
             AutoSizeCol(ResultsGrid2, 1);
           end;

      end;
     except
        ShowMessage('B��dne dane');

      end;

end;
//zakoncz program
procedure TForm2.Button2Click(Sender: TObject);
var
  i: Integer;
begin
  Application.Terminate();
end;
//wczytuj dane z tekstu
procedure TForm2.Button3Click(Sender: TObject);
begin
  hideEdits();
  Memo.Visible := True;
  RBn2.Checked := False;
  RBn3.Checked := False;
  RBn4.Checked := False;
  RBn5.Checked := False;
end;

procedure TForm2.AutoSizeCol(Grid: TStringGrid; Column: integer);
var
  i, W, WMax: integer;
begin
  WMax := 0;
  for i := 0 to (Grid.RowCount - 1) do begin
    W := Grid.Canvas.TextWidth(Grid.Cells[Column, i]);
    if W > WMax then
      WMax := W;
  end;
  Grid.ColWidths[Column] := WMax*2;
end;

end.
