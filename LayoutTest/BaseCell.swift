//
//  BaseCell.swift
//  LayoutTest
//
//  Created by Uporabnik on 28/02/2017.
//  Copyright © 2017 Andrej. All rights reserved.
//

import Foundation
import UIKit

class BaseCell : CustomTableViewCell {
    
    let colorArray: [UIColor] = [
        UIColor(white: 0.6, alpha: 1.0),
        UIColor(white: 0.8, alpha: 1.0)
    ]
    
    func setData(_ data: CustomTableView.CellData) {
        backgroundColor = colorArray[data.orderNumber % colorArray.count]
    }
    
}
