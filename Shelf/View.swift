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
    func headerViewsInShelfView(shelfView: Shelf.View) -> [UIView]
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

    let tableView = UITableView()
    let headerView: HeaderView = {
        return UINib(nibName: "HeaderView", bundle: NSBundle(forClass: View.self)).instantiateWithOwner(nil, options: nil)[0] as! HeaderView
    }()

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public func reloadData() {
        tableView.reloadData()
    }

    public override var frame: CGRect {
        didSet {
            tableView.frame = bounds
        }
    }
}

extension View {

    func configure() {
        let bundle = NSBundle(forClass: View.self)

        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "SectionCell", bundle: bundle), forCellReuseIdentifier: "SectionCell")
        addSubview(tableView)

        dataController.view = self
        tableView.delegate = self
        tableView.dataSource = dataController

        tableView.addSubview(headerView)
        tableView.tableHeaderView = UIView(frame: headerView.frame)
    }
}

extension View: UITableViewDelegate {

    public func scrollViewDidScroll(scrollView: UIScrollView) {

        var origin = CGPointZero
        if scrollView.contentOffset.y + scrollView.contentInset.top < 0 {
            let diff = scrollView.contentOffset.y + scrollView.contentInset.top
            origin = CGPoint(x: 0, y: diff)
        }
        var frame = headerView.frame
        frame.origin = origin
        headerView.frame = frame
    }
}