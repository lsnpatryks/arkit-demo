//
//  PlanesController.swift
//  arkit-demo
//
//  Created by Patryk Spanily on 19.03.2018.
//  Copyright © 2018 Patryk Spanily. All rights reserved.
//

import UIKit
import ARKit

class PlanesController: GenericController {
    
    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configuration.planeDetection = .horizontal
        
        addScene(configuration: configuration)
        addLeftButtton()
        
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
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        planeNode.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
        planeNode.name = "plane"
        return planeNode
    }

    private func removePlanes() {
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "plane" {
                node.removeFromParentNode()
            }
        }
    }
}

