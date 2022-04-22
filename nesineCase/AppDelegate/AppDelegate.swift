//
//  AppDelegate.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let shared = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let viewModel = HomeViewModel(dataProvider: ApiDataProvider())
        let viewController = HomeViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: viewController)
        let bounds = UIScreen.main.bounds
        self.window = UIWindow(frame: bounds)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        return true
    }
}

