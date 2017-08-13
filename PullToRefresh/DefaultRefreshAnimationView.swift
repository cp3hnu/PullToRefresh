//
//  DefaultRefreshAnimationView.swift
//  PullToRefresh
//
//  Created by CP3 on 16/6/18.
//  Copyright © 2016年 CP3. All rights reserved.
//

import UIKit

private let kRotationAnimation = "kRotationAnimation"

public extension CGFloat {
    
    public func toRadians() -> CGFloat {
        return (self * CGFloat(Double.pi)) / 180.0
    }
    
    public func toDegrees() -> CGFloat {
        return self * 180.0 / CGFloat(Double.pi)
    }
}

public class DefaultRefreshAnimationView: RefreshAnimationView {

    fileprivate let shapeLayer = CAShapeLayer()
    fileprivate lazy var identityTransform: CATransform3D = {
        var transform = CATransform3DIdentity
        transform.m34 = CGFloat(1.0 / -500.0)
        transform = CATransform3DRotate(transform, CGFloat(-90.0).toRadians(), 0.0, 0.0, 1.0)
        return transform
    }()
    
    public init() {
        super.init(frame: CGRect.zero)
        
        shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = tintColor.cgColor
        shapeLayer.actions = ["strokeEnd" : NSNull(), "transform" : NSNull()]
        shapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        layer.addSublayer(shapeLayer)
        
        //backgroundColor = UIColor.redColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func tintColorDidChange() {
        super.tintColorDidChange()
        
        shapeLayer.strokeColor = tintColor.cgColor
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let shapeSize: CGFloat = 30
        shapeLayer.frame = CGRect(x: (bounds.width - shapeSize)/2, y: (bounds.height - shapeSize)/2, width: shapeSize, height: shapeSize)
        
        let inset = shapeLayer.lineWidth / 2.0
        shapeLayer.path = UIBezierPath(ovalIn: shapeLayer.bounds.insetBy(dx: inset, dy: inset)).cgPath
    }
    
    // MARK: - Subclass
    override public func pullProgress(_ progress: CGFloat) {
        shapeLayer.strokeEnd = min(0.8 * progress, 0.9)
        
        if progress > 1.0 {
            let degrees = ((progress - 1.0) * 200.0)
            shapeLayer.transform = CATransform3DRotate(identityTransform, degrees.toRadians(), 0.0, 0.0, 1.0)
        } else {
            shapeLayer.transform = identityTransform
        }
    }
    
    override public func startAnimating() {
        super.startAnimating()
        
        if shapeLayer.animation(forKey: kRotationAnimation) != nil { return }
        
        shapeLayer.strokeEnd = 0.9
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat(2 * Double.pi) + currentDegree()
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = Float.infinity
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.fillMode = kCAFillModeForwards
        shapeLayer.add(rotationAnimation, forKey: kRotationAnimation)
    }
    
    override public func stopAnimating() {
        shapeLayer.removeAnimation(forKey: kRotationAnimation)
    }
}


// MARK: - Help
private extension DefaultRefreshAnimationView {
    func currentDegree() -> CGFloat {
        return shapeLayer.value(forKeyPath: "transform.rotation.z") as! CGFloat
    }
}
