//
//  Movie.swift
//  Movie Search
//
//  Created by YJ Yoon on 10/16/19.
//  Copyright © 2019 YJ Yoon. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let id: Int!
    let poster_path: String?
    let backdrop_path: String?
    let title: String
    let release_date: String
    let vote_average: Double
    let overview: String
    let vote_count:Int!
}
