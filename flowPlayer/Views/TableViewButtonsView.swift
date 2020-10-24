//
//  TableViewButtonsView.swift
//  flowPlayer
//

import UIKit

protocol TableViewButtonsViewDelegate: class {
	func touchPlayButton(_ sender: TableViewButton)
	func touchShuffleButton(_ sender: TableViewButton)
}

class TableViewButtonsView: UIView {

	class func defaultView() -> TableViewButtonsView {
		return TableViewButtonsView(frame: CGRect(x: 0, y: 0, width: 0, height: 64 + 16))
	}

	weak var delegate: TableViewButtonsViewDelegate?

	private let xibName = "TableViewButtonsView"

	@IBOutlet var contentView: UIView!
	@IBOutlet weak var playButton: TableViewButton!
	@IBOutlet weak var shuffleButton: TableViewButton!

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.commonInit()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
	}

	private func commonInit() {
		Bundle.main.loadNibNamed(xibName, owner: self, options: nil)

		playButton.setTitle("재생", for: .normal)
		shuffleButton.setTitle("임의 재생", for: .normal)

		playButton.addTarget(self, action: #selector(touchPlayButton(_:)), for: .touchUpInside)
		shuffleButton.addTarget(self, action: #selector(touchShuffleButton(_:)), for: .touchUpInside)

		contentView.frame = self.bounds
		contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

//		contentView.layer.addBorder([.bottom], color: UIColor.tableViewSeparatorColor, width: 1.0)
		addSubview(contentView)
	}

	@objc func touchPlayButton(_ sender: TableViewButton) {
		delegate?.touchPlayButton(sender)
	}

	@objc func touchShuffleButton(_ sender: TableViewButton) {
		delegate?.touchShuffleButton(sender)
	}

}
//
//extension CALayer {
//	func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
//		for edge in arr_edge {
//			let border = CALayer()
//			switch edge {
//			case .top:
//				border.frame = CGRect(x: 0, y: 0, width: frame.width, height: width)
//			case .bottom:
//				border.frame = CGRect(x: 0, y: frame.height - width, width: frame.width, height: width)
//			case .left:
//				border.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
//			case .right:
//				border.frame = CGRect(x: frame.width - width, y: 0, width: width, height: frame.height)
//			default:
//				break
//			}
//			border.backgroundColor = color.cgColor
//			self.addSublayer(border)
//		}
//	}
//}
