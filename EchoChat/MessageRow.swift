//
//  MessageRow.swift
//  EchoChat
//
//  Created by Matteo Manferdini on 02/07/24.
//

import SwiftUI

struct MessageRow: View {
	let message: Message

	var body: some View {
		Text(message.content)
			.foregroundStyle(textColor)
			.padding()
			.background {
				backgroundColor
					.clipShape(RoundedRectangle(cornerRadius: 20))
			}
			.frame(maxWidth: .infinity, alignment: alignment)
			.listRowSeparator(.hidden)
	}

	var backgroundColor: Color {
		switch message.type {
			case .sent: .blue
			case .received: .gray.opacity(0.2)
			case .status: .cyan.opacity(0.2)
			case .error: .red
		}
	}

	var textColor: Color {
		switch message.type {
			case .sent, .error: .white
			case .status, .received: .black
		}
	}

	var alignment: Alignment {
		switch message.type {
			case .sent: .trailing
			case .received: .leading
			case .status, .error: .center
		}
	}
}

#Preview {
	List {
		MessageRow(
			message: Message(type: .status, content: "Lorem ipsum dolor sit amet")
		)
		MessageRow(
			message: Message(type: .sent, content: "Consectetur adipiscing elit.")
		)
		MessageRow(
			message: Message(type: .received,content: "Ut enim ad minim veniam.")
		)
		MessageRow(
			message: Message(type: .error,content: "Nisi ut aliquip ex ea commodo")
		)
	}
	.listStyle(.plain)
}
