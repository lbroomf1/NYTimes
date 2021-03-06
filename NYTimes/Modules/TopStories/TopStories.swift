//
//  TopStories.swift
//  NYTimes
//
//  Created by MAC on 07/09/21.
//

import Foundation

struct TopStories: Decodable {
    let results:[Result]
}

struct Result: Decodable {
    let title: String
    let byline: String
    let updatedDate: String
    
    enum CodingKeys:String, CodingKey {
        case title = "title"
        case byline = "byline"
        case updatedDate = "updated_date"
    }
}
