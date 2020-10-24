//
//  LibraryContextualAction.swift
//  flowPlayer
//

import MediaPlayer

protocol LibraryContextualAction {
	var localizedTitle: String { get }
	var image: UIImage? { get }
	var backgroundColor: UIColor? { get }

}
