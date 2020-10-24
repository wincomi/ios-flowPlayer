//
//  AppSettings.swift
//  flowPlayer
//

struct AppSettings {
	/// 앱 이름
	static var displayName: String? {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
	}

	/// 앱 버전
	static var releaseVersionNumber: String? {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
	}

	struct API {
		static let sendAnywhere = "34e06bae8ed0a3ce643600f23f4771ac38b8856f"

//		struct SoundCloud {
//			static let clientID = "ae933800ed656ea49406377f6ae9baec"
//			static let clientSecret = "72fd8d6ec14cc1f04ce70a7cc560d3f1"
//		}
	}

	struct InAppProduct {
		static let donate1 = "com.wincomi.ios.musisapp.inapp.donate1"
		static let donate2 = "com.wincomi.ios.musisapp.inapp.donate2"
		static let donate3 = "com.wincomi.ios.musisapp.inapp.donate3"
	}
}
