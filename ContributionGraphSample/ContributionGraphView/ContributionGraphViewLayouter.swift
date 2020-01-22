//
//  ContributionGraphViewLayouter.swift
//  ContributionGraphSample
//
//  Created by Yamada Shunya on 2020/01/22.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

enum ContributionGraphViewLayouter {
    
    // v = view, sv = StackView, cv = CollectionView
    //
    // v                        sv        cv                 cell
    // |                        |         |                  |
    // | <- horizontal inset -> | <- 0 -> | <- Item space -> |
    // |                        |         |                  |
    
    static func createLayout(frame: CGRect, horizontalInset: CGFloat, itemSpacing: CGFloat) -> UICollectionViewFlowLayout {
        let numberOfRows: CGFloat = 7
        let spaces: CGFloat = (horizontalInset * 2) + (itemSpacing * numberOfRows)
        let itemSize: CGFloat = (frame.width - spaces) / numberOfRows
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = itemSpacing
        return layout
    }
}
