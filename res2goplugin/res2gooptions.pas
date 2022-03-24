unit res2goOptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, EditBtn, ActnList,
  StrUtils, IDEOptionsIntf, IDEOptEditorIntf, LazIDEIntf, ProjectIntf,
  ProjectResourcesIntf, Laz2_XMLCfg, uSupports;

type


  { TProjectRes2goRes }

  TProjectRes2goRes = class(TAbstractProjectResource)
  private const
    DefaultCGOValue = {$ifdef windows}False{$else}True{$endif};
  private
    FEnabled: Boolean;
    FGoBuildMode: string;
    FGoEnabledCGO: Boolean;
    FGoEnabledFinalizerOn: Boolean;
    FGoRoot: string;
    FGoTags: string;
    FGoUseEmbed: Boolean;
    FGoUseTempdll: Boolean;
    FOutLang: TOutLang;
    FOutputPath: string;
    FPakcageName: string;
    FSaveGfmFile: Boolean;
    FUseDefaultWinAppRes: Boolean;
    FUseOriginalFileName: Boolean;

    procedure Changed;

    procedure SetEnabled(AValue: Boolean);
    procedure SetGoBuildMode(AValue: string);
    procedure SetGoEnabledCGO(AValue: Boolean);
    procedure SetGoEnabledFinalizerOn(AValue: Boolean);
    procedure SetGoRoot(AValue: string);
    procedure SetGoTags(AValue: string);
    procedure SetGoUseEmbed(AValue: Boolean);
    procedure SetGoUseTempdll(AValue: Boolean);
    procedure SetOutLang(AValue: TOutLang);
    procedure SetOutputPath(AValue: string);
    procedure SetPackageName(AValue: string);
    procedure SetSaveGfmFile(AValue: Boolean);
    procedure SetUseDefaultWinAppRes(AValue: Boolean);
    procedure SetUseOriginalFileName(AValue: Boolean);

  public
    function UpdateResources(AResources: TAbstractProjectResources; const {%H-}MainFilename: string): Boolean; override;
    procedure WriteToProjectFile(AConfig: TObject; const Path: String); override;
    procedure ReadFromProjectFile(AConfig: TObject; const Path: String); override;
  public
    property Enabled: Boolean read FEnabled write SetEnabled;
    property OutputPath: string read FOutputPath write SetOutputPath;
    property UseOriginalFileName: Boolean read FUseOriginalFileName write SetUseOriginalFileName;
    property SaveGfmFile: Boolean read FSaveGfmFile write SetSaveGfmFile;
    property OutLang: TOutLang read FOutLang write SetOutLang;
    property PackageName: string read FPakcageName write SetPackageName;
    property UseDefaultWinAppRes: Boolean read FUseDefaultWinAppRes write SetUseDefaultWinAppRes;

    property GoUseTempdll: Boolean read FGoUseTempdll write SetGoUseTempdll;
    property GoEnabledFinalizerOn: Boolean read FGoEnabledFinalizerOn write SetGoEnabledFinalizerOn;
    property GoTags: string read FGoTags write SetGoTags;
    property GoEnabledCGO: Boolean read FGoEnabledCGO write SetGoEnabledCGO;
    property GoBuildMode: string read FGoBuildMode write SetGoBuildMode;
    property GoRoot: string read FGoRoot write SetGoRoot;
    property GoUseEmbed: Boolean read FGoUseEmbed write SetGoUseEmbed;
  end;

  { TRes2goOptionsFrame }

  TRes2goOptionsFrame = class(TAbstractIDEOptionsEditor)
    actSaveGfm: TAction;
    ActionList1: TActionList;
    Bevel1: TBevel;
    cbbGoBuildModes: TComboBox;
    cbbLangs: TComboBox;
    chkEanbledConvert: TCheckBox;
    chkGoEnabledCGO: TCheckBox;
    chkGoEnabledFinalizerOn: TCheckBox;
    chkGoUseEmbed: TCheckBox;
    chkGoUseTempdll: TCheckBox;
    chkSaveGfmFile: TCheckBox;
    chkUseDefaultWinAppRes: TCheckBox;
    chkUseOriginalFileName: TCheckBox;
    EdtGoTags: TEdit;
    edtGoRoot: TDirectoryEdit;
    EdtOutputPath: TDirectoryEdit;
    EdtPkgName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblBuildModeHint: TLabel;
    OutputPath: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    procedure actSaveGfmExecute(Sender: TObject);
    procedure actSaveGfmUpdate(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetTitle: string; override;
    procedure Setup({%H-}ADialog: TAbstractOptionsEditorDialog); override;
    procedure ReadSettings(AOptions: TAbstractIDEOptions); override;
    procedure WriteSettings(AOptions: TAbstractIDEOptions); override;
    class function SupportedOptionsClass: TAbstractIDEOptionsClass; override;
  end;

implementation

{$R *.lfm}

uses
  res2gomain;

const
  ProjectOptionsRes2go = ProjectOptionsMisc + 500;


{ TProjectRes2goRes }

procedure TProjectRes2goRes.Changed;
begin
  Self.Modified:= True;
end;

procedure TProjectRes2goRes.SetEnabled(AValue: Boolean);
begin
  if FEnabled=AValue then Exit;
  FEnabled:=AValue;
  Changed;
end;

procedure TProjectRes2goRes.SetGoBuildMode(AValue: string);
begin
  if FGoBuildMode=AValue then Exit;
  FGoBuildMode:=AValue;
  Changed;
end;

procedure TProjectRes2goRes.SetGoEnabledCGO(AValue: Boolean);
begin
  if FGoEnabledCGO=AValue then Exit;
  FGoEnabledCGO:=AValue;
  Changed;
end;

procedure TProjectRes2goRes.SetGoEnabledFinalizerOn(AValue: Boolean);
begin
  if FGoEnabledFinalizerOn=AValue then Exit;
  FGoEnabledFinalizerOn:=AValue;
  Changed;
end;

procedure TProjectRes2goRes.SetGoRoot(AValue: string);
begin
  if FGoRoot=AValue then Exit;
  FGoRoot:=AValue;
  Changed;
end;

procedure TProjectRes2goRes.SetGoTags(AValue: string);
begin
  if FGoTags=AValue then Exit;
  FGoTags:=AValue;
  Changed;
end;

procedure TProjectRes2goRes.SetGoUseEmbed(AValue: Boolean);
begin
  if FGoUseEmbed=AValue then Exit;
  FGoUseEmbed:=AValue;
  Changed;
end;

procedure TProjectRes2goRes.SetGoUseTempdll(AValue: Boolean);
begin
  if FGoUseTempdll=AValue then Exit;
  FGoUseTempdll:=AValue;
  Changed;
end;

procedure TProjectRes2goRes.SetOutLang(AValue: TOutLang);
begin
  if FOutLang=AValue then Exit;
  FOutLang:=AValue;
  Changed;
end;

procedure TProjectRes2goRes.SetOutputPath(AValue: string);
begin
  if FOutputPath=AValue then Exit;
  FOutputPath:=AValue;
  Changed;
end;

procedure TProjectRes2goRes.SetPackageName(AValue: string);
begin
  if FPakcageName=AValue then Exit;
  FPakcageName:=AValue;
  Changed;
end;

procedure TProjectRes2goRes.SetSaveGfmFile(AValue: Boolean);
begin
  if FSaveGfmFile=AValue then Exit;
  FSaveGfmFile:=AValue;
  Changed;
end;

procedure TProjectRes2goRes.SetUseDefaultWinAppRes(AValue: Boolean);
begin
  if FUseDefaultWinAppRes=AValue then Exit;
  FUseDefaultWinAppRes:=AValue;
  Changed;
end;

procedure TProjectRes2goRes.SetUseOriginalFileName(AValue: Boolean);
begin
  if FUseOriginalFileName=AValue then Exit;
  FUseOriginalFileName:=AValue;
  Changed;
end;

function TProjectRes2goRes.UpdateResources(
  AResources: TAbstractProjectResources; const MainFilename: string): Boolean;
begin
  Result := True;
  if Assigned(MyIDEIntf) then
    MyIDEIntf.ReConvertRes:= True;
end;

procedure TProjectRes2goRes.WriteToProjectFile(AConfig: TObject;
  const Path: String);
begin
  with TXMLConfig(AConfig) do
  begin
    SetDeleteValue(Path+'Res2go/Enabled/Value', Enabled, False);
    SetDeleteValue(Path+'Res2go/OutputPath/Value', OutputPath, '');
    SetDeleteValue(Path+'Res2go/UseOriginalFileName/Value', UseOriginalFileName, False);
    SetDeleteValue(Path+'Res2go/SaveGfmFile/Value', SaveGfmFile, True);
    SetDeleteValue(Path+'Res2go/OutLang/Value', Integer(OutLang), 0);
    SetDeleteValue(Path+'Res2go/PackageName/Value', PackageName, 'main');
    SetDeleteValue(Path+'Res2go/UseDefaultWinAppRes/Value', UseDefaultWinAppRes, False);

    SetDeleteValue(Path+'Res2go/GoUseTempdll/Value', GoUseTempdll, False);
    SetDeleteValue(Path+'Res2go/GoEnabledFinalizerOn/Value', GoEnabledFinalizerOn, False);
    SetDeleteValue(Path+'Res2go/GoTags/Value', GoTags, '');
    SetDeleteValue(Path+'Res2go/GoEnabledCGO/Value', GoEnabledCGO, DefaultCGOValue);
    SetDeleteValue(Path+'Res2go/GoBuildMode/Value', GoBuildMode, '');
    SetDeleteValue(Path+'Res2go/GoRoot/Value', GoRoot, '');
    SetDeleteValue(Path+'Res2go/GoUseEmbed/Value', GoUseEmbed, True);
  end;
end;

procedure TProjectRes2goRes.ReadFromProjectFile(AConfig: TObject;
  const Path: String);
begin
  with TXMLConfig(AConfig) do
  begin
    Enabled := GetValue(Path+'Res2go/Enabled/Value', False);
    OutputPath := GetValue(Path+'Res2go/OutputPath/Value', 'gocode');
    UseOriginalFileName := GetValue(Path+'Res2go/UseOriginalFileName/Value', False);
    SaveGfmFile := GetValue(Path+'Res2go/SaveGfmFile/Value', True);
    OutLang := TOutLang(GetValue(Path+'Res2go/SaveGfmFile/Value', 0));
    PackageName := GetValue(Path+'Res2go/PackageName/Value', 'main');
    UseDefaultWinAppRes := GetValue(Path+'Res2go/UseDefaultWinAppRes/Value', False);

    GoUseTempdll := GetValue(Path+'Res2go/GoUseTempdll/Value', False);
    GoEnabledFinalizerOn := GetValue(Path+'Res2go/GoEnabledFinalizerOn/Value', False);
    GoTags := GetValue(Path+'Res2go/GoTags/Value', '');
    GoEnabledCGO := {$ifndef windows}True{$else}GetValue(Path+'Res2go/GoEnabledCGO/Value', False){$endif};
    GoBuildMode := GetValue(Path+'Res2go/GoBuildMode/Value', '');
    GoRoot := Trim(GetValue(Path+'Res2go/GoRoot/Value', GetEnvironmentVariable('GOROOT')));
    GoUseEmbed := GetValue(Path+'Res2go/GoUseEmbed/Value', True);
  end;

  if Assigned(MyIDEIntf) then
  begin
    MyIDEIntf.EnabledConvert := Enabled;
    MyIDEIntf.OutputPath := OutputPath;
    MyIDEIntf.UseOriginalFileName := UseOriginalFileName;
    MyIDEIntf.SaveGfmFile := SaveGfmFile;
    MyIDEIntf.OutLang := OutLang;
    MyIDEIntf.PackageName := PackageName;
    MyIDEIntf.UseDefaultWinAppRes := UseDefaultWinAppRes;

    MyIDEIntf.GoUseTempdll := GoUseTempdll;
    MyIDEIntf.GoEnabledFinalizerOn := GoEnabledFinalizerOn;
    MyIDEIntf.GoTags := GoTags;
    MyIDEIntf.GoEnabledCGO := GoEnabledCGO;
    MyIDEIntf.GoBuildMode := GoBuildMode;
    MyIDEIntf.GoRoot := GoRoot;
    MyIDEIntf.GoUseEmbed := GoUseEmbed;
  end;
end;




{ TRes2goOptionsFrame }

procedure TRes2goOptionsFrame.actSaveGfmExecute(Sender: TObject);
begin
  //
end;

procedure TRes2goOptionsFrame.actSaveGfmUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=not chkGoUseEmbed.Checked;
end;

constructor TRes2goOptionsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TRes2goOptionsFrame.Destroy;
begin
  inherited Destroy;
end;

function TRes2goOptionsFrame.GetTitle: string;
begin
  Result := 'Go Converter';
end;

procedure TRes2goOptionsFrame.Setup(ADialog: TAbstractOptionsEditorDialog);
begin
{$ifndef windows}
  chkGoEnabledCGO.Checked := True;
{$endif}
end;

procedure TRes2goOptionsFrame.ReadSettings(AOptions: TAbstractIDEOptions);
var
  LRes: TProjectRes2goRes;
begin
  if Assigned(MyIDEIntf) and Assigned(LazarusIDE) and Assigned(LazarusIDE.ActiveProject) and Assigned(LazarusIDE.ActiveProject.Resources) then
  begin
    LRes := TProjectRes2goRes(TAbstractProjectResources(LazarusIDE.ActiveProject.Resources).Resource[TProjectRes2goRes]);
    if Assigned(LRes) then
    begin
      MyIDEIntf.EnabledConvert := LRes.Enabled;
      MyIDEIntf.OutputPath := LRes.OutputPath;
      MyIDEIntf.UseOriginalFileName := LRes.UseOriginalFileName;
      MyIDEIntf.SaveGfmFile := LRes.SaveGfmFile;
      MyIDEIntf.OutLang := LRes.OutLang;
      MyIDEIntf.PackageName :=LRes.PackageName;
      MyIDEIntf.UseDefaultWinAppRes := LRes.UseDefaultWinAppRes;
      MyIDEIntf.GoUseTempdll := LRes.GoUseTempdll;
      MyIDEIntf.GoEnabledFinalizerOn :=LRes.GoEnabledFinalizerOn;
      MyIDEIntf.GoTags := LRes.GoTags;
      MyIDEIntf.GoEnabledCGO :=LRes.GoEnabledCGO;
      MyIDEIntf.GoBuildMode := LRes.GoBuildMode;
      MyIDEIntf.GoRoot := LRes.GoRoot;
      MyIDEIntf.GoUseEmbed:=LRes.GoUseEmbed;


      chkEanbledConvert.Checked := MyIDEIntf.EnabledConvert;
      EdtOutputPath.Text:= MyIDEIntf.OutputPath;
      ChkUseOriginalFileName.Checked:= MyIDEIntf.UseOriginalFileName;
      ChkSaveGfmFile.Checked := MyIDEIntf.SaveGfmFile;
      cbbLangs.ItemIndex:=Integer(MyIDEIntf.OutLang);
      EdtPkgName.Text:= MyIDEIntf.PackageName;
      chkUseDefaultWinAppRes.Checked:=MyIDEIntf.UseDefaultWinAppRes;
      chkGoUseTempdll.Checked:=LRes.GoUseTempdll;
      chkGoEnabledFinalizerOn.Checked:=LRes.GoEnabledFinalizerOn;
      EdtGoTags.Text:= LRes.GoTags;
      chkGoEnabledCGO.Checked:=LRes.GoEnabledCGO;
      cbbGoBuildModes.ItemIndex:=cbbGoBuildModes.Items.IndexOf(LRes.GoBuildMode);
      edtGoRoot.Text := Trim(LRes.GoRoot);
      chkGoUseEmbed.Checked:=LRes.GoUseEmbed;
    end;
  end;
end;

procedure TRes2goOptionsFrame.WriteSettings(AOptions: TAbstractIDEOptions);
var
  LRes: TProjectRes2goRes;
begin
  if Assigned(MyIDEIntf) and Assigned(LazarusIDE) and Assigned(LazarusIDE.ActiveProject) and Assigned(LazarusIDE.ActiveProject.Resources) then
  begin
    LRes := TProjectRes2goRes(TAbstractProjectResources(LazarusIDE.ActiveProject.Resources).Resource[TProjectRes2goRes]);
    if Assigned(LRes) then
    begin
      MyIDEIntf.EnabledConvert := chkEanbledConvert.Checked;
      MyIDEIntf.OutputPath:= EdtOutputPath.Text;
      MyIDEIntf.UseOriginalFileName:=chkUseOriginalFileName.Checked;
      MyIDEIntf.SaveGfmFile := chkSaveGfmFile.Checked;
      MyIDEIntf.OutLang:=TOutLang(cbbLangs.ItemIndex);
      MyIDEIntf.PackageName:= Trim(EdtPkgName.Text);
      if (not MyIDEIntf.UseDefaultWinAppRes) and chkUseDefaultWinAppRes.Checked then
        MyIDEIntf.ReConvertRes:= True;
      MyIDEIntf.UseDefaultWinAppRes := chkUseDefaultWinAppRes.Checked;

      MyIDEIntf.GoUseTempdll := chkGoUseTempdll.Checked;
      MyIDEIntf.GoEnabledFinalizerOn := chkGoEnabledFinalizerOn.Checked;
      MyIDEIntf.GoTags := EdtGoTags.Text;
      MyIDEIntf.GoEnabledCGO:=chkGoEnabledCGO.Checked;
      if cbbGoBuildModes.ItemIndex >= 0 then
        MyIDEIntf.GoBuildMode := cbbGoBuildModes.Items[cbbGoBuildModes.ItemIndex]
      else
        MyIDEIntf.GoBuildMode := '';
      MyIDEIntf.GoRoot := Trim(edtGoRoot.Text);
      MyIDEIntf.GoUseEmbed:=chkGoUseEmbed.Checked;

      LRes.OutputPath := MyIDEIntf.OutputPath;
      LRes.Enabled := MyIDEIntf.EnabledConvert;
      LRes.UseOriginalFileName := MyIDEIntf.UseOriginalFileName;
      LRes.SaveGfmFile := MyIDEIntf.SaveGfmFile;
      LRes.OutLang:=MyIDEIntf.OutLang;
      LRes.PackageName:=MyIDEIntf.PackageName;
      LRes.UseDefaultWinAppRes := MyIDEIntf.UseDefaultWinAppRes;

      LRes.GoUseTempdll:=MyIDEIntf.GoUseTempdll;
      LRes.GoEnabledFinalizerOn:=MyIDEIntf.GoEnabledFinalizerOn;
      LRes.GoTags := MyIDEIntf.GoTags;
      LRes.GoEnabledCGO:=MyIDEIntf.GoEnabledCGO;
      LRes.GoBuildMode:=MyIDEIntf.GoBuildMode;
      LRes.GoRoot:= MyIDEIntf.GoRoot;
      LRes.GoUseEmbed:=MyIDEIntf.GoUseEmbed;
    end;
  end;
end;

class function TRes2goOptionsFrame.SupportedOptionsClass: TAbstractIDEOptionsClass;
begin
  Result := nil;//TProjectIDEOptions;
end;

initialization
  //RegisterIDEOptionsGroup(GroupProject, TRes2goIDEOptions);
  RegisterProjectResource(TProjectRes2goRes);
  RegisterIDEOptionsEditor(GroupProject, TRes2goOptionsFrame, ProjectOptionsRes2go);

end.

