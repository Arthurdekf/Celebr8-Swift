//
//  ContentView.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 10/07/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Image(systemName: "calendar")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
            
            Text("CELEBR8")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Descubra eventos incríveis")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
