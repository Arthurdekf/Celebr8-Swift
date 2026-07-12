//
//  MainTabView.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 10/07/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var searchText = ""
    
    var body: some View {
        TabView {
            Tab("Início", systemImage: "party.popper") {
                NavigationStack {
                    Text("Início")
                }
            }

            Tab("Eventos", systemImage: "calendar.badge.checkmark") {
                NavigationStack {
                    Text("Meus eventos")
                }
            }

            Tab("Perfil", systemImage: "person") {
                NavigationStack {
                    Text("Perfil")
                }
            }
            
            Tab(role: .search) {
                NavigationStack {
                    Text("Buscar eventos")
                }
                .searchable(
                    text: $searchText,
                    prompt: "Buscar eventos"
                )
            }
        }
        .tabViewSearchActivation(.searchTabSelection)
        .tint(AppColors.brand)
    }
}

#Preview {
    MainTabView()
}
