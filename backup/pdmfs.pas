unit pdmFS;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  FileCtrl, ComCtrls, DBGrids, ShellApi, SQLite3Conn, SQLDB, SQLite3DS, DB;

type

  { Tzcad }

  Tzcad = class(TForm)
    CreateSF: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DelSF: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    OpenSF: TButton;
    PageControl1: TPageControl;
    rbAdmin: TRadioButton;
    rbClient: TRadioButton;
    sd: TSelectDirectoryDialog;
    selSF: TButton;
    SFPathAdmin: TEdit;
    SFPathClient: TEdit;
    SQLite3Connection1: TSQLite3Connection;
    Sqlite3Dataset1: TSqlite3Dataset;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure CreateSFClick(Sender: TObject);
    procedure DelSFClick(Sender: TObject);
    procedure OpenSFClick(Sender: TObject);
    procedure rbAdminChange(Sender: TObject);
    procedure rbClientChange(Sender: TObject);
    procedure selSFClick(Sender: TObject);
    procedure showDB(Sender: TObject);
    procedure SQLite3Connection1AfterConnect(Sender: TObject);
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

procedure Tzcad.showDB(Sender: TObject);
begin
    {Параметры компонентов работы с базой
    Можно выставить в опциях у каждого компонента.}
    //*******************************
    SQLite3Dataset1.FileName:='MainDB';
    SQLite3Dataset1.TableName:='Project';
    DataSource1.DataSet:=SQLite3Dataset1;
    SQLite3Connection1.DatabaseName:='MainDB';
    SQLite3Connection1.Transaction:=SQLTransaction1;
    SQLTransaction1.DataBase:=SQLite3Connection1;
    SQLQuery1.DataBase:=SQLite3Connection1;
    SQLQuery1.Transaction:=SQLTransaction1;
    //*******************************

    try
       SQLite3Dataset1.Open;
       SQLite3Connection1.Connected:=True;
    except
       On E:Exception do
          ShowMessage('Ошибка открытия базы: '+ E.Message);
    end;
end;

procedure Tzcad.SQLite3Connection1AfterConnect(Sender: TObject);
begin

end;

end.

