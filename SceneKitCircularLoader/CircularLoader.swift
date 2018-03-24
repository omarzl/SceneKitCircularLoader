//
//  CircularLoader.swift
//  SceneKitCircularLoader
//
//  Created by Omar Zúñiga Lagunas on 24/03/18.
//  Copyright © 2018 omarzl. All rights reserved.
//

import Cocoa
import SceneKit

enum CircularLoaderStatus {
    case playing, paused, stopped
}

protocol CircularLoaderDelegate : class {
    func didFinish()
    func currentProgress(progress: Double)
}

class CircularLoader: SCNNode {

    //Properties
    
    var status = CircularLoaderStatus.stopped
    weak var delegate : CircularLoaderDelegate?
    var duration = 0.0
    var startDuration = 0.0
    var radius : CGFloat = 0.0
    var startAngle : CGFloat = 0.0
    var center = CGPoint.zero
    var hidesOnStop = true
    var loaderColor = NSColor.red
    
    private var segmentNode : SCNNode?
    private var animationKey = "loaderKey"
    private var currentProgress : CGFloat = 0.0
    
    //Init
    
    init(duration: Double, startDuration: Double = 0.0, radius: CGFloat = 12.0, center: CGPoint = .zero) {
        super.init()
        self.duration = duration
        self.startDuration = startDuration
        self.radius = radius
        self.center = center
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //Setup
    
    private func setupView() {
        //Code that rotates the node so the animation starts from left to right
        eulerAngles = SCNVector3(x: 0, y: CGFloat.pi, z: 0)
        
        setupSegmentNode()
    }
    
    func setupSegmentNode() {
        self.segmentNode?.removeFromParentNode()
        
        let center = CGPoint(x: 0, y: 0)
        
        let endAngle = calculateAngle(forDuration: duration, time: CGFloat(startDuration))
        segmentNode = SCNNode(geometry: createSegmentShape(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle))
        addChildNode(segmentNode!)
    }
    
    //Animation
    
    func startAnimation() {
        guard let segmentNode = segmentNode else {
            return
        }
        
        isHidden = false
        status = .playing
        
        runAction(SCNAction.customAction(duration: duration - startDuration) { [weak self] (node, time) in
            guard let aSelf = self, aSelf.status == .playing else {
                return
            }
            
            let currentProgress = CGFloat(aSelf.startDuration) + time
            
            //Updates startDuration for pause
            aSelf.currentProgress = currentProgress
            aSelf.delegate?.currentProgress(progress: Double(currentProgress))
            
            let newAngle = aSelf.calculateAngle(forDuration: aSelf.duration, time: currentProgress)
            let shape = aSelf.createSegmentShape(center: aSelf.center, radius: aSelf.radius, startAngle: aSelf.startAngle, endAngle: newAngle)
            segmentNode.geometry = shape
        }, forKey: animationKey) { [weak self] in
            self?.delegate?.didFinish()
            self?.status = .stopped
            if self?.hidesOnStop ?? false {
                self?.isHidden = true
            }
        }
    }
    
    func pauseAnimation() {
        removeAnimation(forKey: animationKey)
        startDuration = Double(currentProgress)
        status = .paused
    }
    
    func stopAnimation() {
        removeAnimation(forKey: animationKey)
        startDuration = 0.0
        duration = 0.0
        if hidesOnStop {
            isHidden = true
        }
        status = .stopped
    }
    
    //Helper methods
    
    private func calculateAngle(forDuration duration: Double, time: CGFloat) -> CGFloat {
        let newAngle = 360 * time / CGFloat(duration)
        return newAngle > 180 ? (360 - newAngle) * -1 : newAngle
    }
    
    private func createSegmentShape(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) -> SCNShape {
        let segmentPath = NSBezierPath()
        segmentPath.move(to: center)
        segmentPath.appendArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: startAngle + endAngle)
        segmentPath.close()
        segmentPath.flatness = 0.05
        let shapeThickness : CGFloat = 1.0
        let segmentShape = SCNShape(path: segmentPath, extrusionDepth: shapeThickness)
        segmentShape.chamferRadius = 1.0
        segmentShape.firstMaterial?.diffuse.contents = loaderColor
        segmentShape.firstMaterial?.specular.contents = NSColor.darkGray
        
        return segmentShape
    }
}


