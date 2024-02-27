object DM: TDM
  Height = 480
  Width = 640
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Server=192.168.1.30'
      'User_Name=root'
      'Database=DesafioSoftplanDelphi'
      'DriverID=Mongo')
    Left = 112
    Top = 164
  end
  object FDMongoQuery1: TFDMongoQuery
    Connection = FDConnection1
    Left = 112
    Top = 228
  end
  object FDPhysMongoDriverLink1: TFDPhysMongoDriverLink
    Left = 112
    Top = 284
  end
  object FDMongoDataSet1: TFDMongoDataSet
    Connection = FDConnection1
    Left = 112
    Top = 340
  end
end
