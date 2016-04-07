//
//  Output.swift
//  Vapor
//
//  Created by Shaun Harrison on 2/20/16.
//

public class Output {
	private let formatter: OutputFormatter

	public init(formatter: OutputFormatter = OutputFormatter()) {
		self.formatter = formatter
	}

	@available(*, deprecated:0.2, renamed:"write", message:"Use write instead")
	public func writeln(message: String) {
		self.writeln([message])
	}

	@available(*, deprecated:0.2, renamed:"write", message:"Use write instead")
	public func writeln(messages: [String]) {
		self.write(messages, newLine: true);
	}

	public func write(message: String, newLine: Bool = true) {
		self.write([message], newLine: newLine)
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
