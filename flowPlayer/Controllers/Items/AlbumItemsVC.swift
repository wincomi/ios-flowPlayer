//
//  AlbumItemsVC.swift
//  flowPlayer
//

import UIKit
import MediaPlayer

/**
앨범의 곡을 표시하는 ViewController

- TODO: v5.2 디스크별로 분리
- numbersOfSections = item.albumTrackCount
*/
final class AlbumItemsVC: ItemsVC {

	override func viewDidLoad() {
		super.viewDidLoad()

		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}

		tableView.register(R.nib.albumSongCell)
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.albumSongCell, for: indexPath) else { fatalError() }

		let item = items[indexPath.row]
		cell.titleLabel.text = item.title
		cell.albumTrackNumberLabel.text = (item.albumTrackNumber > 0) ? String(item.albumTrackNumber) : nil

		return cell
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 49
	}

	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		let numberOfSongs = R.string.localizable.numberOfSongs(value: items.count)

		let length = items.reduce(0) { (result: TimeInterval, item) -> TimeInterval in
			return result + item.playbackDuration
		}

		if let lengthOfSongs = length.toString() {
			return "\(numberOfSongs), \(lengthOfSongs)"
		}

		return numberOfSongs
	}

/*
	// MARK: - 디스크
	var discNumbers: [Int] {
		return Set(items.map { $0.discNumber }).sorted()
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard discNumbers.count > 1 else { return nil }
		return "\(discNumbers[section]) 디스크"
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return discNumbers.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

	}
*/
}
