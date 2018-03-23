//
//  PhysicsController.swift
//  arkit-demo
//
//  Created by Patryk Spanily on 20.03.2018.
//  Copyright © 2018 Patryk Spanily. All rights reserved.
//

import Foundation
import ARKit

class PhysicsController: GenericController {

    let configuration = ARWorldTrackingConfiguration()
    var position: SCNVector3?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configuration.planeDetection = .horizontal

        addScene(configuration: configuration)
        addLeftButtton()

        let _ = addRightButton(name: "dodaj", action: #selector(addButtonPressed))
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
            self.addSphere(position: position)
        }
    }

    private func addSphere(position: SCNVector3) {
        if let configuration = sceneView.session.configuration as? ARWorldTrackingConfiguration, configuration.planeDetection.contains(.horizontal) {
            configuration.planeDetection = []
            sceneView.session.run(configuration, options: [])
        }
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let boxNode = SCNNode(geometry: box)
        boxNode.position = position
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        boxNode.name = "sphere"
        boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: box, options: [:]))
        
        sceneView.scene.rootNode.addChildNode(boxNode)
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        self.addPlane(node: node, planeAnchor: planeAnchor)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        self.removePlanes()
        self.addPlane(node: node, planeAnchor: planeAnchor)
    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let _ = anchor as? ARPlaneAnchor else {
            return
        }
        self.removePlanes()
    }

    private func addPlane(node: SCNNode, planeAnchor: ARPlaneAnchor) {
        let plane = self.createPlane(planeAnchor: planeAnchor)
        node.addChildNode(plane)
    }

    private func createPlane(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let planeNode = SCNNode()
        planeNode.geometry = SCNPlane(width: planeAnchor.extent.x.cgFloat, height: planeAnchor.extent.z.cgFloat)
        planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        planeNode.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
        planeNode.name = "plane"
        planeNode.physicsBody = SCNPhysicsBody.static()
        return planeNode
    }

    private func removePlanes() {
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "plane" {
                node.removeFromParentNode()
            }
        }
    }

    @objc override func leftButtonPressed() {
        if sceneView.debugOptions.contains(ARSCNDebugOptions.showWorldOrigin) {
            sceneView.debugOptions = []
            sceneView.showsStatistics = false
        } else {
            sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, .showPhysicsShapes]
            sceneView.showsStatistics = true
        }
    }
}
