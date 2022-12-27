//
//  NAToDoApp.swift
//  Shared
//
//  Created by Сергей Кривошеев on 26.03.2022.
//

import SwiftUI

@main
struct NAToDoApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(DataStore())
        }
    }
}
