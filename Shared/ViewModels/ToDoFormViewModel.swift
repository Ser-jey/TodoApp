//
//  ToDoFormViewModel.swift
//  NAToDo (iOS)
//
//  Created by Сергей Кривошеев on 27.03.2022.
//

import Foundation

class ToDoFormViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var completed: Bool = false
    var id: String?
    
    var updating: Bool {
        id != nil
    }
    
    var isDisabled: Bool {
        name.isEmpty
    }
    
    init() {}
    
    init(currentToDo: ToDo) {
        self.name = currentToDo.name
        self.completed = currentToDo.completed
        id = currentToDo.id
    }
    
}
