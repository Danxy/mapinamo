import UIKit
import GoogleMaps
import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyBt1Eq6oRn8rCipxoubQFaysXJpN-kYViI")
        
        initDIServices()
        
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            if let params = params as? [String: AnyObject] {
                let urls = params.map { URL(string: $0.value as? String ?? "") }
                let firstUrl = urls.first { (url)  in
                    return url != nil
                }
                guard  let unwraperdUrl = firstUrl, let url = unwraperdUrl  else {return }
                if let _ = url.scheme, let _ = url.host
                {
                    var parameters: [String: String] = [:]
                    URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                        parameters[$0.name] = $0.value
                    }
                    if let launchVC = self.window?.rootViewController as? LaunchViewController {
                        if let treasureId = parameters["treasure_id"]
                        {
                            launchVC.navigationEvent.onNext(.openTreasureDetails(Int64(treasureId) ?? -1))
                        }
                    }
                }
            }
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return Branch.getInstance().application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return Branch.getInstance().continue(userActivity)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Branch.getInstance().handlePushNotification(userInfo)
    }
}

