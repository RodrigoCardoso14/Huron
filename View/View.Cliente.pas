unit View.Cliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  View.Template, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Mask,
  Model.Cliente, Model, Controller.Cliente;

type
  TClienteView = class(TTemplateView)
    EDTRazaoSocial: TLabeledEdit;
    EDTNomeFantasia: TLabeledEdit;
    MSKCNPJ: TMaskEdit;
    EDTEndereco: TLabeledEdit;
    EDTTelefone: TLabeledEdit;
    EDTEmail: TLabeledEdit;
  private
    { Private declarations }
  public
    procedure SetViewByModel(const AModel: TModel); override;
    procedure SetModelByView; override;
    function Validate: Boolean; override;
    procedure CreateController; override;
    procedure CleanModel; override;


  end;

var
  ClienteView: TClienteView;

implementation

{$R *.dfm}

{ TClienteView }

procedure TClienteView.CleanModel;
begin
  inherited;
  Model := TCliente.Create;
end;

procedure TClienteView.CreateController;
begin
  inherited;
  Controller := TClienteController.Create;
end;

procedure TClienteView.SetModelByView;
begin
  inherited;
  with TCliente(Model) do
  begin
    RazaoSocial := EDTRazaoSocial.Text;
    NomeFantasia := EDTNomeFantasia.Text;
    CNPJ := MSKCNPJ.Text;
    Endereco := EDTEndereco.Text;
    Telefone := EDTTelefone.Text;
    Email := EDTEmail.Text;
  end;
end;

procedure TClienteView.SetViewByModel(const AModel: TModel);
begin
  inherited;
  with TCliente(AModel) do
  begin
    EDTRazaoSocial.Text := RazaoSocial;
    EDTNomeFantasia.Text := NomeFantasia;
    MSKCNPJ.Text := CNPJ;
    EDTEndereco.Text := Endereco;
    EDTTelefone.Text := Telefone;
    EDTEmail.Text := Email;
  end;
end;

function TClienteView.Validate: Boolean;
var
  LMensagem: string;
begin
  LMensagem := '';
  Result := True;
  if Trim(EDTNomeFantasia.Text).IsEmpty then
  begin
    LMensagem := 'Informe o Nome Fantasia';
    EDTNomeFantasia.SetFocus;
    Result := False;
  end
  else if Length(Trim(MSKCNPJ.Text)) <> 14 then
  begin
    LMensagem := 'CNPJ inv�lido';
    MSKCNPJ.SetFocus;
    Result := False;
  end;

  if not LMensagem.Trim.IsEmpty then
  begin
    Application.MessageBox(PWideChar(LMensagem), 'Aten��o', MB_OK + MB_ICONWARNING);
  end;
end;

end.
