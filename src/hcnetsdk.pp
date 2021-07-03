{*******************************************************************************
*  Copyright (c) 2021 Jesse Jin Authors. All rights reserved.                  *
*                                                                              *
*  Use of this source code is governed by a MIT-style                          *
*  license that can be found in the LICENSE file.                              *
*                                                                              *
*  版权由作者 Jesse Jin 所有。                                                 *
*  此源码的使用受 MIT 开源协议约束，详见 LICENSE 文件。                        *
*******************************************************************************}

// 海康威视网络设备SDK
unit HCNetSDK;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Windows;

{$i hcnetsdkconst.inc}
{$i hcnetsdkstruct.inc}

type
  {======== 回调函数声明 ======================================================}

  //异常回调
  ExceptionCallBack = procedure(dwType: DWORD; lUserID, lHandle: LONG;
    pUser: PVOID); stdcall;
  //码流数据回调函数
  RealDataCallBack = procedure(lRealHandle: LONG; dwDataType: DWORD;
    pBuffer: Pointer; dwBufSize: DWORD; pUser: PVOID); stdcall;
  RealDataCallBack_V30 = procedure(lRealHandle: LONG; dwDataType: DWORD;
    pBuffer: Pointer; dwBufSize: DWORD; pUser: PVOID); stdcall;
  //透明通道回调函数
  SerialDataCallBack = procedure(lSerialHandle: LONG; pRecvDataBuffer: Pointer;
    dwBufSize, dwUser: DWORD); stdcall;
  fSerialDataCallBack = procedure(lSerialHandle, lChannel: LONG;
    pRecvDataBuffer: Pointer; dwBufSize: DWORD; pUser: PVOID); stdcall;
  //报警回调函数
  MSGCallBack = procedure(lCommand: LONG; pAlarmer: LPNET_DVR_ALARMER;
    pAlarmInfo: Pointer; dwBufLen: DWORD; pUser: PVOID); stdcall;

