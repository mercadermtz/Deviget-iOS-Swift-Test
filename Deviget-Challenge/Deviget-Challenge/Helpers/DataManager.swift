//
//  DataManager.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 14/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

import Foundation

class DataManager {
    func getTopPost() -> [TopPostChildren]? {
        if let url = Bundle.main.url(forResource: "top", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(RedditResponse.self, from: data)
                if let data = jsonData.data,
                    let children = data.children,
                    children.count > 0 {
                    return children
                }
            } catch {
                print("error:\(error)")
            }
        }
        
        return nil
    }
}
