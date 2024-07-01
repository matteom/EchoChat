//
//  ContentView.swift
//  EchoChat
//
//  Created by Matteo Manferdini on 01/07/24.
//

import SwiftUI
import Observation

struct ContentView: View {
	@State private var postman = Postman()
	@State var messages: [Message] = []

    var body: some View {
		ScrollViewReader { proxy in
			List(messages) { message in
				MessageRow(message: message)
					.id(message.id)
			}
			.onChange(of: messages) {
				withAnimation { proxy.scrollTo(messages.last?.id) }
			}
			.listStyle(.plain)
		}
		.task { await connect() }
		.animation(.easeIn, value: messages)
		.navigationTitle("Echo Chat")
		.safeAreaInset(edge: .bottom) {
			MessageComposer(sendAction: send(_:))
		}
		.toolbar {
			Button("Disconnect", action: postman.disconnect)
				.disabled(!postman.isConnected)
		}
    }
}

private extension ContentView {
	func connect() async {
		guard !postman.isConnected else { return }
		postman.connect()
		postman.startPolling()
		for await message in postman.messages {
			messages.append(message)
		}
	}

	func send(_ message: String) {
		postman.send(message: Message(type: .sent, content: message))
	}
}

#Preview {
	NavigationStack {
		ContentView()
	}
}
