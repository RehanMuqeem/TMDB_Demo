//
//  AppColors.swift
//  TMDBMovies
//
//  Created by appinventiv on 26/12/22.
//

import UIKit

enum AppColors {
    
    /// (214,215,220,1)
    static var pageControlGray: UIColor { getColor("pageControlGray") }
    
    ///(160,160,160,1)
    static var grayLight: UIColor { UIColor(red: 0.625, green: 0.625, blue: 0.625, alpha: 1.0) }

    static func getColor(_ name: String) -> UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(named: name) ?? .white
        } else {
            return UIColor.white
        }
    }
    
    private static var randomColors: UIColor {
        UIColor(hue: .random(in: 0.1..<1.0), saturation: .random(in: 0.5...1.0), brightness: .random(in: 0.5...1.0), alpha: 1.0)
    }
    
    
}
