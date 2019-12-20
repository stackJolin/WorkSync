//
//  AppDelegate.swift
//  WorkSync
//
//  Created by houlin on 2019/12/19.
//  Copyright © 2019 houlin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    @IBOutlet weak var menu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            button.image = NSImage(named: "cloud-sync")
        }
        statusItem.menu = self.menu
        
        NSApp.windows.last?.delegate = self
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func Config(_ sender: Any) {
        NSApp.windows.last?.makeKeyAndOrderFront(nil)
    }
    
    @IBAction func Quit(_ sender: Any) {
        NSApp.terminate(self)
    }
}

extension AppDelegate: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApp.mainWindow?.orderOut(nil)
        return false
    }
}
