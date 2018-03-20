//
//  TableViewController.swift
//  arkit-demo
//
//  Created by Patryk Spanily on 19.03.2018.
//  Copyright © 2018 Patryk Spanily. All rights reserved.
//

import UIKit

enum AppControllerType: String {
    case drawing = "rysowanie"
    case planes = "płaszczyzny"
    case hitTest = "hit test"
}

class TableViewController: UITableViewController {

    let cellReuseableIdentifier = "cell"
    let options: [AppControllerType] = [.drawing, .planes, .hitTest]

    override func viewDidLoad() {
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseableIdentifier)
        self.title = "ARKit demo"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Powrót", style: .plain, target: nil, action: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
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
        case .planes:
            self.navigationController?.pushViewController(PlanesController(), animated: true)
        case .hitTest:
            self.navigationController?.pushViewController(HitTestController(), animated: true)
        }

    }
}
