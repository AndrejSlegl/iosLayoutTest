//
//  ImageCell.swift
//  LayoutTest
//
//  Created by Uporabnik on 28/02/2017.
//  Copyright © 2017 Andrej. All rights reserved.
//

import Foundation
import UIKit

class ImageCell: BaseCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    let imageHeights: [CGFloat] = [
        100,
        150,
        200,
        230,
        180,
        80
    ]
    
    override func setData(_ data: CustomTableView.CellData) {
        super.setData(data)
        orderNumberLabel.text = "\(data.orderNumber)"
        imageViewHeightConstraint.constant = imageHeights[Int(arc4random()) % imageHeights.count]
    }
    
}
