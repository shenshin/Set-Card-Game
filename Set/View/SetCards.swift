//
//  SetCards.swift
//  Set
//
//  Created by Ales Shenshin on 10.06.2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

class SetCards: UIView {
    var counter = 0

    lazy var cardViews: [SetCardView] = {
        var labs: [SetCardView] = []
        for _ in 1...81 {
            let label = SetCardView()
            labs.append(label)
            label.layer.borderWidth = 0.5
            label.layer.borderColor = UIColor.black.cgColor
            label.backgroundColor = .gray
            addSubview(label)
        }
        return labs
    }()

    override func layoutSubviews() {
        //super.layoutSubviews()
        let grid: Grid = Grid(layout: .dimensions(rowCount: 9, columnCount: 9), frame: bounds)
        for index in cardViews.indices {
            cardViews[index].frame = grid[index]!
        }
    }
}
