//
//  NoteCollectionViewLayout.swift
//  FilaFacilTV
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 22/05/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

protocol NoteCollectionViewLayoutDelegate: NSObjectProtocol {
    
    func getAllTexts() -> [String]
    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}

class NoteCollectionViewLayout: UICollectionViewLayout {
    
    open weak var delegate: NoteCollectionViewLayoutDelegate?
    
    // Configurable properties
    var numberOfColumns = 2
    var cellPadding: CGFloat = 10

    //3. Array to keep a cache of attributes.
    fileprivate var cache = [UICollectionViewLayoutAttributes]()

    //4. Content height and size
    fileprivate var contentHeight: CGFloat = 0

    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        super.prepare()
        // 1. Only calculate once
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        var texts = [String]()
        if let delegate = self.delegate {
            texts = delegate.getAllTexts()
        }
        
        // 3. Iterates through the list of items in the first section
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {

            let indexPath = IndexPath(item: item, section: 0)
            
            var expectedHeight: CGFloat = 96
            
            for fontFamily in UIFont.familyNames {
                for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
                    print(fontName)
                }
            }
            
            expectedHeight += texts[indexPath.row].height(withConstrainedWidth: columnWidth - 44, font: UIFont(name: "SFProDisplay-Regular", size: 27)!)
            
//            expectedHeight += CGFloat(Int32.init(CGFloat(texts[indexPath.row].count)) / 17 + 1) * 29
            
            // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: expectedHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            // 6. Updates the collection view content height
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + expectedHeight

            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
}
