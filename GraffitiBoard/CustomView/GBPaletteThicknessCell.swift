//
//  GBPaletteThicknessCell.swift
//  GraffitiBoard
//
//  Created by jeongkyu kim on 2017. 7. 18..
//  Copyright © 2017년 jeongkyu kim. All rights reserved.
//

import UIKit

class GBPaletteThicknessCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.cornerRadius = 5
    }

}
