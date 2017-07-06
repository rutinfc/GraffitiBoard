//
//  GBNavigation.swift
//  GraffitiBoard
//
//  Created by jeongkyu kim on 2017. 7. 6..
//  Copyright © 2017년 jeongkyu kim. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let verticalCompact = UITraitCollection(verticalSizeClass: .compact)
        let compactAppearance = UINavigationBar.appearance(for: verticalCompact)
        let whiteImage = UIImage.init(color: UIColor.white.withAlphaComponent(0.8), size: CGSize(width: 1, height: 1))
        compactAppearance.setBackgroundImage(whiteImage, for: .default)
        compactAppearance.tintColor = UIColor.black
        compactAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        
        let verticalRegular = UITraitCollection(verticalSizeClass: .regular)
        let regularAppearance = UINavigationBar.appearance(for: verticalRegular)
        let blackImage = UIImage.init(color: UIColor.black.withAlphaComponent(0.8), size: CGSize(width: 1, height: 1))
        regularAppearance.setBackgroundImage(blackImage, for: .default)
        regularAppearance.tintColor = UIColor.white
        regularAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    }
    
    override open func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        
//        let image = UIImage.init(color: UIColor.white.withAlphaComponent(0.8), size: CGSize(width: 1, height: 1))
//        
//        self.navigationBar.setBackgroundImage(image, for: .default)
    }
}
