//
//  UIView+Extensions.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import RxSwift

extension UIView {
    
    func addSubviewExpanded(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
        let views = ["view" : subview]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", metrics: nil, views: views))
    }
          
    static func nib() -> UINib {
        let className = NSStringFromClass(self)
        let strippedClassName = className.components(separatedBy: ".").last ?? className
        
        if Bundle.main.path(forResource: strippedClassName, ofType: "nib") != nil {
            return UINib(nibName: strippedClassName, bundle: Bundle.main)
        } else {
            fatalError("no nib was found")
        }
    }
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
}

extension UIView {

    @discardableResult
    func addRoundedCornersMask(_ corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let maskLayer = RoundedCornerMaskLayer(corners: corners, radius: radius, target: self)
        self.layer.mask = maskLayer
        return maskLayer
    }

    private class RoundedCornerMaskLayer: CAShapeLayer {

        let corners:        UIRectCorner
        let radius:         CGFloat
        weak var target:    UIView?

        let disposeBag = DisposeBag()

        init(corners: UIRectCorner, radius: CGFloat, target: UIView) {
            self.corners = corners
            self.radius = radius
            self.target = target

            super.init()

            self.target?.rx.observe(CGRect.self, #keyPath(UIView.bounds))
                .filter { $0 != nil }
                .subscribe(onNext: { [unowned self] bounds in
                    self.frame = bounds!
                })
                .disposed(by: self.disposeBag)
        }

        @available(*, unavailable)
        required init?(coder aDecoder: NSCoder) {
            fatalError("unavailable")
        }

        override func layoutSublayers() {
            super.layoutSublayers()

            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: self.corners,
                                    cornerRadii: CGSize(width: self.radius, height: self.radius))
            self.path = path.cgPath
        }
    }
}

extension UIView {
    
    func setGradientPurplLayer() {
        
        let colors = [UIColor(red: 0.18, green: 0.15, blue: 0.36, alpha: 1.00),
                      UIColor(red: 0.12, green: 0.12, blue: 0.25, alpha: 0.54),
                      UIColor(red: 0.15, green: 0.15, blue: 0.31, alpha: 1.00)]
        let gradientLayer = GradientLayer(target: self,
                                          colors: colors,
                                          startPoint: CGPoint(x: 0.25, y: 0.5),
                                          endPoint: CGPoint(x: 0.75, y: 0.5))
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //@discardableResult
    func setGradientLayer() {
        let colors = [UIColor(red: 0.07, green: 0.07, blue: 0.09, alpha: 1.00),
                      UIColor(red: 0.07, green: 0.07, blue: 0.09, alpha: 1.00),
                      UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.00)]
        let gradientLayer = GradientLayer(target: self,
                                          colors: colors,
                                          startPoint: CGPoint(x: 0.25, y: 0.5),
                                          endPoint: CGPoint(x: 0.75, y: 0.5))
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
//    @discardableResult
//    func setGradientLayer(colors: [UIColor],
//                          startPoint: CAGradientLayer.Point = .left,
//                          endPoint: CAGradientLayer.Point = .right) -> CALayer {
//        let gradientLayer = GradientLayer(target: self,
//                                          colors: colors,
//                                          startPoint: startPoint.point,
//                                          endPoint: startPoint.point)
//        self.layer.insertSublayer(gradientLayer, at: 0)
//        return gradientLayer
//    }

    @discardableResult
    func addButtonGradientLayer() -> CALayer {
        let gradientLayer = GradientLayer(target: self,
                                          colors: [UIColor.white, UIColor.white],
                                          startPoint: CGPoint(x: 0.25, y: 0.5),
                                          endPoint: CGPoint(x: 0.75, y: 0.5))
        self.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }

    private class GradientLayer: CAGradientLayer {

        let disposeBag = DisposeBag()
        
        override init(layer: Any) {
            super.init()
        }

        init(target: UIView,
             colors: [UIColor],
             startPoint: CGPoint = CAGradientLayer.Point.left.point,
             endPoint: CGPoint = CAGradientLayer.Point.right.point)
        {
            super.init()

            self.colors     = colors.map { $0.cgColor }
            self.locations  = [0, 0.61, 1]
            self.startPoint = startPoint
            self.endPoint   = endPoint
            self.transform  = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1, b: 1, c: -1, d: 0.21, tx: 0.38, ty: 0.14))
            target.rx.observe(CGRect.self, #keyPath(UIView.bounds))
                .map { [unowned target] _ in target }
                .subscribe(onNext: { [unowned self] target in
                    self.bounds     = target.bounds.insetBy(dx: -0.5 * target.bounds.size.width,
                                                            dy: -0.5 * target.bounds.size.height)
                    self.position   = target.center
                })
                .disposed(by: self.disposeBag)
        }

        @available(*, unavailable)
        required init?(coder aDecoder: NSCoder) {
            fatalError("unavailable")
        }
    }
}

extension UIView {

    func getSnapshotImage(scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
        defer { UIGraphicsEndImageContext() }

        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        } else {
            return nil
        }
    }
}

extension UIView {
    
    @discardableResult
    func makeDashedBorderLine(color: UIColor,
                              startPoint: CGPoint,
                              endPoint: CGPoint,
                              dashWidth: CGFloat = 0.5,
                              dashPattern: [NSNumber] = [3, 3]) -> CALayer
    {
        let path = CGMutablePath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = dashWidth
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineDashPattern = dashPattern
        path.addLines(between: [startPoint, endPoint])
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
        return shapeLayer
    }
}

extension UIView {
    
    func applyBlurEffect(toBack: UIView, style: UIBlurEffect.Style = .dark) -> UIView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.alpha = 0
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        
        UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseIn, animations: {
            blurEffectView.alpha = 1
        }) { (animationComplete) in
        }
        
        return blurEffectView
    }
    
    func applyBlurEffect(style: UIBlurEffect.Style = .dark, duration: Double = 0.33, alpha: CGFloat = 1) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.alpha = 0
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            blurEffectView.alpha = alpha
        }) { (animationComplete) in
        }
    }
    
    /// Remove UIBlurEffect from UIView
    func removeBlurEffect() {
        let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
        blurredEffectViews.forEach{ blurView in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                blurView.alpha = 0
                blurView.removeFromSuperview()
            }) { (animationComplete) in
            }
        }
    }
}

extension UIView {
    
    func addShadow(shadowColor: UIColor,
                   width: CGFloat,
                   height: CGFloat,
                   shadowOpacity: Float,
                   shadowRadius: CGFloat) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
    }
}
