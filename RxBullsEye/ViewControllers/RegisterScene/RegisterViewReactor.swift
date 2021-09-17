//
//  RegisterViewReactor.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import ReactorKit
import RxSwift

class RegisterViewReactor: Reactor {
    // MARK: - Enum
    
    enum Action {
        case viewDidLoad
        case cancel
        case textChanged(String?)
        case done
    }
    
    enum Mutation {
        case setName(String)
        case dismiss
        case setIsEnableDone(Bool)
    }
    
    struct State {
        var isDismiss = false
        var isEnableDone = true
        var name = ""
    }
    
    // MARK: - Properties
    
    var initialState = State()
    
    var serviceProvider: ServiceProviderType
    
    // MARK: - Initialization
    
    init(serviceProvider: ServiceProviderType) {
        self.serviceProvider = serviceProvider
    }
    
    // MARK: - Methods
    
    func mutate(action: RegisterViewReactor.Action) -> Observable<RegisterViewReactor.Mutation> {
        switch action {
        case .viewDidLoad:
            let name = serviceProvider.userDefaultsService.value(forKey: UserDefaultsService.Key.name.rawValue) as? String ?? "Guest"
            return .just(.setName(name))
        
        case .cancel:
            return .just(.dismiss)
            
        case .textChanged(let text):
            if text != nil && text != "" {
                return .of(.setName(text ?? ""), .setIsEnableDone(true))
            } else {
                return .of(.setName(""), .setIsEnableDone(false))
            }
            
        case .done:
            return serviceProvider.hallOfFameService.update(name: currentState.name)
                .flatMap { _ -> Observable<Mutation> in
                    return .just(.dismiss)
            }
        }
    }
    
    func reduce(state: RegisterViewReactor.State, mutation: RegisterViewReactor.Mutation) -> RegisterViewReactor.State {
        var state = state
        
        switch mutation {
        case .setName(let name):
            state.name = name
            
        case .dismiss:
            state.isDismiss = true
            
        case .setIsEnableDone(let isEnableDone):
            state.isEnableDone = isEnableDone
        }
        
        return state
    }
}

