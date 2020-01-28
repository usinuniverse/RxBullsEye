//
//  GameRoomViewReactor.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import ReactorKit
import RxSwift

class GameRoomViewReactor: Reactor {
    // MARK: - Enum
    
    enum Action {
        case start
        case sliderValueChanged(Float)
        case check
    }
    
    enum Mutation {
        case startGame(Int)
        case increaseCount
        case setPreviousNumber(Int)
        case setSlider(Float)
        case endGame
    }
    
    struct State {
        let title = "Bulls-Eye 👀"
        var isPlaying = false
        var goalNumber = 0
        var count = 0
        var previousNumber = 0
        var sliderValue: Float = 50
        var isFinish = false
    }
    
    // MARK: - Properties
    
    var initialState = State()
    
    var serviceProvider: ServiceProviderType
    
    // MARK: - Initialization
    
    init(serviceProvider: ServiceProviderType) {
        self.serviceProvider = serviceProvider
    }
    
    // MARK: - Methods
    
    func mutate(action: GameRoomViewReactor.Action) -> Observable<GameRoomViewReactor.Mutation> {
        switch action {
        case .start:
            return Observable.just(.startGame(Int.random(in: 1...100)))
            
        case .sliderValueChanged(let value):
            return Observable.just(.setSlider(value))
            
        case .check:
            if self.currentState.goalNumber == Int(self.currentState.sliderValue) {
                let name = self.serviceProvider.userDefaultsService.value(forKey: UserDefaultsService.Key.name.rawValue) as? String
                return self.serviceProvider.hallOfFameService.create(record: Record(name: name ?? "Guest", score: 101 - self.currentState.count))
                    .flatMap { _ -> Observable<Mutation> in
                        return Observable.just(.endGame)
                }
            } else {
                return Observable.of(.increaseCount, .setSlider(50), .setPreviousNumber(Int(self.currentState.sliderValue)))
            }
        }
    }
    
    func reduce(state: GameRoomViewReactor.State, mutation: GameRoomViewReactor.Mutation) -> GameRoomViewReactor.State {
        var state = state
        switch mutation {
        case .startGame(let goalNumber):
            state.isPlaying = true
            state.goalNumber = goalNumber
            state.count = 1
            state.previousNumber = 0
            state.sliderValue = 50
            state.isFinish = false
            
        case .setSlider(let value):
            state.sliderValue = value
            
        case .increaseCount:
            state.count += 1
            
        case .setPreviousNumber(let previousNumber):
            state.previousNumber = previousNumber
            
        case .endGame:
            state.isPlaying = false
            state.isFinish = true
        }
        
        return state
    }
    
    func createHallOfFameViewReactor() -> HallOfFameViewReactor {
        return HallOfFameViewReactor(serviceProvider: self.serviceProvider)
    }
    
}

