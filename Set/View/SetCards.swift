//
//  SetCards.swift
//  Set
//
//  Created by Ales Shenshin on 10.06.2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

class SetCards: UIView {

    var cardViews: [SetCardView] = [] { didSet { setNeedsLayout() } }

    override func layoutSubviews() {
        var grid: Grid = Grid(layout: .aspectRatio(bounds.width / bounds.height), frame: bounds)
        grid.count = cardViews.count
        for index in cardViews.indices {
            guard let frame = grid[index] else { fatalError() }//continue }
            cardViews[index].frame = frame
        }
    }
}
