//
//  ServiceProvider.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import Foundation

class ServiceProvider: ServiceProviderType {
    lazy var userDefaultsService: UserDefaultsServiceType = UserDefaultsService(serviceProvider: self)
    lazy var hallOfFameService: HallOfFameServiceType = HallOfFameService(serviceProvider: self)
}
