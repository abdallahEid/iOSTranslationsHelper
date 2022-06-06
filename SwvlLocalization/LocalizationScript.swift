//
//  LocalizationScript.swift
//  SwvlLocalization
//
//  Created by Abdallah Eid on 01/06/2022.
//

import TabularData
import Foundation

// MARK: - LocalizationScript
class LocalizationScript {
    
    // MARK: - Properties
    private let csvFilePath: String
    private let fileHandler: FileHandler
    
    private var dataFrame: DataFrame?
    private var languagesCodes = [String]()
    private var filesLanguagesMap = [String: String]()
    private var localizationPerLanguage = [String: [String]]()
    
    // MARK: - Computed Properties
    private var localizableFilesUrlsStrings: [String] {
        return fileHandler.getLocalizableFilesUrls()
    }
    
    // MARK: Constants
    private let keyKey: String = "KEY"
    
    // MARK: Initializations
    init(csvFilePath: String, fileHandler: FileHandler) {
        self.csvFilePath = csvFilePath
        self.fileHandler = fileHandler
    }
    
    // MARK: - Run
    func run() {
        readCSVFile()
        handleFilesLanguagesMapping()
        constructLocalization()
        getLocalizableFilesAndWriteDataToEachFile()
    }
    
    // MARK: - Read CSV
    private func readCSVFile() {
        do {
            let url = URL(fileURLWithPath: csvFilePath)
            let result = try DataFrame(contentsOfCSVFile: url)
            dataFrame = result
            
        } catch {
            print("Error in reading file")
        }
    }
    
    // MARK: - Construct Localization
    private func constructLocalization() {
        guard let dataFrame = dataFrame else {
            return
        }
        
        for languagesCode in languagesCodes {
            localizationPerLanguage[languagesCode] = [String]()
            dataFrame.rows.enumerated().forEach { index, value in
                if let key = dataFrame["KEY"][index],
                    dataFrame.columns.map( { $0.name } ).contains(languagesCode) {
                    if let value = dataFrame[languagesCode][index] as? String {
                        let localization = value.removeEndLinesAndSpacesFromTheEndOfText()
                        localizationPerLanguage[languagesCode]?.append("\"\(key)\" = \"\(localization)\";")
                    } else {
                        if let value = dataFrame["en"][index] as? String {
                            let localization = value.removeEndLinesAndSpacesFromTheEndOfText()
                            localizationPerLanguage[languagesCode]?.append("\"\(key)\" = \"\(localization)\";")
                        } else {
                            localizationPerLanguage[languagesCode]?.append("\"\(key)\" = \"\(key)\";")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Get LocalizableFiles And Write Data To Each File
    private func getLocalizableFilesAndWriteDataToEachFile(){
        localizableFilesUrlsStrings.forEach {
            if let language = self.filesLanguagesMap[$0]  {
                print("Adding localizations to file \($0) ......")
                fileHandler.writeTextToFile(texts: self.localizationPerLanguage[language], filePathString: $0) { success in
                    if success {
                        print("success in writing in file")
                    } else {
                        print("Error in writing in file")
                    }
                }
                print("Localizations added to file \($0)")
            } else {
                print("Can't find the file \($0)")
            }
        }
    }
    
    // MARK: - Files and Languages Mapping 
    private func handleFilesLanguagesMapping(){
        for localizableFilesUrlsString in localizableFilesUrlsStrings {
            let components = localizableFilesUrlsString.components(separatedBy: "/")
            let fileName = components[components.count - 2]
            let languageCode = fileName.replacingOccurrences(of: ".lproj", with: "")
            
            languagesCodes.append(languageCode)
            filesLanguagesMap[localizableFilesUrlsString] = languageCode
        }
    }
    
}
