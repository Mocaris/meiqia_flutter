import Flutter
import Meiqia
import MeiQiaSDK
import UIKit

public class SwiftMeiqiaFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "meiqia_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftMeiqiaFlutterPlugin.init()
        registrar.addMethodCallDelegate(instance, channel: channel)
        MQManager.openMeiqiaService()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        debugPrint("meiqia_flutter method =>\(call.method)--\(String(describing: call.arguments))\n")
        switch call.method {
        case "initMeiqia":
            let args = call.arguments as! [String: Any]
            let appKey = args["appKey"] as! String
            MQManager.initWithAppkey(appKey, completion: { _, error -> Void in
                debugPrint("初始化-->\(String(describing: error))")
            })
            MQChatViewManager().enableSyncServerMessage(true)
            result(nil)
        case "chat":
            let args = call.arguments as! [String: Any]
            let manager = MQChatViewManager.init()
            // 顾客ID
            let customId = args["customId"] as! String
            manager.setLoginCustomizedId(customId)
            // 顾客信息
            let clientInfo = args["clientInfo"] as? [String: Any]
            if clientInfo != nil {
                manager.setClientInfo(clientInfo, override: true)
            }
            // 指定客服
            let agentId = args["agentId"] as? String
            if clientInfo != nil {
                manager.setScheduledAgentId(agentId)
            }
            manager.pushMQChatViewController(in: UIApplication.shared.delegate!.window?!.rootViewController!)
        case "chatForm":
            let manager = MQMessageFormViewManager()
            manager.pushMQMessageFormViewController(in: UIApplication.shared.delegate!.window?!.rootViewController!)

        case "sendTxtMessage":
            let args = call.arguments as! [String: Any]
            let txtMessage = args["txtMessage"] as! String
            MQManager.sendTextMessage(withContent: txtMessage, completion: { _, error -> Void in
                debugPrint("sendTextMessage:\(error == nil ? "success" : String(describing: error))")
            })
        case "sendPicMessage":
            let args = call.arguments as! [String: Any]
            let picPath = args["picPath"] as! String
            MQManager.sendImageMessage(with: UIImage(contentsOfFile: picPath), completion: { _, error -> Void in
                debugPrint("sendImageMessage:\(error == nil ? "success" : String(describing: error))")
            })
        case "sendVideoMessage":
            let args = call.arguments as! [String: Any]
            let videoPath = args["videoPath"] as! String
            MQManager.sendVideoMessage(videoPath, completion: { _, error -> Void in
                debugPrint("sendVideoMessage：\(error == nil ? "success" : String(describing: error))")
            })
        case "endCurrentConversation":
            MQManager.endCurrentConversation(completion: { _, _ -> Void in

            })
        case "closeMeiqiaService":
            MQManager.closeMeiqiaService()
        case "openMeiqiaService":
            MQManager.openMeiqiaService()
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        MQManager.registerDeviceToken(deviceToken)
    }
    
    public func applicationWillEnterForeground(_ application: UIApplication) {
        MQManager.openMeiqiaService()
    }
    
    public func applicationDidEnterBackground(_ application: UIApplication) {
        MQManager.closeMeiqiaService()
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        
    }
}
