//
//  HitTestController.swift
//  arkit-demo
//
//  Created by Patryk Spanily on 20.03.2018.
//  Copyright © 2018 Patryk Spanily. All rights reserved.
//

import Foundation
import ARKit

class HitTestController: GenericController {

    let configuration = ARWorldTrackingConfiguration()

    var position: SCNVector3?

    override func viewDidLoad() {
        super.viewDidLoad()

        addScene(configuration: configuration)
        addLeftButtton()

        let _ = self.addRightButton(name: "dodaj", action: #selector(addButtonPressed))

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else {
            return
        }
        let transform = pointOfView.transform
        self.position = SCNVector3(-transform.m31 + transform.m41, -transform.m32 + transform.m42, -transform.m33 + transform.m43)
    }

    @objc func addButtonPressed() {
        if let position = self.position {
            self.drawSphere(position: position)
        }
    }

    private func drawSphere(position: SCNVector3) {
        let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.1))
        sphereNode.position = position
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        sphereNode.name = "sphere"
        sceneView.scene.rootNode.addChildNode(sphereNode)
    }

    private func changeColor(node: SCNNode) {
        if node.name == "sphere" {
            let red = CGFloat(arc4random_uniform(255)) / 255
            let green = CGFloat(arc4random_uniform(255)) / 255
            let blue = CGFloat(arc4random_uniform(255)) / 255
            node.geometry?.firstMaterial?.diffuse.contents = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneTapped = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneTapped)
        let hitTest = sceneTapped.hitTest(touchCoordinates)
        if !hitTest.isEmpty {
            changeColor(node: hitTest.first!.node)
        }
    }
}
