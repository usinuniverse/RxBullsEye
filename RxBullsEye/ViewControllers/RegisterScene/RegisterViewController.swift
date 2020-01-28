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
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Bind
    
    func bind(reactor: RegisterViewReactor) {
        // Action
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        let cancelButton = self.setNavigationBarButton(type: .cancel, at: .left)
        cancelButton.rx.tap
            .map { Reactor.Action.cancel }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        let doneButton = self.setNavigationBarButton(type: .done, at: .right)
        doneButton.rx.tap
            .map { Reactor.Action.done }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.textField.rx.text.changed
            .distinctUntilChanged()
            .map { Reactor.Action.textChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .bind(to: self.textField.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isDismiss }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isDismiss in
                guard isDismiss else { return }
                self?.dismiss(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isEnableDone }
            .distinctUntilChanged()
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
    
}
