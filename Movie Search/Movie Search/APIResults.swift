//
//  APIResults.swift
//  Movie Search
//
//  Created by YJ Yoon on 10/16/19.
//  Copyright © 2019 YJ Yoon. All rights reserved.
//

import Foundation

struct APIResults:Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}
