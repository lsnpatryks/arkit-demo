//
//  ViewController.swift
//  arkit-demo
//
//  Created by Patryk Spanily on 18.03.2018.
//  Copyright © 2018 Patryk Spanily. All rights reserved.
//

import UIKit
import ARKit

class DrawController: GenericController {

    var drawButton: UIButton?
    var resetButton: UIButton?

    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.autoenablesDefaultLighting = false
        addScene(configuration: configuration)
        addLeftButtton()

        self.drawButton = self.addRightButton(name: "rysuj", action: nil)
        self.resetButton = self.addRightButton(name: "reset", action: #selector(resetButtonPressed))
    }

    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else {
            return
        }
        DispatchQueue.main.async {
            if let button = self.drawButton {
                if button.isHighlighted {
                    let transform = pointOfView.transform
                    let position = SCNVector3(-transform.m31 + transform.m41, -transform.m32 + transform.m42, -transform.m33 + transform.m43)
                    self.drawSphere(position: position)
                }
            }
        }
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

