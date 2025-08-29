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
                    Image(systemName: "pencil")
                    Text("Write")
                }
            
            RecordView()
                .tabItem {
                    Image(systemName: "mic.circle")
                    Text("Record")
                }
            
            LibraryView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Library")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
