//
//  HallOfFameViewController.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import UIKit

import ReactorKit
import RxDataSources
import RxSwift

class HallOfFameViewController: BaseViewController, StoryboardView {
    // MARK: - Properties
    // MARK: Declare
    
    private let dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfRecord>(
        animationConfiguration: AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .automatic),
        configureCell: { (dataSource, tableView, indexPath, record) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as? RecordTableViewCell else { fatalError() }
            cell.score = record.score
            cell.name = record.name
            return cell
    },
        canEditRowAtIndexPath: { (_, _) -> Bool in
            return true
    })
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Methods
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
    }
    
    // MARK: Configure
    
    private func configureTableView() {
        tableView.register(UINib(nibName: RecordTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RecordTableViewCell.identifier)
        tableView.register(UINib(nibName: RecordTableHeaderView.identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: RecordTableHeaderView.identifier)
        tableView.tableFooterView = UIView()
    }
    
    // MARK: Bind
    
    func bind(reactor: HallOfFameViewReactor) {
        // Delegate
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // Action
        let registerButton = setNavigationBarButton(type: .register, at: .right)
        registerButton.rx.tap
            .map { reactor.createRegisterViewReactor() }
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, reactor in
                let registerViewController = ViewControllers.register(reactor).instantiate()
                weakSelf.present(registerViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        Observable.just(())
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .map { Reactor.Action.delete($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.records }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - Extension
// MARK: UITableViewDelegate

extension HallOfFameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecordTableHeaderView.identifier) as? RecordTableHeaderView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
