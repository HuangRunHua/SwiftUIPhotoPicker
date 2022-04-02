//
//  ContentView.swift
//  PhotoPicker
//
//  Created by Runhua Huang on 2022/4/2.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ImageModel.id, ascending: false)], animation: .linear)
        
    private var imageModel: FetchedResults<ImageModel>
    
    @State private var isShowButton = false
    @State private var image = UIImage()
    @State private var showThemesContent = false
    
    var body: some View {
        NavigationView {
            Image(uiImage: UIImage(data: imageModel.first?.imageData ?? Data()) ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .redacted(reason: showThemesContent ? [] : .placeholder)
                .interactiveDismissDisabled()
                .onAppear(perform: {
                    DispatchQueue.main.async() {
                        showThemesContent.toggle()
                        self.image = UIImage(data: imageModel.first?.imageData ?? Data()) ?? UIImage()
                    }
                })
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.isShowButton = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Photo")
            .sheet(isPresented: $isShowButton, onDismiss: {
                if let data = self.image.jpegData(compressionQuality: 1.0) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        addItem(data: data)
                    }
                }
            }) {
                ButtonView(image: $image)
            }
        }
    }
    private func addItem(data: Data) {
        withAnimation {
            imageModel.first?.imageData = data
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
