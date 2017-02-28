//
//  CustomTableViewController.swift
//  LayoutTest
//
//  Created by Andrej on 2/24/17.
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

class CustomTableView: UIScrollView {
    class CellData {
        var color: UIColor = UIColor.black
        var calculatedHeight: CGFloat = 0
        var isHeightInvalidated: Bool = true
        var orderNumber = 0
        weak var cell: CustomTableViewCell?
    }
    
    private var contentWidth: CGFloat = 0
    
    private var reusableCells: [CustomTableViewCell] = []
    private var cellDataArray: [CellData] = []
    
    let textArray = [
        "aåobshioer fsgbsdiog bfihsbfgio sfbg usofbdugbsdfug bsduig sb ufiwdbg usdbgusdbf udbg ubgupbg udabg usdbg dsiu gbdaug bdsugbadugo dsb fuqe bgueabfiuesb vuabs iufbaeiu baduwe bguiasbg uisad bfsaui gbadsiuf ba euifbasuif basui fadfg a",
        "gdgsdg dsg sdfds fsfsh fshfds fshfdsh fds h dfhfdh dfh dfhfdh fdhdfhfdg fsdh dfhfdh dfhdfhdfh dfhdf hfdshd fghasf gsfghsfgsf gsdfhsfghsd hshgsfghsf gsdg sdgsd gsd",
        "gdsgfs gdfsgh fsgdfsh fsh fsfdsh sfg sf gdsg sdgdsg sdg dsgdsg sd",
        "f dafda gdagda fsa"
    ]
    
    let colorArray: [UIColor] = [
        UIColor(white: 0.6, alpha: 1.0),
        UIColor(white: 0.8, alpha: 1.0)
    ]
    
    func reusableCell() -> CustomTableViewCell {
        if let cell = reusableCells.first(where: { $0.data == nil }) {
            return cell
        }
        
        let cell = CustomTableViewCell()
        reusableCells.append(cell)
        self.addSubview(cell)
        
        return cell
    }
    
    func reload() {
        self.autoresizesSubviews = false
        let rowCount = 100
        
        for i in 0 ..< rowCount {
            let cellData = CellData()
            cellData.color = colorArray[i % colorArray.count]
            cellData.orderNumber = i
            cellDataArray.append(cellData)
        }
        
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        let widthChanged = bounds.size.width != contentWidth
        contentWidth = bounds.size.width
        
        update(widthChanged: widthChanged)
        
        super.layoutSubviews()
    }
    
    func update(widthChanged: Bool) {
        var contentHeight = contentSize.height
        var verticalContentOffset = contentOffset.y
        
        if widthChanged {
            for cell in reusableCells {
                if let data = cell.data {
                    data.isHeightInvalidated = true
                    contentHeight += updateHeightIfInvalidated(data)
                }
            }
        }
        
        if let cells = reusableCellsOnEdge() {
            if contentOffset.y + bounds.size.height >= contentHeight {
                let idx = cells.last.data!.orderNumber + 1
                if idx < cellDataArray.count {
                    let data = cellDataArray[idx]
                    contentHeight += prepareCell(data)
                }
            } else {
                if cells.last.frame.minY > contentOffset.y + bounds.size.height && contentOffset.y > 0 {
                    contentHeight -= cells.last.data!.calculatedHeight
                    cells.last.data = nil
                }
            }
            
            if contentOffset.y <= 0 {
                let idx = cells.first.data!.orderNumber - 1
                if idx >= 0 {
                    let data = cellDataArray[idx]
                    let height = prepareCell(data)
                    verticalContentOffset += height
                    contentHeight += height
                }
            } else {
                if cells.first.frame.maxY < contentOffset.y && contentOffset.y + bounds.size.height < contentHeight {
                    verticalContentOffset -= cells.first.data!.calculatedHeight
                    contentHeight -= cells.first.data!.calculatedHeight
                    cells.first.data = nil
                }
            }
        }
        
        var top: CGFloat = 0
        var i = 0
        
        while contentHeight < bounds.size.height {
            if i == cellDataArray.count {
                break
            }
            
            top += prepareCell(cellDataArray[i])
            contentHeight = max(contentHeight, top)
            
            i += 1
        }
        
        contentOffset = CGPoint(x: contentOffset.x, y: verticalContentOffset)
        contentSize = CGSize(width: contentWidth, height: contentHeight)
        updateVisibleCellFrames()
    }
    
    func updateVisibleCellFrames() {
        var top: CGFloat = 0
        
        for cell in reusableCells.sorted(by: { $0.orderNumber < $1.orderNumber }) {
            guard let data = cell.data else {
                continue
            }
            
            cell.frame = CGRect(x: 0, y: top, width: contentWidth, height: data.calculatedHeight)
            top = cell.frame.maxY
        }
    }
    
    func prepareCell(_ data: CellData) -> CGFloat {
        _ = cellForData(data)
        _ = updateHeightIfInvalidated(data)
        
        return data.calculatedHeight
    }
    
    func updateHeightIfInvalidated(_ data: CellData) -> CGFloat {
        if data.isHeightInvalidated, let cell = data.cell {
            if cell.frame.size.width != contentWidth {
                cell.frame = CGRect(x: 0, y: 0, width: contentWidth, height: cell.frame.size.height)
                cell.updateConstraintsIfNeeded()
            }
            
            let size = cell.systemLayoutSizeFitting(CGSize(width: contentWidth, height: 0))
            let diff = size.height - data.calculatedHeight
            data.calculatedHeight = size.height
            data.isHeightInvalidated = false
            
            return diff
        }
        
        return 0
    }
    
    func reusableCellsOnEdge() -> (first: CustomTableViewCell, last: CustomTableViewCell)? {
        var max = -1
        var min = Int.max
        var minCell: CustomTableViewCell?
        var maxCell: CustomTableViewCell?
        
        for cell in reusableCells {
            if let data = cell.data {
                if data.orderNumber > max {
                    max = data.orderNumber
                    maxCell = cell
                }
                if data.orderNumber < min {
                    min = data.orderNumber
                    minCell = cell
                }
            }
        }
        
        guard let minC = minCell, let maxC = maxCell else {
            return nil
        }
        
        return (minC, maxC)
    }
    
    func cellForData(_ data: CellData) -> CustomTableViewCell {
        if let cell = data.cell {
            return cell
        }
        
        let cell = reusableCell()
        cell.subview0.backgroundColor = data.color
        cell.label.text = "\(data.orderNumber)"
        cell.label2.text = textArray[Int(arc4random()) % textArray.count]
        cell.data = data
        
        data.isHeightInvalidated = true
        
        return cell
    }
    
}

class CustomTableViewController: UIViewController {
    @IBOutlet weak var customTableView: CustomTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTableView.showsVerticalScrollIndicator = false
        customTableView.showsHorizontalScrollIndicator = false
        customTableView.reload()
    }
    
}
