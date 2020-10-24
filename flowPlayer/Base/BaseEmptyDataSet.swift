//
//  BaseEmptyDataSet.swift
//  flowPlayer
//

import UIKit
import DZNEmptyDataSet
import MediaPlayer

final class BaseEmptyDataSet: UIViewController {
	static let shared = BaseEmptyDataSet()
}

extension BaseEmptyDataSet: DZNEmptyDataSetSource {
	func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		let string = "결과 없음"

		var textStyle: UIFont.TextStyle = .headline
		if #available(iOS 11.0, *) {
			textStyle = .largeTitle
		}

		let attributes = [
			NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: textStyle),
			NSAttributedString.Key.foregroundColor: UIColor.black
		]

		return NSAttributedString(string: string, attributes: attributes)
	}

	func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		var string: String {
			switch MPMediaLibrary.authorizationStatus() {
			case .restricted:
				return "Media library access restricted by corporate or parental settings".localized
			case .denied:
				return "Media library access denied by user".localized
			case .notDetermined:
				return "TUTORIAL_DESC2".localized
			case .authorized:
				return "음악이 존재하지 않습니다."
			}
		}

		let attributes = [
			NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)
		]

		return NSAttributedString(string: string, attributes: attributes)
	}

	func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
		if MPMediaLibrary.authorizationStatus() == .authorized {
			return nil
		}

		let string = "Go to settings app...".localized

		let attributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body),
			NSAttributedString.Key.foregroundColor: UIApplication.shared.delegate?.window??.tintColor as Any
		]

		return NSAttributedString(string: string, attributes: attributes)
	}

	func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
		return -(navigationController?.navigationBar.frame.size.height ?? 64)
	}
}

extension BaseEmptyDataSet: DZNEmptyDataSetDelegate {
	func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
		guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
		UIApplication.shared.open(url, options: [:], completionHandler: nil)
	}
}
