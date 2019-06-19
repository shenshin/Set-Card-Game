//
//  SetCards.swift
//  Set
//
//  Created by Ales Shenshin on 10.06.2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

class SetCardsScreen: UIView {
    enum CardState {
        case normal, selected, set, nonSet, hint
    }
    var cardViews: [SetCardView] = [] { didSet { setNeedsLayout() } }

    override func layoutSubviews() {
        var grid: Grid = Grid(layout: .aspectRatio(bounds.width / bounds.height), frame: bounds)
        grid.count = cardViews.count
        for index in cardViews.indices {
            guard let frame = grid[index] else { continue }
            cardViews[index].frame = frame
        }
    }
    /// Возвращает графическое отображение карты соответствующее параметрам модели
    private func getView(from features: Features) -> SetCardView {
        return SetCardView(shape: features.shape, color: features.color, number: features.number, shading: features.shading)
    }
    /// Возвращает конкретную карту из отображённых в данный момент, соответствующую карте с заданными параметрами из модели,
    /// если, конечно, она там есть, а если нет, то возвращает `nil`
    private func getDisplayedView(from features: Features) -> SetCardView? {
        let cardView = getView(from: features)
        if let view = cardViews.first(where: {$0 == cardView}) {
            return view
        } else {
            return nil
        }
    }
    /// Добавляет карту на экран при условии, что её там ещё нет, и возвращает ссылку на добавленную карту
    func addCardToView(with features: Features) -> SetCardView? {
        let view = getView(from: features)
        if !cardViews.contains(view) {
            cardViews.append(view)
            addSubview(view)
            return view
        } else {
            return nil
        }
    }
    /// Изменяет статус (оформление) карты на экране, соответствующей карте из модели
    func markCard(with features: Features, as state: CardState) {
        var bgColor: UIColor
        switch state {
        case .normal:
            bgColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        case .selected:
            bgColor = #colorLiteral(red: 0.8501310945, green: 0.7857109904, blue: 0.6069644094, alpha: 1)
        case .set:
            bgColor = #colorLiteral(red: 0.6564321518, green: 0.8429018855, blue: 0.6854554415, alpha: 1)
        case .nonSet:
            bgColor = #colorLiteral(red: 0.8805846572, green: 0.5817456841, blue: 0.6022415757, alpha: 1)
        case .hint:
            bgColor = #colorLiteral(red: 0.6551629901, green: 0.8148941398, blue: 0.8421137929, alpha: 1)
        }
        getDisplayedView(from: features)?.backgroundColor = bgColor
    }
    /// Удаляет с экрана карту, соответствующую данной карте из модели
    func removeCardFromSuperView(with features: Features) {
        if let view = getDisplayedView(from: features) {
            view.removeFromSuperview()
            cardViews.removeAll(where: {$0 == view})
        }
    }
}
