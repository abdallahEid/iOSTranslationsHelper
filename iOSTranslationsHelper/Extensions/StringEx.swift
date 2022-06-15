//
//  StringEx.swift
//  SwvlLocalization
//
//  Created by Abdallah Eid on 01/06/2022.
//

import Foundation

extension String {
    func appendLineToURL(fileURL: URL) throws {
        try (self + "\n").appendToURL(fileURL: fileURL)
    }
    
    func appendToURL(fileURL: URL) throws {
        let data = self.data(using: String.Encoding.utf8)!
        try data.append(fileURL: fileURL)
    }
    
    func removeEndLinesAndSpacesFromTheEndOfText() -> String {
        var newString = self
        
        while let lastCharacter = newString.popLast() {
            if lastCharacter != " " && lastCharacter != "\n" {
                break
            }
        }
        
        return newString
    }
}
