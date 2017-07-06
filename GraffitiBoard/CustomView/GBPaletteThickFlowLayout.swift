//
//  GBPaletteThickFlowLayout.swift
//  GraffitiBoard
//
//  Created by jeongkyu kim on 2017. 7. 18..
//  Copyright © 2017년 jeongkyu kim. All rights reserved.
//

import UIKit

class GBPaletteThickFlowLayout: UICollectionViewFlowLayout {

    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let isHorizontal = (self.scrollDirection == .horizontal)
        
        var bound = CGRect.zero
        
        bound.size = self.collectionView!.contentSize
        
        guard let collectionView = collectionView , !collectionView.isPagingEnabled,
            let layoutAttributes = self.layoutAttributesForElements(in: bound)
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        
        
        
        let midSide = (isHorizontal ? collectionView.bounds.size.width : collectionView.bounds.size.height) / 2
        let proposedContentOffsetCenterOrigin = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + midSide
        
        var targetContentOffset: CGPoint
        
        if isHorizontal {
            let closest = layoutAttributes.sorted { abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)
        }
        else {
            let closest = layoutAttributes.sorted { abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - midSide))
        }
        
        print("<---- \(proposedContentOffset) | \(targetContentOffset)")
        
        return targetContentOffset
    }
}
