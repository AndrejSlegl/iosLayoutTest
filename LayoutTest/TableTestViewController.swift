//
//  TableTestViewController.swift
//  LayoutTest
//
//  Created by Andrej on 2/23/17.
//  Copyright © 2017 Andrej. All rights reserved.
//

import Foundation
import UIKit

class CellData {
    let identifier = "cell"
    let height: CGFloat
    let color: UIColor
    let index: Int
    
    var wasDisplayed = false
    var addedOnTop = false
    
    init(height: CGFloat, color: UIColor, index: Int) {
        self.height = height
        self.color = color
        self.index = index
    }
}

class Cell: UITableViewCell {
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var label1: UILabel!
    
    var data: CellData?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        /*
        if let d = data {
            if superview == nil {
                print("Cell \(d.index) removed")
            } else {
                print("Cell \(d.index) added")
            }
        }*/
    }
    
    func set(data: CellData) {
        self.data = data
        heightConstraint.constant = data.height
        rootView.backgroundColor = data.color
        label1.text = "\(data.index)"
    }
}

class TableTestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addBtnTapped() {
        insertOneOnTop()
        //newCount += 1
    }
    
    let colorArray: [UIColor] = [
        UIColor(white: 0.6, alpha: 1.0),
        UIColor(white: 0.8, alpha: 1.0)
    ]
    
    private var observerContext = 0
    var cellDataArray: [CellData] = []
    var newCount = 0
    
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.scrollsToTop = false
        
        reload()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = cellDataArray[indexPath.row]
        
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: data.identifier) else {
            fatalError("dequeueReusableCell failed")
        }
        
        if let cell = tableViewCell as? Cell {
            cell.set(data: data)
        }
        
        data.wasDisplayed = true
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func reload() {
        cellDataArray.removeAll(keepingCapacity: true)
        
        for i in 0 ..< 100 {
            let height = ((arc4random() % 10) + 5) * 10
            let color = colorArray[i % colorArray.count]
            cellDataArray.append(CellData(height: CGFloat(height), color: color, index: i))
        }
        
        tableView.reloadData()
    }
    
    func insertOneOnTop() {
        if let first = cellDataArray.first {
            let colorIdx = colorArray.index(of: first.color) ?? -1
            let color = colorArray[(colorIdx + 1) % colorArray.count]
            let data = CellData(height: 200, color: color, index: first.index - 1)
            
            data.addedOnTop = true
            cellDataArray.insert(data, at: 0)
            
            //tableView.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: &observerContext)
            
            let contentOffset = tableView.contentOffset
            let contentSize = tableView.contentSize
            
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                self.tableView.setNeedsUpdateConstraints()
                self.tableView.updateConstraintsIfNeeded()
                self.tableView.layoutIfNeeded()
                
                let offsetDiff = self.tableView.contentOffset.y - contentOffset.y
                let sizeDiff = self.tableView.contentSize.height - contentSize.height
                let newContentOffset = self.tableView.contentOffset
                
                print("offsetDiff = \(offsetDiff)")
                print("sizeDiff = \(sizeDiff)")
                
                let addedOnTopAndDisplayed = self.cellDataArray.filter( { $0.addedOnTop && $0.wasDisplayed })
                let newCellOffset = CGFloat(addedOnTopAndDisplayed.count * 200)
                
                for cell in addedOnTopAndDisplayed {
                    cell.addedOnTop = false
                }
                
                self.tableView.contentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y + newCellOffset)
                }
            }
            
            tableView.reloadData()
 
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
