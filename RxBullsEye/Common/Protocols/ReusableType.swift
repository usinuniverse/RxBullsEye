//
//  ReusableType.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import UIKit

protocol ReusableType {
    static var identifier: String { get }
}

extension ReusableType {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView: ReusableType {}
extension UIViewController: ReusableType {}

