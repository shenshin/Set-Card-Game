//
//  SetCardView.swift
//  Set
//
//  Created by Alexander Shenshin on 12.06.2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    /// Отступ от фигуры до начала её ограничивающего прямоугольника:
    /// отступ справа и слева (по горизонтали) по отношению к ширине прямоугольника и
    /// отступ сверху и снизу (по вертикали) по отношению к высоте прямоугольника.
    /// На практике величина этого значения определяет расстояние между фигурами
    static let shapeOffset: CGFloat = 1/15
    /// Отступ от границ view до начала области отрисовки фигур
    static let boundsInset: CGFloat = 5
    /// Отношение толщины линии обводки к ширине фигуры
    static let lineWidthToBoundsWidth: CGFloat = 1/20
    /// Отношение промежутка между линиями штриховки к ширине фигуры
    static let stripesSpaceToBoundsWidth: CGFloat = 1/10
    /// Отношение толщины линий штриховки фигуры к её линии обводки
    static let stripesToLineWidth: CGFloat = 1/2.5
    /// Отношение ширины фигуры к её длине (равно золотому сечению)
    static let aspectRatio: CGFloat = 1.618 // (Golden ratio)
    /// Отношение радиуса угла карты к её ширине
    static let cornerRadiusToBoundsWidth: CGFloat = 1/8
}

protocol SetCardViewDelegate: class {
    func cardTapped(_ cardView: SetCardView)
}

class SetCardView: UIView {
    
    private(set) var features: Features = Features() //{didSet{setNeedsLayout();setNeedsDisplay()}}
    
    weak var delegate: SetCardViewDelegate?

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
    /// Координаты первого элемента из трёх возможных
    private var firstElement: CGRect {
        let dimentions: (rows: Int, columns: Int) = bounds.isLandscape ? (1, 3) : (3, 1)
        let grid = Grid(layout: .dimensions(rowCount: dimentions.rows, columnCount: dimentions.columns),
             frame: bounds.inset(by: Constants.boundsInset))
        return grid[0]!
    }
    /// Соотношения величины отступа от начала границы карты к размеру элемента карты
    /// Например, при двух элементах на карте, чтобы узнать отступ 1-го элемента от границы карты,
    /// нужно взять число `offsetsArray[1][0]`, т.е. 1/2, и умножить его на размер (длину или ширину)
    /// первого элемента карты `firstElement`
    var offsets: [CGFloat] { // все эти коэфиценты здесь потому что я не смог вычислить формулу для i-го элемента
        let offsetsArray: [[CGFloat]] = [[1], [1/2, 3/2], [0, 1, 2]]
        return offsetsArray[features.number.rawValue]
    }
    
    /// Настройка параметров класса. Вызывается один раз после инициализации
    private func setupView() {
        backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.113947622, green: 0.1140615543, blue: 0.1157705386, alpha: 1).cgColor
        clipsToBounds = true
        contentMode = .redraw
    }
    override func layoutSubviews() {
        layer.cornerRadius = bounds.width * Constants.cornerRadiusToBoundsWidth
    }
    override func draw(_ rect: CGRect) {
        for offset in offsets {
            drawElement(in: firstElement
            .applying(CGAffineTransform(translationX: bounds.isLandscape ? firstElement.width * offset : 0,
                                        y: bounds.isLandscape ? 0 : firstElement.height * offset)))
        }
    }
    @objc func tapRecognizedOnCard(by recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            delegate?.cardTapped(self)
        default:
            break
        }
    }
    static func ==(rhs: SetCardView, lhs: SetCardView) -> Bool {
        return rhs.features == lhs.features
    }
    private func drawElement(in rect: CGRect) {
        strokeColor.setStroke()
        fillColor.setFill()
        // т.к. размер вида может быть каким угодно, нужно создать новый прямоугольник,
        // находящийся по середине rect и уменьшенный согласно aspectRatio
        var newRect: CGRect = rect.isLandscape && ((rect.width / rect.height) > Constants.aspectRatio) ?
            rect.insetBy(dx: (rect.width - rect.height*Constants.aspectRatio)/2, dy: 0) :
            rect.insetBy(dx: 0, dy: (rect.height - rect.width/Constants.aspectRatio)/2)
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