var
  {======== 接口函数 ==========================================================}

  {-------- 通用接口 ----------------------------------------------------------}

  //初始化SDK
  NET_DVR_Init: function(): BOOL; stdcall;
  //释放SDK资源
  NET_DVR_Cleanup: function(): BOOL; stdcall;
  //返回最后操作的错误码
  NET_DVR_GetLastError: function(): DWORD; stdcall;
  //设置SDK网络连接超时时间和连接尝试次数
  NET_DVR_SetConnectTime: function(dwWaitTime: DWORD = 3000;
  dwTryTimes: DWORD = 3): BOOL; stdcall;
  //设置SDK重连功能
  NET_DVR_SetReconnect: function(dwInterval: DWORD = 10000;
  bEnableRecon: BOOL = True): BOOL; stdcall;
  //设置接收超时时间
  NET_DVR_SetRecvTimeOut: function(nRecvTimeOut: DWORD = 5000): BOOL; stdcall;
  //注册接收异常、重连等消息的窗口句柄
  NET_DVR_SetDVRMessage: function(nMessage: UINT; hWin: HWND): BOOL; stdcall;
  //注册接收异常、重连等消息的窗口句柄或回调函数
  NET_DVR_SetExceptionCallBack_V30: function(nMessage: UINT; hWin: HWND;
  cbExceptionCallBack: ExceptionCallBack; pUser: PVOID): BOOL; stdcall;
  //获取SDK的版本信息
  NET_DVR_GetSDKVersion: function(): DWORD; stdcall;
  //获取当前SDK的状态信息
  NET_DVR_GetSDKState: function(pSDKState: LPNET_DVR_SDKSTATE): BOOL; stdcall;
  //获取当前SDK的功能信息
  NET_DVR_GetSDKAbility: function(pSDKAbl: LPNET_DVR_SDKABL): BOOL; stdcall;
  //启用SDK写日志文件
  NET_DVR_SetLogToFile: function(nLogLevel: DWORD = 0; strLogDir: PAnsiChar = nil;
  bAutoDel: BOOL = True): BOOL; stdcall;

  {-------- 登录/登出 ---------------------------------------------------------}

  //登录
  NET_DVR_Login: function(sDVRIP: PAnsiChar; wDVRPort: word;
  sUserName, sPassword: PAnsiChar; lpDeviceInfo: LPNET_DVR_DEVICEINFO): LONG; stdcall;
  NET_DVR_Login_V30: function(sDVRIP: PAnsiChar; wDVRPort: word;
  sUserName, sPassword: PAnsiChar; lpDeviceInfo: LPNET_DVR_DEVICEINFO_V30): LONG;
  stdcall;
  NET_DVR_Login_V40: function(pLoginInfo: LPNET_DVR_USER_LOGIN_INFO;
  lpDeviceInfo: LPNET_DVR_DEVICEINFO_V40): LONG; stdcall;
  //登出
  NET_DVR_Logout: function(lUserID: LONG): BOOL; stdcall;
  NET_DVR_Logout_V30: function(lUserID: LONG): BOOL; stdcall;

  {-------- 参数配置 ----------------------------------------------------------}

  //获取设备的配置信息
  NET_DVR_GetDVRConfig: function(lUserID: LONG; dwCommand: DWORD;
  lChannel: LONG; lpOutBuffer: LPVOID; dwOutBufferSize: DWORD;
  lpBytesReturned: LPDWORD): BOOL;
  stdcall;
  //设置设备的配置信息
  NET_DVR_SetDVRConfig: function(lUserID: LONG; dwCommand: DWORD;
  lChannel: LONG; lpInBuffer: LPVOID; dwInBufferSize: DWORD): BOOL; stdcall;

  {-------- 设备抓图 ----------------------------------------------------------}

  //单帧数据捕获并保存成JPEG图
  NET_DVR_CaptureJPEGPicture: function(lUserID, lChannel: LONG;
  lpJpegPara: LPNET_DVR_JPEGPARA; sPicFileName: PAnsiChar): BOOL; stdcall;
  //单帧数据捕获并保存成JPEG存放在指定的内存空间中
  NET_DVR_CaptureJPEGPicture_NEW: function(lUserID, lChannel: LONG;
  lpJpegPara: LPNET_DVR_JPEGPARA; sJpegPicBuffer: Pointer; dwPicSize: DWORD;
  lpSizeReturned: LPDWORD): BOOL; stdcall;

  {-------- 实时预览 ----------------------------------------------------------}

  //实时预览
  NET_DVR_RealPlay: function(lUserID: LONG; lpClientInfo: LPNET_DVR_CLIENTINFO): LONG;
  stdcall;
  NET_DVR_RealPlay_V30: function(lUserID: LONG; lpClientInfo: LPNET_DVR_CLIENTINFO;
  cbRealDataCallBack: RealDataCallBack_V30; pUser: PVOID; bBlocked: BOOL): LONG;
  stdcall;
  NET_DVR_RealPlay_V40: function(lUserID: LONG; lpPreviewInfo: LPNET_DVR_PREVIEWINFO;
  fRealDataCallBack_V30: RealDataCallBack; pUser: PVOID): LONG; stdcall;
  //停止预览
  NET_DVR_StopRealPlay: function(lRealHandle: LONG): BOOL; stdcall;
  //设置声音播放模式
  NET_DVR_SetAudioMode: function(dwMode: DWORD): BOOL; stdcall;
  //独占声卡模式下开启声音
  NET_DVR_OpenSound: function(lRealHandle: LONG): BOOL; stdcall;
  //独占声卡模式下关闭声音
  NET_DVR_CloseSound: function(): BOOL; stdcall;
  //共享声卡模式下开启声音
  NET_DVR_OpenSoundShare: function(lRealHandle: LONG): BOOL; stdcall;
  //共享声卡模式下关闭声音
  NET_DVR_CloseSoundShare: function(): BOOL; stdcall;
  //调节播放音量
  NET_DVR_Volume: function(lRealHandle: LONG; wVolume: word): BOOL; stdcall;
  //设置抓图模式
  NET_DVR_SetCapturePictureMode: function(dwCaptureMode: DWORD): BOOL; stdcall;
  //预览时抓图并保存在指定内存中
  NET_DVR_CapturePictureBlock_New: function(lRealHandle: LONG;
  pPicBuf: Pointer; dwPicSize: DWORD; lpSizeReturned: LPDWORD): BOOL; stdcall;
  //预览时抓图并保存成图片文件
  NET_DVR_CapturePictureBlock: function(lRealHandle: LONG;
  const sPicFileName: PAnsiChar; dwTimeOut: DWORD): BOOL; stdcall;
  //预览时单帧数据捕获并保存成图片
  NET_DVR_CapturePicture: function(lRealHandle: LONG;
  sPicFileName: PAnsiChar): BOOL; stdcall;
  //视频录像
  NET_DVR_SaveRealData: function(lRealHandle: LONG; sFileName: PAnsiChar): BOOL;
  stdcall;
  //按指定的目标封装格式进行视频录像
  NET_DVR_SaveRealData_V30: function(lRealHandle: LONG; dwTransType: STREAM_TYPE;
  sFileName: PAnsiChar): BOOL; stdcall;
  //停止视频录像
  NET_DVR_StopSaveRealData: function(lRealHandle: LONG): BOOL; stdcall;

  {-------- 数据透传 ----------------------------------------------------------}

  //建立透明通道
  NET_DVR_SerialStart: function(lUserID, lSerialPort: LONG;
  cbSerialDataCallBack: SerialDataCallBack; dwUser: DWORD): LONG;
  stdcall;
  NET_DVR_SerialStart_V40: function(lUserID: LONG; lpInBuffer: PVOID;
  dwInBufferSize: LONG; cbSerialDataCallBack: fSerialDataCallBack; pUser: PVOID): LONG;
  stdcall;
  //通过透明通道向设备串口发送数据
  NET_DVR_SerialSend: function(lSerialHandle, lChannel: LONG;
  pSendBuf: PVOID; dwBufSize: DWORD): BOOL; stdcall;
  //断开透明通道
  NET_DVR_SerialStop: function(lSerialHandle: LONG): BOOL; stdcall;
  //直接向串口发送数据，不需要建立透明通道
  NET_DVR_SendToSerialPort: function(lUserID: LONG; dwSerialPort, dwSerialIndex: DWORD;
  pSendBuf: PVOID; dwBufSize: DWORD): BOOL; stdcall;
  //直接向232串口发送数据，不需要建立透明通道
  NET_DVR_SendTo232Port: function(lUserID: LONG; pSendBuf: PVOID;
  dwBufSize: DWORD): BOOL; stdcall;

  {-------- 报警 --------------------------------------------------------------}

  //注册回调函数，接收设备报警消息等
  NET_DVR_SetDVRMessageCallBack_V30: function(fMessageCallBack: MSGCallBack;
  pUser: PVOID): BOOL; stdcall;
  NET_DVR_SetDVRMessageCallBack_V31: function(fMessageCallBack: MSGCallBack;
  pUser: PVOID): BOOL; stdcall;
  NET_DVR_SetDVRMessageCallBack_V50: function(iIndex: integer;
  fMessageCallBack: MSGCallBack; pUser: PVOID): BOOL; stdcall;
  //建立报警上传通道，获取报警等信息
  NET_DVR_SetupAlarmChan: function(lUserID: LONG): LONG; stdcall;
  NET_DVR_SetupAlarmChan_V30: function(lUserID: LONG): LONG; stdcall;
  NET_DVR_SetupAlarmChan_V41: function(lUserID: LONG;
  lpSetupParam: LPNET_DVR_SETUPALARM_PARAM): LONG; stdcall;
  NET_DVR_SetupAlarmChan_V50: function(lUserID: LONG;
  lpSetupParam: LPNET_DVR_SETUPALARM_PARAM_V50; const sPicFileName: PAnsiChar;
  dwDataLen: DWORD): LONG; stdcall;
  //撤销报警上传通道
  NET_DVR_CloseAlarmChan: function(lAlarmHandle: LONG): BOOL; stdcall;
  NET_DVR_CloseAlarmChan_V30: function(lAlarmHandle: LONG): BOOL; stdcall;
  //启动监听，接收设备主动上传的报警等信息
  NET_DVR_StartListen: function(sLocalIP: PAnsiChar; wLocalPort: word): BOOL;
  stdcall;
  //启动监听，接收设备主动上传的报警等信息（支持多线程）
  NET_DVR_StartListen_V30: function(sLocalIP: PAnsiChar; wLocalPort: word;
  DataCallback: MSGCallBack; pUser: PVOID): LONG; stdcall;
  //停止监听
  NET_DVR_StopListen: function(): BOOL; stdcall;
  //停止监听（支持多线程）
  NET_DVR_StopListen_V30: function(lListenHandle: LONG): BOOL; stdcall;

