/*
 The MIT License (MIT)
 
 Copyright (c) 2017 Maiko Hermans
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import QuartzCore

@IBDesignable
public class MHCircleButton: UIButton {
    
    fileprivate var sign: TypeOfSign?
    fileprivate var signSize: CGFloat?
    fileprivate var path = UIBezierPath()
    fileprivate var lines = CAShapeLayer()
    fileprivate var originBackgroundColor: UIColor?
    
    /**
     Specify the shape of the button.
     
     true by default
     - true: The shape will be a circle
     - false: The shape will be square
     */
    @IBInspectable public var useCircle: Bool = true {
        didSet {
            if useCircle == true {
                self.layer.cornerRadius = self.frame.width / 2
            }
        }
    }
    
    /**
     Specify which sign will be used
     
     true by default
     - true: The sign will be a plus
     - false: The sign will be minus
     */
    @IBInspectable public var usePlusSign: Bool = true {
        didSet {
            if usePlusSign == true {
                sign = TypeOfSign.Plus
            } else {
                sign = TypeOfSign.Minus
            }
            setup()
        }
    }
    
    /// Specify the border size of the button
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    /// Specify the border color of the button
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    /// Specify the color of the sign which is drawn inside the button
    @IBInspectable public var signColor: UIColor = UIColor.white {
        didSet {
            lines.strokeColor = signColor.cgColor
            lines.fillColor = signColor.cgColor
        }
    }
    
    /// Specify the line width of the sign which is drawn inside the button
    @IBInspectable public var signLineWidth: CGFloat = 1 {
        didSet {
            lines.lineWidth = signLineWidth
        }
    }
    
    /// Specify the border width for when the button is pressed
    @IBInspectable public var buttonPressedBorderWidth: CGFloat = 0
    
    /// Specify the bordor color for when the button is pressed
    @IBInspectable public var buttonPressedBorderColor: UIColor = UIColor.clear
    
    /// Specify the background color for when the button is pressed
    @IBInspectable public var buttonPressedBackground: UIColor = UIColor.clear
    
    /// Specify the sign color for when the button is pressed
    @IBInspectable public var buttonPressedSignColor: UIColor = UIColor.lightGray
    
    /**
     Specify whether you want the end of the sign to be rounded or not
     
     false by default
     - true: Rounded ends
     - false: Square ends
     */
    @IBInspectable public var useRoundedLines: Bool = false {
        didSet {
            if useRoundedLines == true {
                lines.lineCap = kCALineCapRound
            } else {
                lines.lineCap = kCALineCapSquare
            }
        }
    }
    
    /**
     Specify whether you want the button the animate when pressed or not
     
     true by default
     - true: button will be animated
     - false: button won't be animated
     */
    @IBInspectable public var animateButton: Bool = true
    
    /// Specify the duration of the animation.
    @IBInspectable public var animateDuration: Double = 0.5
    
    func setup() {
        
        signSize = min(bounds.width, bounds.height) * 0.6
        
        if let typeSign = sign {
            switch(typeSign) {
            case TypeOfSign.Plus:
                drawPlus()
                
            case TypeOfSign.Minus:
                drawMinus()
            }
        }
    }
    
    func drawPlus() {
        //lines = CAShapeLayer()
        
        path.move(to: CGPoint(x: bounds.width/2 - signSize!/2, y: bounds.height/2))
        path.addLine(to: CGPoint(x: bounds.width/2 + signSize!/2, y: bounds.height/2))
        
        path.move(to: CGPoint(x: bounds.width/2 + 0.5, y: bounds.height/2 - signSize!/2))
        
        path.addLine(to: CGPoint(x: bounds.width/2 + 0.5, y: bounds.height/2 + signSize!/2))
        
        lines.path = path.cgPath
        lines.bounds = self.frame
        lines.strokeColor = signColor.cgColor
        lines.fillColor = signColor.cgColor
        lines.lineWidth = signLineWidth
        lines.lineCap = kCALineCapRound
        lines.frame = self.frame
        self.layer.addSublayer(lines)
    }
    
    func drawMinus() {
        path.move(to: CGPoint(x: bounds.width/2 - signSize!/2 + 0.5, y: bounds.height/2))
        path.addLine(to: CGPoint(x: bounds.width/2 + signSize!/2 + 0.5, y: bounds.height/2))
        
        lines.path = path.cgPath
        lines.bounds = self.frame
        lines.strokeColor = signColor.cgColor
        lines.fillColor = signColor.cgColor
        lines.lineWidth = signLineWidth
        lines.frame = self.frame
        self.layer.addSublayer(lines)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        originBackgroundColor = self.backgroundColor
        self.backgroundColor = buttonPressedBackground
        self.layer.borderColor = buttonPressedBorderColor.cgColor
        self.layer.borderWidth = buttonPressedBorderWidth
        lines.fillColor = buttonPressedSignColor.cgColor
        lines.strokeColor = buttonPressedSignColor.cgColor
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if animateButton {
            animateTouchEnd()
        } else {
            self.backgroundColor = originBackgroundColor
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = borderWidth
            lines.fillColor = signColor.cgColor
            lines.strokeColor = signColor.cgColor
        }
    }
    
    func animateTouchEnd() {
        let backgroundAnimateColor = CABasicAnimation(keyPath: "backgroundColor")
        backgroundAnimateColor.fromValue = self.backgroundColor
        backgroundAnimateColor.toValue = originBackgroundColor
        self.backgroundColor = originBackgroundColor
        
        let borderAnimateColor = CABasicAnimation(keyPath: "borderColor")
        borderAnimateColor.fromValue = self.layer.borderColor
        borderAnimateColor.toValue = self.borderColor
        self.layer.borderColor = self.borderColor.cgColor
        
        let borderAnimateWidth = CABasicAnimation(keyPath: "borderWidth")
        borderAnimateWidth.fromValue = self.layer.borderWidth
        borderAnimateWidth.toValue = self.borderWidth
        self.layer.borderWidth = self.borderWidth
        
        let fillAnimateColor = CABasicAnimation(keyPath: "fillColor")
        fillAnimateColor.fromValue = self.lines.fillColor
        fillAnimateColor.toValue = self.signColor.cgColor
        self.lines.fillColor = self.signColor.cgColor
        
        let strokeAnimateColor = CABasicAnimation(keyPath: "strokeColor")
        strokeAnimateColor.fromValue = self.lines.strokeColor
        strokeAnimateColor.toValue = self.signColor.cgColor
        self.lines.strokeColor = self.signColor.cgColor
        
        let combAnimate = CAAnimationGroup()
        combAnimate.duration = animateDuration
        combAnimate.animations = [backgroundAnimateColor, borderAnimateColor, borderAnimateWidth, fillAnimateColor, strokeAnimateColor]
        combAnimate.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        self.layer.add(combAnimate, forKey: "")
    }
}

/**
 Sign style
 
 - Plus: Use this when you want to show a plus sign.
 - Minus: Use this when you want to show a minus sign.
 */
enum TypeOfSign {
    case Plus
    case Minus
}
