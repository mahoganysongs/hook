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
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    Text("Write")
                }
            
            RecordView()
                .tabItem {
                    Image("record-icon")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    Text("Record")
                }
            
            LibraryView()
                .tabItem {
                    Image("library-icon")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    Text("Library")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
