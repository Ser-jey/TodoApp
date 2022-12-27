//
//  ToDoFormView.swift
//  NAToDo (iOS)
//
//  Created by Сергей Кривошеев on 27.03.2022.
//

import SwiftUI

struct ToDoFormView: View {
    
    @EnvironmentObject var dataStore: DataStore
    @ObservedObject var toDoFormVM: ToDoFormViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            Form{
                VStack(alignment: .leading){
                    TextField("ToDo", text: $toDoFormVM.name)
                    Divider()
                    Toggle("Completed", isOn: $toDoFormVM.completed)
                }
            }
            .navigationTitle("ToDo")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: cancelButton, trailing: updateSaveButton)
        }
        
        
    }
}

extension ToDoFormView {
    
    func upDateToDo() {
        let toDo = ToDo(id: toDoFormVM.id!, name: toDoFormVM.name, completed: toDoFormVM.completed)
        dataStore.updateToDo.send(toDo)
        presentationMode.wrappedValue.dismiss()
    }
    
    func addToDo() {
        let toDo = ToDo(name: toDoFormVM.name, completed: toDoFormVM.completed)
        dataStore.addToDo.send(toDo)
        presentationMode.wrappedValue.dismiss()
    }
    
    var cancelButton: some View {
        Button("Cancel"){
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var updateSaveButton: some View {
        Button(toDoFormVM.updating ? "Update" : "Save", action: toDoFormVM.updating ? upDateToDo : addToDo)
            .disabled(toDoFormVM.isDisabled)
    }
}

struct ToDoFormView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoFormView(toDoFormVM: ToDoFormViewModel())
            .environmentObject(DataStore())
    }
}
