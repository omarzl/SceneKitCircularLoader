//
//  TestView.swift
//  SceneKitCircularLoader
//
//  Created by Omar Zúñiga Lagunas on 24/03/18.
//  Copyright © 2018 omarzl. All rights reserved.
//

import Cocoa
import SceneKit

class TestView: SCNView {

    var loaderNode : SCNNode?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scene = SCNScene()
        let camera = SCNNode()
        camera.camera = SCNCamera()
        camera.position = SCNVector3(x: 0, y: 0, z: 30)
        scene?.rootNode.addChildNode(camera)
        
        allowsCameraControl = true
    }
    
    func test() {
        
        self.loaderNode?.removeFromParentNode()
        
        let loaderNode = CircularLoader(duration: 10.0)
        scene?.rootNode.addChildNode(loaderNode)
        loaderNode.position = SCNVector3(x: 0, y: 0.25, z: 0)
        
        self.loaderNode = loaderNode
        
        loaderNode.startAnimation()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (_) in
            loaderNode.pauseAnimation()
        }
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (_) in
            loaderNode.startAnimation()
        }
        
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { (_) in
            loaderNode.pauseAnimation()
        }
        Timer.scheduledTimer(withTimeInterval: 8.0, repeats: false) { (_) in
            loaderNode.startAnimation()
        }
    }
}



