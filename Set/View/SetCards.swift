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

    lazy var labels: [UILabel] = {
        var labs: [UILabel] = []
        for _ in 1...81 {
            let label = UILabel()
            labs.append(label)
            label.layer.borderWidth = 0.5
            label.layer.borderColor = UIColor.black.cgColor
            label.backgroundColor = .gray
            addSubview(label)
        }
        print("counting labels")
        return labs
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        let grid: Grid = Grid(layout: .dimensions(rowCount: 9, columnCount: 9), frame: bounds)
        var cardIndex = 1
        for labelIndex in labels.indices {
            let card = labels[labelIndex]
            card.frame = grid[labelIndex]!
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            card.attributedText = NSAttributedString(string: "\(cardIndex)", attributes: [.paragraphStyle: paragraph, .foregroundColor: UIColor.white])
            cardIndex += 1
        }
    }
}
