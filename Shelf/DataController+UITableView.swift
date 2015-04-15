//
//  DataController+Logic.swift
//  Shelf
//
//  Created by Hirohisa Kawasaki on 4/16/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

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
        let height = _tableView(tableView, heightForRowAtIndexPath: indexPath)
        return view!.contentInset.top + height + view!.contentInset.bottom
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
        let sectionView = tableView.dequeueReusableCellWithIdentifier(SectionReuseIdentifier, forIndexPath: indexPath) as! SectionView

        for cell in sectionView.scrollView.subviews {
            cell.removeFromSuperview()
        }

        // TODO: create only visible cells
        let cells = createCells(indexPath.section)

        for cell in cells {
            sectionView.scrollView.addSubview(cell)
        }

        var width = cells.last?.frame.maxX ?? sectionView.frame.width
        width += view!.contentInset.right
        let contentSize = CGSize(width: width, height: sectionView.frame.height - 1) // TODO: scrolling will be disabled by using delegate
        sectionView.scrollView.contentSize = contentSize

        return sectionView
    }
}