//
//  ContributionGraphViewDelegate.swift
//  ContributionGraphSample
//
//  Created by Yamada Shunya on 2020/01/22.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

protocol ContributionGraphViewDelegate: AnyObject {
    func didSelect(_ contributionGraphView: ContributionGraphView, contribution: Contribution)
}
