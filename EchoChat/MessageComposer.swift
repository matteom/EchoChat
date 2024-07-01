//
//  MessageComposer.swift
//  EchoChat
//
//  Created by Matteo Manferdini on 03/07/24.
//

import SwiftUI

struct MessageComposer: View {
	var sendAction: (String) -> Void
	@State private var message: String = ""

	var body: some View {
		HStack {
			TextField("", text: $message)
				.padding(.horizontal)
				.padding(.vertical, 6)
				.overlay {
					Capsule()
						.stroke(Color.secondary)
				}
			Button(action: {
				sendAction(message)
				message = ""
			}, label: {
				Image(systemName: "arrow.up")
			})
			.buttonStyle(.borderedProminent)
			.buttonBorderShape(.circle)
			.disabled(message.isEmpty)
		}
		.padding()
		.padding(.trailing, -8)
		.background(Color.white)
	}
}

#Preview {
	Color.clear
		.safeAreaInset(edge: .bottom) {
			MessageComposer { _ in }
		}
}
