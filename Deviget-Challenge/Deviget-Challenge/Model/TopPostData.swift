//
//  TopPostData.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 14/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

import Foundation

struct TopPostData: Codable {
    let modhash: String?
    let children: [TopPostChildren]?
    let after: String?
    let before: String?
}
