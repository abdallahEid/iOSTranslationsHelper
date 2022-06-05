//
//  main.swift
//  SwvlLocalization
//
//  Created by Abdallah Eid on 01/06/2022.
//

import Foundation

let program = Main()
program.run()

class Main {
    // MARK: - Properties
    private var localizationScript: LocalizationScript?
    private var fileHandler: FileHandler?

    // MARK: - Start Function
    func run(){
        let csvFileInput = takeInput(inputMessage: "Please, enter your CSV file path")
        let projectFileInput = takeInput(inputMessage: "Please, enter your project file path")
        
        fileHandler = FileHandler(directoryPath: projectFileInput)
        localizationScript = LocalizationScript(csvFilePath: csvFileInput, fileHandler: fileHandler!)
        localizationScript?.run()
    }
}

// MARK: - Helpers
extension Main {
    private func takeInput(inputMessage: String) -> String{
            
        print(inputMessage)
        var input = getInput()
        while (input == "") {
            print(inputMessage)
            input = getInput()
        }
        return input
    }
    
    private func getInput() -> String {
        let keyboard = FileHandle.standardInput
        let inputData = keyboard.availableData
        let strData = String(data: inputData, encoding: String.Encoding.utf8)!
        
        return strData.trimmingCharacters(in: CharacterSet.newlines)
    }
}

