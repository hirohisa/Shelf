//
//  ViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 3/14/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Shelf

class CollectionViewCell: UICollectionViewCell {

    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        label.frame = bounds
        contentView.addSubview(label)
    }
}

class ViewController: UIViewController {

    var shelfView: Shelf.View?

    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = view.bounds

        let shelfView = Shelf.View(frame: frame)
        shelfView.dataSource = self
        shelfView.delegate = self
        shelfView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(shelfView)

        self.shelfView = shelfView
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
        return 5
    }

    func shelfView(shelfView: Shelf.View, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func shelfView(shelfView: Shelf.View, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        label.text = "section: \(section)"
        label.sizeToFit()
        return label
    }

}

