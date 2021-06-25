import 'dart:async';

import 'package:flutter/services.dart';

class MeiqiaFlutter {
  static const MethodChannel _channel = const MethodChannel('meiqia_flutter');

  static Future<void> initMeiqia(String appKey) async {
    await _channel.invokeMethod('initMeiqia', {"appKey": appKey});
  }

  ///关闭美洽服务
  static Future<void> closeMeiqiaService() async {
    await _channel.invokeMethod('closeMeiqiaService');
  }

  ///开启美洽服务
  static Future<void> openMeiqiaService() async {
    await _channel.invokeMethod('openMeiqiaService');
  }

  ///结束当前会话
  static Future<void> endCurrentConversation() async {
    await _channel.invokeMethod('endCurrentConversation');
  }

  ///发送消息 文字
  static Future<void> sendTxtMessage(String content) async {
    await _channel.invokeMethod('sendTxtMessage', {"txtMessage": content});
  }

  ///发送消息 图片
  static Future<void> sendPicMessage(String picPath) async {
    await _channel.invokeMethod('sendTxtMessage', {"picPath": picPath});
  }

  ///发送消息 视频
  static Future<void> sendVideoMessage(String videoPath) async {
    await _channel.invokeMethod('sendVideoMessage', {"videoPath": videoPath});
  }

  ///留言列表
  static Future<void> chatForm() async {
    await _channel.invokeMethod('chatForm');
  }

  ///设置或更新顾客列表
  static Future<void> setClientInfo(Map<String, dynamic> clientInfo, {bool update: true}) async {
    await _channel.invokeMethod('setClientInfo', {"clientInfo": clientInfo, "update": update});
  }

  /// 开启客服
  /// customId开发者顾客Id
  /// clientInfo 设置顾客信息
  ///  agentId 指定客服ID
  ///  preTxt 预发送文字
  ///  prePicPath 预发送图片
  static Future<void> chat({
    required String customId,
    Map<String, dynamic>? clientInfo,
    String? agentId,
    String? preTxt,
    String? prePicPath,
  }) async {
    var arg = {};
    arg["customId"] = customId;
    if (null != clientInfo) {
      arg["clientInfo"] = clientInfo;
    }
    if (null != agentId) {
      arg["agentId"] = agentId;
    }
    if (null != preTxt) {
      arg["preTxt"] = preTxt;
    }
    if (null != prePicPath) {
      arg["prePicPath"] = prePicPath;
    }
    await _channel.invokeMethod('chat', arg);
  }
}
