//
//  TextCell.swift
//  LayoutTest
//
//  Created by Uporabnik on 28/02/2017.
//  Copyright © 2017 Andrej. All rights reserved.
//

import Foundation
import UIKit

class TextCell: CustomTableViewCell {
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    let colorArray: [UIColor] = [
        UIColor(white: 0.6, alpha: 1.0),
        UIColor(white: 0.8, alpha: 1.0)
    ]
    
    let textArray = [
        "aåobshioer fsgbsdiog bfihsbfgio sfbg usofbdugbsdfug bsduig sb ufiwdbg usdbgusdbf udbg ubgupbg udabg usdbg dsiu gbdaug bdsugbadugo dsb fuqe bgueabfiuesb vuabs iufbaeiu baduwe bguiasbg uisad bfsaui gbadsiuf ba euifbasuif basui fadfg a",
        "gdgsdg dsg sdfds fsfsh fshfds fshfdsh fds h dfhfdh dfh dfhfdh fdhdfhfdg fsdh dfhfdh dfhdfhdfh dfhdf hfdshd fghasf gsfghsfgsf gsdfhsfghsd hshgsfghsf gsdg sdgsd gsd",
        "gdsgfs gdfsgh fsgdfsh fsh fsfdsh sfg sf gdsg sdgdsg sdg dsgdsg sd",
        "f dafda gdagda fsa"
    ]
    
    func setData(_ data: CustomTableView.CellData) {
        backgroundColor = colorArray[data.orderNumber % colorArray.count]
        orderNumberLabel.text = "\(data.orderNumber)"
        textLabel.text = textArray[Int(arc4random()) % textArray.count]
    }
}
