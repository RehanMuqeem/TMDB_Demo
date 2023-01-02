//
//  CustomSegmentedContro;.swift
//  TMDBMovies
//
//  Created by appinventiv on 26/12/22.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let segmentStringSelected: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let segmentStringHighlited: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 14, weight: .bold),
            NSAttributedString.Key.foregroundColor: AppColors.grayLight
        ]
        
        setTitleTextAttributes(segmentStringHighlited, for: .normal)
        setTitleTextAttributes(segmentStringSelected, for: .selected)
        setTitleTextAttributes(segmentStringHighlited, for: .highlighted)
        
        layer.masksToBounds = true
        
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = .clear//AppColors.gradientColor
        } else {
            tintColor = .blue
        }
        
        backgroundColor = AppColors.pageControlGray
        
        //corner radius
        let cornerRadius = bounds.height / 2
        let maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        //background
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        if #available(iOS 11.0, *) {
            layer.maskedCorners = maskedCorners
        } else {
            // Fallback on earlier versions
        }
        
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex),
           let foregroundImageView = subviews[foregroundIndex] as? UIImageView {
            foregroundImageView.image = UIImage()
            foregroundImageView.clipsToBounds = true
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.backgroundColor = .black
            
            foregroundImageView.layer.cornerRadius = bounds.height / 2 + 4
            if #available(iOS 11.0, *) {
                foregroundImageView.layer.maskedCorners = maskedCorners
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
}
