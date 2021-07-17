{*******************************************************************************
*  Copyright (c) 2021 Jesse Jin Authors. All rights reserved.                  *
*                                                                              *
*  Use of this source code is governed by a MIT-style                          *
*  license that can be found in the LICENSE file.                              *
*                                                                              *
*  版权由作者 Jesse Jin 所有。                                                 *
*  此源码的使用受 MIT 开源协议约束，详见 LICENSE 文件。                        *
*******************************************************************************}

//海康威视设备封装
unit HIKDevice;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows, LConvEncoding, Graphics, HCNetSDK;

type
  //海康异常类
  EHIKError = class(Exception);

  //海康设备登录信息
  THIKLoginInfo = record
    IP: string;
    Port: word;
    User: string;
    Password: string;
  end;

  { THIKDeviceBase }

  //海康设备基础类
  THIKDeviceBase = class
  private
    mInited: boolean;          //初始化状态
    FLoginInfo: THIKLoginInfo; //登录信息
    function GetIsLogin: boolean;
  protected
    mUserID: LONG;                       //登录ID
    mDeviceInfo: NET_DVR_DEVICEINFO_V30; //设备信息
  public
    constructor Create;
    destructor Destroy; override;
    //登录
    function Login(ALoginInfo: THIKLoginInfo): boolean; virtual;
    //登出
    procedure Logout; virtual;
    //登录信息
    property LoginInfo: THIKLoginInfo read FLoginInfo;
    //是否已登录
    property IsLogin: boolean read GetIsLogin;
  end;

  { THIKIPCDevice }

  //海康IPC设备
  THIKIPCDevice = class(THIKDeviceBase)
  private
    mPlayPort: LONG; //播放库通道号
    function GetIsRealPlay: boolean;
  protected
    mRealHandle: LONG;                 //预览句柄
    mPreviewInfo: NET_DVR_PREVIEWINFO; //预览参数
    mJpegPara: NET_DVR_JPEGPARA;       //设备抓图参数
  public
    constructor Create;
    destructor Destroy; override;
    //登出
    procedure Logout; override;
    //打开预览
    procedure OpenPreview(AViewWindowHandle: HWND);
    //关闭预览
    procedure ClosePreview;
    //预览抓图并存为文件
    function SaveRealPic(APicName: string): boolean;
    //设备抓图并存为文件
    function SavePic(APicName: string): boolean; overload;
    //设备抓图并存入流
    function SavePic(out AStream: TMemoryStream): boolean; overload;
    //设备抓图并存入jpg对象
    function SavePic(out AJpgPic: TJPEGImage): boolean; overload;
    //是否正在实时预览
    property IsRealPlay: boolean read GetIsRealPlay;
  end;

//初始化SDK，只有在返回值为真的情况下才能使用该封装模块的功能
function InitSDK(ALibName: string = ''): boolean;

//释放SDK
function UnInitSDK: boolean;

implementation

var
  SDKReadied: boolean = False;

function InitSDK(ALibName: string): boolean;
begin
  if not SDKReadied then
    SDKReadied := LoadHCNetSDK(ALibName);
  Result := SDKReadied;
end;

function UnInitSDK: boolean;
begin
  if SDKReadied then
    SDKReadied := not UnLoadHCNetSDK;
  Result := not SDKReadied;
end;

{ THIKIPCDevice }

function THIKIPCDevice.GetIsRealPlay: boolean;
begin
  Result := mRealHandle >= 0;
end;

constructor THIKIPCDevice.Create;
begin
  inherited Create;
  mRealHandle := -1;
  mPlayPort := -1;
  FillChar(mPreviewInfo, SizeOf(NET_DVR_PREVIEWINFO), 0);
  mJpegPara.wPicSize := $FF;  //抓图尺寸 $FF-使用当前码流分辨率
  mJpegPara.wPicQuality := 0; //抓图质量 0-最好
end;

destructor THIKIPCDevice.Destroy;
begin
  inherited Destroy;
end;

procedure THIKIPCDevice.Logout;
begin
  ClosePreview;
  inherited Logout;
end;

