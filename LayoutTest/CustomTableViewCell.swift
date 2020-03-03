//
//  CustomTableViewCell.swift
//  LayoutTest
//
//  Created by Uporabnik on 28/02/2017.
//  Copyright © 2017 Andrej. All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewCell: UIView {
    internal(set) var reuseIdentifier: String!
    
    internal var data: CustomTableView.CellData? {
        didSet {
            oldValue?.cell = nil
            data?.cell = self
            isHidden = data == nil
        }
    }
    
    internal var orderNumber: Int {
        return data?.orderNumber ?? -1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = true
        autoresizesSubviews = false
        autoresizingMask = UIView.AutoresizingMask(rawValue: 0)
    }
}
