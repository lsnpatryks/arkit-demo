//
//  TableViewController.swift
//  arkit-demo
//
//  Created by Patryk Spanily on 19.03.2018.
//  Copyright © 2018 Patryk Spanily. All rights reserved.
//

import UIKit

enum AppControllerType: String {
    case drawing = "drawing"
}

class TableViewController: UITableViewController {

    let cellReuseableIdentifier = "cell"
    let options: [AppControllerType] = [.drawing]
    
    override func viewDidLoad() {
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseableIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseableIdentifier, for: indexPath)

        cell.textLabel?.text = options[indexPath.row].rawValue
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(options[indexPath.row]) {
        case .drawing:
            self.navigationController?.pushViewController(DrawController(), animated: true)
        }
    }
}