//
//  UICollectionViewCell+Extension.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 3/13/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

// MARK: - UICollectionView
protocol XibCollectionViewCell {
    static var name: String { get }
    static func registerTo(collectionView: UICollectionView)
    static func dequeue(collectionView: UICollectionView, at indexPath: IndexPath) -> Self?
}

extension XibCollectionViewCell where Self: UICollectionViewCell {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func registerTo(collectionView: UICollectionView) {
        collectionView.register(Self.self, forCellWithReuseIdentifier: name)
    }
    
    static func dequeue(collectionView: UICollectionView, at indexPath: IndexPath) -> Self? {
        return collectionView.dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? Self
    }
}

extension UICollectionViewCell: XibCollectionViewCell { }

// MARK: - UICollectionReusableView (Header & Footer)
enum XibCollectionSupplementaryKind {
    case header, footer
    
    var kind: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}

protocol XibCollectionSupplementary {
    static var name: String { get }
    static func registerTo(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind)
    static func dequeue(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind, at indexPath: IndexPath) -> Self?
}

extension XibCollectionSupplementary where Self: UICollectionReusableView {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func registerTo(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind) {
        collectionView.register(Self.self, forSupplementaryViewOfKind: kind.kind, withReuseIdentifier: name)
    }
    
    static func dequeue(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind, at indexPath: IndexPath) -> Self? {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind.kind, withReuseIdentifier: name, for: indexPath) as? Self
    }
}

extension UICollectionReusableView: XibCollectionSupplementary { }

