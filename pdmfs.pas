unit pdmFS;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  FileCtrl, ShellApi;

type

  { Tzcad }

  Tzcad = class(TForm)
    CreateSF: TButton;
    DelSF: TButton;
    OpenSF: TButton;
    sd: TSelectDirectoryDialog;
    selSF: TButton;
    SFPathAdmin: TEdit;
    SFPathClient: TEdit;
    rbAdmin: TRadioButton;
    rbClient: TRadioButton;
    procedure CreateSFClick(Sender: TObject);
    procedure DelSFClick(Sender: TObject);
    procedure OpenSFClick(Sender: TObject);
    procedure rbAdminChange(Sender: TObject);
    procedure rbClientChange(Sender: TObject);
    procedure selSFClick(Sender: TObject);
  private

  public

  end;

var
  zcad: Tzcad;

implementation

{$R *.lfm}

{ Tzcad }

procedure Tzcad.rbAdminChange(Sender: TObject);
begin
  if rbAdmin.Checked then
  begin
    rbClient.Checked:=false;
    SFPathAdmin.Enabled:=true;
  end;
end;

procedure Tzcad.CreateSFClick(Sender: TObject);
var
  fsPath : String;
begin
  rbAdmin.Checked:=true;
  if sd.Execute then
  begin
    SFPathAdmin.Text:=sd.FileName;
    fsPath:=sd.FileName;
  end
  else exit;
  ShellExecute(0,PChar('cmd.exe /c net share folder='+fsPath),nil,nil,nil,1);
end;

procedure Tzcad.DelSFClick(Sender: TObject);
begin
     if FileExists(SFPathAdmin.Text) then
     begin
       if RemoveDir(SFPathAdmin.Text) then ShowMessage('папка удалена');
     end;
end;

procedure Tzcad.OpenSFClick(Sender: TObject);
var
  path : string;
begin
     path := SFPathAdmin.Text;
     ExecuteProcess(AnsiString('explorer.exe'),path,[]);

end;

procedure Tzcad.rbClientChange(Sender: TObject);
begin
  if rbClient.Checked then
  begin
    rbAdmin.Checked:=false;
    SFPathAdmin.Enabled:=false;
  end;
end;

procedure Tzcad.selSFClick(Sender: TObject);
begin
  if sd.Execute then
  SFPathClient.Text:=sd.FileName else exit;
end;

end.

