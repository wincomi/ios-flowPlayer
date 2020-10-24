//
//  FavoritesTableViewController.swift
//  musicFlow
//
//  Created by Wincomi on 2016. 10. 16..
//  Copyright © 2016 Wincomi. All rights reserved.
//

import UIKit
import MediaPlayer
import DZNEmptyDataSet

// swiftlint:disable all
class FavoritesTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
	func loadCustomObject(withKey key: String) -> NSArray? {
		let encodedObject: Data? = defaults.object(forKey: key) as? Data
		if encodedObject == nil {
			return nil
		}
		let object = NSKeyedUnarchiver.unarchiveObject(with: encodedObject!)!
		return object as? NSArray
	}

	func getFavs(type: String) -> NSArray {
		let object = loadCustomObject(withKey: "fav" + type)
		if object == nil {
			return NSArray()
		}
		return object!
	}

	let musicPlayer = MPMusicPlayerController.systemMusicPlayer
	let defaults = UserDefaults.standard

	var albums = NSArray()
	var artists = NSArray()
	var songs = NSArray()

	let type = [
		"Albums",
		"Artists",
		"Songs"
	]

	override func viewDidLoad() {
		super.viewDidLoad()

		getData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if tableView.indexPathForSelectedRow != nil {
			tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: animated)
		}
	}

	// MARK:
	func getData() {
		albums = getFavs(type: "Albums")
		artists = getFavs(type: "Artists")
		songs = getFavs(type: "Songs")
	}

	// MARK: - Table view data source
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			if albums.count == 0 {
				return 1
			}
			return albums.count
		case 1:
			if artists.count == 0 {
				return 1
			}
			return artists.count
		case 2:
			if songs.count == 0 {
				return 1
			}
			return songs.count
		default:
			return 1
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			if albums.count == 0 {
				return noDataCell(type: "Albums", indexPath: indexPath)
			}
		case 1:
			if artists.count == 0 {
				return noDataCell(type: "Artists", indexPath: indexPath)
			}
		case 2:
			if songs.count == 0 {
				return noDataCell(type: "Songs", indexPath: indexPath)
			}
		default:
			break
		}

		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
			let collection = albums[indexPath.row] as! MPMediaItemCollection
			if collection.representativeItem?.albumTitle != nil {
//				cell.textLabel?.text = collection.title(for: .album)
//				cell.detailTextLabel?.text = collection.description(for: .album)
//				cell.imageView?.image = collection.image(in: .album, size: CGSize(width: 38, height: 38))
				cell.accessoryType = .disclosureIndicator
				return cell
			} else {
				return noDataCell(type: "Album", indexPath: indexPath)
			}
		} else if indexPath.section == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
			let item = artists[indexPath.row] as! MPMediaItem
			cell.textLabel?.text = item.albumArtist
			cell.imageView?.image = nil
			cell.accessoryType = .disclosureIndicator
			return cell
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
		let item = songs[indexPath.row] as! MPMediaItem
		if let title = item.title {
			cell.textLabel?.text = title
//			cell.detailTextLabel?.text = MPMediaItemCollection(items: [item]).description(for: .album)

			if let artwork = item.artwork {
				cell.imageView?.image = artwork.image(at: CGSize(width: 38, height: 38))
			} else {
				cell.imageView?.image = nil
			}
			cell.accessoryType = .none
		} else {
			return noDataCell(type: "Song", indexPath: indexPath)
		}

		return cell
	}

	func noDataCell(type: String, indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataCell", for: indexPath)
		cell.textLabel?.text = String(format: NSLocalizedString("%@ do not exist.", comment: ""), NSLocalizedString(type, comment: ""))
		return cell
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return NSLocalizedString("Albums", comment: "")
		case 1:
			return NSLocalizedString("Artists", comment: "")
		case 2:
			return NSLocalizedString("Songs", comment: "")
		default:
			return nil
		}
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.section {
		default:
			return 54
		}

	}


	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// TODO:
	}

}

