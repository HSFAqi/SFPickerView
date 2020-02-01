//
//  ViewController.swift
//  SFPickerView
//
//  Created by hsfiOSGitHub on 01/02/2020.
//  Copyright (c) 2020 hsfiOSGitHub. All rights reserved.
//

import UIKit
import SFPickerView

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: self.view.bounds, style: UITableView.Style.plain)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
extension ViewController: UITableViewDelegate {
    
}

