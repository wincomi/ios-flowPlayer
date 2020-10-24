//
//  MPMediaPropertyPredicate+Extension.swift
//  flowPlayer
//

import MediaPlayer

extension MPMediaPropertyPredicate {
	static let cloudPredicate = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
}
