//
//  CardView.swift
//  Set
//
//  Created by Ales Shenshin on 03/06/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

class CardView: UIView {

    override func draw(_ rect: CGRect) {
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 307.02, y: 161.16))
        bezier2Path.addCurve(to: CGPoint(x: 232.19, y: 176.35), controlPoint1: CGPoint(x: 293.65, y: 169.38), controlPoint2: CGPoint(x: 269.04, y: 184.8))
        bezier2Path.addCurve(to: CGPoint(x: 136.94, y: 160.06), controlPoint1: CGPoint(x: 195.35, y: 167.9), controlPoint2: CGPoint(x: 184.93, y: 158.18))
        bezier2Path.addCurve(to: CGPoint(x: 42.69, y: 201.37), controlPoint1: CGPoint(x: 88.96, y: 161.94), controlPoint2: CGPoint(x: 59.83, y: 199.49))
        bezier2Path.addCurve(to: CGPoint(x: 12.7, y: 172.26), controlPoint1: CGPoint(x: 25.55, y: 203.25), controlPoint2: CGPoint(x: 16.14, y: 184.26))
        bezier2Path.addCurve(to: CGPoint(x: 17.84, y: 102.78), controlPoint1: CGPoint(x: 9.26, y: 160.27), controlPoint2: CGPoint(x: 7.32, y: 128.21))
        bezier2Path.addCurve(to: CGPoint(x: 58.97, y: 48.32), controlPoint1: CGPoint(x: 28.37, y: 77.36), controlPoint2: CGPoint(x: 36.43, y: 64.59))
        bezier2Path.addCurve(to: CGPoint(x: 124.09, y: 27.67), controlPoint1: CGPoint(x: 81.51, y: 32.06), controlPoint2: CGPoint(x: 102.67, y: 28.61))
        bezier2Path.addCurve(to: CGPoint(x: 186.64, y: 39.87), controlPoint1: CGPoint(x: 145.51, y: 26.73), controlPoint2: CGPoint(x: 167.79, y: 32.36))
        bezier2Path.addCurve(to: CGPoint(x: 248.33, y: 49.26), controlPoint1: CGPoint(x: 205.49, y: 47.38), controlPoint2: CGPoint(x: 222.63, y: 54.9))
        bezier2Path.addCurve(to: CGPoint(x: 296.32, y: 24.85), controlPoint1: CGPoint(x: 274.04, y: 43.63), controlPoint2: CGPoint(x: 287.75, y: 30.48))
        bezier2Path.addCurve(to: CGPoint(x: 329.73, y: 8.89), controlPoint1: CGPoint(x: 304.89, y: 19.22), controlPoint2: CGPoint(x: 315.17, y: 7.95))
        bezier2Path.addCurve(to: CGPoint(x: 356.3, y: 49.26), controlPoint1: CGPoint(x: 344.3, y: 9.83), controlPoint2: CGPoint(x: 354.09, y: 35.02))
        bezier2Path.addCurve(to: CGPoint(x: 349.4, y: 110.06), controlPoint1: CGPoint(x: 358.5, y: 63.5), controlPoint2: CGPoint(x: 359.5, y: 87.5))
        bezier2Path.addCurve(to: CGPoint(x: 307.02, y: 161.16), controlPoint1: CGPoint(x: 339.3, y: 132.62), controlPoint2: CGPoint(x: 320.39, y: 152.94))
        bezier2Path.close()
        UIColor.red.setStroke()
        bezier2Path.lineWidth = 1
        bezier2Path.stroke()

    }
}
