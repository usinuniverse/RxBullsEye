//
//  ServiceProviderType.swift
//  RxBullsEye
//
//  Created by jae hyeong ahn on 2020/01/28.
//  Copyright © 2020 usinuniverse. All rights reserved.
//

import Foundation

protocol ServiceProviderType {
    var userDefaultsService: UserDefaultsServiceType { get }
    var hallOfFameService: HallOfFameServiceType { get }
}

