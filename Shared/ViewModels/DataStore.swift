//
//  Datastore.swift
//  NAToDo (iOS)
//
//  Created by Сергей Кривошеев on 26.03.2022.
//

import Foundation
import Combine
import SwiftUI


class DataStore: ObservableObject {
    
    @Published var toDos: [ToDo] = []
    @Published var appError: AppError? = nil
    
    var addToDo = PassthroughSubject<ToDo, Never>()
    var updateToDo = PassthroughSubject<ToDo, Never>()
    var deleteToDo = PassthroughSubject<Int, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    
    init() {
        addSubscritions()
        if FileManager().doFileExist(docName: fileName) {
        loadToDos()
        } else {
            addToDo.send(ToDo.sampleData.first!)
        }
    }
    
    func addSubscritions() {
        
        addToDo.sink { [weak self] toDo in
            self?.toDos.append(ToDo(name: toDo.name, completed: toDo.completed))
            self?.saveToDos()
            
        }.store(in: &subscriptions)
        
        updateToDo.sink { [weak self] toDo in
            guard let Index = self?.toDos.firstIndex(where: { $0.id == toDo.id }) else { return }
            self?.toDos[Index] = toDo
            self?.saveToDos()
            
        }.store(in: &subscriptions)
        
        deleteToDo.sink { [weak self] index in
            self?.toDos.remove(at: index)
            self?.saveToDos()
            
        }.store(in: &subscriptions)
        
    }
    
//    func deleteToDo(_ toDo: ToDo) {
//        if let indexToDelete = toDos.firstIndex(where: {$0.id == toDo.id}) {
//            toDos.remove(at: indexToDelete)
//        }
//        saveToDos()
//    }
    
    func loadToDos() {
        FileManager().readDocument(docName: fileName) { (result) in
            switch result {
                
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    toDos = try decoder.decode([ToDo].self, from: data)
                } catch {
                    self.appError = AppError(errorString:error.localizedDescription)
                    print(error.localizedDescription)
                }
            case .failure(let error):
                self.appError = AppError(errorString: error.localizedDescription)
                print(error.localizedDescription)
            }
            
        }
    }
    
    func saveToDos() {
        print("Saving toDos to file system")
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(toDos)
            let jsonString = String(decoding: data, as: UTF8.self)
            FileManager().saveDocument(contens: jsonString, docName: fileName) { error in
                if let error = error {
                    self.appError = AppError(errorString: error.localizedDescription)
                    print(error.localizedDescription)
                }
            }
        } catch {
            self.appError = AppError(errorString: error.localizedDescription)
            print(error.localizedDescription)
        }
    }
    
    struct AppError: Identifiable {
        let id = UUID().uuidString
        var errorString: String
    }
    
}
