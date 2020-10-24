//
//  MusicPlayerManager.swift
//  flowPlayer
//

import MediaPlayer

final class MusicPlayerManager {
	static let shared = MusicPlayerManager()
	private static let player = MPMusicPlayerController.systemMusicPlayer

	private init() { }

	/// 지금 재생 중인 음악
	var nowPlayingItem: MPMediaItem? {
		return MusicPlayerManager.player.nowPlayingItem
	}

	/// 지금 재생 중인지 확인하는 코드.
	/// musicPlayer.playbackState는 제대로 확인할 수 없는 경우가 많다. (다른 앱에서 오디오 재생시에도 false가 반환된다)
	/// 대신, AVAudioSession를 사용하여 지금 재생 중인지 확인한다.
	var isPlaying: Bool {
		return AVAudioSession.sharedInstance().isOtherAudioPlaying
	}

	/// https://stackoverflow.com/questions/22075366/play-an-mpmediaitemcollection-in-mpmusicplayercontroller-shuffled-but-let-user

	/// 음악 재생
	func play() {
		DispatchQueue.main.async {
			MusicPlayerManager.player.play()
			// 기본 음악 앱 종료 후 첫 재생시 재생되지 않는 오류
			if MusicPlayerManager.player.nowPlayingItem == nil {
				MusicPlayerManager.player.play()
			}
		}
	}

	/// 음악 재생
	///
	/// - Parameters:
	///   - items: MPMediaItem으로 구성된 배열
	///   - index: items 배열에서 재생할 index. 랜덤 재생을 할 경우 nil로 설정
	func play(with items: [MPMediaItem], at index: Int? = nil) {
		if items.isEmpty { return }

		DispatchQueue.main.async {
			let collection = MPMediaItemCollection(items: items)
			MusicPlayerManager.player.setQueue(with: collection)
			if let index = index {
				MusicPlayerManager.player.nowPlayingItem = items[index]
			}
			MusicPlayerManager.player.prepareToPlay() // 재생 딜레이를 줄이기 위한 함수
		}

		play()
	}

	/// 음악 일시정지
	func pause() {
		DispatchQueue.main.async {
			MusicPlayerManager.player.pause()
		}
	}

	/// 음악 정지
	func stop() {
		DispatchQueue.main.async {
			MusicPlayerManager.player.stop()
		}
	}

	/// (Queue에서) 이전 곡으로 스킵
	func skipToPreviousItem() {
		DispatchQueue.main.async {
			MusicPlayerManager.player.skipToPreviousItem()
		}
	}

	/// (Queue에서) 다음 곡으로 스킵
	func skipToNextItem() {
		DispatchQueue.main.async {
			MusicPlayerManager.player.skipToNextItem()
		}
	}

	/// ShuffleMode 설정
	///
	/// - Parameter mode: .off, .songs, (.albums는 차후에)
	func setShuffleMode(_ mode: MPMusicShuffleMode) {
		DispatchQueue.main.async {
			MusicPlayerManager.player.shuffleMode = mode
		}
	}

}
