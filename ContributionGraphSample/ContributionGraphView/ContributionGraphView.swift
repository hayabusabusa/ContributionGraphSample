//
//  ContributionGraphView.swift
//  ContributionGraphSample
//
//  Created by Yamada Shunya on 2020/01/22.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

class ContributionGraphView: UIView {
    
    // MARK: Appearance
    
    @IBInspectable private var verticalStackViewSpacing: CGFloat = 8.0
    @IBInspectable private var verticalInset: CGFloat = 8.0
    @IBInspectable private var horizontalInset: CGFloat = 16.0
    @IBInspectable private var itemSpacing: CGFloat = 4.0
    @IBInspectable private var cornerRadius: CGFloat = 4
    @IBInspectable private var cellCornerRadius: CGFloat = 0
    @IBInspectable private var borderWidth: CGFloat = 1
    @IBInspectable private var borderColor: UIColor = UIColor.lightGray.withAlphaComponent(0.6)
    @IBInspectable private var labelColor: UIColor = .lightGray
    @IBInspectable private var showsScrollIndicator: Bool = false
    
    @IBInspectable public var baseColor: UIColor = .systemBlue
    @IBInspectable public var enableReloadAnimatoin: Bool = true
    
    // MARK: Properties
    
    public weak var delegate: ContributionGraphViewDelegate?
    public var contributions: [Contribution] = [Contribution]() {
        didSet {
            reload()
        }
    }
    
    private var dataSource: [Contribution] = [Contribution]()
    private let dataSourceManager = ContributionGraphViewDataSourceManager()
    
    // MARK: SubViews
    
    private var verticalStackView: UIStackView?
    private var horizontalStackView: UIStackView?
    private var collectionView: UICollectionView?
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect,
         verticalInset: CGFloat = 16.0,
         horizontalInset: CGFloat = 8.0,
         itemSpacing: CGFloat = 4.0,
         cornerRadius: CGFloat = 4,
         cellCornerRadius: CGFloat = 0,
         borderWidth: CGFloat = 1,
         borderColor: UIColor = UIColor.gray.withAlphaComponent(0.6),
         baseColor: UIColor = .systemBlue,
         showsScrollIndicator: Bool = false,
         enableReloadAnimatoin: Bool = true) {
        super.init(frame: frame)
        self.verticalInset = verticalInset
        self.horizontalInset = horizontalInset
        self.itemSpacing = itemSpacing
        self.cornerRadius = cornerRadius
        self.cellCornerRadius = cellCornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.baseColor = baseColor
        self.showsScrollIndicator = showsScrollIndicator
        self.enableReloadAnimatoin = enableReloadAnimatoin
        setup()
    }
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rearrangedCollectionViewLayout()
        print(#function)
    }
}

// MARK: - Setup

extension ContributionGraphView {
    
    private func setup() {
        setupLayers()
        setupVerticalStackView()
        setupHorizontalStackView()
        setupWeekLabels()
        setupCollectionView()
    }
    
    private func setupLayers() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    private func setupVerticalStackView() {
        let stackView = UIStackView()
        self.verticalStackView = stackView
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = verticalStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: verticalInset),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalInset),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalInset),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalInset)
        ])
    }
    
    private func setupHorizontalStackView() {
        let stackView = UIStackView()
        self.horizontalStackView = stackView
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = itemSpacing
        verticalStackView?.addArrangedSubview(stackView)
    }
    
    private func setupWeekLabels() {
        let weeks: [String] = ["S", "M", "T", "W", "T", "F", "S"]
        weeks.forEach { week in
            let label = UILabel()
            label.text = week
            label.font = .systemFont(ofSize: 14)
            label.textColor = labelColor
            label.textAlignment = .center
            horizontalStackView?.addArrangedSubview(label)
        }
    }
    
    private func setupCollectionView() {
        let layout = ContributionGraphViewLayouter.createLayout(frame: frame, horizontalInset: horizontalInset, itemSpacing: itemSpacing)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView = collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = showsScrollIndicator
        collectionView.showsHorizontalScrollIndicator = showsScrollIndicator
        collectionView.register(ContributionGraphViewCell.self, forCellWithReuseIdentifier: ContributionGraphViewCell.identifier)
        verticalStackView?.addArrangedSubview(collectionView)
        
        contributions = []
    }
    
    private func setup(_ cell: ContributionGraphViewCell, at indexPath: IndexPath) {
        let contribution = dataSource[indexPath.row]
        cell.backgroundColor = contribution.color(base: baseColor)
        cell.layer.cornerRadius = cellCornerRadius
    }
}

// MARK: - Update, reload

extension ContributionGraphView {
    
    private func rearrangedCollectionViewLayout() {
        let layout = ContributionGraphViewLayouter.createLayout(frame: frame, horizontalInset: horizontalInset, itemSpacing: itemSpacing)
        collectionView?.setCollectionViewLayout(layout, animated: false)
    }
    
    private func reload() {
        dataSource = dataSourceManager.createDataSource(with: contributions)
        collectionView?.reloadData()
        
        if enableReloadAnimatoin {
            collectionView?.performBatchUpdates({ [weak self] in
                guard let cells = self?.collectionView?.visibleCells else { return }
                cells.shuffled().enumerated().forEach { $0.element.layer.add(ContributionGraphViewAnimator.animation(index: $0.offset), forKey: "opacity") }
            }, completion: nil)
        }
    }
    
    public func update(with contribution: Contribution) {
        guard let index = dataSourceManager.index(dataSource, of: contribution) else { return }
        dataSource[index] = contribution
        collectionView?.reloadItems(at: [IndexPath(row: index, section: 0)])
        
        if enableReloadAnimatoin {
            collectionView?.performBatchUpdates({ [weak self] in
                guard let cell = self?.collectionView?.cellForItem(at: IndexPath(row: index, section: 0)) else { return }
                cell.layer.add(ContributionGraphViewAnimator.animation(index: index, offset: 0), forKey: "opacity")
            }, completion: nil)
        }
    }
}

// MARK: - CollectionView dataSource

extension ContributionGraphView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContributionGraphViewCell.identifier, for: indexPath) as? ContributionGraphViewCell else { return UICollectionViewCell() }
        setup(cell, at: indexPath)
        return cell
    }
}

// MARK: - CollectionView delegate

extension ContributionGraphView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contribution = dataSource[indexPath.row]
        if case .inset = contribution.rate { return }
        delegate?.didSelect(self, contribution: contribution)
    }
}
