//
//  FileManager+Extensions.swift
//  NAToDo (iOS)
//
//  Created by Сергей Кривошеев on 28.03.2022.
//

import Foundation


let fileName: String = "ToDos.json"
extension FileManager {
    static var docDirURL: URL {
        return Self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveDocument(contens: String, docName: String, complition: (Error?) -> Void) {
        let url = Self.docDirURL.appendingPathComponent(docName)
        // сохранеиние файла на устройстве
        do {
            try contens.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            complition(error)
        }
    }
    
    func readDocument(docName: String, complition: (Result<Data,Error>) -> Void) {
        let url = Self.docDirURL.appendingPathComponent(docName)
        
        do {
             let data = try Data(contentsOf: url)
            complition(.success(data))
        } catch {
            complition(.failure(error))
        }
    }
    
    func doFileExist(docName: String) -> Bool {
        fileExists(atPath: Self.docDirURL.appendingPathComponent(docName).path)
    }
    
    
}
