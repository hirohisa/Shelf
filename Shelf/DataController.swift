//
//  DataController.swift
//  Shelf
//
//  Created by Hirohisa Kawasaki on 4/5/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

extension View.DataController {

    func createCell(fromDataSource dataSource: ViewDataSource, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = dataSource.shelfView(view!, cellForItemAtIndexPath: indexPath)

        let button = createButtonOrFindInView(cell.contentView)
        button.indexPath = indexPath

        return cell
    }

    func createButtonOrFindInView(view: UIView) -> Button {
        for subview in view.subviews {
            if let subview = subview as? Button {
                return subview
            }
        }

        let button = Button(frame: view.bounds)
        button.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        button.addTarget(self, action: "didSelectCell:", forControlEvents: .TouchUpInside)
        view.addSubview(button)
        view.sendSubviewToBack(button)
        return button
    }

    func createCells(section: Int) -> [UICollectionViewCell] {

        if let dataSource = view?.dataSource {
            switch dataSource.shelfView(view!, contentModeForSection: section) {
            case .Horizontal:
                return createCells(_horizontal : section)
            case .Vertical:
                return createCells(_vertical : section)
            default:
                break
            }
        }

        return []
    }

    func didSelectCell(sender: Button) {
        let cell = sender.superview?.superview

        if let cell = cell as? UICollectionViewCell {
            cell.selected = !cell.selected
        }
        view?.delegate?.shelfView(view!, didSelectItemAtIndexPath: sender.indexPath!)
    }
}

extension View.DataController {

    // TODO: rename all methods

    func _horizontal(#tableView: UITableView, section: Int) -> CGFloat {
        return view!.dataSource!.shelfView(view!, heightFotItemInSection: section)
    }

    func _vertical(#tableView: UITableView, section: Int) -> CGFloat {
        let shelfView = view!
        let dataSource = shelfView.dataSource!

        var x = shelfView.contentInset.left
        var y = shelfView.contentInset.top
        var length = 0
        for index in 0 ..< dataSource.shelfView(shelfView, numberOfItemsInSection: section) {
            let indexPath = NSIndexPath(forItem: index, inSection: section)
            let width = dataSource.shelfView(view!, widthFotItemAtIndexPath: indexPath)

            // TODO: Rewrite tableView to shelfView
            if shelfView.frame.width < x + width {
                x = shelfView.contentInset.left
                length += 1
            }
            x += width
        }

        let height = dataSource.shelfView(view!, heightFotItemInSection: section)

        return height * CGFloat(length + 1)
    }


    func createCells(_horizontal section: Int) -> [UICollectionViewCell] {

        var cells = [UICollectionViewCell]()
        if let dataSource = view?.dataSource {
            let shelfView = view!
            var x = shelfView.contentInset.left
            var y = shelfView.contentInset.top
            for index in 0 ..< dataSource.shelfView(shelfView, numberOfItemsInSection: section) {
                let indexPath = NSIndexPath(forItem: index, inSection: section)
                let cell = createCell(fromDataSource: dataSource, indexPath: indexPath)
                let width = dataSource.shelfView(shelfView, widthFotItemAtIndexPath: indexPath)
                let height = dataSource.shelfView(shelfView, heightFotItemInSection: section)
                cell.frame = CGRect(x: x, y: y, width: width, height: height)
                x = cell.frame.maxX

                cells.append(cell)
            }
        }

        return cells
    }

    func createCells(_vertical section: Int) -> [UICollectionViewCell] {

        var cells = [UICollectionViewCell]()
        if let dataSource = view?.dataSource {
            let shelfView = view!
            var x = shelfView.contentInset.left
            var length = 0
            for index in 0 ..< dataSource.shelfView(shelfView, numberOfItemsInSection: section) {
                let indexPath = NSIndexPath(forItem: index, inSection: section)
                let cell = createCell(fromDataSource: dataSource, indexPath: indexPath)
                let width = dataSource.shelfView(shelfView, widthFotItemAtIndexPath: indexPath)
                let height = dataSource.shelfView(shelfView, heightFotItemInSection: section)

                if shelfView.frame.width < x + width {
                    x = shelfView.contentInset.left
                    length += 1
                }

                let y = height * CGFloat(length) + shelfView.contentInset.top

                cell.frame = CGRect(x: x, y: y, width: width, height: height)

                cells.append(cell)
                x = cell.frame.maxX
            }
        }

        return cells
    }

}