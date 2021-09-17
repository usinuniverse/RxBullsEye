//
//  AppDelegate.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let serviceProvider = ServiceProvider()
        let reactor = GameRoomViewReactor(serviceProvider: serviceProvider)
        let gameRoomViewController = ViewControllers.gameRoom(reactor).instantiate()
        window?.rootViewController = gameRoomViewController
        return true
    }
}

