//
//  GBPalette.swift
//  GraffitiBoard
//
//  Created by jeongkyu kim on 2017. 7. 17..
//  Copyright © 2017년 jeongkyu kim. All rights reserved.
//

import UIKit

class GBPaletteView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var colorCV: UICollectionView!
    @IBOutlet weak var gauge: UIImageView!
    @IBOutlet weak var thicknessCV: UICollectionView!
    @IBOutlet weak var thicknessHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nib = UINib.init(nibName: "GBPaletteColorCell", bundle: nil)
        self.colorCV.register(nib, forCellWithReuseIdentifier: "DefaultCell")
        
        let thickNib = UINib.init(nibName: "GBPaletteThicknessCell", bundle: nil)
        self.thicknessCV.register(thickNib, forCellWithReuseIdentifier: "DefaultCell")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if let layout = self.thicknessCV.collectionViewLayout as? UICollectionViewFlowLayout {
            
            DispatchQueue.main.async {
                
                if self.thicknessHeightConstraint.isActive {
                    let padding = (self.thicknessCV.frame.width - layout.itemSize.width) / 2
                    layout.sectionInset = UIEdgeInsetsMake(0, padding, 5, padding)
                    layout.scrollDirection = .horizontal
                    self.gauge!.image = UIImage(named: "down-triangle-empty")?.withRenderingMode(.alwaysTemplate)
                    self.gauge!.highlightedImage = UIImage(named: "down-triangle")?.withRenderingMode(.alwaysTemplate)
                } else {
                    let padding = (self.thicknessCV.frame.height - layout.itemSize.height) / 2
                    layout.sectionInset = UIEdgeInsetsMake(padding, 0, padding, 5)
                    layout.scrollDirection = .vertical
                    self.gauge!.image = UIImage(named: "right-triangle-empty")?.withRenderingMode(.alwaysTemplate)
                    self.gauge!.highlightedImage = UIImage(named: "right-triangle")?.withRenderingMode(.alwaysTemplate)
                }
            }
        }
    }
    
    static func createPalleteView() -> GBPaletteView? {
        
        guard let views = Bundle.main.loadNibNamed("GBPaletteView", owner: self, options: nil) else { return nil }
        
        for view in views {
            
            if let view = view as? GBPaletteView {
                if (view.restorationIdentifier == "PalleteView") {
                    return view;
                }
            }
        }
        
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if scrollView == self.thicknessCV {
            self.gauge!.isHighlighted = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.thicknessCV {
            self.gauge!.isHighlighted = false
        }
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if scrollView == self.thicknessCV {
//            self.gauge!.isHighlighted = false
//        }
//    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.thicknessCV {
            self.gauge!.isHighlighted = false
        }
    }
}
