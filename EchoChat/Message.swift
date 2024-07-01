//
//  Message.swift
//  EchoChat
//
//  Created by Matteo Manferdini on 01/07/24.
//

import Foundation

struct Message: Identifiable, Hashable {
	let type: MessageType
	let content: String
	let timestamp: Date = Date()

	var id: Int { hashValue }

	enum MessageType {
		case sent, received, status, error
	}
}
