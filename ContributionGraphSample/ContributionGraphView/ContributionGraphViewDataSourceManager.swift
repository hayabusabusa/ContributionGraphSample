//
//  ContributionGraphViewDataSourceManager.swift
//  ContributionGraphSample
//
//  Created by Yamada Shunya on 2020/01/22.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

struct ContributionGraphViewDataSourceManager {
    
    // MARK: Properties
    
    private let calendar: Calendar
    private let formatter: DateFormatter
    
    // MARK: Initializer
    
    init() {
        calendar = Calendar.current
        formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
    }
    
    /// Create new dataSource from array of contributions.
    ///
    /// - Parameters:
    ///   - contributions: New contributions.
    ///   - startDate: Month showing contribution graph view. Default values is today.
    func createDataSource(with contributions: [Contribution], startDate: Date = Date()) -> [Contribution] {
        guard let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: startDate)),
            let numberOfDays = calendar.range(of: .day, in: .month, for: startDate)?.count else { return [] }
        
        let firstWeekday = calendar.component(.weekday, from: firstDay) - 1
        
        // NOTE: Dummy date...
        let dummyDay = Date(timeIntervalSince1970: 0)
        
        // NOTE: Create new dataSource and append insets.
        var dataSource: [Contribution] = [Contribution]()
        dataSource.append(contentsOf: [Contribution](repeating: Contribution(date: dummyDay, rate: .inset), count: firstWeekday))
        
        for i in 1 ... numberOfDays {
            if let tomorrow = calendar.date(byAdding: .day, value: i, to: firstDay) {
                let contribution = contributions.first(where: { formatter.string(from: $0.date) == formatter.string(from: tomorrow) }) ?? Contribution(date: tomorrow, rate: .zero)
                dataSource.append(contribution)
            }
        }
        return dataSource
    }
    
    func index(_ dataSource: [Contribution], of contribution: Contribution) -> Int? {
        guard let index = dataSource
            .firstIndex(where: { formatter.string(from: $0.date) == formatter.string(from: contribution.date) }) else { return nil }
        return index
    }
}