function LoadHCNetSDK(ALibName: string = ''): boolean;
function UnLoadHCNetSDK: boolean;

implementation

const
  DEFAULT_LIB_NAME = 'HCNetSDK.dll';

var
  hLibHandle: TLibHandle = 0;

function LoadHCNetSDK(ALibName: string): boolean;
begin
  if hLibHandle <> 0 then
  begin
    Result := True;
    Exit;
  end;
  if ALibName = '' then
    ALibName := DEFAULT_LIB_NAME;
  hLibHandle := System.LoadLibrary(UTF8Decode(ALibName));
  Result := hLibHandle <> 0;
  if Result then
  begin
    //通用接口
    Pointer(NET_DVR_Init) := GetProcedureAddress(hLibHandle, 'NET_DVR_Init');
    Pointer(NET_DVR_Cleanup) := GetProcedureAddress(hLibHandle, 'NET_DVR_Cleanup');
    Pointer(NET_DVR_GetLastError) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_GetLastError');
    Pointer(NET_DVR_SetConnectTime) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetConnectTime');
    Pointer(NET_DVR_SetReconnect) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetReconnect');
    Pointer(NET_DVR_SetRecvTimeOut) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetRecvTimeOut');
    Pointer(NET_DVR_SetDVRMessage) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetDVRMessage');
    Pointer(NET_DVR_SetExceptionCallBack_V30) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetExceptionCallBack_V30');
    Pointer(NET_DVR_GetSDKVersion) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_GetSDKVersion');
    Pointer(NET_DVR_GetSDKState) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_GetSDKState');
    Pointer(NET_DVR_GetSDKAbility) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_GetSDKAbility');
    Pointer(NET_DVR_SetLogToFile) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetLogToFile');

    //登录/登出
    Pointer(NET_DVR_Login) := GetProcedureAddress(hLibHandle, 'NET_DVR_Login');
    Pointer(NET_DVR_Login_V30) := GetProcedureAddress(hLibHandle, 'NET_DVR_Login_V30');
    Pointer(NET_DVR_Login_V40) := GetProcedureAddress(hLibHandle, 'NET_DVR_Login_V40');
    Pointer(NET_DVR_Logout) := GetProcedureAddress(hLibHandle, 'NET_DVR_Logout');
    Pointer(NET_DVR_Logout_V30) := GetProcedureAddress(hLibHandle, 'NET_DVR_Logout_V30');

    //参数配置
    Pointer(NET_DVR_GetDVRConfig) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_GetDVRConfig');
    Pointer(NET_DVR_SetDVRConfig) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetDVRConfig');

    //设备抓图
    Pointer(NET_DVR_CaptureJPEGPicture) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_CaptureJPEGPicture');
    Pointer(NET_DVR_CaptureJPEGPicture_NEW) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_CaptureJPEGPicture_NEW');

    //实时预览
    Pointer(NET_DVR_RealPlay) := GetProcedureAddress(hLibHandle, 'NET_DVR_RealPlay');
    Pointer(NET_DVR_RealPlay_V30) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_RealPlay_V30');
    Pointer(NET_DVR_RealPlay_V40) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_RealPlay_V40');
    Pointer(NET_DVR_StopRealPlay) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_StopRealPlay');
    Pointer(NET_DVR_SetAudioMode) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetAudioMode');
    Pointer(NET_DVR_OpenSound) := GetProcedureAddress(hLibHandle, 'NET_DVR_OpenSound');
    Pointer(NET_DVR_CloseSound) := GetProcedureAddress(hLibHandle, 'NET_DVR_CloseSound');
    Pointer(NET_DVR_OpenSoundShare) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_OpenSoundShare');
    Pointer(NET_DVR_CloseSoundShare) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_CloseSoundShare');
    Pointer(NET_DVR_Volume) := GetProcedureAddress(hLibHandle, 'NET_DVR_Volume');
    Pointer(NET_DVR_SetCapturePictureMode) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetCapturePictureMode');
    Pointer(NET_DVR_CapturePictureBlock_New) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_CapturePictureBlock_New');
    Pointer(NET_DVR_CapturePictureBlock) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_CapturePictureBlock');
    Pointer(NET_DVR_CapturePicture) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_CapturePicture');
    Pointer(NET_DVR_SaveRealData) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SaveRealData');
    Pointer(NET_DVR_SaveRealData_V30) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SaveRealData_V30');
    Pointer(NET_DVR_StopSaveRealData) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_StopSaveRealData');

    //数据透传
    Pointer(NET_DVR_SerialStart) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SerialStart');
    Pointer(NET_DVR_SerialStart_V40) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SerialStart_V40');
    Pointer(NET_DVR_SerialSend) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SerialSend');
    Pointer(NET_DVR_SerialStop) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SerialStop');
    Pointer(NET_DVR_SendToSerialPort) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SendToSerialPort');
    Pointer(NET_DVR_SendTo232Port) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SendTo232Port');

    //报警
    Pointer(NET_DVR_SetDVRMessageCallBack_V30) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetDVRMessageCallBack_V30');
    Pointer(NET_DVR_SetDVRMessageCallBack_V31) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetDVRMessageCallBack_V31');
    Pointer(NET_DVR_SetDVRMessageCallBack_V50) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetDVRMessageCallBack_V50');
    Pointer(NET_DVR_SetupAlarmChan) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetupAlarmChan');
    Pointer(NET_DVR_SetupAlarmChan_V30) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetupAlarmChan_V30');
    Pointer(NET_DVR_SetupAlarmChan_V41) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetupAlarmChan_V41');
    Pointer(NET_DVR_SetupAlarmChan_V50) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_SetupAlarmChan_V50');
    Pointer(NET_DVR_CloseAlarmChan) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_CloseAlarmChan');
    Pointer(NET_DVR_CloseAlarmChan_V30) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_CloseAlarmChan_V30');
    Pointer(NET_DVR_StartListen) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_StartListen');
    Pointer(NET_DVR_StartListen_V30) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_StartListen_V30');
    Pointer(NET_DVR_StopListen) := GetProcedureAddress(hLibHandle, 'NET_DVR_StopListen');
    Pointer(NET_DVR_StopListen_V30) :=
      GetProcedureAddress(hLibHandle, 'NET_DVR_StopListen_V30');
  end;
