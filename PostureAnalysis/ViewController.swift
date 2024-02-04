//
//  ViewController.swift
//  PostureAnalysis
//
//  Created by Ojasvi Sethi on 04/02/24.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var nodeUpdater : NodeUpdater!
    var informationView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        informationView = UILabel()
        informationView.translatesAutoresizingMaskIntoConstraints = false
        informationView.textAlignment = .center
        informationView.textColor = UIColor.black
        informationView.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(informationView)
        
        // Set up constraints (adjust as needed)
        NSLayoutConstraint.activate([
            informationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            informationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer,
                  didUpdate node: SCNNode,
                  for anchor: ARAnchor) {
        if let anchor = anchor as? ARBodyAnchor {
            let arSkeleton = anchor.skeleton
            
            //Get the 4x4 matrix transformation from the hip node.
            let upLeg = arSkeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "left_upLeg_joint"))
            let leg = arSkeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "left_leg_joint"))
            let spine7 = arSkeleton.modelTransform(for: ARSkeleton.JointName(rawValue:"spine_7_joint"))
            let matrix1 = SCNMatrix4(upLeg!)
            let matrix2 = SCNMatrix4(spine7!)
            let matrix3 = SCNMatrix4(leg!)
            let legPosition = SCNVector3(matrix3.m41, matrix3.m42, matrix3.m43)
            let spine7Position = SCNVector3(matrix2.m41, matrix2.m42, matrix2.m43)
            
            
            //Compute the angle made by leg joint and spine7 joint
            //from the hip_joint (root node of the skeleton)
            let angle = SCNVector3.angleBetween(legPosition, spine7Position)
            //print("angle : ", angle * 180.0 / Float.pi)
            
            //Add my geometry node
            var angleNode = SCNNode()
            node.addChildNode(angleNode)
            angleNode.transform = matrix1
            //Apply a local rotation for display in the good orientation.
            angleNode.transform = SCNMatrix4Mult(SCNMatrix4MakeRotation(Float.pi, 1, 0, 0), angleNode.transform)
            angleNode.scale = SCNVector3(0.3, 0.3, 0.3)
            
            
            let flora = UIColor(red: 0.0, green: 0.8, blue: 0.2, alpha: 1.0)
            let cantaloupe = UIColor(red: 1.0, green: 0.8, blue: 0.4, alpha: 1.0)
            //Update the color display depending on the posture angle
            var color = flora
            if angle < (Float.pi / 2.0 ) {// 90°
                color = cantaloupe
            }
            if angle > (Float.pi * 2.0 / 3.0) {// 120°
                color = cantaloupe
            }
            
            //Update the geometry of the feedback node
            nodeUpdater.updateDebugAngle(node: &angleNode,
                                         startAngle: 0,
                                         stopAngle: CGFloat(angle))
            nodeUpdater.setOnlyEmissiveColor(to: angleNode, with: color)
            angleNode.geometry?.materials.first?.isDoubleSided = true
            
            DispatchQueue.main.async { [weak self] in
                self?.informationView.text = "Posture angle : \(Int(angle * 180.0 / Float.pi ))"
            }
        }
        
        
    }
    
}
