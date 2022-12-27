//
//  ContentView.swift
//  Shared
//
//  Created by Сергей Кривошеев on 26.03.2022.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var dataStore: DataStore
    @State var modalType: ModalType? = nil
    var body: some View {
        NavigationView {
            List{
                ForEach($dataStore.toDos){ $toDo in
                    HStack {
                        Image(systemName: toDo.completed ? "checkmark.circle" : "circle")
                            .foregroundColor(toDo.completed ? Color.mint : Color.pink)
                            .onTapGesture {
                                withAnimation(.linear(duration: 0.2)) {
                                    toDo.completed.toggle()
                                }
                            }
                            .font(.title3)
                        TextField("ToDo", text: $toDo.name)
                            .font(.title3)
                            .onSubmit { // Выполняется по нажатию Ввод'а
                                dataStore.updateToDo.send(toDo)
                            }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            guard let index = dataStore.toDos.firstIndex(where: {
                                $0.id == toDo.id
                           }) else { return }
                            withAnimation(.linear(duration: 0.2)){
                                dataStore.deleteToDo.send(index)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            withAnimation(.linear(duration: 0.2)) {
                                toDo.completed.toggle()
                            }
                            dataStore.updateToDo.send(toDo)
                        } label: {
                            Text(toDo.completed ? "Remove complition" : "To complete")
                        }.tint(.teal)

                    }
                    
                }
//                .onMove { indexSet, index in
//                    dataStore.toDos.move(fromOffsets: indexSet, toOffset: index)
//                  }
//
            }
            .listStyle(.insetGrouped) // InsetGroupedListSyle()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My ToDos")
                        .font(.title)
                        .foregroundColor(Color(.label))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation(){
                            modalType = .new                        }
                         
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }

                }
            }
        }
        .alert(item: $dataStore.appError) { appError in
            Alert(title: Text("Error"), message: Text(appError.errorString))
        }
        .sheet(item: $modalType){
            $0
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(DataStore())
    }
}
