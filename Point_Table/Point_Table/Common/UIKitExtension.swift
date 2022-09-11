//
//  UIKitExtension.swift
//  OurEyesOnly
//
//  Created by Kevin Shah on 04/04/19.
//  Copyright © 2019 Kevin Shah. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable public var isRound: Bool {
        get { return (layer.cornerRadius == (frame.size.width/2) * ScreenSize.widthRatio) || (layer.cornerRadius == (frame.size.height/2) * ScreenSize.heightRatio) }
        set { layer.cornerRadius = newValue == true ? (frame.size.height/2) * ScreenSize.widthRatio : layer.cornerRadius }
    }
    
    @IBInspectable public var isViewRound: Bool {
        get { return (layer.cornerRadius == (frame.size.width/2) * ScreenSize.widthRatio) || (layer.cornerRadius == (frame.size.height/2) * ScreenSize.heightRatio) }
        set { layer.cornerRadius = newValue == true ? (frame.size.height/2) * ScreenSize.widthRatio : layer.cornerRadius }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
    @IBInspectable public var borderColor: UIColor {
        get { return self.layer.borderColor == nil ? UIColor.clear : UIColor(cgColor: self.layer.borderColor!) }
        set { self.layer.borderColor = newValue.cgColor }
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue * ScreenSize.widthRatio }
    }
    
    @IBInspectable public var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable public var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable public var shadowColor: UIColor? {
        get { return layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) : nil }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    @IBInspectable public var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable public var zPosition: CGFloat {
        get { return layer.zPosition }
        set { layer.zPosition = newValue }
    }
}

extension String {
    func firstCharacterUpperCase() -> String {

        //break it into an array by delimiting the sentence using a space
        let breakupSentence = self.components(separatedBy: " ")
        var newSentence = ""

        //Loop the array and concatinate the capitalized word into a variable.
        for wordInSentence  in breakupSentence {
            newSentence = "\(newSentence) \(wordInSentence.capitalized)"
        }

        // send it back up.
        return newSentence
    }
    
}
extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
