//
//  CustomActivityIndicator.swift
//  ToDoApp
//
//  Created by Павел on 27.03.2025.
//

import UIKit

final class CustomActivityIndicator: UIView {
    
    // MARK: - Properties
    private let circleLayer = CAShapeLayer()
    private let animationDuration: CFTimeInterval = 1.5

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Setup
    private func setup() {
        circleLayer.lineWidth = 4.0
        circleLayer.strokeColor = Color.yellowCg
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        layer.addSublayer(circleLayer)
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCirclePath()
    }

    private func updateCirclePath() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 4 - circleLayer.lineWidth / 4
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -CGFloat.pi / 2,
            endAngle: 3 * CGFloat.pi / 2,
            clockwise: true
        )
        circleLayer.path = path.cgPath
    }

    // MARK: - Animation
    
    func startAnimating() {
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.duration = animationDuration
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.duration = animationDuration
        strokeStartAnimation.beginTime = animationDuration / 2
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [strokeEndAnimation, strokeStartAnimation]
        groupAnimation.duration = animationDuration * 2
        groupAnimation.repeatCount = .infinity

        circleLayer.add(groupAnimation, forKey: "loading")
    }

    func stopAnimating() {
        circleLayer.removeAllAnimations()
    }
}
