//
//  SwiftUIView.swift
//  ScreenTimeAPIExample
//
//  Created by Doyeon on 2023/04/25.
//

import SwiftUI
import FamilyControls

struct SwiftUIView: View {
    
    @State var selection = FamilyActivitySelection()
    @State var isPresented = false
    
    var body: some View {
        Button("Present FamilyActivityPicker") { isPresented.toggle() }
            .familyActivityPicker(isPresented: $isPresented, selection: $selection)
            .onChange(of: selection) { newSelection in
                let applications = selection.applications
                let categories = selection.categories
                let webDomains = selection.webDomains
                
                print("< -------------- selected -------------- >")
                print("applications token : \(applications)")
                print("categories : \(categories)")
                print("webDomains : \(webDomains)")
            }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
