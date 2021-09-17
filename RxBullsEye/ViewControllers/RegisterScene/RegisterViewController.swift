//
//  RegisterViewController.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

class RegisterViewController: BaseViewController, StoryboardView {
    // MARK: - Properites
    // MARK: IBOutlet
    
    @IBOutlet private weak var textField: UITextField!
    
    // MARK: - Methods
    // MARK: Bind
    
    func bind(reactor: RegisterViewReactor) {
        // Action
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let cancelButton = setNavigationBarButton(type: .cancel, at: .left)
        cancelButton.rx.tap
            .map { Reactor.Action.cancel }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let doneButton = setNavigationBarButton(type: .done, at: .right)
        doneButton.rx.tap
            .map { Reactor.Action.done }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        textField.rx.text.changed
            .distinctUntilChanged()
            .map { Reactor.Action.textChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isDismiss }
            .distinctUntilChanged()
            .filter({ $0 })
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isEnableDone }
            .distinctUntilChanged()
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
