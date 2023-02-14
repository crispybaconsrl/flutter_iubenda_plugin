import Flutter
import UIKit
import iubenda

public class SwiftIubendaPlugin: NSObject, FlutterPlugin {
    
    // MARK: - Methods channel constants
    private let METHOD_GET_PLATFORM_VERSION = "getPlatformVersion"
    private let METHOD_CHECK_CONSENT = "check_consent"
    
    // MARK: - Events channel constants
    
    
    // MARK: - Variables
    private var consentResult: FlutterResult?
    
    private var bannerIsShowed = false
    private var isConsentInvoked = false
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "iubenda_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftIubendaPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        /** Registers the plugin as a receiver of UIApplicationDelegate calls.*/
        registrar.addApplicationDelegate(instance)
        let notificationCenter = NotificationCenter.default
        let notificationName = Notification.Name(NSNotification.Name.ConsentChanged.rawValue)
        notificationCenter.addObserver(
            instance,
            selector: #selector(consentDidChange(_:)),
            name: notificationName,
            object: nil
        )
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case METHOD_GET_PLATFORM_VERSION:
            result("iOS " + UIDevice.current.systemVersion)
        case METHOD_CHECK_CONSENT:
            consentResult = result
            guard let args = (call.arguments as? [String : Any]) else {
                return
            }
            let siteId = args["siteId"] as? String
            let cokiesId = args["cookiesId"] as? String
            let showPreferences = args["showPreferences"] as? Bool ?? false
            
            let config = IubendaCMPConfiguration()
            config.gdprEnabled = true
            config.googleAds = true
            config.siteId = siteId ?? ""
            config.cookiePolicyId = cokiesId ?? ""
            config.acceptIfDismissed = false
            
            bannerIsShowed = false
            IubendaCMP.initialize(with: config)
            if let currentVC = viewController(with: nil) {
                if showPreferences {
                    IubendaCMP.openPreferences(from: currentVC)
                } else {
                    var hasExpressedPreferences = IubendaCMP.storage.preferenceExpressed
                    if hasExpressedPreferences {
                        returnConsentResult()
                    }
                }
                IubendaCMP.askConsent(from: currentVC)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func returnConsentResult(consent: Bool? = nil) {
        var userConsent = consent;
        if (userConsent == nil) {
            userConsent = IubendaCMP.isConsentGiven()
        }
        
        var purposeString = IubendaCMP.storage.purposeConsents
        var isGooglePersonalised = checkPersonalizedAds(purposes: purposeString)
        if let strongConsentResult = consentResult {
            strongConsentResult(isGooglePersonalised)
        }
        
    }
    
    private func checkPersonalizedAds(purposes: String) -> Bool {
        if (purposes.count < 10) {
            return false
        } else {
            var isPersonalized = true
            var googlePersonalisedPurposes: [Int] = [1,2,3,4,7,9,10]
            
            for (index, c) in purposes.enumerated() {
                if googlePersonalisedPurposes.contains(index + 1) {
                    var purposeValue = convertStringToBoolean(value: c)
                    isPersonalized = isPersonalized && purposeValue
                }
            }
            return isPersonalized
        }
    }
    
    private func convertStringToBoolean(value: Character) -> Bool {
        if (value == "1") {
                return true
            }
            return false
        }
    
    /** App Delegate Methods*/
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        return true
    }
    
    func viewController(with window: UIWindow?) -> UIViewController? {
        var windowToUse = window
        if windowToUse == nil {
            for window in UIApplication.shared.windows {
                if window.isKeyWindow {
                    windowToUse = window
                    break
                }
            }
        }
        
        var topController = windowToUse?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
    
    @objc func consentDidChange(_ notification: NSNotification){
        if IubendaCMP.isConsentGiven() {
            if let currentVC = viewController(with: nil) {
                if IubendaCMP.isGooglePersonalized() {
                    // enable Google personalized ADs
                } else {
                    // disable Google personalized ADs
                }
                currentVC.dismiss(animated: true)
                returnConsentResult()
            }
        }
        print("Iubenda googlePersonalied: \(IubendaCMP.storage.googlePersonalized)")
    }
    
}
