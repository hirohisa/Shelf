//
//  View.swift
//  Shelf
//
//  Created by Hirohisa Kawasaki on 3/14/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public protocol ViewDelegate {
    func shelfView(shelfView: Shelf.View, didSelectItemAtIndexPath indexPath: NSIndexPath)
}

public protocol ViewDataSource {
    func numberOfSectionsInShelfView(shelfView: Shelf.View) -> Int
    func shelfView(shelfView: Shelf.View, numberOfItemsInSection section: Int) -> Int

    func shelfView(shelfView: Shelf.View, configureItemCell cell: ItemCell, indexPath: NSIndexPath)
    func shelfView(shelfView: Shelf.View, titleForHeaderInSection section: Int) -> String
}

public class View: UIView {

    public var delegate: ViewDelegate?
    public var dataSource: ViewDataSource? {
        didSet {
            reloadData()
        }
    }

    class DataController: NSObject {
        weak var view: View?
    }
    let dataController = DataController()

    let tableView: TableView
    required override public init(frame: CGRect) {
        tableView = TableView(frame: frame, style: .Plain)
        super.init(frame: frame)
        configure()
    }

    required public convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
}

// MARK: Public methods

extension View {

    // Data

    public func reloadData() {
        tableView.reloadData()
    }

}

extension View {

    func configure() {
        addSubview(tableView)

        dataController.view = self
        //tableView.delegate = dataController
        tableView.dataSource = dataController
    }

    func indexPathsInSections(sections: [Int]) -> [NSIndexPath] {

        var indexPaths = [NSIndexPath]()
        for section in sections {

            var indexPath: NSIndexPath?
            indexPath = NSIndexPath(forRow: 0, inSection: section)

            if let indexPath = indexPath {
                indexPaths.append(indexPath)
            }
        }

        return indexPaths
    }
}

class TableView: UITableView {

    required override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        configure()
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero, style: .Plain)
        configure()
    }

    func configure() {
        allowsSelection = false
        estimatedRowHeight = 200
        rowHeight = UITableViewAutomaticDimension

        let bundle = NSBundle(forClass: SectionCell.self)
        registerNib(UINib(nibName: "SectionCell", bundle: bundle), forCellReuseIdentifier: "SectionCell")
    }
}


class Button: UIButton {
    var indexPath: NSIndexPath?
}