unit Controller;

interface

uses
  DAO, Model, Singleton.Connection, Util.Enum, DB;

type
  TController = class
  private
    FModel: TModel;
    FDAO: TDAO;
    procedure SetModel(const Value: TModel);
    procedure SetDAO(const Value: TDAO);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Transaction(const AOperacao: TOperacao; const AModel: TModel; out AMensagem: string): Boolean;
    procedure BeforeSave(const AOperacao: TOperacao; const AModel: TModel); virtual;
    procedure Save(const AOperacao: TOperacao; const AModel: TModel);
    procedure AfterSave(const AOperacao: TOperacao; const AModel: TModel); virtual;

    property DAO: TDAO read FDAO write SetDAO;
    property Model: TModel read FModel write SetModel;
  end;

implementation

uses
  System.SysUtils;

{ TController }

procedure TController.AfterSave(const AOperacao: TOperacao; const AModel: TModel);
begin

end;

procedure TController.BeforeSave(const AOperacao: TOperacao; const AModel: TModel);
begin

end;

constructor TController.Create;
begin

end;

destructor TController.Destroy;
begin
  FreeAndNil(FDAO);
  FreeAndNil(FModel);
  inherited;
end;

procedure TController.Save(const AOperacao: TOperacao; const AModel: TModel);
begin
  BeforeSave(AOperacao, AModel);
  case AOperacao of
    oCreate, oUpdate: DAO.Save(AModel);
    oDelete: DAO.Delete(AModel);
  end;
  AfterSave(AOperacao, AModel);
end;

procedure TController.SetDAO(const Value: TDAO);
begin
  FDAO := Value;
end;

procedure TController.SetModel(const Value: TModel);
begin
  FModel := Value;
end;

function TController.Transaction(const AOperacao: TOperacao; const AModel: TModel; out AMensagem: string): Boolean;
begin
  AMensagem := EmptyStr;
  TConnectionSingleton.GetInstance.FDConnection.StartTransaction;
  try
    try
      Save(AOperacao, AModel);
      TConnectionSingleton.GetInstance.FDConnection.Commit;
      Result := True;
    except
      on E: EDataBaseError do
      begin
        if AOperacao = oDelete then
          AMensagem := 'N�o foi poss�vel excluir esse registro.'
        else
          AMensagem := StringReplace(E.Message, Slinebreak, '. ', [RfReplaceAll]);

        Result := False;
        TConnectionSingleton.GetInstance.FDConnection.Rollback;
      end;

      on E: Exception do
      begin
        AMensagem := StringReplace(E.Message, Slinebreak, '. ', [RfReplaceAll]);
        Result := False;
        TConnectionSingleton.GetInstance.FDConnection.Rollback;
      end;
    end;
  finally

  end;
end;

end.
