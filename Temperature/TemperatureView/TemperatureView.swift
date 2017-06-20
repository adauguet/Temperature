//
//  TemperatureView.swift
//  Temperature
//
//  Created by Antoine DAUGUET on 16/06/2017.
//  Copyright © 2017 Antoine DAUGUET. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TemperatureView: UIView {
    
    var view: UIView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = Bundle(for: type(of: self)).loadNibNamed("TemperatureView", owner: self, options: nil)![0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func configure(temperature: Double) {
        let string = String(format: "%.2f", temperature)
        if string.last == "0" {
            let attributedString = NSMutableAttributedString(string: string)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.clear, range: NSRange(location: 4, length: 1))
            temperatureLabel.attributedText = attributedString
        } else {
            temperatureLabel.text = string
        }
        temperatureLabel.font = temperatureLabel.font.monospacedDigitFont
    }
}

extension UIFont {
    var monospacedDigitFont: UIFont {
        let oldFontDescriptor = fontDescriptor
        let newFontDescriptor = oldFontDescriptor.monospacedDigitFontDescriptor
        return UIFont(descriptor: newFontDescriptor, size: 0)
    }
}

private extension UIFontDescriptor {
    var monospacedDigitFontDescriptor: UIFontDescriptor {
        let fontDescriptorFeatureSettings = [[UIFontFeatureTypeIdentifierKey: kNumberSpacingType, UIFontFeatureSelectorIdentifierKey: kMonospacedNumbersSelector]]
        let fontDescriptorAttributes = [UIFontDescriptorFeatureSettingsAttribute: fontDescriptorFeatureSettings]
        let fontDescriptor = addingAttributes(fontDescriptorAttributes)
        return fontDescriptor
    }
}
