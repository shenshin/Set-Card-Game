//
//  SetCardView.swift
//  Set
//
//  Created by Alexander Shenshin on 12.06.2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let shapeOffset: CGFloat = 1/10
    static let lineWidthToBoundsWidth: CGFloat = 1/35
    static let stripesSpaceToBoundsWidth: CGFloat = 1/10
    static let stripesToLineWidth: CGFloat = 1/2.5
    static let aspectRatio: CGFloat = 1.618 // (Golden ratio)
}

class SetCardView: UIView {
    
    struct Features {
        enum Color: CaseIterable { case green, purple, red }
        enum Shape: CaseIterable { case squiggle, diamond, oval }
        enum Number: Int, CaseIterable { case one = 1, two, three }
        enum Shading: CaseIterable { case solid, outlined, striped }
        init(shape: Shape = Shape.oval, color: Color = Color.red, number: Number = Number.one, shading: Shading = Shading.striped) {
            self.shape = shape; self.color = color; self.number = number; self.shading = shading
        }
        var color: Color; var shape: Shape; var number: Number; var shading: Shading
    }
    
    var features: Features = Features() {didSet{setNeedsLayout();setNeedsDisplay()}}

    private var strokeColor: UIColor {
        switch features.color {
        case .green:
            return #colorLiteral(red: 0.002848926932, green: 0.6812832952, blue: 0.0004391930997, alpha: 1)
        case .purple:
            return #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        case .red:
            return #colorLiteral(red: 0.8794299364, green: 0.01756579243, blue: 0.4070725441, alpha: 1)
        }
    }
    private var fillColor: UIColor {
        switch features.shading {
        case .solid:
            return strokeColor
        case .outlined, .striped:
            return .white
        }
    }
    private func drawPath(in rect: CGRect) -> UIBezierPath {
        switch features.shape {
        case .squiggle:
            return drawSuiggle(in: rect)
        case .diamond:
            return drawDiamond(in: rect)
        case .oval:
            return drawOval(in: rect)
        }
    }
    /// Настройка параметров класса. Вызывается один раз после инициализации
    private func setupView() {
        backgroundColor = .clear
        contentMode = .redraw
    }

