//
//  CustomTableView.swift
//  LayoutTest
//
//  Created by Uporabnik on 28/02/2017.
//  Copyright © 2017 Andrej. All rights reserved.
//

import Foundation
import UIKit

class CustomTableView: UIScrollView {
    internal class CellData {
        var calculatedHeight: CGFloat = 0
        var isHeightInvalidated: Bool = true
        var orderNumber = 0
        weak var cell: CustomTableViewCell?
    }
    
    private var contentWidth: CGFloat = 0
    private var reusableCells: [CustomTableViewCell] = []
    private var cellDataArray: [CellData] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        autoresizesSubviews = false
    }
    
    private func reusableCell(fromNibNamed: String) -> CustomTableViewCell {
        if let cell = reusableCells.first(where: { $0.data == nil && $0.reuseIdentifier == fromNibNamed }) {
            return cell
        }
        
        let xib = Bundle.main.loadNibNamed(fromNibNamed, owner: nil, options: nil)
        
        guard let cell = xib?.first as? CustomTableViewCell else {
            fatalError("Cannot load CustomTableViewCell instance from nib \"\(fromNibNamed)\"")
        }
        
        cell.reuseIdentifier = fromNibNamed
        reusableCells.append(cell)
        self.addSubview(cell)
        
        return cell
    }
    
    func reload() {
        let rowCount = 100
        
        for i in 0 ..< rowCount {
            let cellData = CellData()
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
    
    private func update(widthChanged: Bool) {
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
    
    private func updateVisibleCellFrames() {
        var top: CGFloat = 0
        
        for cell in reusableCells.sorted(by: { $0.orderNumber < $1.orderNumber }) {
            guard let data = cell.data else {
                continue
            }
            
            cell.frame = CGRect(x: 0, y: top, width: contentWidth, height: data.calculatedHeight)
            top = cell.frame.maxY
        }
    }
    
    private func prepareCell(_ data: CellData) -> CGFloat {
        _ = cellForData(data)
        _ = updateHeightIfInvalidated(data)
        
        return data.calculatedHeight
    }
    
    private func updateHeightIfInvalidated(_ data: CellData) -> CGFloat {
        if data.isHeightInvalidated, let cell = data.cell {
            if cell.frame.size.width != contentWidth {
                cell.frame = CGRect(x: 0, y: 0, width: contentWidth, height: cell.frame.size.height)
                cell.updateConstraintsIfNeeded()
            }
            
            let size = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let diff = size.height - data.calculatedHeight
            data.calculatedHeight = size.height
            data.isHeightInvalidated = false
            
            return diff
        }
        
        return 0
    }
    
    private func reusableCellsOnEdge() -> (first: CustomTableViewCell, last: CustomTableViewCell)? {
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
    
    private func cellForData(_ data: CellData) -> CustomTableViewCell {
        if let cell = data.cell {
            return cell
        }
        
        let nibName = arc4random() % 2 == 0 ? "TextCell" : "ImageCell"
        
        let cell = reusableCell(fromNibNamed: nibName)
        cell.data = data
        
        if let baseCell = cell as? BaseCell {
            baseCell.setData(data)
        }
        
        data.isHeightInvalidated = true
        
        return cell
    }
    
}
