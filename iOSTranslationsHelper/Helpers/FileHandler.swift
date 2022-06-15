//
//  FileHandler.swift
//  SwvlLocalization
//
//  Created by Abdallah Eid on 01/06/2022.
//

import Foundation

class FileHandler {
    
    private var directoryPath: String
    
    init(directoryPath: String) {
        self.directoryPath = directoryPath
    }
    
    func writeTextToFile(texts: [String]?, filePathString: String, completion: (Bool) -> Void) {
        
        let filePaths = getAllDirectoryFilesPaths()
        var success = true
        for filePath in filePaths{
            if filePath == filePathString {
                do {
                    let fileURL = URL(fileURLWithPath: filePath)
                    try "\n".appendToURL(fileURL: fileURL as URL)

                    for text in texts ?? [] {
                        try text.appendLineToURL(fileURL: fileURL as URL)
                    }

                    success = true

                } catch {
                    success = false
                }
                break
            }
        }
        
        completion(success)
    }
    
    private func getAllDirectoryFilesPaths() -> [String] {
        let fileManager = FileManager.default
        var files = [String]() // Using a URL instead of a path.

        guard let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: directoryPath) else { return [] }
        let directoryUrl = URL(fileURLWithPath: directoryPath)

        while let filepath = enumerator.nextObject() as? String {
            let pathUrl = directoryUrl.appendingPathComponent(filepath)
            let pathUrlString = pathUrl.absoluteString.replacingOccurrences(of: "file://", with: "")
            files.append(pathUrlString)
        }
        
        return files
    }
    
    func getLocalizableFilesUrls() -> [String]{
        var urlStrings = [String]()

        let filePaths = getAllDirectoryFilesPaths()
        for filePath in filePaths{
            if filePath.hasSuffix("/Localizable.strings") {
                urlStrings.append(filePath)
            }
        }
        
        return urlStrings
    }
}
