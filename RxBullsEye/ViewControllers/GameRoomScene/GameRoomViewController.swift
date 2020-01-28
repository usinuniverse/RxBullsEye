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
    
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var goalNumberLabel: UILabel!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var checkButton: UIButton!
    
    // MARK: - Methods
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Bind
    
    func bind(reactor: GameRoomViewReactor) {
        // Action
        let startButton = self.setNavigationBarButton(type: .start, at: .left)
        startButton.rx.tap
            .map { Reactor.Action.start }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        let hallOfFameButton = self.setNavigationBarButton(type: .hallOfFame, at: .right)
        hallOfFameButton.rx.tap
            .map { reactor.createHallOfFameViewReactor() }
            .subscribe(onNext: { [weak self] reactor in
                let hallOfFameViewController = ViewControllers.hallOfFame(reactor).instantiate()
                self?.navigationController?.pushViewController(hallOfFameViewController, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.checkButton.rx.tap
            .map { Reactor.Action.check }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.slider.rx.value
            .map { Reactor.Action.sliderValueChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { "\($0.count)" }
            .bind(to: self.countLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { "\($0.goalNumber)" }
            .filter { $0 != "0" }
            .distinctUntilChanged()
            .bind(to: self.goalNumberLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { !$0.isPlaying }
            .distinctUntilChanged()
            .bind(to: startButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isPlaying }
            .distinctUntilChanged()
            .bind(to: self.slider.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.sliderValue }
            .distinctUntilChanged()
            .bind(to: self.slider.rx.value)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isPlaying }
            .distinctUntilChanged()
            .bind(to: self.checkButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isFinish }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isFinish in
                guard isFinish else { return }
                guard let self = self else { return }
                self.alert(
                    title: "🎉정답!!🎉",
                    message: "축하합니다!. \(reactor.currentState.count)회 만에 정답을 맞추셨네요!\n바로 순위를 확인하실래요?",
                    actions: [AlertAction(title: "취소", type: 0, style: .cancel),
                              AlertAction(title: "확인", type: 1, style: .default)],
                    preferredStyle: .alert, vc: self)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { [weak self] type in
                        guard type == 1 else { return }
                        let reactor = reactor.createHallOfFameViewReactor()
                        let hallOfFameViewController = ViewControllers.hallOfFame(reactor).instantiate()
                        self?.navigationController?.pushViewController(hallOfFameViewController, animated: true)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
    }
    
}
