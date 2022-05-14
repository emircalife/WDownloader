object frmHistoricoDownloads: TfrmHistoricoDownloads
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Hist'#243'rico de Downloads'
  ClientHeight = 349
  ClientWidth = 502
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object grdHistoricoDownload: TDBGrid
    Left = 0
    Top = 0
    Width = 502
    Height = 315
    Align = alTop
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'URL'
        Width = 337
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'Data In'#237'cio'
        Title.Alignment = taCenter
        Width = 72
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'Data Fim'
        Title.Alignment = taCenter
        Width = 72
        Visible = True
      end>
  end
  object btnFechar: TBitBtn
    Left = 214
    Top = 321
    Width = 75
    Height = 25
    Caption = 'Fecha&r'
    TabOrder = 1
    OnClick = btnFecharClick
  end
end
