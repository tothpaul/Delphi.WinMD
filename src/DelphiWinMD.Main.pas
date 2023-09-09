unit DelphiWinMD.Main;
{
  Delphi winmd parser (c)2023 Execute SARL https://www.execute.fr
}
interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls,

  DelphiWinMD.Types,
  DelphiWinMD.Files, Vcl.ExtCtrls, Vcl.Grids, Vcl.StdCtrls, Vcl.Buttons;

type
  TMain = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    mnFileOpen: TMenuItem;
    TreeView: TTreeView;
    DrawGrid: TDrawGrid;
    Splitter1: TSplitter;
    procedure mnFileOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Déclarations privées }
    FWinMD: TWinMDFile;
    FRoot: TTreeNode;
    FTable: PTableInfo;
    procedure LoadFile(const AFileName: string);
  public
    { Déclarations publiques }
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

procedure TMain.DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  var S: string;
  if ARow = 0 then
  begin
    S := FTable.FieldDefs[ACol].FieldName;
  end else begin
    S := FWinMD.GetValue(FTable.TableIndex, ARow - 1, ACol);
  end;
  with DrawGrid.Canvas do
  begin
    FillRect(Rect);
    Rect.Inflate(-2, -2);
    TextRect(Rect, S, [tfSingleLine, tfVerticalCenter, tfEndEllipsis, tfNoPrefix]);
  end;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  if FileExists('Windows.Win32.winmd') then
    LoadFile('Windows.Win32.winmd');
end;

procedure TMain.LoadFile(const AFileName: string);
begin
  TreeView.Items.BeginUpdate;
  try
    TreeView.Items.Clear;
    FreeAndNil(FWinMD);
    AllocConsole;
    FWinMD := TWinMDFile.Create;
    FWinMD.LoadFromFile(AFileName);
    FRoot := TreeView.Items.AddChild(nil, FWinMD.Module);
//    FRoot.HasChildren := True;
    FWinMD.ForEachTable(
      procedure (const Info: TTableInfo)
      begin
        if Info.RecordCount > 0 then
        begin
          var Node := TreeView.Items.AddChild(FRoot, Info.TableName);
          Node.Data := @Info;
          TreeView.Items.AddChild(Node, 'RecordCount = ' + Info.RecordCount.ToString);
          TreeView.Items.AddChild(Node, 'RecordSize = ' + Info.RecordSize.ToString)
        end;
      end
    );
  finally
    TreeView.Items.EndUpdate;
  end;
end;

procedure TMain.mnFileOpenClick(Sender: TObject);
begin
  var S: string;
  if PromptForFileName(S, 'Windows metadata (*.winMd)|*.winmd', '', 'Load WinMD filed', '', False) then
  begin
    LoadFile(S);
  end;
end;

procedure TMain.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  if Node.Data = nil then
    DrawGrid.Hide
  else begin
    FTable := Node.Data;
    DrawGrid.ColCount := FTable.FieldCount;
    DrawGrid.RowCount := 1 + FTable.RecordCount;
    DrawGrid.Show;
    DrawGrid.Invalidate;
  end;
end;

end.
