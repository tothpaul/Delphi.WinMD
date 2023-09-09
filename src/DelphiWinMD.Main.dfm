object Main: TMain
  Left = 0
  Top = 0
  Caption = 'Delphi WinMD Explorer'
  ClientHeight = 516
  ClientWidth = 963
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  OnCreate = FormCreate
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 473
    Top = 0
    Height = 516
    ExplicitLeft = 488
    ExplicitTop = 240
    ExplicitHeight = 100
  end
  object TreeView: TTreeView
    Left = 0
    Top = 0
    Width = 473
    Height = 516
    Align = alLeft
    Indent = 19
    TabOrder = 0
    OnChange = TreeViewChange
    ExplicitHeight = 515
  end
  object DrawGrid: TDrawGrid
    Left = 476
    Top = 0
    Width = 487
    Height = 516
    Align = alClient
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goFixedRowDefAlign]
    TabOrder = 1
    OnDrawCell = DrawGridDrawCell
    ExplicitWidth = 483
    ExplicitHeight = 515
  end
  object MainMenu: TMainMenu
    Left = 408
    Top = 256
    object File1: TMenuItem
      Caption = 'File'
      object mnFileOpen: TMenuItem
        Caption = 'Open...'
        OnClick = mnFileOpenClick
      end
    end
  end
end
