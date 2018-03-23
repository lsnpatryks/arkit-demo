//
//  GenericController.swift
//  arkit-demo
//
//  Created by Patryk Spanily on 19.03.2018.
//  Copyright © 2018 Patryk Spanily. All rights reserved.
//

import Foundation
import ARKit

class GenericController: UIViewController, ARSCNViewDelegate {

    var sceneView = ARSCNView()
    var leftButton = UIButton()
    var buttons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = []
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.delegate = self
    }

    func addScene(configuration: ARWorldTrackingConfiguration) {
        // scene view
        view.addSubview(sceneView)
        sceneView.session.run(configuration, options: [])

        NSLayoutConstraint.activate(
            [NSLayoutAttribute.top, NSLayoutAttribute.bottom, NSLayoutAttribute.right, NSLayoutAttribute.left].map {
                NSLayoutConstraint(item: sceneView, attribute: $0, relatedBy: .equal, toItem: view, attribute: $0, multiplier: 1, constant: 0)
            }
        )
    }

    func addLeftButtton() {
        // left button
        view.addSubview(leftButton)
        leftButton.setTitle("debug", for: .normal)
        leftButton.setTitleColor(.black, for: .normal)
        leftButton.backgroundColor = UIColor.white
        leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
        leftButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: leftButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: leftButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: leftButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70),
            NSLayoutConstraint(item: leftButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40),
            ])
    }

    func addRightButton(name: String, action: Selector?) -> UIButton {
        let button = UIButton()
        
        view.addSubview(button)
        button.setTitle(name, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        if let selector = action {
            button.addTarget(self, action: selector, for: .touchUpInside)
        }

        if(buttons.count > 0){
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -20),
                NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: buttons.last, attribute: .top, multiplier: 1, constant: -20),
                NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70),
                NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40),
                ])
        } else {
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -20),
                NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20),
                NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70),
                NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40),
                ])
        }
        
        buttons.append(button)
        
        return button;
    }

    @objc func leftButtonPressed() {
        if sceneView.debugOptions.contains(ARSCNDebugOptions.showWorldOrigin) {
            sceneView.debugOptions = []
            sceneView.showsStatistics = false
        } else {
            sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
            sceneView.showsStatistics = true
        }
    }

}
