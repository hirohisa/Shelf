//
//  View+DataController.swift
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

extension View.DataController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let section = indexPath.section
        if let dataSource = view?.dataSource {
            switch view!.headerPosition {
            case .Embedding:
                switch indexPath.row {
                case 0:
                    return dataSource.shelfView(view!, heightForHeaderInSection: section)
                default:
                    break
                }
            default:
                break
            }
        }
        return _tableView(tableView, heightForRowAtIndexPath: indexPath)
    }

    func _tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        if let dataSource = view?.dataSource {
            switch dataSource.shelfView(view!, contentModeForSection: section) {
            case .Horizontal:
                return _horizontal(tableView: tableView, section: section)
            case .Vertical:
                return _vertical(tableView: tableView, section: section)
            default:
                break
            }
        }
        return 60
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

        var length: Int = 0
        var x: CGFloat = 0
        for index in 0..<dataSource.shelfView(shelfView, numberOfItemsInSection: section) {
            let indexPath = NSIndexPath(forItem: index, inSection: section)
            let width = dataSource.shelfView(view!, widthFotItemAtIndexPath: indexPath)

            // TODO: Rewrite tableView to shelfView
            if shelfView.frame.width < x + width {
                x = 0
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
            var x: CGFloat = 0
            for index in 0..<dataSource.shelfView(shelfView, numberOfItemsInSection: section) {
                let indexPath = NSIndexPath(forItem: index, inSection: section)
                let cell = createCell(fromDataSource: dataSource, indexPath: indexPath)
                let width = dataSource.shelfView(shelfView, widthFotItemAtIndexPath: indexPath)
                let height = dataSource.shelfView(shelfView, heightFotItemInSection: section)
                cell.frame = CGRect(x: x, y: 0, width: width, height: height)
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
            var x: CGFloat = 0
            var length: Int = 0
            for index in 0..<dataSource.shelfView(shelfView, numberOfItemsInSection: section) {
                let indexPath = NSIndexPath(forItem: index, inSection: section)
                let cell = createCell(fromDataSource: dataSource, indexPath: indexPath)
                let width = dataSource.shelfView(shelfView, widthFotItemAtIndexPath: indexPath)
                let height = dataSource.shelfView(shelfView, heightFotItemInSection: section)

                if shelfView.frame.width < x + width {
                    x = 0
                    length += 1
                }

                let y = height * CGFloat(length)

                cell.frame = CGRect(x: x, y: y, width: width, height: height)

                cells.append(cell)
                x = cell.frame.maxX
            }
        }

        return cells
    }

}

extension View.DataController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let dataSource = view?.dataSource {
            return dataSource.numberOfSectionsInShelfView(view!)
        }

        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var rows = 0

        // Header
        switch view!.headerPosition {
        case .Floating:
            break
        case .Embedding:
            rows += 1
        }

        // Contents
        if let view = view {
            let numbers = view.dataSource?.shelfView(view, numberOfItemsInSection: section)
            if numbers > 0 {
                rows += 1
            }
        }

        return rows
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let dataSource = view?.dataSource {
            switch view!.headerPosition {
            case .Floating:
                return dataSource.shelfView(view!, heightForHeaderInSection: section)
            default:
                break
            }
        }

        return 0
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let dataSource = view?.dataSource {
            switch view!.headerPosition {
            case .Floating:
                return dataSource.shelfView(view!, viewForHeaderInSection: section)
            default:
                break
            }
        }

        return nil
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch view!.headerPosition {
        case .Floating:
            return _tableView(tableView, cellForRowAtIndexPath: indexPath)
        case .Embedding:
            switch indexPath.row {
            case 0:
                return _embedding(tableView, cellForRowAtIndexPath: indexPath)
            default:
                return _tableView(tableView, cellForRowAtIndexPath: indexPath)
            }
        }
    }

    // TODO: Refactor
    func _embedding(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)

        let header = view!.dataSource!.shelfView(view!, viewForHeaderInSection: indexPath.section)
        if let header = header {
            cell.contentView.addSubview(header)
        }

        return cell
    }

    func _tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let view = tableView.dequeueReusableCellWithIdentifier(SectionReuseIdentifier, forIndexPath: indexPath) as SectionView

        for cell in view.scrollView.subviews {
            cell.removeFromSuperview()
        }

        // TODO: create only visible cells
        let cells = createCells(indexPath.section)

        for cell in cells {
            view.scrollView.addSubview(cell)
        }

        let width = cells.last?.frame.maxX ?? view.frame.width
        let contentSize = CGSize(width: width, height: view.frame.height - 1) // TODO: scrolling will be disabled by using delegate
        view.scrollView.contentSize = contentSize

        return view
    }
}