procedure THIKIPCDevice.OpenPreview(AViewWindowHandle: HWND);
begin
  if not IsLogin then
    Exit;
  if IsRealPlay then
    Exit;
  //设置预览参数
  mPreviewInfo.lChannel := 1;                 //通道
  mPreviewInfo.dwStreamType := 0;             //主码流
  mPreviewInfo.dwLinkMode := 0;               //使用TCP连接
  mPreviewInfo.hPlayWnd := AViewWindowHandle; //播放句柄
  //设置预览抓图格式为 jpg
  NET_DVR_SetCapturePictureMode(Ord(JPEG_MODE));
  //开始预览
  mRealHandle := NET_DVR_RealPlay_V40(mUserID, @mPreviewInfo, nil, nil);
end;

procedure THIKIPCDevice.ClosePreview;
begin
  if not IsRealPlay then
    Exit;
  if NET_DVR_StopRealPlay(mRealHandle) then
    mRealHandle := -1;
end;

function THIKIPCDevice.SaveRealPic(APicName: string): boolean;
begin
  Result := False;
  if not IsRealPlay then
    Exit;
  Result := NET_DVR_CapturePictureBlock(mRealHandle,
    PAnsiChar(UTF8ToCP936(APicName)), 0);
end;

function THIKIPCDevice.SavePic(APicName: string): boolean;
begin
  Result := False;
  if not IsLogin then
    Exit;
  Result := NET_DVR_CaptureJPEGPicture(mUserID, 1, @mJpegPara,
    PAnsiChar(UTF8ToCP936(APicName)));
end;

function THIKIPCDevice.SavePic(out AStream: TMemoryStream): boolean;
var
  tmpBuff: array[0..400 * 1024 - 1] of byte; //最大差不多只能450K
  DataLen: DWORD;
begin
  Result := False;
  if not IsLogin then
    Exit;
  if NET_DVR_CaptureJPEGPicture_NEW(mUserID, 1, @mJpegPara, @tmpBuff,
    SizeOf(tmpBuff), @DataLen) then
  begin
    AStream.Clear;
    AStream.Write(tmpBuff, DataLen);
    AStream.Position := 0;
    Result := True;
  end;
end;

function THIKIPCDevice.SavePic(out AJpgPic: TJPEGImage): boolean;
var
  ms: TMemoryStream;
begin
  Result := False;
  ms := TMemoryStream.Create;
  try
    if SavePic(ms) then
    begin
      AJpgPic.Clear;
      AJpgPic.LoadFromStream(ms);
      Result := True;
    end;
  finally
    ms.Free;
  end;
end;

{ THIKDeviceBase }

function THIKDeviceBase.GetIsLogin: boolean;
begin
  Result := mUserID >= 0;
end;

constructor THIKDeviceBase.Create;
begin
  if not SDKReadied then
    raise EHIKError.Create('海康动态库加载失败');
  mInited := NET_DVR_Init();
  mUserID := -1;
  FillChar(mDeviceInfo, SizeOf(NET_DVR_DEVICEINFO_V30), 0);
end;

destructor THIKDeviceBase.Destroy;
begin
  Logout;
  if mInited then
    mInited := not NET_DVR_Cleanup();
  inherited Destroy;
end;

function THIKDeviceBase.Login(ALoginInfo: THIKLoginInfo): boolean;
begin
  Result := False;
  if not mInited then
    Exit;
  //设置重连参数
  NET_DVR_SetConnectTime();
  NET_DVR_SetReconnect();
  if IsLogin then
    Exit;
  mUserID := NET_DVR_Login_V30(PAnsiChar(UTF8ToCP936(ALoginInfo.IP)),
    ALoginInfo.Port, PAnsiChar(UTF8ToCP936(ALoginInfo.User)),
    PAnsiChar(UTF8ToCP936(ALoginInfo.Password)), @mDeviceInfo);
  Result := IsLogin;
  if Result then
    FLoginInfo := ALoginInfo;
end;

procedure THIKDeviceBase.Logout;
begin
  if not mInited then
    Exit;
  if not IsLogin then
    Exit;
  if NET_DVR_Logout(mUserID) then
    mUserID := -1;
end;

initialization

finalization
  begin
    //释放动态库
    UnInitSDK;
  end;

end.
