//
//  SCNVector.swift
//  PostureAnalysis
//
//  Created by Ojasvi Sethi on 04/02/24.
//

import SceneKit
import simd

extension SCNVector3 {
    static func dotProduct(left: SCNVector3, right: SCNVector3) -> Float {
        return left.x * right.x + left.y * right.y + left.z * right.z
    }

    static func angleBetween(_ v1: SCNVector3, _ v2: SCNVector3) -> Float {
        let cosinus = dotProduct(left: v1, right: v2) / v1.length / v2.length
        let angle = acos(cosinus)
        return angle
    }
    
    var length: Float {
        return sqrt(x * x + y * y + z * z)
    }
}
