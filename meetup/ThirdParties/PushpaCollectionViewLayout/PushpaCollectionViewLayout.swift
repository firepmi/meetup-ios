//
//  PushpaCollectionViewLayout.swift
//  PushpaCollectionViewLayout
//
//  Created by Canopas on 19/10/18.
//  Copyright © 2018 Canopas Inc. All rights reserved.
//

import UIKit

class PushpaCollectionViewLayout: UICollectionViewLayout {
    public var itemSize: CGSize = CGSize(width: 280, height: 300) { didSet{ invalidateLayout() } }
    public var maximumVisibleItems: Int = 4 { didSet{ invalidateLayout() } }
    public var spacing:CGFloat = 10 { didSet { invalidateLayout() } }
    public var leftSpace:CGFloat = 12 { didSet { invalidateLayout() } }
    
    override open var collectionView: UICollectionView {
        return super.collectionView!
    }
    
    override open var collectionViewContentSize: CGSize {
        let itemsCount = CGFloat(collectionView.numberOfItems(inSection: 0))
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height * itemsCount)
    }
    
    override open func prepare() {
        super.prepare()
        assert(collectionView.numberOfSections == 1, "Multiple sections aren't supported!")
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    fileprivate var contentOffset: CGPoint   { return collectionView.contentOffset }
    fileprivate var bounds: CGRect           { return collectionView.bounds }
    fileprivate var totalCount: Int          { return collectionView.numberOfItems(inSection: 0) }
    fileprivate var minIndex: Int            { return max(Int(contentOffset.y) / Int(bounds.height), 0) }
    fileprivate var maxIndex: Int            { return min(minIndex + maximumVisibleItems, totalCount) }
    fileprivate var deltaOffset: CGFloat     { return CGFloat(Int(collectionView.contentOffset.y) % Int(collectionView.bounds.height)) }
    fileprivate var percentDelta: CGFloat    { return CGFloat(deltaOffset) / bounds.height }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes:[UICollectionViewLayoutAttributes] = stride(from: minIndex, to: maxIndex, by: 1).map({ index in
            let path = IndexPath.init(item: index, section: 0)
            return self.getAttribute(for: path)
        })
        
        if minIndex > 0 {
            let previsItemAttr = IndexPath(item: minIndex - 1, section: 0)
            attributes.append(self.getAttribute(for: previsItemAttr))
        }
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return getAttribute(for: indexPath)
    }
    
    fileprivate func getAttribute(for indexPath:IndexPath) -> UICollectionViewLayoutAttributes {
        let firstVisibleIndex = indexPath.row - minIndex
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attr.center.x = bounds.midX
        attr.center.y = self.contentOffset.y + bounds.height / 2 + spacing * CGFloat(firstVisibleIndex)
        attr.size = itemSize
        attr.zIndex = maximumVisibleItems - firstVisibleIndex
        
        switch firstVisibleIndex {
        case -1:
            attr.center.y -= deltaOffset + bounds.height/2 + itemSize.height/2 //- leftSpace - spacing
            
            UIView.animate(withDuration: 1) {
                self.collectionView.layoutSubviews()
            }
        case 0:
            attr.center.y -= ensureRange(value: deltaOffset,
                                         minimum: -bounds.height,
                                         maximum: bounds.height/2 + itemSize.height/2) //- leftSpace)
            UIView.animate(withDuration: 1) {
                self.collectionView.layoutSubviews()
            }
        case 1:
            attr.center.y -= spacing * percentDelta
            
            let scale: CGFloat = 0.95
            var t = CGAffineTransform.identity
            t = t.scaledBy(x: scale, y: 1)
            attr.alpha = 0.97
            
            
            UIView.animate(withDuration: 1) {
                attr.transform = t
                self.collectionView.layoutSubviews()
            }
            
            if firstVisibleIndex == maximumVisibleItems - 1 {
                attr.alpha = percentDelta
            }
            
            break
        case 2..<maximumVisibleItems:
            attr.center.y -= spacing * percentDelta
    
            let scale: CGFloat = 0.9
            var t = CGAffineTransform.identity
            t = t.scaledBy(x: scale, y: 1)
            attr.alpha = 0.9
            
            
            UIView.animate(withDuration: 1) {
                attr.transform = t
                self.collectionView.layoutSubviews()
            }
            
            if firstVisibleIndex == maximumVisibleItems - 1 {
                attr.alpha = percentDelta
            }
            
            break
        default:
            attr.alpha = 0
            break
        }
        
        return attr
    }
}

//MARK: Helper
fileprivate func ensureRange<T>(value: T, minimum: T, maximum: T) -> T where T : Comparable {
    return min(max(value, minimum), maximum)
}
