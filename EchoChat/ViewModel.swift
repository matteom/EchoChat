//
//  ViewModel.swift
//  EchoChat
//
//  Created by Matteo Manferdini on 01/07/24.
//

import Foundation
import Observation

@Observable class ViewModel {
	var messages: [Message] = []
	private let postman = Postman()

	var isConnected: Bool { postman.isConnected }

	func connect() async {
		guard !isConnected else { return }
		postman.connect()
		postman.startPolling()
		for await message in postman.messages {
			messages.append(message)
		}
	}

	func disconnect() {
		postman.disconnect()
	}

	func send(_ message: String) {
		postman.send(message: Message(type: .sent, content: message))
	}
}
