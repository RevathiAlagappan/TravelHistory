//
//  LocationListViewModel.swift
//  Location Task
//
//  Created by Mac on 18/08/21.
//

import Foundation


struct LocationListViewModel {
    let locations: [[String : Any]]
}

extension LocationListViewModel {
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.locations.count
    }
    
    func locationAtIndex(_ index: Int) -> LocationListModel {
        let location = self.locations[index]
        return LocationListModel(location)
    }
    
}



