//
//  SwiftUIView.swift
//  ScreenTimeAPIExample
//
//  Created by Doyeon on 2023/04/25.
//

import SwiftUI

struct SwiftUIView: View {
    
    @EnvironmentObject var model: MyModel
    @State var isPresented = false
    
    var body: some View {
        VStack {
            Button("Present FamilyActivityPicker") { isPresented.toggle() }
                .familyActivityPicker(isPresented: $isPresented, selection: $model.newSelection)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
