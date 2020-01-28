//
//  UserDefaultsServiceType.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import Foundation

protocol UserDefaultsServiceType {
    var serviceProvider: ServiceProviderType { get }
    
    func set<T>(value: T, forKey key: String) -> Void
    func value(forKey key: String) -> Any?
}

