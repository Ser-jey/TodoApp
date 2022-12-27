//
//  ToDo.swift
//  NAToDo (iOS)
//
//  Created by Сергей Кривошеев on 26.03.2022.
//

import Foundation

struct ToDo: Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var completed: Bool = false
    
    static var sampleData: [ToDo] {
        [
            ToDo(name: "Get Groceries"),
            
        ]
    }
}
