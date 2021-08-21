//
//  LocationList.swift
//  Location Task
//
//  Created by Mac on 19/08/21.
//

import Foundation

struct LocationListModel {
    private let location: [String:Any]
    
    init(_ location: [String:Any]) {
        self.location = location
    }
    
    var title: String {
        return "\(self.location["title"] ?? "")"
    }
}
