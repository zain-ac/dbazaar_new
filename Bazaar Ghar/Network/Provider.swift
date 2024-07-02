//
//  Services.swift
//  RGB
//
//  Created by usamaghalzai on 15/11/2021.
//  Copyright © 2021 usamaghalzai. All rights reserved.
//

import Foundation
import Moya

struct Provider {
    static let services = MoyaProvider<Services>(plugins: [Plugin.networkPlugin, NetworkLoggerPlugin(verbose: true), Plugin.authPlugin])
    static let backgroundServices = MoyaProvider<Services>(plugins: [NetworkLoggerPlugin(verbose: true), Plugin.authPlugin])
}

