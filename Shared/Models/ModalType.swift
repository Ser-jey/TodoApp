//
//  ModalType.swift
//  NAToDo (iOS)
//
//  Created by Сергей Кривошеев on 27.03.2022.
//

import Foundation
import SwiftUI

enum ModalType: Identifiable, View {
    case new
    case update(ToDo)
    var id: String {
        switch self {
        case .new:
            return "new"
        case .update:
            return "update"
        }
    }
    var body: some View {
        switch self {
        case .new:
            return ToDoFormView(toDoFormVM: ToDoFormViewModel())
        case .update(let ToDo):
            return ToDoFormView(toDoFormVM: ToDoFormViewModel(currentToDo: ToDo))
        }
    }
}
