object DM: TDM
  OnCreate = DataModuleCreate
  Height = 137
  Width = 383
  PixelsPerInch = 96
  object Trans: TFDTransaction
    Connection = Conn
    Left = 72
  end
  object Conn: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 24
  end
  object SchAdapter: TFDSchemaAdapter
    Left = 136
  end
  object qryListaDownloads: TFDQuery
    Connection = Conn
    Left = 45
    Top = 73
  end
  object qryManutDownloads: TFDQuery
    Connection = Conn
    Left = 197
    Top = 73
  end
  object FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink
    Left = 248
  end
end
