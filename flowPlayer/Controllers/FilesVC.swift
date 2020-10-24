//
//  FilesVC.swift
//  flowPlayer
//

import UIKit
import DZNEmptyDataSet

class FilesVC: BaseTableVC {
	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.emptyDataSetSource = self
	}
}

extension FilesVC: DZNEmptyDataSetSource {
	func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		let string = "지원 일시 중단 안내"

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
		let string = "'iTunes와 연동하는 음악 앱'에 집중하기 위하여 파일 브라우저 기능을 제거하였습니다.\n기존의 음악은 iTunes 파일 공유에서 가져올 수 있습니다.\n\n차후 업데이트를 기대해주세요!"
		let attributes = [
			NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)
		]

		return NSAttributedString(string: string, attributes: attributes)
	}

}
