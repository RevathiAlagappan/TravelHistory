//
//  LocationModel.swift
//  Location Task
//
//  Created by unikove on 18/08/21.
//

import Foundation

struct LocationList: Decodable {
    let location: [LocationModel]
}

struct LocationModel: Decodable {
    let title: String
    
}
