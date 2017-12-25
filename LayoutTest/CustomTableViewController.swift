//
//  CustomTableViewController.swift
//  LayoutTest
//
//  Created by Andrej on 2/24/17.
//  Copyright © 2017 Andrej. All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewController: UIViewController {
    @IBOutlet weak var customTableView: CustomTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTableView.reload()
    }
    
    @IBAction func button1Tapped(_ sender: Any) {
    }
    
}
