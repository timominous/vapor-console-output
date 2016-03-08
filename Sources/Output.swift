//
//  Output.swift
//  Vapor
//
//  Created by Shaun Harrison on 2/20/16.
//

public class Output {
	private let formatter = OutputFormatter()

	public func writeln(message: String) {
		self.writeln([message])
	}

	public func writeln(messages: [String]) {
		self.write(messages, newLine: true);
	}

	public func write(messages: [String], newLine: Bool = true) {
		for message in messages {
			let formatted = self.formatter.format(message)

			if newLine {
				print(formatted)
			} else {
				print(formatted, terminator: "")
			}
		}
	}

}
