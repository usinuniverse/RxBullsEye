//
//  GameRoomViewController.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxUIAlert

class GameRoomViewController: BaseViewController, StoryboardView {
    // MARK: - Properties
    // MARK: IBOutlet
    
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var previousNumberLabel: UILabel!
    @IBOutlet private weak var goalNumberLabel: UILabel!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var checkButton: UIButton!
    
    // MARK: - Methods
    // MARK: Bind
    
    func bind(reactor: GameRoomViewReactor) {
        // Action
        let startButton = setNavigationBarButton(type: .start, at: .left)
        startButton.rx.tap
            .map { Reactor.Action.start }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let hallOfFameButton = setNavigationBarButton(type: .hallOfFame, at: .right)
        hallOfFameButton.rx.tap
            .map { reactor.createHallOfFameViewReactor() }
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, reactor in
                let hallOfFameViewController = ViewControllers.hallOfFame(reactor).instantiate()
                weakSelf.navigationController?.pushViewController(hallOfFameViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        checkButton.rx.tap
            .map { Reactor.Action.check }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        slider.rx.value
            .map { Reactor.Action.sliderValueChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.map { "\($0.count)" }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.previousNumber == 0 ? "-" : "\($0.previousNumber)" }
            .distinctUntilChanged()
            .bind(to: previousNumberLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { "\($0.goalNumber)" }
            .filter { $0 != "0" }
            .distinctUntilChanged()
            .bind(to: goalNumberLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isPlaying }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, isPlaying in
                startButton.isEnabled = !isPlaying
                weakSelf.slider.isEnabled = isPlaying
                weakSelf.checkButton.isEnabled = isPlaying
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.sliderValue }
            .distinctUntilChanged()
            .bind(to: slider.rx.value)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isFinish }
            .distinctUntilChanged()
            .filter { $0 }
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.rx.alert(
                    title: "🎉정답!!🎉",
                    message: "축하합니다!.\n\(reactor.currentState.count)회 만에 정답을 맞추셨네요!\n바로 순위를 확인하실래요?",
                    actions: [
                        .init(title: "취소", type: 0, style: .cancel),
                        .init(title: "확인", type: 1, style: .default)
                    ],
                    preferredStyle: .alert,
                    vc: weakSelf
                )
                .filter({ $0.index == 1 })
                .subscribe(onNext: { _ in
                    let reactor = reactor.createHallOfFameViewReactor()
                    let hallOfFameViewController = ViewControllers.hallOfFame(reactor).instantiate()
                    weakSelf.navigationController?.pushViewController(hallOfFameViewController, animated: true)
                })
                .disposed(by: weakSelf.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
