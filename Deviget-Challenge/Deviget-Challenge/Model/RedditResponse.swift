//
//  RedditResponse.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 14/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

import Foundation

struct RedditResponse: Codable {
    let kind: String?
    let data: TopPostData?
}
