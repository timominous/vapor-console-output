//
//  OutputFormatter.swift
//  Vapor
//
//  Created by Shaun Harrison on 2/20/16.
//  Adopted from Symfony: https://github.com/symfony/console/blob/40b3aca/Formatter/OutputFormatter.php
//

public class OutputFormatter {
	public var decorated: Bool
	private var styles = Dictionary<String, OutputFormatterStyle>()
	private var styleStack = Array<OutputFormatterStyle>()

	public init(decorated: Bool = true, styles: [String: OutputFormatterStyle] = Dictionary()) {
		self.decorated = decorated

		self.setStyle("error", style: OutputFormatterStyle(foreground: "white", background: "red"));
		self.setStyle("info", style: OutputFormatterStyle(foreground: "green"));
		self.setStyle("comment", style: OutputFormatterStyle(foreground: "yellow"));
		self.setStyle("question", style: OutputFormatterStyle(foreground: "black", background: "cyan"));

		for (name, style) in styles {
			self.setStyle(name, style: style);
		}
	}

	public class func escapeText(text: String) -> String {
		// TODO: Replace with regex when NSRegularExpression is available.
		return text.replace("<", with: "\\<").replace("\\\\<", with: "\\<")
	}

	public func setStyle(name: String, style: OutputFormatterStyle) {
		self.styles[name.lowercased()] = style
	}

	public func hasStyle(name: String) -> Bool {
		return self.styles[name.lowercased()] != nil
	}

	public func getStyle(name: String) -> OutputFormatterStyle? {
		return self.styles[name.lowercased()]
	}

	public func format(message: String) -> String {
		// TODO: Very error prone. Should replace with
		// regex when NSRegularExpression is available.
		// Needs support for fg=00;bg=00 syntax

		var output = message

		for (name, style) in self.styles {
			let open = "<\(name)>"
			let close = "</\(name)>"

			while true {
				guard let openRange = output.rangeOfString(open) else {
					break
				}

				let endRange: Range<String.Index>

				if let range = output.rangeOfString(close, range: openRange.endIndex..<output.endIndex) {
					endRange = range
				} else {
					endRange = output.endIndex..<output.endIndex
				}

				let text = output[openRange.endIndex..<endRange.startIndex]
				output.replaceSubrange(openRange.startIndex..<endRange.endIndex, with: self.applyStyle(text, style: style))
			}
		}

		return output
	}

	private func createStyleFromString(string: String) -> OutputFormatterStyle? {
		if let style = self.styles[string] {
			return style
		}

		// TODO: Support fg=00;bg=00 syntax
		return nil
	}

	private func applyCurrentStyle(text: String) -> String {
		if let style = self.styleStack.last {
			return self.applyStyle(text, style: style)
		} else {
			return text
		}
	}

	private func applyStyle(text: String, style: OutputFormatterStyle) -> String {
		if self.decorated && text.characters.count > 0 {
			return style.apply(text)
		} else {
			return text
		}
	}

}
