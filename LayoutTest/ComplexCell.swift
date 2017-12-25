//
//  ComplexCell.swift
//  LayoutTest
//
//  Created by Uporabnik on 28/02/2017.
//  Copyright © 2017 Andrej. All rights reserved.
//

import Foundation
import UIKit

class ComplexCell: BaseCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var contentContainer: UIView!
    
    let imageHeights: [CGFloat] = [
        100,
        150,
        200,
        230,
        180,
        80
    ]
    
    let textArray = [
        "aåobshioer fsgbsdiog bfihsbfgio sfbg usofbdugbsdfug bsduig sb ufiwdbg usdbgusdbf udbg ubgupbg udabg usdbg dsiu gbdaug bdsugbadugo dsb fuqe bgueabfiuesb vuabs iufbaeiu baduwe bguiasbg uisad bfsaui gbadsiuf ba euifbasuif basui fadfg a",
        "gdgsdg dsg sdfds fsfsh fshfds fshfdsh fds h dfhfdh dfh dfhfdh fdhdfhfdg fsdh dfhfdh dfhdfhdfh dfhdf hfdshd fghasf gsfghsfgsf gsdfhsfghsd hshgsfghsf gsdg sdgsd gsd",
        "gdsgfs gdfsgh fsgdfsh fsh fsfdsh sfg sf gdsg sdgdsg sdg dsgdsg sd",
        "f dafda gdagda fsa",
        "hofns ghif hnigohnsf ihsdnhidsfn iodshn sdoihbdshio dsbgiodsbgoidabgdasiogfbsaoig absgisab giaogb asiofg asiofasbg fiosabfgi"
    ]
    
    override func setData(_ data: CustomTableView.CellData) {
        super.setData(data)
        orderNumberLabel.text = "\(data.orderNumber)"
        imageViewHeightConstraint.constant = data.imageHeight //imageHeights[Int(arc4random()) % imageHeights.count]
        titleLabel.text = textArray[Int(arc4random()) % textArray.count]
        descLabel.text = textArray[Int(arc4random()) % textArray.count]
    }
    
}
