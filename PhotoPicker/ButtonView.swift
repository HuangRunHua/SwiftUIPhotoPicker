//
//  ButtonView.swift
//  PhotoPicker
//
//  Created by Runhua Huang on 2022/4/2.
//

import SwiftUI

struct ButtonView: View {
    
    @Binding var image: UIImage
    @State private var isShowPhotoLibrary = false
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 400)
            Button(action: {
                self.isShowPhotoLibrary = true
            }) {
                Label("Add Item", systemImage: "plus")
            }
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
            }
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
    }

}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(image: .constant(UIImage())).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
