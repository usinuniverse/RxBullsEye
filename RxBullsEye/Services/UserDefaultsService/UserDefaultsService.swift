//
//  UserDefaults.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import Foundation

class UserDefaultsService: UserDefaultsServiceType {
    // MARK: - Enum
    
    enum Key: String {
        case hallOfFame
        case name
    }
    
    // MARK: - Properties
    
    var serviceProvider: ServiceProviderType
    
    private var userDefaults = UserDefaults.standard
    
    // MARK: - Initialization
    
    init(serviceProvider: ServiceProviderType) {
        self.serviceProvider = serviceProvider
    }
    
    // MARK: - Methods
    
    func set<T>(value: T, forKey key: String) {
        self.userDefaults.set(value, forKey: key)
    }
    
    func value(forKey key: String) -> Any? {
        return self.userDefaults.value(forKey: key)
    }
    
}
