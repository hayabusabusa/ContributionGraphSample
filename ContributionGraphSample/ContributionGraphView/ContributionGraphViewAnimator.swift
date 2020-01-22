//
//  ContributionGraphViewAnimator.swift
//  ContributionGraphSample
//
//  Created by Yamada Shunya on 2020/01/22.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

enum ContributionGraphViewAnimator {
    
    static func animation(index: Int, duration: CFTimeInterval = 1.0, offset: Double = 0.05) -> CABasicAnimation {
        let beginTimeOffset: Double = Double(index) * offset
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0
        fadeAnimation.duration = duration
        fadeAnimation.beginTime = CACurrentMediaTime() + beginTimeOffset
        fadeAnimation.toValue = 1
        fadeAnimation.fillMode = .backwards
        fadeAnimation.isRemovedOnCompletion = true
        fadeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return fadeAnimation
    }
}
