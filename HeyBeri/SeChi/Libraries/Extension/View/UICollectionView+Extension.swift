//
//  UICollectionView+Extension.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 3/13/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

extension UICollectionView {
    func set(delegateAndDataSource: UICollectionViewDataSource & UICollectionViewDelegate) {
        delegate = delegateAndDataSource
        dataSource = delegateAndDataSource
    }
    
    func registerNibCellFor<T: UICollectionViewCell>(type: T.Type) {
        let nibName = type.name
        register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: type.name)
    }
    
    func registerClassCellFor<T: UICollectionViewCell>(type: T.Type) {
        let nibName = type.name
        register(type, forCellWithReuseIdentifier: nibName)
    }
    
    func registerNibSupplementaryViewFor<T: UIView>(type: T.Type, ofKind kind: XibCollectionSupplementaryKind) {
        let nibName = type.name
        register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: kind.kind, withReuseIdentifier: nibName)
    }
    
    func registerClassSupplementaryViewFor<T: UIView>(type: T.Type, ofKind kind: XibCollectionSupplementaryKind) {
        let nibName = type.name
        register(type, forSupplementaryViewOfKind: kind.kind, withReuseIdentifier: nibName)
    }
    
    // MARK: - Get component functions
    func reusableCell<T: UICollectionViewCell>(type: T.Type, indexPath: IndexPath) -> T? {
        let nibName = type.name
        return self.dequeueReusableCell(withReuseIdentifier: nibName, for: indexPath) as? T
    }
    
    func cell<T: UICollectionViewCell>(type: T.Type, section: Int, item: Int) -> T? {
        guard let indexPath = validIndexPath(section: section, item: item) else { return nil }
        return self.cellForItem(at: indexPath) as? T
    }
    
    func reusableSupplementaryViewFor<T: UIView>(type: T.Type, ofKind kind: XibCollectionSupplementaryKind, indexPath: IndexPath) -> T? {
        let nibName = type.name
        return self.dequeueReusableSupplementaryView(ofKind: kind.kind, withReuseIdentifier: nibName, for: indexPath) as? T
    }
    
    // MARK: - UI functions
    func scrollToTop(animated: Bool = true) {
        setContentOffset(.zero, animated: animated)
    }
    
//    func scrollToBottom(animated: Bool = true) {
//        guard numberOfSections > 0 else { return }
//        let lastRowNumber = numberOfItems(inSection: numberOfSections - 1)
//        guard lastRowNumber > 0 else { return }
//        let indexPath = IndexPath(item: lastRowNumber - 1, section: numberOfSections - 1)
//        scrollToItem(at: indexPath, at: .top, animated: animated)
//    }
    
    func reloadCellAt(section: Int = 0, item: Int) {
        if let indexPath = validIndexPath(section: section, item: item) {
            reloadItems(at: [indexPath])
        }
    }
    
    func reloadSectionAt(index: Int) {
        reloadSections(IndexSet(integer: index))
    }
    
    func change(bottomInset value: CGFloat) {
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
    }
    
    // MARK: - Supporting functions
    func validIndexPath(section: Int, item: Int) -> IndexPath? {
        guard section >= 0 && item >= 0 else { return nil }
        let itemCount = numberOfItems(inSection: section)
        guard itemCount > 0 && item < itemCount else { return nil }
        return IndexPath(item: item, section: section)
    }
}

