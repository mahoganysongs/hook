//
//  ContentView.swift
//  Hook
//
//  Created by Mark Murdoch on 29/08/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WriteView()
                .tabItem {
                    Image("write-icon")
                        .renderingMode(.template)
                    Text("Write")
                }
            
            RecordView()
                .tabItem {
                    Image("record-icon")
                        .renderingMode(.template)
                    Text("Record")
                }
            
            LibraryView()
                .tabItem {
                    Image("library-icon")
                        .renderingMode(.template)
                    Text("Library")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
