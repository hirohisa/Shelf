//
//  DataController.swift
//  Shelf
//
//  Created by Hirohisa Kawasaki on 4/5/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

extension View.DataController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let view = view, let dataSource = view.dataSource {
            return dataSource.shelfView(view, numberOfItemsInSection: collectionView.tag)
        }
        return 1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell

        if let view = view, let dataSource = view.dataSource {
            let indexPath = NSIndexPath(forItem: indexPath.item, inSection: collectionView.tag)
            dataSource.shelfView(view, configureItemCell: cell, indexPath: indexPath)
        }

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if let view = view, let delegate = view.delegate {
            let indexPath = NSIndexPath(forItem: indexPath.item, inSection: collectionView.tag)
            delegate.shelfView(view, didSelectItemAtIndexPath: indexPath)
        }
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
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.tag = indexPath.row // TODO: replace tag to other variable

        return cell
    }

}