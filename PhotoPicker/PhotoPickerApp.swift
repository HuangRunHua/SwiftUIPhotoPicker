//
//  PhotoPickerApp.swift
//  PhotoPicker
//
//  Created by Runhua Huang on 2022/4/2.
//

import SwiftUI

@main
struct PhotoPickerApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
