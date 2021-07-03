{*******************************************************************************
*  Copyright (c) 2021 Jesse Jin Authors. All rights reserved.                  *
*                                                                              *
*  Use of this source code is governed by a MIT-style                          *
*  license that can be found in the LICENSE file.                              *
*                                                                              *
*  版权由作者 Jesse Jin 所有。                                                 *
*  此源码的使用受 MIT 开源协议约束，详见 LICENSE 文件。                        *
*******************************************************************************}

// 海康威视网络设备SDK结构体定义
type
  //SDK状态信息结构体
  NET_DVR_SDKSTATE = packed record
    dwTotalLoginNum: DWORD;      //当前注册的用户数
    dwTotalRealPlayNum: DWORD;   //当前实时预览的路数
    dwTotalPlayBackNum: DWORD;   //当前回放或下载的路数
    dwTotalAlarmChanNum: DWORD;  //当前建立报警通道的路数
    dwTotalFormatNum: DWORD;     //当前硬盘格式化的路数
    dwTotalFileSearchNum: DWORD; //当前文件搜索的路数
    dwTotalLogSearchNum: DWORD;  //当前日志搜索的路数
    dwTotalSerialNum: DWORD;     //当前建立透明通道的路数
    dwTotalUpgradeNum: DWORD;    //当前升级的路数
    dwTotalVoiceComNum: DWORD;   //当前语音转发的路数
    dwTotalBroadCastNum: DWORD;  //当前语音广播的路数
    dwRes: array[0..9] of DWORD; //保留，置为0
  end;
  LPNET_DVR_SDKSTATE = ^NET_DVR_SDKSTATE;

  //SDK功能信息结构体
  NET_DVR_SDKABL = packed record
    dwMaxLoginNum: DWORD;        //最大注册用户数
    dwMaxRealPlayNum: DWORD;     //最大实时预览的路数
    dwMaxPlayBackNum: DWORD;     //最大回放或下载的路数
    dwMaxAlarmChanNum: DWORD;    //最大建立报警通道的路数
    dwMaxFormatNum: DWORD;       //最大硬盘格式化的路数
    dwMaxFileSearchNum: DWORD;   //最大文件搜索的路数
    dwMaxLogSearchNum: DWORD;    //最大日志搜索的路数
    dwMaxSerialNum: DWORD;       //最大建立透明通道的路数
    dwMaxUpgradeNum: DWORD;      //最大升级的路数
    dwMaxVoiceComNum: DWORD;     //最大语音转发的路数
    dwMaxBroadCastNum: DWORD;    //最大语音广播的路数
    dwRes: array[0..9] of DWORD; //保留，置为0
  end;
  LPNET_DVR_SDKABL = ^NET_DVR_SDKABL;

  //设备参数结构体
  NET_DVR_DEVICEINFO = packed record
    sSerialNumber: array[0..SERIALNO_LEN - 1] of byte; //序列号
    byAlarmInPortNum: byte;                            //模拟报警输入个数
    byAlarmOutPortNum: byte;                           //模拟报警输出个数
    byDiskNum: byte;                                   //硬盘个数
    byDVRType: byte;                                   //设备类型
    byChanNum: byte;                                   //设备模拟通道个数
    byStartChan: byte;                                 //起始通道号，目前设备通道号从1开始
  end;
  LPNET_DVR_DEVICEINFO = ^NET_DVR_DEVICEINFO;

  //设备参数结构体
  NET_DVR_DEVICEINFO_V30 = packed record
    sSerialNumber: array[0..SERIALNO_LEN - 1] of Byte; //序列号
    byAlarmInPortNum: Byte;                            //模拟报警输入个数
    byAlarmOutPortNum: Byte;                           //模拟报警输出个数
    byDiskNum: Byte;                                   //硬盘个数
    byDVRType: Byte;                                   //设备类型
    byChanNum: Byte;                                   //设备模拟通道个数，数字(IP)通道最大个数为byIPChanNum+byHighDChanNum*256
    byStartChan: Byte;                                 //模拟通道的起始通道号，从1开始
    byAudioChanNum: Byte;                              //设备语音对讲通道数
    byIPChanNum: Byte;                                 //设备最大数字通道个数，低8位
    byZeroChanNum: Byte;                               //零通道编码个数
    byMainProto: Byte;                                 //主码流传输协议类型：0-private，1-rtsp，2-同时支持私有协议和rtsp协议取流(默认采用私有协议取流)
    bySubProto: Byte;                                  //子码流传输协议类型：0-private，1-rtsp，2-同时支持私有协议和rtsp协议取流(默认采用私有协议取流)
    bySupport: Byte;                                   //能力
    bySupport1: Byte;                                  //能力集扩充
    bySupport2: Byte;                                  //能力集扩充
    wDevType: Word;                                    //设备型号
    bySupport3: Byte;                                  //能力集扩展
    byMultiStreamProto: Byte;                          //是否支持多码流
    byStartDChan: Byte;                                //起始数字通道号，0表示无数字通道，比如DVR或IPC
    byStartDTalkChan: Byte;                            //起始数字对讲通道号，区别于模拟对讲通道号，0表示无数字对讲通道
    byHighDChanNum: Byte;                              //数字通道个数，高8位
    bySupport4: Byte;                                  //能力集扩展
    byLanguageType: Byte;                              //支持语种能力
    byVoiceInChanNum: Byte;                            //音频输入通道数
    byStartVoiceInChanNo: Byte;                        //音频输入起始通道号，0表示无效
    byRes3: array[0..1] of Byte;                       //保留，置为0
    byMirrorChanNum: Byte;                             //镜像通道个数，录播主机中用于表示导播通道
    wStartMirrorChanNo: Word;                          //起始镜像通道号
    byRes2: array[0..1] of Byte;                       //保留，置为0
  end;
  LPNET_DVR_DEVICEINFO_V30 = ^NET_DVR_DEVICEINFO_V30;

  //设备参数结构体
  NET_DVR_DEVICEINFO_V40 = packed record
    struDeviceV30: NET_DVR_DEVICEINFO_V30; //设备参数
    bySupportLock: Byte;                   //设备是否支持锁定功能，为1时，dwSurplusLockTime和byRetryLoginTime有效
    byRetryLoginTime: Byte;                //剩余可尝试登录的次数，用户名、密码错误时，此参数有效
    byPasswordLevel: Byte;                 //密码安全等级：0-无效，1-默认密码，2-有效密码，3-风险较高的密码，当管理员用户的密码为出厂默认密码(12345)或者风险较高的密码时，建议上层客户端提示用户更改密码
    byProxyType: Byte;                     //代理服务器类型：0-不使用代理，1-使用标准代理，2-使用EHome代理
    dwSurplusLockTime: DWORD;              //剩余时间，单位：秒，用户锁定时此参数有效
    byCharEncodeType: Byte;                //字符编码类型：0-无字符编码信息(老设备)，1-GB2312，2-GBK，3-BIG5，4-Shift_JIS(日文)，5-EUC-KR(韩文)，6-UTF-8，7-ISO8859-1，8-ISO8859-2，9-ISO8859-3，…，依次类推，21-ISO8859-15(西欧)
    bySupportDev5: Byte;                   //支持v50版本的设备参数获取，设备名称和设备类型名称长度扩展为64字节
    byLoginMode: Byte;                     //登录模式：0-SDK私有协议，1-ISAPI协议
    byRes2: array[0..252] of Byte;         //保留，置为0
  end;
  LPNET_DVR_DEVICEINFO_V40 = ^NET_DVR_DEVICEINFO_V40;

  //登录状态回调函数
  LoginResultCallBack = procedure(lUserID: LONG; dwResult: DWORD; lpDeviceInfo:
    LPNET_DVR_DEVICEINFO_V30; pUser: PVOID); stdcall;

  //用户登录参数结构体
  NET_DVR_USER_LOGIN_INFO = packed record
    sDeviceAddress: array[0..NET_DVR_DEV_ADDRESS_MAX_LEN - 1] of AnsiChar; //设备地址，IP 或者普通域名
    byUseTransport: Byte;                                                  //是否启用能力集透传：0-不启用透传，默认；1-启用透传
    wPort: Word;                                                           //设备端口号
    sUserName: array[0..NET_DVR_LOGIN_USERNAME_MAX_LEN - 1] of AnsiChar;   //登录用户名
    sPassword: array[0..NET_DVR_LOGIN_PASSWD_MAX_LEN - 1] of AnsiChar;     //登录密码
    cbLoginResult: LoginResultCallBack;                                    //登录状态回调函数，bUseAsynLogin 为1时有效
    pUser: PVOID;                                                          //用户数据
    bUseAsynLogin: BOOL;                                                   //是否异步登录：0-否，1-是
    byProxyType: Byte;                                                     //代理服务器类型：0-不使用代理，1-使用标准代理，2-使用EHome代理
    byUseUTCTime: Byte;                                                    //是否使用UTC时间：0-不进行转换，默认；1-输入输出UTC时间，SDK进行与设备时区的转换；2-输入输出平台本地时间，SDK进行与设备时区的转换
    byLoginMode: Byte;                                                     //登录模式：0-SDK私有协议，1-ISAPI协议，2-自适应(设备支持协议类型未知时使用，一般不建议)
    byHttps: Byte;                                                         //ISAPI协议登录时是否启用HTTPS(byLoginMode为1时有效)：0-不启用，1-启用，2-自适应(设备支持协议类型未知时使用，一般不建议)
    iProxyID: LONG;                                                        //代理服务器序号，添加代理服务器信息时相对应的服务器数组下标值
    byVerifyMode: Byte;                                                    //认证方式， 0-不认证，1-双向认证（暂不支持），2-单向认证；使用海康私有协议登录且使用TLS链路时有效（即SDK Over TLS，byLoginMode为0且byHttps为1）;选择0时，无需加载CA证书；选择2时，需要调用接口NET_DVR_SetSDKLocalCfg加载CA证书，枚举值为NET_SDK_LOCAL_CFG_CERTIFICATION
    byRes3: array[0..119] of Byte;                                         //保留，置为0
  end;
  LPNET_DVR_USER_LOGIN_INFO = ^NET_DVR_USER_LOGIN_INFO;

  //JPEG图像信息结构体
  NET_DVR_JPEGPARA = packed record
    wPicSize: Word;    //图片尺寸：$ff-Auto(使用当前码流分辨率)
    wPicQuality: Word; //图片质量系数：0-最好，1-较好，2-一般
  end;
  LPNET_DVR_JPEGPARA = ^NET_DVR_JPEGPARA;

  //预览参数结构体
  NET_DVR_CLIENTINFO = packed record
    lChannel: LONG;          //通道号，1~32表示模拟通道1~32，9000系列混合型DVR和NVR等设备的IP通道从33开始
    lLinkMode: LONG;         //最高位(31)为0表示主码流，为1表示子码流；0~30位表示连接方式：0-TCP方式，1-UDP方式，2-多播方式
    hPlayWnd: HWND;          //播放窗口的句柄，为NULL表示不显示图像
    sMultiCastIP: PAnsiChar; //多播组地址
  end;
  LPNET_DVR_CLIENTINFO = ^NET_DVR_CLIENTINFO;

  //预览参数结构体
  NET_DVR_PREVIEWINFO = packed record
    lChannel: LONG;                                  //通道号，目前设备模拟通道号从1开始，数字通道的起始通道号通过NET_DVR_GetDVRConfig(配置命令NET_DVR_GET_IPPARACFG_V40)获取(dwStartDChan)。
    dwStreamType: DWORD;                             //码流类型：0-主码流，1-子码流，2-三码流，3-虚拟码流，以此类推
    dwLinkMode: DWORD;                               //连接方式：0-TCP方式，1-UDP方式，2-多播方式，3-RTP方式，4-RTP/RTSP，5-RTP/HTTP，6-HRUDP(可靠传输)
    hPlayWnd: HWND;                                  //播放窗口的句柄，为NULL表示不解码显示
    bBlocked: BOOL;                                  //0-非阻塞取流，1-阻塞取流
    bPassbackRecord: BOOL;                           //是否启用录像回传：0-不启用录像回传，1-启用录像回传
    byPreviewMode: Byte;                             //延迟预览模式：0-正常预览，1-延迟预览
    byStreamID: array[0..STREAM_ID_LEN - 1] of Byte; //流ID，为字母、数字和"_"的组合，lChannel为$ffffffff时启用此参数
    byProtoType: Byte;                               //应用层取流协议：0-私有协议，1-RTSP协议。
    byRes1: Byte;                                    //保留，置为0
    byVideoCodingType: Byte;                         //码流数据编解码类型：0-通用编码数据，1-热成像探测器产生的原始数据
    dwDisplayBufNum: DWORD;                          //播放库播放缓冲区最大缓冲帧数，取值范围：1、6(默认，自适应播放模式)、15，置0时默认为1
    byNPQMode: Byte;                                 //NPQ模式：0-直连模式，1-过流媒体模式
    byRes: array[0..214] of Byte;                    //保留，置为0
  end;
  LPNET_DVR_PREVIEWINFO = ^NET_DVR_PREVIEWINFO;

  //报警设备信息结构体
  NET_DVR_ALARMER = packed record
    byUserIDValid: Byte;                               //userid是否有效：0-无效；1-有效
    bySerialValid: Byte;                               //序列号是否有效：0-无效；1-有效
    byVersionValid: Byte;                              //版本号是否有效：0-无效；1-有效
    byDeviceNameValid: Byte;                           //设备名字是否有效：0-无效；1-有效
    byMacAddrValid: Byte;                              //MAC地址是否有效：0-无效；1-有效
    byLinkPortValid: Byte;                             //Login端口是否有效：0-无效；1-有效
    byDeviceIPValid: Byte;                             //设备IP是否有效：0-无效；1-有效
    bySocketIPValid: Byte;                             //Socket IP是否有效：0-无效；1-有效
    lUserID: LONG;                                     //NET_DVR_Login或NET_DVR_Login_V30返回值, 布防时有效
    sSerialNumber: array[0..SERIALNO_LEN - 1] of Byte; //序列号
    dwDeviceVersion: DWORD;                            //版本信息：V3.0以上版本支持的设备最高8位为主版本号，次高8位为次版本号，低16位为修复版本号；V3.0以下版本支持的设备高16位表示主版本，低16位表示次版本
    sDeviceName: array[0..NAME_LEN - 1] of AnsiChar;   //设备名称
    byMacAddr: array[0..MACADDR_LEN - 1] of Byte;      //MAC地址
    wLinkPort: Word;                                   //设备通讯端口
    sDeviceIP: array[0..127] of AnsiChar;              //设备IP地址
    sSocketIP: array[0..127] of AnsiChar;              //报警主动上传时的Socket IP地址
    byIpProtocol: Byte;                                //IP协议：0-IPV4；1-IPV6
    byRes2: array[0..10] of Byte;                      //保留，置为0
  end;
  LPNET_DVR_ALARMER = ^NET_DVR_ALARMER;

  //报警布防参数结构体
  NET_DVR_SETUPALARM_PARAM = packed record
    dwSize: DWORD;               //结构体大小
    byLevel: Byte;               //布防优先级：0-一等级(高)，1-二等级(中)，2-三等级(低)
    byAlarmInfoType: Byte;       //智能交通报警信息上传类型：0-老报警信息(NET_DVR_PLATE_RESULT)，1-新报警信息
    byRetAlarmTypeV40: Byte;     //0-移动侦测、视频丢失、遮挡、IO信号量等报警信息以普通方式上传，1-报警信息以数据可变长方式上传
    byRetDevInfoVersion: Byte;   //CVR上传报警信息类型(仅对接CVR时有效)：0-COMM_ALARM_DEVICE，1-COMM_ALARM_DEVICE_V40
    byRetVQDAlarmType: Byte;     //VQD报警上传类型(仅对接VQD诊断功能的设备有效)：0-COMM_ALARM_VQD，1-COMM_ALARM_VQD_EX
    byFaceAlarmDetection: Byte;  //人脸报警信息类型：1-人脸侦测报警，0-人脸抓拍报警
    bySupport: Byte;             //能力：bit0-二级布防是否上传图片，0-上传，1-不上传；Bit1-是否启用断网续传数据确认机制，0-不开启，1-开启
    byBrokenNetHttp: Byte;       //断网续传类型(设备目前只支持一个断网续传布防连接)，按位表示，0-不续传，1-续传：bit0-车牌检测(IPC)，bit1-客流统计(IPC)，bit2-热度图统计(IPC)，bit3-人脸抓拍(IPC)，bit4-人脸对比(IPC)，bit5-JSON报警透传(IPC)
    wTaskNo: Word;               //任务处理号
    byDeployType: Byte;          //布防类型：0-客户端布防，1-实时布防
    byRes1: array[0..2] of Byte; //保留，置为0
    byAlarmTypeURL: Byte;        //报警图片数据类型：bit0-人脸抓拍中图片数据上传类型，0-二进制传输，1-URL传输；bit1-EVENT_JSON中图片数据上传类型：0-二进制传输，1-URL传输；bit2-人脸比对中图片数据上传类型：0-二进制传输，1-URL传输
    byCustomCtrl: Byte;          //bit0表示是否上传副驾驶人脸子图: 0-不上传，1-上传。
  end;
  LPNET_DVR_SETUPALARM_PARAM = ^NET_DVR_SETUPALARM_PARAM;

  //报警布防参数V50结构体
  NET_DVR_SETUPALARM_PARAM_V50 = packed record
    dwSize: DWORD;                  //结构体大小
    byLevel: Byte;                  //布防优先级：0-一等级(高)，1-二等级(中)，2-三等级(低)
    byAlarmInfoType: Byte;          //智能交通报警信息上传类型：0-老报警信息，1-新报警信息
    byRetAlarmTypeV40: Byte;        //0-移动侦测、视频丢失、遮挡、IO信号量等报警信息以普通方式上传，1-报警信息以数据可变长方式上传
    byRetDevInfoVersion: Byte;      //CVR上传报警信息类型(仅对接CVR时有效)：0-COMM_ALARM_DEVICE，1-COMM_ALARM_DEVICE_V40
    byRetVQDAlarmType: Byte;        //VQD报警上传类型(仅对接VQD诊断功能的设备有效)：0-COMM_ALARM_VQD，1-COMM_ALARM_VQD_EX
    byFaceAlarmDetection: Byte;     //人脸报警信息类型：1-人脸侦测报警，0-人脸抓拍报警
    bySupport: Byte;                //能力：bit0-二级布防是否上传图片，0-上传，1-不上传；Bit1-是否启用断网续传数据确认机制，0-不开启，1-开启
    byBrokenNetHttp: Byte;          //断网续传类型(设备目前只支持一个断网续传布防连接)，按位表示，0-不续传，1-续传：bit0-车牌检测(IPC)，bit1-客流统计(IPC)，bit2-热度图统计(IPC)，bit3-人脸抓拍(IPC)，bit4-人脸对比(IPC)，bit5-JSON报警透传(IPC)
    wTaskNo: Word;                  //任务处理号
    byDeployType: Byte;             //布防类型：0-客户端布防，1-实时布防
    byRes1: array[0..2] of Byte;    //保留，置为0
    byAlarmTypeURL: Byte;           //报警图片数据类型：bit0-人脸抓拍中图片数据上传类型，0-二进制传输，1-URL传输；bit1-EVENT_JSON中图片数据上传类型：0-二进制传输，1-URL传输；bit2-人脸比对中图片数据上传类型：0-二进制传输，1-URL传输
    byCustomCtrl: Byte;             //bit0表示是否上传副驾驶人脸子图: 0-不上传，1-上传。(注：只在公司内部8600/8200等平台开放)
    byRes4: array[0..127] of Byte;  //保留，置为0
  end;
  LPNET_DVR_SETUPALARM_PARAM_V50 = ^NET_DVR_SETUPALARM_PARAM_V50;

