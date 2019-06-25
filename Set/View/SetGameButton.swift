//
//  SetGameButton.swift
//  Set
//
//  Created by Ales Shenshin on 11.06.2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

class SetGameButton: UIButton {
// кнопки снизу игрового экрана. можно добавить сюда какую-то кастомизацию, например скруглить их углы
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 7
    }
}
