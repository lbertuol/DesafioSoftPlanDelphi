object DM: TDM
  Height = 480
  Width = 640
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=Mongo'
      'Database=DesafioSoftplanDelphi'
      'Server=127.0.0.1'
      'Port=27017')
    Left = 224
    Top = 184
  end
  object FDPhysMongoDriverLink1: TFDPhysMongoDriverLink
    Left = 232
    Top = 328
  end
  object FDManager1: TFDManager
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 400
    Top = 272
  end
  object FDMongoQuery1: TFDMongoQuery
    Connection = FDConnection1
    Left = 536
    Top = 392
  end
end
