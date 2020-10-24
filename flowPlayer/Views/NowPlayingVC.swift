//
//  NowPlayingVC.swift
//  flowPlayer
//

import MediaPlayer

/* LNPopupBarController 닫기
	self.popupPresentationContainer?.closePopup
*/
class NowPlayingVC: UIViewController {

	var delegate: NowPlayingDelegate?

	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var artworkImageView: UIImageView!

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!

	let musicPlayer = MPMusicPlayerController.systemMusicPlayer

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupNotifications()

		setupUI()
		updateSongInfomationUI(mediaItem: musicPlayer.nowPlayingItem)

		let gesture = UITapGestureRecognizer(target: self, action: #selector(testGesture(_:)))
		view.addGestureRecognizer(gesture)
	}

	@objc func testGesture(_ sender: UITapGestureRecognizer) {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction.cancelAction)

		guard let item = musicPlayer.nowPlayingItem else { return }
		let presentAlbumVCAction = UIAlertAction(title: "앨범 보기", style: .default) { (_) in
			self.popupPresentationContainer?.closePopup(animated: true) {
				self.delegate?.presentAlbumVC(of: item)
			}
		}

		let artistAction = UIAlertAction(title: "아티스트 보기", style: .default) { (_) in
			self.popupPresentationContainer?.closePopup(animated: true) {
				self.delegate?.presentArtistVC(of: item)
			}
		}

		for action in [UIAlertAction(title: "음악 정보", style: .default) { _ in
			self.presentItemInfoModal(mediaItem: item)
			},
					   UIAlertAction(title: "공유", style: .default) { _ in
						self.presentActivityVC(mediaItem: item)
			},presentAlbumVCAction,artistAction] {
			alert.addAction(action)
		}

		present(alert, animated: true, completion: nil)
	}


	deinit {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: musicPlayer)

		musicPlayer.endGeneratingPlaybackNotifications()
	}


	// MARK: - 노티피케이션
	func setupNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingItemDidChanged(notification:)), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: musicPlayer)
		musicPlayer.beginGeneratingPlaybackNotifications()
	}

	@objc func nowPlayingItemDidChanged(notification: Notification) {
		updateSongInfomationUI(mediaItem: musicPlayer.nowPlayingItem)
	}

	// MARK: - UI
	func setupUI() {
		artworkImageView.contentMode = .scaleAspectFit
//		titleLabel.numberOfLines = 0
//		titleLabel.type = .continuous
//		titleLabel.animationCurve = .easeInOut
//		subtitleLabel.numberOfLines = 0
	}

	func updateSongInfomationUI(mediaItem: MPMediaItem?) {
		guard let item = mediaItem else {
			titleLabel.text = "..."
			subtitleLabel.text = "..."
			artworkImageView.image = nil
			return
		}
		titleLabel.text = item.getTitle()
		subtitleLabel.text = item.getAttributedString().string
		artworkImageView.image = item.artwork?.image(at: artworkImageView.bounds.size)
		backgroundImageView.image = artworkImageView.image

		popupItem.title = titleLabel.text
//		popupItem.subtitle = subtitleLabel.text
//		popupItem.image = artworkImageView.image
		popupItem.progress = 0.5
	}

	// MARK: - 엑스트라 기능

	// 음악 정보 보기
	func presentItemInfoModal(mediaItem: MPMediaItem) {
		let vc = ItemInfoModal(item: mediaItem)
//		let transitionDelegate = vc.transitionDelegate
//		vc.transitioningDelegate = transitionDelegate
//		vc.modalPresentationStyle = .custom

		present(vc, animated: true)
	}

	// #NowPlaying
	func presentActivityVC(mediaItem: MPMediaItem) {
		guard let item = musicPlayer.nowPlayingItem else { return }

		let nowplayingString = NowPlayingFormatter().string(from: item)
		let activityController = VisualActivityViewController(activityItems: (artworkImageView.image == nil) ? [nowplayingString] : [nowplayingString, artworkImageView.image!], applicationActivities: nil)
		present(activityController, animated: true)
	}
}
