//
//  Postman.swift
//  EchoChat
//
//  Created by Matteo Manferdini on 01/07/24.
//

import Foundation
import Observation

@Observable class Postman: NSObject {
	let messages: AsyncStream<Message>
	private(set) var isConnected = false
	private let continuation: AsyncStream<Message>.Continuation
	private var pollingTimer: Timer?
	private let webSocketTask: URLSessionWebSocketTask = URLSession.shared.webSocketTask(
		with: URL(string: "wss://ws.postman-echo.com/raw")!
	)

	override init() {
		(self.messages, self.continuation) = AsyncStream.makeStream(of: Message.self)
	}

	func connect() {
		webSocketTask.delegate = self
		webSocketTask.resume()
		isConnected = true
	}

	func disconnect() {
		pollingTimer?.invalidate()
		webSocketTask.cancel(with: .normalClosure, reason: nil)
		isConnected = false
	}

	func send(message: Message) {
		var message = message
		webSocketTask.send(.string(message.content)) { error in
			if let error {
				message = Message(type: .error, content: error.localizedDescription)
			}
			self.continuation.yield(message)
		}
	}

	func startPolling() {
		pollingTimer = Timer(timeInterval: 0.5, repeats: true) { [weak self] _ in
			self?.webSocketTask.receive { [weak self] result in
				guard let self else { return }
				guard isConnected else { return }
				handle(result)
			}
		}
		RunLoop.main.add(pollingTimer!, forMode: .common)
	}
}

extension Postman: URLSessionWebSocketDelegate {
	func urlSession(
		_ session: URLSession,
		webSocketTask: URLSessionWebSocketTask,
		didOpenWithProtocol protocol: String?
	) {
			continuation.yield(Message(type: .status, content: "Connection open"))
	}

	func urlSession(
		_ session: URLSession,
		webSocketTask: URLSessionWebSocketTask,
		didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
		reason: Data?
	) {
		continuation.yield(Message(type: .status, content: "Connection closed"))
	}
}

private extension Postman {
	func handle(_ result: Result<URLSessionWebSocketTask.Message, any Error>) {
		let message = switch result {
		case .success(let success):
			switch success {
				case .string(let string):
					Message(type: .received, content: string)
				case .data(let data):
					Message(type: .error, content: "Received binay data")
				@unknown default: fatalError()
			}
		case .failure(let failure):
			Message(type: .error, content: failure.localizedDescription)
		}
		continuation.yield(message)
	}
}
