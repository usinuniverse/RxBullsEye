//
//  RecordTableViewCell.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    // MARK: - Properties
    // MARK: Declare
    
    var score: Int? {
        willSet {
            self.scoreLabel.text = "\(newValue ?? 0)"
        }
    }
    var name: String? {
        willSet {
            self.nameLabel.text = newValue
        }
    }
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.scoreLabel.text = nil
        self.nameLabel.text = nil
    }
    
}
