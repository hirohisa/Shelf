//
//  ViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 3/14/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Shelf

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = view.bounds

        let shelfView = Shelf.View(frame: frame)
        shelfView.dataSource = self
        shelfView.delegate = self
        shelfView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        view.addSubview(shelfView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: Shelf.ViewDelegate {

    func shelfView(shelfView: View, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("select indexPath section:\(indexPath.section), item:\(indexPath.row)")
    }
}

extension ViewController: Shelf.ViewDataSource {

    func numberOfSectionsInShelfView(shelfView: Shelf.View) -> Int {
        return 2
    }

    func shelfView(shelfView: Shelf.View, heightFotItemInSection section: Int) -> CGFloat {
        return 100
    }

    func shelfView(shelfView: Shelf.View, widthFotItemAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row%2 {
        case 0:
            return 100
        default:
            return 80
        }
    }

    func shelfView(shelfView: Shelf.View, stretchForSection section: Int) -> SectionStretch {
        return .Vertical
    }

    func shelfView(shelfView: Shelf.View, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func shelfView(shelfView: Shelf.View, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = shelfView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell

        switch indexPath.row%2 {
        case 0:
            cell.backgroundColor = UIColor.blackColor()
        default:
            cell.backgroundColor = UIColor.grayColor()
        }

        return cell
    }

    func shelfView(shelfView: Shelf.View, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func shelfView(shelfView: Shelf.View, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

}