    override func draw(_ rect: CGRect) {
        strokeColor.setStroke()
        fillColor.setFill()
        if rect.width < rect.height {
            
        }
    }
    private func drawElement(in rect: CGRect) {
        // т.к. размер вида может быть каким угодно, нужно создать новый прямоугольник,
        // находящийся по середине rect и уменьшенный согласно aspectRatio
        var newRect: CGRect = bounds.height > bounds.width ?
            rect.insetBy(dx: 0, dy: (rect.height - rect.width/Constants.aspectRatio)/2) :
            rect.insetBy(dx: (rect.width - rect.height*Constants.aspectRatio)/2, dy: 0)
        // делаю отступы фигуры от краёв view на велечину shapeOffset
        newRect = newRect.insetBy(dx: newRect.width*Constants.shapeOffset, dy: newRect.height*Constants.shapeOffset)
        let lineWidth: CGFloat = newRect.width * Constants.lineWidthToBoundsWidth
        // Рисую фигуру в зависимости от выбранной формы
        let shape = drawPath(in: newRect)
        shape.lineWidth = lineWidth
        shape.lineJoinStyle = .round
        shape.fill()
        shape.stroke()
        // Рисую полосочки
        if features.shading == .striped {
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            shape.addClip()
            let stripes = drawStripes(in: newRect)
            stripes.lineWidth = lineWidth * Constants.stripesToLineWidth
            stripes.stroke()
            context?.restoreGState()
        }
    }
    /// Рисует "закарючку" в прямоугольнике
    private func drawSuiggle(in rect: CGRect) -> UIBezierPath {
        let squiggle = UIBezierPath()
        squiggle.move(to: CGPoint(x: 307.02, y: 161.16))
        squiggle.addCurve(to: CGPoint(x: 232.19, y: 176.35), controlPoint1: CGPoint(x: 293.65, y: 169.38), controlPoint2: CGPoint(x: 269.04, y: 184.8))
        squiggle.addCurve(to: CGPoint(x: 136.94, y: 160.06), controlPoint1: CGPoint(x: 195.35, y: 167.9), controlPoint2: CGPoint(x: 184.93, y: 158.18))
        squiggle.addCurve(to: CGPoint(x: 42.69, y: 201.37), controlPoint1: CGPoint(x: 88.96, y: 161.94), controlPoint2: CGPoint(x: 59.83, y: 199.49))
        squiggle.addCurve(to: CGPoint(x: 12.7, y: 172.26), controlPoint1: CGPoint(x: 25.55, y: 203.25), controlPoint2: CGPoint(x: 16.14, y: 184.26))
        squiggle.addCurve(to: CGPoint(x: 17.84, y: 102.78), controlPoint1: CGPoint(x: 9.26, y: 160.27), controlPoint2: CGPoint(x: 7.32, y: 128.21))
        squiggle.addCurve(to: CGPoint(x: 58.97, y: 48.32), controlPoint1: CGPoint(x: 28.37, y: 77.36), controlPoint2: CGPoint(x: 36.43, y: 64.59))
        squiggle.addCurve(to: CGPoint(x: 124.09, y: 27.67), controlPoint1: CGPoint(x: 81.51, y: 32.06), controlPoint2: CGPoint(x: 102.67, y: 28.61))
        squiggle.addCurve(to: CGPoint(x: 186.64, y: 39.87), controlPoint1: CGPoint(x: 145.51, y: 26.73), controlPoint2: CGPoint(x: 167.79, y: 32.36))
        squiggle.addCurve(to: CGPoint(x: 248.33, y: 49.26), controlPoint1: CGPoint(x: 205.49, y: 47.38), controlPoint2: CGPoint(x: 222.63, y: 54.9))
        squiggle.addCurve(to: CGPoint(x: 296.32, y: 24.85), controlPoint1: CGPoint(x: 274.04, y: 43.63), controlPoint2: CGPoint(x: 287.75, y: 30.48))
        squiggle.addCurve(to: CGPoint(x: 329.73, y: 8.89), controlPoint1: CGPoint(x: 304.89, y: 19.22), controlPoint2: CGPoint(x: 315.17, y: 7.95))
        squiggle.addCurve(to: CGPoint(x: 356.3, y: 49.26), controlPoint1: CGPoint(x: 344.3, y: 9.83), controlPoint2: CGPoint(x: 354.09, y: 35.02))
        squiggle.addCurve(to: CGPoint(x: 349.4, y: 110.06), controlPoint1: CGPoint(x: 358.5, y: 63.5), controlPoint2: CGPoint(x: 359.5, y: 87.5))
        squiggle.addCurve(to: CGPoint(x: 307.02, y: 161.16), controlPoint1: CGPoint(x: 339.3, y: 132.62), controlPoint2: CGPoint(x: 320.39, y: 152.94))
        squiggle.close()
        // выравниваю длину и ширину исходного изображения и прямоугольника
        squiggle.apply(CGAffineTransform.identity.scaledBy(x: rect.width / squiggle.bounds.width, y: rect.height / squiggle.bounds.height))
        // совмещаю новые размеры изображения точкой начала координат прямоугольника
        squiggle.apply(CGAffineTransform.identity.translatedBy(x: rect.minX - squiggle.bounds.minX, y: rect.minY - squiggle.bounds.minY))
        return squiggle
    }
    private func drawStripes(in rect: CGRect) -> UIBezierPath {
        let stripes = UIBezierPath()
        let dx: CGFloat = rect.width * Constants.stripesSpaceToBoundsWidth
        for xCoord in stride(from: rect.minX + dx, to: rect.maxX, by: dx) {
            stripes.move(to: CGPoint(x: xCoord, y: rect.minY))
            stripes.addLine(to: CGPoint(x: xCoord, y: rect.maxY))
        }
        return stripes
    }
    private func drawDiamond(in rect: CGRect) -> UIBezierPath {
        let diamond = UIBezierPath()
        diamond.move(to: CGPoint(x: rect.minX, y: rect.midY))
        diamond.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        diamond.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        diamond.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        diamond.close()
        return diamond
    }
    private func drawOval(in rect: CGRect) -> UIBezierPath {
        let oval = UIBezierPath(roundedRect: rect, cornerRadius: rect.height/2)
        return oval
    }
    
    // вынужден использовать инициализаторы для правильной настройки всех параметров вида,
    // находящихся в методе setupView, вызываемом из init-ов
    
    /// Задание всех атрибутов карты при создании вида
    convenience init(shape: Features.Shape, color: Features.Color, number: Features.Number, shading: Features.Shading) {
        self.init(frame: CGRect.zero)
        self.features = Features(shape: shape, color: color, number: number, shading: shading)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}
