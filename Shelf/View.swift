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

    func shelfView(shelfView: Shelf.View, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell

    func shelfView(shelfView: Shelf.View, heightFotItemInSection section: Int) -> CGFloat
    func shelfView(shelfView: Shelf.View, widthFotItemAtIndexPath indexPath: NSIndexPath) -> CGFloat
    func shelfView(shelfView: Shelf.View, contentModeForSection section: Int) -> ContentMode

    func shelfView(shelfView: Shelf.View, heightForHeaderInSection section: Int) -> CGFloat
    func shelfView(shelfView: Shelf.View, viewForHeaderInSection section: Int) -> UIView?
}

public enum ContentMode {
    case Horizontal
    case Vertical
}

public enum SectionHeaderPosition {
    case Floating
    case Embedding
}

public class View: UIView {

    public var headerPosition: SectionHeaderPosition = .Floating {
        didSet {
            reloadData()
        }
    }
    public var contentInset = UIEdgeInsetsZero // add spacing area around content

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

    private var reuseClasses = [String: AnyClass]()
    private var reuseNibs = [String: UINib]()
    private var reuseCells = [String: [UICollectionReusableView]]()
}

// MARK: Public methods

extension View {

    // Data

    public func reloadData() {
        tableView.reloadData()
    }

    // Row insertion/deletion/reloading.

    public func beginUpdates() {
        tableView.beginUpdates()
    }

    public func endUpdates() {
        tableView.endUpdates()
    }

    public func insertContentsInSections(sections: [Int], withRowAnimation animation: UITableViewRowAnimation) {
        tableView.insertRowsAtIndexPaths(indexPathsInSections(sections), withRowAnimation: animation)
    }

    public func deleteContentsInSections(sections: [Int], withRowAnimation animation: UITableViewRowAnimation) {
        tableView.deleteRowsAtIndexPaths(indexPathsInSections(sections), withRowAnimation: animation)
    }

    public func reloadContentsInSections(sections: [Int], withRowAnimation animation: UITableViewRowAnimation) {
        tableView.reloadRowsAtIndexPaths(indexPathsInSections(sections), withRowAnimation: animation)
    }

    // Appearance

    public func dequeueReusableCellWithReuseIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> AnyObject {
        if let result = reuseCells[identifier]?.first {
            return result
        }

        if let result: AnyClass = reuseClasses[identifier] {
            let cellClass = result as! UICollectionViewCell.Type
            let cell = cellClass()
            return cell
        }

        fatalError("unable to dequeue a cell with identifier Cell - must register a nib or a class")
    }

    public func registerClass(cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        if let cellClass: AnyClass = cellClass {
            reuseClasses[identifier] = cellClass
        }
    }

    public func registerNib(nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        if let nib = nib {
            reuseNibs[identifier] = nib
        }
    }
}

extension View {

    func configure() {
        addSubview(tableView)

        dataController.view = self
        tableView.delegate = dataController
        tableView.dataSource = dataController
    }

    func indexPathsInSections(sections: [Int]) -> [NSIndexPath] {

        var indexPaths = [NSIndexPath]()
        for section in sections {

            var indexPath: NSIndexPath?
            switch headerPosition {
            case .Floating:
                indexPath = NSIndexPath(forRow: 0, inSection: section)
            case .Embedding:
                indexPath = NSIndexPath(forRow: 1, inSection: section)
            }

            if let indexPath = indexPath {
                indexPaths.append(indexPath)
            }
        }

        return indexPaths
    }
}

let SectionReuseIdentifier = "section"

class SectionView: UITableViewCell {

    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRectZero)
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        scrollView.frame = contentView.bounds
        scrollView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        contentView.addSubview(scrollView)
    }

}

class TableView: UITableView {

    required override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        configure()
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero, style: .Plain)
    }

    func configure() {
        autoresizingMask = .FlexibleWidth | .FlexibleHeight
        allowsSelection = false
        separatorStyle = .None
        registerClass(SectionView.self, forCellReuseIdentifier: SectionReuseIdentifier)
    }
}


class Button: UIButton {
    var indexPath: NSIndexPath?
}