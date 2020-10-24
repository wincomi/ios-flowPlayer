//
//  MPMediaItemCollection+Extension.swift
//  flowPlayer
//

import MediaPlayer

extension Array where Element: MPMediaItemCollection {
	// https://stackoverflow.com/questions/35903252/get-album-titles-for-indexed-uitableview-using-mpmediaquery-in-swift
	subscript(indexPath: IndexPath, for querySection: [MPMediaQuerySection]?) -> Element {
		let currLoc = querySection?[indexPath.section].range.location ?? 0
		return self[currLoc + indexPath.row]
	}
}

//extension MPMediaItemCollection {
//	func title(for type: ItemCollectionType) -> String {
//		switch type {
//		case .playlist:
//			return (self as? MPMediaPlaylist)?.name ?? R.string.localizable.unknownWith(type.rawValue)
//		case .artist:
//			return representativeItem?.albumArtist ?? R.string.localizable.unknownWith(type.rawValue)
//		case .album:
//			return representativeItem?.albumTitle ?? R.string.localizable.unknownWith(type.rawValue)
//		case .genre:
//			return representativeItem?.genre ?? R.string.localizable.unknownWith(type.rawValue)
//		case .composer:
//			return representativeItem?.composer ?? R.string.localizable.unknownWith(type.rawValue)
//		}
//	}
//
//	func description(for type: ItemCollectionType) -> String? {
//		switch type {
//		case .playlist:
//			return (self as? MPMediaPlaylist)?.descriptionText
//		case .album:
//			guard let item = representativeItem else {
//				return "Unknown artist".localized
//			}
//
//			guard let albumArtist = item.albumArtist else {
//				if item.isCompilation {
//					return "Various artists".localized
//				}
//				return item.artist ?? "Unknown artist".localized
//			}
//
//			return albumArtist
//		default:
//			return nil
//		}
//	}
//
//	func image(in type: ItemCollectionType, size: CGSize = CGSize(width: 64, height: 64)) -> UIImage? {
//		let emptyImage = getImageWithColor(color: .tableViewBackgroundColor, size: size)
//		switch type {
//		case .playlist:
//			if (self as? MPMediaPlaylist)?.playlistAttributes == .smart {
//				return R.image.tab.playlist.smartPlaylists()
//			} else {
//				return R.image.tab.playlists()
//			}
//		case .album:
//			return representativeItem?.artwork?.image(at: size) ?? emptyImage
//		default:
//			return nil
//		}
//	}
//
//	/* private */ func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
//		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//		UIGraphicsBeginImageContextWithOptions(size, false, 0)
//		color.setFill()
//		UIRectFill(rect)
//		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//		UIGraphicsEndImageContext()
//		return image
//	}
//}
