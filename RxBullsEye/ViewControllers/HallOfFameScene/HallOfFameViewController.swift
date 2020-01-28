//
//  HallOfFameViewController.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import UIKit

import ReactorKit

class HallOfFameViewController: BaseViewController, StoryboardView {
    // MARK: - Properties
    // MARK: IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Methods
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Bind
    
    func bind(reactor: HallOfFameViewReactor) {
        
    }
    
}
