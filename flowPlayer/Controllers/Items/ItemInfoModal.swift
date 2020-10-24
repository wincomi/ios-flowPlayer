//
//  ItemInfoModal.swift
//  flowPlayer
//

import UIKit
import MediaPlayer
//import SPStorkController

struct ItemInfoCell {
	var title: String
	var detail: String?
	var action: ((MPMediaItem) -> Void)?
}

class ItemInfoModal: BaseTableVC {

	var cellReuseIdentifier: String = "Cell"

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

//	var transitionDelegate: SPStorkTransitioningDelegate {
//		let delegate = SPStorkTransitioningDelegate()
//		delegate.showIndicator = true
//		delegate.swipeToDismissEnabled = false
////		delegate.customHeight = 500
////		delegate.translateForDismiss = 240
//
//		return delegate
//	}

	var sections: [[ItemInfoCell]] = []

	var item: MPMediaItem

	init(item: MPMediaItem) {
		self.item = item

		super.init(style: .grouped)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		modalPresentationCapturesStatusBarAppearance = true

		self.title = R.string.localizable.songInfo()

		self.sections = [
			[
				ItemInfoCell(title: R.string.localizable.title(), detail: item.title, action: nil),
				ItemInfoCell(title: R.string.localizable.artist(), detail: item.artist, action: nil),
				ItemInfoCell(title: R.string.localizable.album(), detail: item.albumTitle) { _ in
					self.dismiss(animated: true)
				},
				ItemInfoCell(title: R.string.localizable.albumArtist(), detail: item.albumArtist, action: nil),
				ItemInfoCell(title: R.string.localizable.composer(), detail: item.composer, action: nil),
				ItemInfoCell(title: "User Grouping", detail: item.userGrouping, action: nil),
				ItemInfoCell(title: R.string.localizable.genre(), detail: item.genre, action: nil)
			],
			[
				ItemInfoCell(title: R.string.localizable.year(),
							 detail: (item.year != nil) ? String(item.year!) : nil,
							 action: nil),
				ItemInfoCell(title: "Album Track",
							 detail: "\(item.albumTrackNumber) / \(item.albumTrackCount)", action: nil),
				ItemInfoCell(title: "Disc",
							 detail: "\(item.discNumber) / \(item.discCount)",
					action: nil),
				ItemInfoCell(title: MPMediaItemPropertyIsCompilation,
							 detail: String(item.isCompilation),
							 action: nil)
			]
		]

//		if UIDevice.current.userInterfaceIdiom == .phone, let width = presentingViewController?.view.bounds.size.width {
//			self.setupArtwork(size: width)
//		}

		tableView.register(RightDetailTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
	}

	func setupArtwork(size: CGFloat) {
		guard let artwork = self.item.artwork else { return }

		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
		imageView.accessibilityLabel = "Artwork"
		// imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: 1, constant: 0))

		imageView.image = artwork.image(at: CGSize(width: size, height: size))
		imageView.isUserInteractionEnabled = true
		imageView.contentMode = .scaleAspectFill
//		let gesture = UITapGestureRecognizer(target: self, action: #selector(self.longPressArtwork(sender:)))
//		imageView.addGestureRecognizer(gesture)

		let topBorderView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: 1.0 / UIScreen.main.scale))
		topBorderView.backgroundColor = self.tableView.separatorColor
		imageView.addSubview(topBorderView)

		let bottomBorderView = UIView(frame: CGRect(x: 0, y: size, width: size, height: 1.0 / UIScreen.main.scale))
		bottomBorderView.backgroundColor = self.tableView.separatorColor
		imageView.addSubview(bottomBorderView)

		tableView.tableHeaderView = imageView
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

		let rowItem = sections[indexPath.section][indexPath.row]
		cell.textLabel?.text = rowItem.title
		cell.detailTextLabel?.text = rowItem.detail ?? "-"
		cell.accessoryType = (rowItem.action != nil) ? .disclosureIndicator : .none

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)

		let rowItem = sections[indexPath.section][indexPath.row]

		if let action = rowItem.action {
			action(self.item)
		} else if let textToShare = rowItem.detail {
			let vc = VisualActivityViewController(text: textToShare)
			vc.previewFont = UIFont.systemFont(ofSize: 15)
//			let vc = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
			vc.excludedActivityTypes = [.addToReadingList, .assignToContact, .print]
			present(vc, animated: true)
		}
	}

	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		SPStorkController.scrollViewDidScroll(scrollView)
	}
}

class RightDetailTableViewCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .value1, reuseIdentifier: reuseIdentifier)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		//		textLabel?.textColor = UIColor.lightGray
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
