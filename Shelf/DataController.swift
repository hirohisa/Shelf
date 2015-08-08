//
//  DataController.swift
//  Shelf
//
//  Created by Hirohisa Kawasaki on 4/5/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

extension View.DataController {

    func createCell(fromDataSource dataSource: ViewDataSource, indexPath: NSIndexPath) -> ItemCell {
        let bundle = NSBundle(forClass: ItemCell.self)
        let cell = UINib(nibName: "ItemCell", bundle: bundle).instantiateWithOwner(nil, options: nil).last! as! ItemCell

        dataSource.shelfView(view!, configureItemCell: cell, indexPath: indexPath)

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

    func createCells(section: Int) -> [ItemCell] {

        var cells = [ItemCell]()
        if let shelfView = view, let dataSource = shelfView.dataSource {

            let width: CGFloat = 100
            let height: CGFloat = 150
            var x: CGFloat = 0
            var y: CGFloat = 0
            for index in 0 ..< dataSource.shelfView(shelfView, numberOfItemsInSection: section) {
                let indexPath = NSIndexPath(forItem: index, inSection: section)
                let cell = createCell(fromDataSource: dataSource, indexPath: indexPath)
                cell.frame = CGRect(x: x, y: y, width: width, height: height)
                x = cell.frame.maxX + 15

                cells.append(cell)
            }
        }

        return cells
    }

    func didSelectCell(sender: Button) {
        let cell = sender.superview?.superview

        if let cell = cell as? UICollectionViewCell {
            cell.selected = !cell.selected
        }
        view?.delegate?.shelfView(view!, didSelectItemAtIndexPath: sender.indexPath!)
    }
}

extension View.DataController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let view = view, let dataSource = view.dataSource {
            return dataSource.numberOfSectionsInShelfView(view)
        }

        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("SectionCell", forIndexPath: indexPath) as! SectionCell
        if let view = view, let dataSource = view.dataSource {
            cell.titleLabel.text = dataSource.shelfView(view, titleForHeaderInSection: indexPath.row)
        }

        cell.configure(createCells(indexPath.row))

        return cell
    }

}