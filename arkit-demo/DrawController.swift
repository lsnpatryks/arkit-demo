//
//  ViewController.swift
//  arkit-demo
//
//  Created by Patryk Spanily on 18.03.2018.
//  Copyright © 2018 Patryk Spanily. All rights reserved.
//

import UIKit
import ARKit

class DrawController: UIViewController, ARSCNViewDelegate {

    var sceneView = ARSCNView()
    var leftButton = UIButton()
    var drawButton = UIButton()
    var resetButton = UIButton()

    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()

        // scene view
        view.addSubview(sceneView)
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(configuration, options: [])
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.delegate = self

        NSLayoutConstraint.activate(
            [NSLayoutAttribute.top, NSLayoutAttribute.bottom, NSLayoutAttribute.right, NSLayoutAttribute.left].map {
                NSLayoutConstraint(item: sceneView, attribute: $0, relatedBy: .equal, toItem: view, attribute: $0, multiplier: 1, constant: 0)
            }
        )

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
            NSLayoutConstraint(item: leftButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70),
            ])

        // right button
        view.addSubview(drawButton)
        drawButton.setTitle("draw", for: .normal)
        drawButton.setTitleColor(.black, for: .normal)
        drawButton.backgroundColor = UIColor.white
        drawButton.addTarget(self, action: #selector(drawButtonPressed), for: .touchUpInside)
        drawButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: drawButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: drawButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: drawButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70),
            NSLayoutConstraint(item: drawButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70),
            ])

        // reset button
        view.addSubview(resetButton)
        resetButton.setTitle("reset", for: .normal)
        resetButton.setTitleColor(.black, for: .normal)
        resetButton.backgroundColor = UIColor.white
        resetButton.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: resetButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: resetButton, attribute: .bottom, relatedBy: .equal, toItem: drawButton, attribute: .top, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: resetButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70),
            NSLayoutConstraint(item: resetButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70),
            ])
    }

    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else {
            return
        }
        DispatchQueue.main.async {
            if self.drawButton.isHighlighted {
                let transform = pointOfView.transform
                let position = SCNVector3(-transform.m31 + transform.m41, -transform.m32 + transform.m42, -transform.m33 + transform.m43)
                self.drawSphere(position: position)
            }
        }
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

    @objc func drawButtonPressed() {

    }

    @objc func resetButtonPressed() {
        sceneView.scene.rootNode.enumerateHierarchy({ (node, _) in node.removeFromParentNode() })
    }

    private func drawSphere(position: SCNVector3) {
        let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
        sphereNode.position = position
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        sceneView.scene.rootNode.addChildNode(sphereNode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

