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
			out.replaceRange(range, with: replacement)
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
					index = target.startIndex.advancedBy(p - UnsafeMutablePointer<Int8>(targetBytes))
					index = self.startIndex.advancedBy(self.startIndex.distanceTo(range.startIndex)).advancedBy(target.startIndex.distanceTo(index!))
				}
			}
		}

		guard let startIndex = index else {
			return nil
		}

		return startIndex..<startIndex.advancedBy(str.characters.count)
	}

}
