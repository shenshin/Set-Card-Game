//
//  CardView.swift
//  Set
//
//  Created by Ales Shenshin on 03/06/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit
@IBDesignable class CardView: UIView {

    override func draw(_ rect: CGRect) {
        let xSc: CGFloat = 1
        let ySc: CGFloat = 1
        var squigglePoints: [[CGFloat]] = []
        squigglePoints.append([232.19, 176.35, 293.65, 169.38, 184.8])
        let squiggle = UIBezierPath()
        squiggle.move(to: CGPoint(x: xSc * 307.02, y: ySc * 161.16))
        squiggle.addCurve(to: CGPoint(x: xSc * 232.19, y: ySc * 176.35), controlPoint1: CGPoint(x: xSc * 293.65, y: ySc * 169.38), controlPoint2: CGPoint(x: xSc * 269.04, y: ySc * 184.8))
        squiggle.addCurve(to: CGPoint(x: xSc * 136.94, y: ySc * 160.06), controlPoint1: CGPoint(x: xSc * 195.35, y: ySc * 167.9), controlPoint2: CGPoint(x: xSc * 184.93, y: ySc * 158.18))
        squiggle.addCurve(to: CGPoint(x: xSc * 42.69, y: ySc * 201.37), controlPoint1: CGPoint(x: xSc * 88.96, y: ySc * 161.94), controlPoint2: CGPoint(x: xSc * 59.83, y: ySc * 199.49))
        squiggle.addCurve(to: CGPoint(x: xSc * 12.7, y: ySc * 172.26), controlPoint1: CGPoint(x: xSc * 25.55, y: ySc * 203.25), controlPoint2: CGPoint(x: xSc * 16.14, y: ySc * 184.26))
        squiggle.addCurve(to: CGPoint(x: xSc * 17.84, y: ySc * 102.78), controlPoint1: CGPoint(x: xSc * 9.26, y: ySc * 160.27), controlPoint2: CGPoint(x: xSc * 7.32, y: ySc * 128.21))
        squiggle.addCurve(to: CGPoint(x: xSc * 58.97, y: ySc * 48.32), controlPoint1: CGPoint(x: xSc * 28.37, y: ySc * 77.36), controlPoint2: CGPoint(x: xSc * 36.43, y: ySc * 64.59))
        squiggle.addCurve(to: CGPoint(x: xSc * 124.09, y: ySc * 27.67), controlPoint1: CGPoint(x: xSc * 81.51, y: ySc * 32.06), controlPoint2: CGPoint(x: xSc * 102.67, y: ySc * 28.61))
        squiggle.addCurve(to: CGPoint(x: xSc * 186.64, y: ySc * 39.87), controlPoint1: CGPoint(x: xSc * 145.51, y: ySc * 26.73), controlPoint2: CGPoint(x: xSc * 167.79, y: ySc * 32.36))
        squiggle.addCurve(to: CGPoint(x: xSc * 248.33, y: ySc * 49.26), controlPoint1: CGPoint(x: xSc * 205.49, y: ySc * 47.38), controlPoint2: CGPoint(x: xSc * 222.63, y: ySc * 54.9))
        squiggle.addCurve(to: CGPoint(x: xSc * 296.32, y: ySc * 24.85), controlPoint1: CGPoint(x: xSc * 274.04, y: ySc * 43.63), controlPoint2: CGPoint(x: xSc * 287.75, y: ySc * 30.48))
        squiggle.addCurve(to: CGPoint(x: xSc * 329.73, y: ySc * 8.89), controlPoint1: CGPoint(x: xSc * 304.89, y: ySc * 19.22), controlPoint2: CGPoint(x: xSc * 315.17, y: ySc * 7.95))
        squiggle.addCurve(to: CGPoint(x: xSc * 356.3, y: ySc * 49.26), controlPoint1: CGPoint(x: xSc * 344.3, y: ySc * 9.83), controlPoint2: CGPoint(x: xSc * 354.09, y: ySc * 35.02))
        squiggle.addCurve(to: CGPoint(x: xSc * 349.4, y: ySc * 110.06), controlPoint1: CGPoint(x: xSc * 358.5, y: ySc * 63.5), controlPoint2: CGPoint(x: xSc * 359.5, y: ySc * 87.5))
        squiggle.addCurve(to: CGPoint(x: xSc * 307.02, y: ySc * 161.16), controlPoint1: CGPoint(x: xSc * 339.3, y: ySc * 132.62), controlPoint2: CGPoint(x: xSc * 320.39, y: ySc * 152.94))
        squiggle.close()
        UIColor.red.setStroke()
        squiggle.lineWidth = 1
        squiggle.stroke()

    }
}
