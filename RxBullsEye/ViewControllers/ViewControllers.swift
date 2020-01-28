//
//  ViewControllers.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import UIKit

enum ViewControllers {
    case gameRoom(GameRoomViewReactor)
    case hallOfFame(HallOfFameViewReactor)
    case register(RegisterViewReactor)
}

extension ViewControllers {
    func instantiate() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch self {
        case .gameRoom(let reactor):
            guard let gameRoomViewController = storyboard.instantiateViewController(withIdentifier: GameRoomViewController.identifier) as? GameRoomViewController else { fatalError() }
            gameRoomViewController.reactor = reactor
            let navigationController = UINavigationController(rootViewController: gameRoomViewController)
            return navigationController
            
        case .hallOfFame(let reactor):
            guard let hallOfFameViewController = storyboard.instantiateViewController(withIdentifier: HallOfFameViewController.identifier) as? HallOfFameViewController else { fatalError() }
            hallOfFameViewController.reactor = reactor
            return hallOfFameViewController
            
        case .register(let reactor):
            guard let registerViewController = storyboard.instantiateViewController(withIdentifier: RegisterViewController.identifier) as? RegisterViewController else { fatalError() }
            registerViewController.reactor = reactor
            let navigationController = UINavigationController(rootViewController: registerViewController)
            return navigationController
        }
    }
}
