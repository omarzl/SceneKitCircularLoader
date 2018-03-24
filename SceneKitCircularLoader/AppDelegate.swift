//
//  AppDelegate.swift
//  SceneKitCircularLoader
//
//  Created by Omar Zúñiga Lagunas on 24/03/18.
//  Copyright © 2018 omarzl. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var sceneView: TestView!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        sceneView.test()
    }
}

