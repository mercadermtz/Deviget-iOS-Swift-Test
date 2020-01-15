//
//  NetworkManager.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 15/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

import UIKit

struct NetworkManager {
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion:  @escaping (UIImage?, Error?) -> ()) {
        getData(from: url) { data, response, error in
            if let data = data,
                error == nil {
                let image = UIImage(data: data)
                completion(image, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
