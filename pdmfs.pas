unit pdmFS;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  FileCtrl, ComCtrls, DBGrids, ShellApi, SQLite3Conn, SQLDB, SQLite3DS, DB;

type

  { Tzcad }

  Tzcad = class(TForm)
    CreateBtn: TButton;
    DelBtn: TButton;
    FindBtn: TButton;
    CreateSF: TButton;
    ds: TDataSource;
    ReNameBtn: TButton;
    ProjGrid: TDBGrid;
    DelSF: TButton;
    DesignE: TEdit;
    NameE: TEdit;
    FindE: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    OpenSF: TButton;
    PageControl1: TPageControl;
    rbAdmin: TRadioButton;
    rbClient: TRadioButton;
    sd: TSelectDirectoryDialog;
    selSF: TButton;
    SFPathAdmin: TEdit;
    SFPathClient: TEdit;
    dbCon: TSQLite3Connection;
    dataSet: TSqlite3Dataset;
    q: TSQLQuery;
    Transact: TSQLTransaction;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure CreateBtnClick(Sender: TObject);
    procedure CreateSFClick(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
    procedure DelSFClick(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure OpenSFClick(Sender: TObject);
    procedure ProjGridCellClick(Column: TColumn);
    procedure rbAdminChange(Sender: TObject);
    procedure rbClientChange(Sender: TObject);
    procedure ReNameBtnClick(Sender: TObject);
    procedure selSFClick(Sender: TObject);
    procedure showDB(Sender: TObject);
    procedure dbConAfterConnect(Sender: TObject);
  private
         id, FfsPath : String;
  public
        property PathFS : String read FfsPath write FfsPath;
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
  PathFS:=sd.FileName;
  ShellExecute(0,PChar('cmd.exe /c net share folder='+fsPath),nil,nil,nil,1);
end;

procedure Tzcad.DelBtnClick(Sender: TObject);
begin
  if ProjGrid.DataSource.DataSet.FieldByName('Name').AsString = '' then
  begin
    ShowMessage('Выберите проект');
    exit;
  end;
  dataSet.Close;
  with q do
  begin
    SQL.Clear;
    SQL.Add('delete from Project where ID = '+ id);
    ExecSQL;
    Transact.Commit;
    Close;
  end;
  dataSet.Open;
end;

procedure Tzcad.CreateBtnClick(Sender: TObject);
begin
  if PathFS = '' then
  begin
    ShowMessage('Выберите общую папку');
    exit;
  end;
  CreateDir(PathFS + '\' + DesignE.Text + ' _ ' + NameE.Text);
  if (NameE.Text = '') or (DesignE.Text = '') then
  begin
    ShowMessage('Введите обозначение и наименование');
    exit;
  end;

  dataSet.Close;
  with q do
  begin
    SQL.Clear;
    SQL.Add('insert into Project(Designator, Name) values'+
    '('+ QuotedStr(DesignE.Text) +','+ QuotedStr(NameE.Text) +')');
    ExecSQL;
    Transact.Commit;
    Close;
  end;
  dataSet.Open;
end;

procedure Tzcad.DelSFClick(Sender: TObject);
begin
     if FileExists(SFPathAdmin.Text) then
     begin
       if RemoveDir(SFPathAdmin.Text) then ShowMessage('папка удалена');
     end;
end;

procedure Tzcad.FindBtnClick(Sender: TObject);
begin
     if FindE.Text = '' then
     begin
       ShowMessage('Введите обозначение для поиска');
       exit;
     end;
     dataSet.Locate('Designator',FindE.Text,[]);
end;

procedure Tzcad.OpenSFClick(Sender: TObject);
var
  path : string;
begin
     path := SFPathAdmin.Text;
     ExecuteProcess(AnsiString('explorer.exe'),path,[]);
end;

procedure Tzcad.ProjGridCellClick(Column: TColumn);
begin
  id := ProjGrid.DataSource.DataSet.FieldByName('ID').AsString;
end;

procedure Tzcad.rbClientChange(Sender: TObject);
begin
  if rbClient.Checked then
  begin
    rbAdmin.Checked:=false;
    SFPathAdmin.Enabled:=false;
  end;
end;

procedure Tzcad.ReNameBtnClick(Sender: TObject);
var
  NameProj, Design : string;
begin
  NameProj:= ProjGrid.DataSource.DataSet.FieldByName('Name').AsString;
  Design:= ProjGrid.DataSource.DataSet.FieldByName('Designator').AsString;
    dataSet.Close;
  with q do
  begin
    SQL.Clear;
    SQL.Add('update project set designator = '+ QuotedStr(Design) +' ,'+ 'name ='+
                    QuotedStr(NameProj)+ 'where id ='+ id);
    ExecSQL;
    Transact.Commit;
    Close;
  end;
  dataSet.Open;
end;

procedure Tzcad.selSFClick(Sender: TObject);
begin
  if sd.Execute then
  SFPathClient.Text:=sd.FileName else exit;
  PathFS:=sd.FileName;
end;

procedure Tzcad.showDB(Sender: TObject);
begin
  try
     dataSet.Open;
     dbCon.Connected:=True;
  except
     On E:Exception do
        ShowMessage('Ошибка открытия базы: '+ E.Message);
  end;
end;

procedure Tzcad.dbConAfterConnect(Sender: TObject);
begin

end;

end.

