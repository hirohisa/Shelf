//
//  MenuViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 4/6/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "ViewController Floating"
        case 1:
            cell.textLabel?.text = "ViewController Embedding"
        case 2:
            cell.textLabel?.text = "ShelfViewController"
        default:
            break
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        switch indexPath.row {
        case 0:
            let viewController = ViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case 1:
            let viewController = ViewController()
            viewController.headerPosition = .Embedding
            navigationController?.pushViewController(viewController, animated: true)
        case 2:
            let viewController = ShelfViewController()
            navigationController?.pushViewController(viewController, animated: true)
            break
        default:
            break
        }
    }

}
