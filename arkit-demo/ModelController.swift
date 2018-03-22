//
//  ModelController.swift
//  arkit-demo
//
//  Created by Patryk Spanily on 22.03.2018.
//  Copyright © 2018 Patryk Spanily. All rights reserved.
//

import Foundation
import ARKit
import ModelIO
import SceneKit.ModelIO

class ModelController: GenericController {

    let configuration = ARWorldTrackingConfiguration()
    let drawButton = UIButton()
    var secondButton = UIButton()
    var position: SCNVector3?
    
    var object, secondObject: MDLObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configuration.planeDetection = .horizontal

        addScene(configuration: configuration)
        addLeftButtton()
        
        self.object = MDLAsset(url: URL(fileURLWithPath:  Bundle.main.path(forResource: "model1", ofType: "obj")!)).object(at: 0)
        self.secondObject = MDLAsset(url: URL(fileURLWithPath:  Bundle.main.path(forResource: "model2", ofType: "obj")!)).object(at: 0)
        
        // right button
        view.addSubview(drawButton)
        drawButton.setTitle("nr 1", for: .normal)
        drawButton.setTitleColor(.black, for: .normal)
        drawButton.backgroundColor = UIColor.white
        drawButton.translatesAutoresizingMaskIntoConstraints = false
        drawButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: drawButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: drawButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: drawButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70),
            NSLayoutConstraint(item: drawButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40),
            ])
        
        // reset button
        view.addSubview(secondButton)
        secondButton.setTitle("nr 2", for: .normal)
        secondButton.setTitleColor(.black, for: .normal)
        secondButton.backgroundColor = UIColor.white
        secondButton.addTarget(self, action: #selector(secondButtonPressed), for: .touchUpInside)
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: secondButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: secondButton, attribute: .bottom, relatedBy: .equal, toItem: drawButton, attribute: .top, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: secondButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70),
            NSLayoutConstraint(item: secondButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40),
            ])
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else {
            return
        }
        let transform = pointOfView.transform
        self.position = SCNVector3(-transform.m31 + transform.m41, -transform.m32 + transform.m42, -transform.m33 + transform.m43)
    }
    
    @objc func addButtonPressed(){
        if let position = self.position {
            self.drawModel(position: position)
        }
    }
    
    @objc func secondButtonPressed(){
        if let position = self.position {
            self.drawSecondModel(position: position)
        }
    }
    
    func drawModel(position: SCNVector3) {
        let node = SCNNode(mdlObject: self.object!)
        node.position = position
        node.scale = SCNVector3(0.01, 0.01, 0.01)
        node.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "model1")
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func drawSecondModel(position: SCNVector3){
        let node = SCNNode(mdlObject: self.secondObject!)
        node.position = position
        node.scale = SCNVector3(0.2, 0.2, 0.2)
        node.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "model2")
        sceneView.scene.rootNode.addChildNode(node)
    }
}
