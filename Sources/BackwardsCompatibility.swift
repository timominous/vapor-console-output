//
//  BackwardsCompatibility.swift
//  Vapor
//
//  Created by Shaun Harrison on 3/30/16.
//

#if !swift(>=3.0)

extension String {

	internal func lowercased() -> String {
		return self.lowercaseString
	}

	internal mutating func replaceSubrange(range: Range<Index>, with: String) {
		self.replaceRange(range, with: with)
	}

}

extension String.CharacterView.Index {

	internal func advanced(by n: Distance) -> String.CharacterView.Index {
		return self.advancedBy(n)
	}

	internal func distance(to end: String.CharacterView.Index) -> Distance {
		return self.distanceTo(end)
	}

}

#endif
