//
//  SceneDelegate.swift
//  ToDoApp
//
//  Created by Павел on 18.03.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = ThemeUserDefaults.shared.theme.getUserInterfaceStyle()
        
        let tabBarController = UITabBarController()
        
        let settingsViewController = SettingsAssembly.buildScreen()
        settingsViewController.tabBarItem = UITabBarItem(title: "",
                                                         image: UIImage(systemName: "gearshape.2.fill"),
                                                         tag: 0)
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        
        let tasksViewController = TasksAssembly.buildScreen()
        tasksViewController.tabBarItem = UITabBarItem(title: "",
                                                      image: UIImage(systemName: "tray.full"),
                                                      tag: 1)
        let tasksNavigationController = UINavigationController(rootViewController: tasksViewController)
        
        let createTaskViewController = CreateTaskAssembly.buildScreen()
        createTaskViewController.tabBarItem = UITabBarItem(title: "",
                                                               image: UIImage(systemName: "pencil.line"),
                                                               tag: 2)
        let newTaskNavigationController = UINavigationController(rootViewController: createTaskViewController)
        
        
        tabBarController.viewControllers = [settingsNavigationController, tasksNavigationController, newTaskNavigationController]
        tabBarController.selectedViewController = tasksNavigationController
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }

}

