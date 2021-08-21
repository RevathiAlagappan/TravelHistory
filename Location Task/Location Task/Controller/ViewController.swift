//
//  ViewController.swift
//  Location Task
//
//  Created by unikove on 18/08/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var locationTbl: UITableView!
    
    var locationListVM: LocationListViewModel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTbl.delegate = self
        locationTbl.dataSource = self
        prepareData()
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("LocationUpdate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(prepareData), name: Notification.Name(NotificationName.updateLocation), object: nil)
        
    }
    
    @objc func prepareData() {
        
        self.locationListVM = LocationListViewModel(locations: CoreDataManager.shared.fetchLocationRecord())

        locationTbl.reloadData()
    }

}

extension ViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationListVM.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        //cell?.textLabel?.text = "Test"
        
        let location = self.locationListVM.locationAtIndex(indexPath.row)
        
        cell?.textLabel?.text = location.title
        cell?.textLabel?.numberOfLines = 0
        return cell!
    }
    
}



