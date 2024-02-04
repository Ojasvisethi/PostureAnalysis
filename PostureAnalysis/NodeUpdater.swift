//
//  NodeUpdater.swift
//  PostureAnalysis
//
//  Created by Ojasvi Sethi on 04/02/24.
//

import SceneKit
import UIKit



class NodeUpdater {
    
    // Set both diffuse and emissive colors for the node
    func setOnlyEmissiveColor(node: SCNNode, color: UIColor) {
        if let geometry = node.geometry {
            for material in geometry.materials {
                material.diffuse.contents = color
                material.emission.contents = color
                material.isDoubleSided = true
            }
        }
    }
    
    // Set only the emissive color for the node
    func setOnlyEmissiveColor(to node: SCNNode, with color: UIColor) {
        if let geometry = node.geometry {
            for material in geometry.materials {
                material.emission.contents = color
                material.isDoubleSided = true
            }
        }
    }
    
    // Update the geometry of the feedback node based on the angle
    func updateDebugAngle(node: inout SCNNode, startAngle: CGFloat, stopAngle: CGFloat) {
        // Remove existing geometry
        node.geometry = nil
        
        // Calculate the angle in radians
        let angleInRadians = Float(stopAngle - startAngle)
        
        // Create a circular arc using SCNShape and UIBezierPath
        let path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 0.5, startAngle: startAngle, endAngle: stopAngle, clockwise: true)
        let shape = SCNShape(path: path, extrusionDepth: 0.1)
        
        // Create a new node with the shape geometry
        let arcNode = SCNNode(geometry: shape)
        
        // Set the position and rotation based on the angle
        // Adjust position and rotation based on your needs
        arcNode.position = SCNVector3(0, 0.5, 0)
        arcNode.rotation = SCNVector4(1, 0, 0, angleInRadians / 2.0)
        
        // Add the arc node as a child node to the main node
        node.addChildNode(arcNode)
    }
}
