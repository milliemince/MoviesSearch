//
//  DataStructs.swift
//  MovieQueryApp
//
//  Created by Camille Mince on 1/14/21.
//

import Foundation

struct ResultsType: Decodable {
    let page: Int
    let results: [MovieData]?
    let total_results: Int
    let total_pages: Int
}

struct MovieData: Decodable {
    let poster_path: String?
    let overview: String
    let title: String
}

func toValidSearchString(s: inout String) -> String {
    var stillContainsSpaces = s.contains(" ")
    while stillContainsSpaces {
        let index = s.firstIndex(of: " ")
        s.remove(at: index!)
        s.insert(contentsOf: "%20", at: index!)
        if !s.contains(" ") {
            stillContainsSpaces = false
        }
    }
    return s
}

