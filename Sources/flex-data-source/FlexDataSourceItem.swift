//
//  FlexDataSourceItem.swift
//  FlexDataSource
//
//  Created by Elliot Schrock on 2/10/18.
//

import UIKit

public protocol FlexDataSourceItem {
    func cellIdentifier() -> String
    func cellClass() -> UITableViewCell.Type
    func configureCell(_ cell: UITableViewCell)
}

open class ConcreteFlexDataSourceItem<T>: FlexDataSourceItem where T: UITableViewCell {
    private let identifier: String
    
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    open func cellIdentifier() -> String {
        return identifier
    }
    
    open func cellClass() -> UITableViewCell.Type {
        return T.self
    }
    
    open func configureCell(_ cell: UITableViewCell) {
        // NO OP: override me!
    }
}

open class FunctionalFlexDataSourceItem<T>: ConcreteFlexDataSourceItem<T> where T: UITableViewCell {
    private let configureCell: (UITableViewCell) -> Void

    public init(identifier: String = "cell", _ configureCell: @escaping (UITableViewCell) -> Void) {
        self.configureCell = configureCell
        super.init(identifier: identifier)
    }

    open override func configureCell(_ cell: UITableViewCell) {
        configureCell(cell)
    }
}

open class TappableFunctionalFlexItem<T>: FunctionalFlexDataSourceItem<T>, Tappable where T: UITableViewCell {
    public var onTap: () -> Void
    
    public init(identifier: String, _ configureCell: @escaping (UITableViewCell) -> Void, _ onTap: @escaping () -> Void) {
        self.onTap = onTap
        super.init(identifier: identifier, configureCell)
    }
}

open class SwipableItem<T>: TappableFunctionalFlexItem<T>, Swipable where T: UITableViewCell {
    public var onSwipe: () -> Void
    
    public init(identifier: String,
                _ configureCell: @escaping (UITableViewCell) -> Void,
                _ onTap: @escaping () -> Void,
                _ onSwipe: @escaping () -> Void) {
        self.onSwipe = onSwipe
        super.init(identifier: identifier, configureCell, onTap)
    }
}
