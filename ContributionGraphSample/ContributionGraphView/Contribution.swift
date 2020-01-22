//
//  Contribution.swift
//  ContributionGraphSample
//
//  Created by Yamada Shunya on 2020/01/22.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

struct Contribution {
    let date: Date
    
    enum Rate {
        case inset
        case zero
        case low
        case middle
        case high
        case max
    }
    let rate: Rate
    
    func color(base: UIColor) -> UIColor {
        switch rate {
        case .inset: return .clear
        case .zero: return .systemGroupedBackground
        case .low: return base.withAlphaComponent(0.3)
        case .middle: return base.withAlphaComponent(0.6)
        case .high: return base.withAlphaComponent(0.8)
        case .max: return base
        }
    }
}
