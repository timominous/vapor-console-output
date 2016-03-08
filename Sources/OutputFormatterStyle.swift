//
//  OutputFormatterStyle.swift
//  Vapor
//
//  Created by Shaun Harrison on 2/20/16.
//  Adopted from Symfony: https://github.com/symfony/console/blob/40b3aca/Formatter/OutputFormatterStyle.php
//

private typealias OutputFormatterStyleOption = (set: String, unset: String)

public class OutputFormatterStyle {
	private static let availableForegroundColors = [
		"black":  OutputFormatterStyleOption(set: "30", unset: "39"),
		"red":  OutputFormatterStyleOption(set: "31", unset: "39"),
		"green":  OutputFormatterStyleOption(set: "32", unset: "39"),
		"yellow":  OutputFormatterStyleOption(set: "33", unset: "39"),
		"blue":  OutputFormatterStyleOption(set: "34", unset: "39"),
		"magenta":  OutputFormatterStyleOption(set: "35", unset: "39"),
		"cyan":  OutputFormatterStyleOption(set: "36", unset: "39"),
		"white":  OutputFormatterStyleOption(set: "37", unset: "39"),
		"default":  OutputFormatterStyleOption(set: "39", unset: "39")
	]

	private static let availableBackgroundColors = [
		"black": OutputFormatterStyleOption(set: "40", unset: "49"),
		"red": OutputFormatterStyleOption(set: "41", unset: "49"),
		"green": OutputFormatterStyleOption(set: "42", unset: "49"),
		"yellow": OutputFormatterStyleOption(set: "43", unset: "49"),
		"blue": OutputFormatterStyleOption(set: "44", unset: "49"),
		"magenta": OutputFormatterStyleOption(set: "45", unset: "49"),
		"cyan": OutputFormatterStyleOption(set: "46", unset: "49"),
		"white": OutputFormatterStyleOption(set: "47", unset: "49"),
		"default": OutputFormatterStyleOption(set: "49", unset: "49")
	]

	private static let availableOptions = [
		"bold": OutputFormatterStyleOption(set: "1", unset: "22"),
		"underscore": OutputFormatterStyleOption(set: "4", unset: "24"),
		"blink": OutputFormatterStyleOption(set: "5", unset: "25"),
		"reverse": OutputFormatterStyleOption(set: "7", unset: "27"),
		"conceal": OutputFormatterStyleOption(set: "8", unset: "28")
	]

	public var foreground: String? {
		willSet {
			if let value = newValue where self.dynamicType.availableForegroundColors[value] == nil {
				fatalError("Invalid foreground color specified: \(value)")
			}
		}
	}

	public var background: String? {
		willSet {
			if let value = newValue where self.dynamicType.availableBackgroundColors[value] == nil {
				fatalError("Invalid background color specified: \(value)")
			}
		}
	}

	private var options = Array<OutputFormatterStyleOption>()

	public init(foreground: String? = nil, background: String? = nil, options: [String]? = nil) {
		self.foreground = foreground
		self.background = background

		if let options = options {
			for option in options {
				self.setOption(option)
			}
		}
	}

	public func setOption(option: String) {
		guard let value = self.dynamicType.availableOptions[option] else {
			fatalError("Invalid option specified: \(option)")
		}

		self.options.append(value)
	}

	public func unsetOption(option: String) {
		fatalError("TODO")
	}

	public func apply(text: String) -> String {
		var setCodes = Array<String>()
		var unsetCodes = Array<String>()

		if let foreground = self.foreground, color = self.dynamicType.availableForegroundColors[foreground] {
			setCodes.append(color.set)
			unsetCodes.append(color.unset)
		}

		if let background = self.background, color = self.dynamicType.availableBackgroundColors[background] {
			setCodes.append(color.set)
			unsetCodes.append(color.unset)
		}

		for option in options {
			setCodes.append(option.set)
			unsetCodes.append(option.unset)
		}

		if setCodes.count == 0 {
			return text
		} else {
			return "\u{001B}[\(setCodes.joinWithSeparator(";"))m\(text)\u{001B}[\(unsetCodes.joinWithSeparator(";"))m"
		}
	}

}
