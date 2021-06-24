package com.mocaris.meiqia_flutter

import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import com.meiqia.core.MQManager
import com.meiqia.core.bean.MQMessage
import com.meiqia.core.callback.OnClientInfoCallback
import com.meiqia.core.callback.OnEndConversationCallback
import com.meiqia.core.callback.OnInitCallback
import com.meiqia.core.callback.OnMessageSendCallback
import com.meiqia.meiqiasdk.activity.MQMessageFormActivity
import com.meiqia.meiqiasdk.util.MQConfig
import com.meiqia.meiqiasdk.util.MQIntentBuilder
import io.flutter.Log

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.lang.Exception

/** MeiqiaFlutterPlugin */
class MeiqiaFlutterPlugin: FlutterPlugin, MethodCallHandler {
  val TAG = "MeiqiaFlutterPlugin"
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "meiqia_flutter")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    MQManager.getInstance(context).openMeiqiaService()
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      when (call.method) {
        "initMeiqia" -> {
          val appKey = call.argument<String>("appKey")
          MQConfig.init(context, appKey, object : OnInitCallback {
            override fun onFailure(p0: Int, p1: String) {
              Log.e(TAG, p1)
            }

            override fun onSuccess(p0: String) {
              Log.d(TAG, p0)
            }
          })
          result.success(null)
        }
        "chat" -> {
          val intent = MQIntentBuilder(context).also {
            //开发者ID
            val customId = call.argument<String>("customId")
            it.setCustomizedId(customId)
            //设置更新顾客信息
            if (call.hasArgument("clientInfo")) {
              val clientInfo = call.argument<HashMap<String, String>>("clientInfo")
              it.setClientInfo(clientInfo)
            }
            //指定客服分配 agentId
            if (call.hasArgument("agentId")) {
              val agentId = call.argument<String>("agentId")
              it.setScheduledAgent(agentId)
            }
            //预发送文字
            if (call.hasArgument("preTxt")) {
              it.setPreSendTextMessage(call.argument<String>("preTxt"))
            }
            //预发送图片
            if (call.hasArgument("prePicPath")) {
              it.setPreSendImageMessage(File(call.argument<String>("prePicPath")!!))
            }
          }
          context.startActivity(intent.build())
          result.success(null)
        }
        //留言表单
        "chatForm" -> {
          context.startActivity(Intent(context, MQMessageFormActivity::class.java))
          result.success(null)
        }
        //更新顾客信息
        "setClientInfo" -> {
          val clientInfo = call.argument<HashMap<String, String>>("clientInfo")
          val update = call.argument<Boolean>("update") ?: false
          val callback = object : OnClientInfoCallback {
            override fun onFailure(p0: Int, p1: String) {
              Log.e(TAG, p1)
            }

            override fun onSuccess() {

            }
          }
          if (update) {
            MQManager.getInstance(context).updateClientInfo(clientInfo, callback)
          } else {
            MQManager.getInstance(context).setClientInfo(clientInfo, callback)
          }
          result.success(null)
        }
        //发送消息
        "sendTxtMessage" -> {
          val callback = object : OnMessageSendCallback {
            override fun onSuccess(p0: MQMessage, p1: Int) {
              Log.d(TAG, p0.content)
            }

            override fun onFailure(p0: MQMessage, p1: Int, p2: String) {
              Log.e(TAG, p0.content)
              Log.e(TAG, p2)
            }
          }
          val txt = call.argument<String>("txtMessage")
          MQManager.getInstance(context).sendMQTextMessage(txt, callback)
        }
        "sendPicMessage" -> {
          val callback = object : OnMessageSendCallback {
            override fun onSuccess(p0: MQMessage, p1: Int) {
              Log.d(TAG, p0.content)
            }

            override fun onFailure(p0: MQMessage, p1: Int, p2: String) {
              Log.e(TAG, p0.content)
              Log.e(TAG, p2)
            }
          }
          val path = call.argument<String>("picPath")
          MQManager.getInstance(context).sendMQPhotoMessage(path, callback)
        }
        "sendVideoMessage" -> {
          val callback = object : OnMessageSendCallback {
            override fun onSuccess(p0: MQMessage, p1: Int) {
              Log.d(TAG, p0.content)
            }

            override fun onFailure(p0: MQMessage, p1: Int, p2: String) {
              Log.e(TAG, p0.content)
              Log.e(TAG, p2)
            }
          }
          val path = call.argument<String>("videoPath")
          MQManager.getInstance(context).sendMQVideoMessage(path, callback)
        }
        "endCurrentConversation" -> {
          MQManager.getInstance(context)
            .endCurrentConversation(object : OnEndConversationCallback {
              override fun onFailure(p0: Int, p1: String) {
                Log.e(TAG, p1)
              }

              override fun onSuccess() {
              }

            })
        }
        "closeMeiqiaService" -> {
          MQManager.getInstance(context).closeMeiqiaService()
        }
        "openMeiqiaService" -> {
          MQManager.getInstance(context).openMeiqiaService()
        }
        else -> {
          result.notImplemented()
        }
      }
    } catch (e: Exception) {
      result.error("0", e.message ?: e.localizedMessage, null)
      Log.d(TAG, e.message ?: e.localizedMessage)
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    MQManager.getInstance(context).closeMeiqiaService()
    channel.setMethodCallHandler(null)
  }
}
