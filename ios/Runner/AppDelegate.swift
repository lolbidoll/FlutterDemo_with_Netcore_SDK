import UIKit
import Flutter
import Smartech
import SmartPush
import UserNotifications
import UserNotificationsUI
import smartech_base
import Foundation
import FirebaseCore
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, SmartechDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    registerForPushNotifications(application: application)
    Smartech.sharedInstance().initSDK(with: self, withLaunchOptions: launchOptions)
    UNUserNotificationCenter.current().delegate = self
    SmartPush.sharedInstance().registerForPushNotificationWithDefaultAuthorizationOptions()
    Smartech.sharedInstance().setDebugLevel(.verbose)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    private func registerForPushNotifications(application: UIApplication) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]

            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {
                (granted, error) in
                guard granted else { return }
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
          print("Firebase registration token: \(String(describing: fcmToken))")
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      SmartPush.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      SmartPush.sharedInstance().didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    //MARK:- UNUserNotificationCenterDelegate Methods
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      SmartPush.sharedInstance().willPresentForegroundNotification(notification)
      completionHandler([.alert, .badge, .sound])
    }
        
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            SmartPush.sharedInstance().didReceive(response)
      }
      
      completionHandler()
    }
    
   override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        SmartPush.sharedInstance().didReceiveRemoteNotification(userInfo, withCompletionHandler: completionHandler)
    }
    
    
    // MARK: - Smartech Delegate Methods

    func handleDeeplinkAction(withURLString deeplinkURLString: String, andNotificationPayload notificationPayload: [AnyHashable : Any]?) {
      
      SmartechBasePlugin.handleDeeplinkAction(deeplinkURLString, andCustomPayload:notificationPayload)
        print("SMT Deeplink" + deeplinkURLString)
    }
}
