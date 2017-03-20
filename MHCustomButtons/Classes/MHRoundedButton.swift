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

@IBDesignable
public class MHRoundedButton: UIButton {
    
    fileprivate var originBackgroundColor: UIColor?
    
    /// Specify the radius of the corners for the button
    @IBInspectable public var cornerRadius: CGFloat = 0 { didSet { self.layer.cornerRadius = cornerRadius } }
    
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
    
    /// Specify the border width for when the button is pressed
    @IBInspectable public var buttonPressedBorderWidth: CGFloat = 0
    
    /// Specify the bordor color for when the button is pressed
    @IBInspectable public var buttonPressedBorderColor: UIColor = UIColor.clear
    
    /// Specify the background color for when the button is pressed
    @IBInspectable public var buttonPressedBackground: UIColor = UIColor.clear
    
    /**
     Specify whether you want the button the animate when pressed or not
     
     true by default
     - true: button will be animated
     - false: button won't be animated
     */
    @IBInspectable public var animateButton: Bool = true
    
    /// Specify the duration of the animation.
    @IBInspectable public var animateDuration: Double = 0.5
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        originBackgroundColor = self.backgroundColor
        self.backgroundColor = buttonPressedBackground
        self.layer.borderColor = buttonPressedBorderColor.cgColor
        self.layer.borderWidth = buttonPressedBorderWidth
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if animateButton {
            animateTouchEnd()
        } else {
            self.backgroundColor = originBackgroundColor
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = borderWidth
        }
    }
    
    func animateTouchEnd() {
        let borderAnimateColor = CABasicAnimation(keyPath: "borderColor")
        borderAnimateColor.fromValue = self.layer.borderColor
        borderAnimateColor.toValue = self.borderColor
        self.layer.borderColor = self.borderColor.cgColor
        
        let borderAnimateWidth = CABasicAnimation(keyPath: "borderWidth")
        borderAnimateWidth.fromValue = self.layer.borderWidth
        borderAnimateWidth.toValue = self.borderWidth
        self.layer.borderWidth = self.borderWidth
        
        let backgroundAnimateColor = CABasicAnimation(keyPath: "backgroundColor")
        backgroundAnimateColor.fromValue = self.backgroundColor
        backgroundAnimateColor.toValue = originBackgroundColor
        self.backgroundColor = originBackgroundColor
        
        let combAnimate = CAAnimationGroup()
        combAnimate.duration = animateDuration
        combAnimate.animations = [borderAnimateColor, borderAnimateWidth, backgroundAnimateColor]
        combAnimate.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        self.layer.add(combAnimate, forKey: "")
    }
}
