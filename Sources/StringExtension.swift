//
//  StringExtension.swift
//  Vapor
//
//  Created by Shaun Harrison on 3/23/16.
//

#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

extension String {

	internal func replace(target: String, with replacement: String) -> String {
		var out = self

		while let range = out.rangeOfString(target) {
			out.replaceSubrange(range, with: replacement)
		}

		return out
	}

	internal func rangeOfString(str: String) -> Range<Index>? {
		return rangeOfString(str, range: self.startIndex..<self.endIndex)
	}

	internal func rangeOfString(str: String, range: Range<Index>) -> Range<Index>? {
		let target = self[range]
		var index: Index? = nil

		target.withCString { (targetBytes) in
			str.withCString { (strBytes) in
				let p = strstr(targetBytes, strBytes)

				if p != nil {
					index = target.startIndex.advanced(by: p - UnsafeMutablePointer<Int8>(targetBytes))
					index = self.startIndex.advanced(by: self.startIndex.distance(to: range.startIndex)).advanced(by: target.startIndex.distance(to: index!))
				}
			}
		}

		guard let startIndex = index else {
			return nil
		}

		return startIndex..<startIndex.advanced(by: str.characters.count)
	}

}
