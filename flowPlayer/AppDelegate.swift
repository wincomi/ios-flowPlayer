//
//  AppDelegate.swift
//  flowPlayer
//

import UIKit
import LNPopupController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		UIApplication.shared.delegate?.window??.tintColor = UIColor.ThemeColor.pink
		UISwitch.appearance().onTintColor = UIColor.ThemeColor.pink

		#if DEBUG
		TabManager.shared.resetUserTabs()
		#endif

		// UISearchController를 사용할 경우 작동되지 않음
//		UINavigationBar.appearance().shadowImage = UIImage.imageWithColor(color: UIColor.tableViewSeparatorColor)

		return true
	}

}

extension UIImage {
	class func imageWithColor(color: UIColor) -> UIImage {
		let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		color.setFill()
		UIRectFill(rect)
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return image
	}
}
