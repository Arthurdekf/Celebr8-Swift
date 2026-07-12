//
//  AppDelegate.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 11/07/26.
//

import UIKit
import FirebaseCore

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [
            UIApplication.LaunchOptionsKey: Any
        ]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
