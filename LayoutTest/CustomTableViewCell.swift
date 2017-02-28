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
    let label = UILabel()
    let label2 = UILabel()
    let subview0 = UIView()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = true
        autoresizesSubviews = false
        autoresizingMask = UIViewAutoresizing(rawValue: 0)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(1000, for: .horizontal)
        label.setContentCompressionResistancePriority(1000, for: .horizontal)
        
        subview0.translatesAutoresizingMaskIntoConstraints = false
        
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.numberOfLines = 0
        label2.lineBreakMode = .byWordWrapping
        label2.textAlignment = .left
        
        addSubview(subview0)
        subview0.addSubview(label)
        subview0.addSubview(label2)
        
        subview0.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        subview0.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        subview0.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        subview0.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        label.centerYAnchor.constraint(equalTo: subview0.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: subview0.leadingAnchor, constant: 20).isActive = true
        
        label2.topAnchor.constraint(equalTo: subview0.topAnchor, constant: 10).isActive = true
        subview0.bottomAnchor.constraint(equalTo: label2.bottomAnchor, constant: 10).isActive = true
        subview0.trailingAnchor.constraint(equalTo: label2.trailingAnchor, constant: 20).isActive = true
        label2.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