end;

function UnLoadHCNetSDK: boolean;
begin
  if hLibHandle <> 0 then
  begin
    if System.UnloadLibrary(hLibHandle) then
    begin
      hLibHandle := 0;

      //通用接口
      NET_DVR_Init := nil;
      NET_DVR_Cleanup := nil;
      NET_DVR_GetLastError := nil;
      NET_DVR_SetConnectTime := nil;
      NET_DVR_SetReconnect := nil;
      NET_DVR_SetRecvTimeOut := nil;
      NET_DVR_SetDVRMessage := nil;
      NET_DVR_SetExceptionCallBack_V30 := nil;
      NET_DVR_GetSDKVersion := nil;
      NET_DVR_GetSDKState := nil;
      NET_DVR_GetSDKAbility := nil;
      NET_DVR_SetLogToFile := nil;

      //登录/登出
      NET_DVR_Login := nil;
      NET_DVR_Login_V30 := nil;
      NET_DVR_Login_V40 := nil;
      NET_DVR_Logout := nil;
      NET_DVR_Logout_V30 := nil;

      //参数配置
      NET_DVR_GetDVRConfig := nil;
      NET_DVR_SetDVRConfig := nil;

      //设备抓图
      NET_DVR_CaptureJPEGPicture := nil;
      NET_DVR_CaptureJPEGPicture_NEW := nil;

      //实时预览
      NET_DVR_RealPlay := nil;
      NET_DVR_RealPlay_V30 := nil;
      NET_DVR_RealPlay_V40 := nil;
      NET_DVR_StopRealPlay := nil;
      NET_DVR_SetAudioMode := nil;
      NET_DVR_OpenSound := nil;
      NET_DVR_CloseSound := nil;
      NET_DVR_OpenSoundShare := nil;
      NET_DVR_CloseSoundShare := nil;
      NET_DVR_Volume := nil;
      NET_DVR_SetCapturePictureMode := nil;
      NET_DVR_CapturePictureBlock_New := nil;
      NET_DVR_CapturePictureBlock := nil;
      NET_DVR_CapturePicture := nil;
      NET_DVR_SaveRealData := nil;
      NET_DVR_SaveRealData_V30 := nil;
      NET_DVR_StopSaveRealData := nil;

      //数据透传
      NET_DVR_SerialStart := nil;
      NET_DVR_SerialStart_V40 := nil;
      NET_DVR_SerialSend := nil;
      NET_DVR_SerialStop := nil;
      NET_DVR_SendToSerialPort := nil;
      NET_DVR_SendTo232Port := nil;

      //报警
      NET_DVR_SetDVRMessageCallBack_V30 := nil;
      NET_DVR_SetDVRMessageCallBack_V31 := nil;
      NET_DVR_SetDVRMessageCallBack_V50 := nil;
      NET_DVR_SetupAlarmChan := nil;
      NET_DVR_SetupAlarmChan_V30 := nil;
      NET_DVR_SetupAlarmChan_V41 := nil;
      NET_DVR_SetupAlarmChan_V50 := nil;
      NET_DVR_CloseAlarmChan := nil;
      NET_DVR_CloseAlarmChan_V30 := nil;
      NET_DVR_StartListen := nil;
      NET_DVR_StartListen_V30 := nil;
      NET_DVR_StopListen := nil;
      NET_DVR_StopListen_V30 := nil;
    end;
  end;
  Result := hLibHandle = 0;
end;

end.

