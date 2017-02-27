//
//  ViewController.swift
//  LayoutTest
//
//  Created by Andrej on 2/22/17.
//  Copyright © 2017 Andrej. All rights reserved.
//

import UIKit

class CustomView: UIView {
    
    var height: CGFloat = 120
    var identifier: String = "CustomView"
    
    var intrinsicHeight: CGFloat = UIViewNoIntrinsicMetric {
        didSet {
            if oldValue != intrinsicHeight {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: intrinsicHeight)
    }
    
    override func updateConstraints() {
        //if let heightConstraint = constraints.first(where: { $0.firstAttribute == .height }) {
        //    heightConstraint.constant = height
        //}
        
        super.updateConstraints()
        
        print("\(identifier).updateConstraints")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("\(identifier).layoutSubviews (\(frame.size.height))")
        
        //if let cs = subviews.first as? CustomView {
        //    print("\(cs.identifier).height = \(cs.frame.size.height)")
        //}
    }
    
    func printHeight() {
        print("\(identifier).height = \(frame.size.height)")
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var customView0: CustomView!
    @IBOutlet var customView0HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subview0: CustomView!
    @IBOutlet var subview0HeightConstraint: NSLayoutConstraint!
    @IBOutlet var subview0BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var customView0TopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        print("customView0.frame = \(customView0.frame.debugDescription)")
        print("subview0.frame = \(subview0.frame.debugDescription)")
        
        subview0.identifier = "Subview"
        customView0HeightConstraint.isActive = false
        subview0HeightConstraint.isActive = false
        subview0BottomConstraint.isActive = true
        
        subview0.intrinsicHeight = 80
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        print("ViewController.viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("ViewController.viewDidLayoutSubviews")
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        print("ViewController.updateViewConstraints")
    }
    
    @IBAction func increaseButtonTapped() {
        //subview0HeightConstraint.constant += 10
        subview0.intrinsicHeight += 10
        view.updateConstraintsIfNeeded()
        
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func increaseTopButtonTapped() {
        customView0TopConstraint.constant += 10
    }
}

