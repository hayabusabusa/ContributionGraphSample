//
//  ViewController.swift
//  ContributionGraphSample
//
//  Created by Yamada Shunya on 2020/01/22.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstContributionGraphView: ContributionGraphView!
    @IBOutlet weak var secondContributionGraphView: ContributionGraphView!
    @IBOutlet weak var thirdContributionGraphView: ContributionGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupContributionGraphViews()
    }
    
    @objc
    private func onTapRefreshButton(_ sender: UIBarButtonItem) {
        let contributions = generateContributions()
        let contribution = generateContribution()
        firstContributionGraphView.contributions = contributions
        secondContributionGraphView.update(with: contribution)
        thirdContributionGraphView.graphDate = generateRandomDate()
    }
}

// MARK: - Setup

extension ViewController {
    
    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(onTapRefreshButton(_:)))
    }
    
    private func setupContributionGraphViews() {
        let contributions = generateContributions()
        firstContributionGraphView.delegate = self
        firstContributionGraphView.contributions = contributions
        secondContributionGraphView.contributions = contributions
        thirdContributionGraphView.contributions = contributions
        thirdContributionGraphView.enableReloadAnimatoin = false
    }
}

// MARK: - Utils

extension ViewController {
    
    private func generateContribution() -> Contribution {
        return Contribution(date: Date(), rate: randomRate())
    }
    
    private func generateContributions() -> [Contribution] {
        let calendar = Calendar.current
        guard let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: Date())),
            let numberOfDays = calendar.range(of: .day, in: .month, for: Date())?.count else { return [] }
        
        var contributions = [Contribution]()
        for i in 1 ... numberOfDays {
            if let tomorrow = calendar.date(byAdding: .day, value: i, to: firstDay) {
                let contribution = Contribution(date: tomorrow, rate: randomRate())
                contributions.append(contribution)
            }
        }
        return contributions
    }
    
    private func generateRandomDate() -> Date? {
        let today = Date()
        let culendar = Calendar.current
        let addingDay = Int.random(in: 30 ... 90)
        let date = culendar.date(byAdding: .day, value: addingDay, to: today)
        return date
    }
    
    private func randomRate() -> Contribution.Rate {
        let random = Int.random(in: 0 ... 4)
        switch random {
        case 0: return .zero
        case 1: return .low
        case 2: return .middle
        case 3: return .high
        case 4: return .max
        default: return .zero
        }
    }
}

extension ViewController: ContributionGraphViewDelegate {
    
    func didSelect(_ contributionGraphView: ContributionGraphView, contribution: Contribution) {
        print(contribution)
    }
}
