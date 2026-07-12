//
//  Celebr8App.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 10/07/26.
//

import SwiftUI

@main
struct Celebr8App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
