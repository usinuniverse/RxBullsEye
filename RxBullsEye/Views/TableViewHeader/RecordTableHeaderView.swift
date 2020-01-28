//
//  RecordHeaderView.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import UIKit

class RecordTableHeaderView: UIView {
    // MARK: - Properties
    // MARK: IBOutlet
    
    @IBOutlet var mainView: UIView!
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.customInit()
    }
    
    func customInit() {
        Bundle.main.loadNibNamed(RecordTableHeaderView.identifier, owner: self, options: nil)
        self.mainView.frame = self.bounds
        self.mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.mainView)
    }
    
}
