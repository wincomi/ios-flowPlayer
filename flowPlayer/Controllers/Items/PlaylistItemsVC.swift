//
//  PlaylistItemsVC.swift
//  flowPlayer
//

import UIKit
import MediaPlayer

// NOTE: - tableView의 editMode 사용하지 않기
final class PlaylistItemsVC: ItemsVC {
	/// 현재 재생목록. 일반적으로 재생목록에 아이템을 추가할 때 사용한다.
	var currentPlaylist: MPMediaPlaylist

	override init(itemCollection: MPMediaItemCollection, style: UITableView.Style = .grouped) {
		guard let playlist = itemCollection as? MPMediaPlaylist else { fatalError("this itemCollection is not a playlist") }

		self.currentPlaylist = playlist
		super.init(itemCollection: itemCollection, style: style)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		if currentPlaylist.canAddItems {
			let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add) { _ in
				self.present(self.addItemAtPlaylistController, animated: true)
			}

			var rightBarButtonItems = navigationItem.rightBarButtonItems ?? []
			rightBarButtonItems.append(addButtonItem)
			navigationItem.rightBarButtonItems = rightBarButtonItems
		}

		if items.count > 0 {
			let tableViewButtonsView = TableViewButtonsView.defaultView()
			tableViewButtonsView.delegate = self
			tableView.tableHeaderView = tableViewButtonsView
		}
	}

	var addItemAtPlaylistController: MPMediaPickerController {
		let mediaPicker = MPMediaPickerController(mediaTypes: .music)
//		mediaPicker.prompt = "애플 정책상 일반 재생목록 내의 음악 추가만 가능합니다.\n재생목록의 제목 및 설명 변경, 재생목록 내의 음악의 순서 변경 및 삭제는 기본 음악 앱에서만 할 수 있습니다."
		mediaPicker.allowsPickingMultipleItems = true
//		mediaPicker.showsCloudItems = defaults.bool(forKey: "showCloudItems")
		mediaPicker.delegate = self
		mediaPicker.modalPresentationStyle = .pageSheet
		return mediaPicker
	}
}

// TODO: 재생목록에 음악 추가시 재생목록 리로드
extension PlaylistItemsVC: MPMediaPickerControllerDelegate {
	// addItem(at playlist: MPMediaPlaylist) 호출 이후
	func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
		mediaPicker.dismiss(animated: true)

		currentPlaylist.add(mediaItemCollection.items) { (error) in
			if let error = error {
				print(error.localizedDescription)
			} else {
				/// 정상적으로 추가되었을 경우 재생목록의 아이템을 다시 불러옴.
				/// DispatchQueue.main.async을 사용하지 않을 경우
				/// tableView.reloadData()가 호출되지 않을 것임.
				DispatchQueue.main.async {
					self.items = self.currentPlaylist.items
					self.tableView.reloadData()
				}
			}
		}
	}

	func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
		mediaPicker.dismiss(animated: true, completion: nil)
	}

}

extension PlaylistItemsVC: TableViewButtonsViewDelegate {
	func touchPlayButton(_ sender: TableViewButton) {
		MusicPlayerManager.shared.setShuffleMode(.off)
		MusicPlayerManager.shared.play(with: items, at: 0)
	}

	func touchShuffleButton(_ sender: TableViewButton) {
		MusicPlayerManager.shared.setShuffleMode(.songs)
		MusicPlayerManager.shared.play(with: items)
	}
}
