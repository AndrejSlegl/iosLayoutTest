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
    let subview: UIView
    let reuseIdentifier: String
    
    var data: CustomTableView.CellData? {
        didSet {
            oldValue?.cell = nil
            data?.cell = self
            isHidden = data == nil
        }
    }
    
    var orderNumber: Int {
        return data?.orderNumber ?? -1
    }
    
    required init(subview: UIView, reuseIdentifier: String) {
        self.subview = subview
        self.reuseIdentifier = reuseIdentifier
        
        super.init(frame: CGRect.zero)
        
        addSubview(subview)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: subview.trailingAnchor).isActive = true
        
        let bottomConstraint = bottomAnchor.constraint(equalTo: subview.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(1)
        bottomConstraint.isActive = true
        
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = true
        autoresizesSubviews = true
        autoresizingMask = UIViewAutoresizing(rawValue: 0)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
