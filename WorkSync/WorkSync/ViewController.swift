//
//  ViewController.swift
//  WorkSync
//
//  Created by houlin on 2019/12/19.
//  Copyright © 2019 houlin. All rights reserved.
//

import Cocoa
import SnapKit

private let WSGitDirsKey:String = "WSGitDirsKey"

class ViewController: NSViewController {

    private var timer:Timer?
    private var preTime:TimeInterval = Date().timeIntervalSince1970
    private var hourMargin:Int = 4
    
    private var dirsStr:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.documentView = tv
        
        view.addSubview(lbTitle)
        view.addSubview(scrollView)
        view.addSubview(btnSync)
        view.addSubview(btnPop)
        
        lbTitle.snp.remakeConstraints { (snp) in
            snp.left.equalTo(self.view).offset(20)
            snp.right.equalTo(self.view).offset(-20)
            snp.top.equalTo(self.view).offset(20)
            snp.height.equalTo(40)
        }
        
        btnSync.snp.remakeConstraints { (snp) in
            snp.width.equalTo(50)
            snp.height.equalTo(20)
            snp.right.equalTo(self.lbTitle)
            snp.bottom.equalTo(self.view).offset(-20)
        }
        
        scrollView.snp.remakeConstraints { (snp) in
            snp.top.equalTo(self.lbTitle.snp.bottom).offset(20)
            snp.left.right.equalTo(self.lbTitle)
            snp.bottom.equalTo(self.btnSync.snp.top).offset(-20)
        }
        
        btnPop.snp.remakeConstraints { (snp) in
            snp.right.equalTo(self.tv)
            snp.top.equalTo(self.lbTitle)
        }
        
        btnSync.target = self
        btnSync.action = #selector(self.sync)
        
        
        self.timer = Timer(timeInterval: 10, target: self, selector: #selector(self.checkoutTime), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: .common)
        
        if let preDirs = UserDefaults.standard.value(forKey: WSGitDirsKey) as? String {
            self.tv.string = preDirs
            self.dirsStr = preDirs
        }
        
        btnPop.target = self
        btnPop.action = #selector(self.popUpBtnAction(btn:))
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    lazy var tv:NSTextView = {
        let obj = NSTextView()
        obj.backgroundColor = NSColor.white
        obj.layoutManager?.defaultAttachmentScaling = NSImageScaling.scaleProportionallyDown
        obj.maxSize = NSMakeSize(CGFloat(Float.greatestFiniteMagnitude), CGFloat(Float.greatestFiniteMagnitude))
        obj.isVerticallyResizable = true
        obj.isHorizontallyResizable = false
        obj.textContainerInset = NSSize(width: 5, height: 5)
        obj.autoresizingMask = NSView.AutoresizingMask(rawValue: NSView.AutoresizingMask.width.rawValue | NSView.AutoresizingMask.height.rawValue)
        obj.textContainer?.containerSize = NSMakeSize(0, CGFloat(Float.greatestFiniteMagnitude))
        obj.textContainer?.widthTracksTextView = true
        obj.isEditable = true
        return obj
    }()

    private lazy var scrollView:NSScrollView = {
        let obj = NSScrollView()
        obj.backgroundColor = NSColor.black
        obj.hasVerticalScroller = true
        obj.drawsBackground = false
        obj.hasHorizontalRuler = false
        obj.autohidesScrollers = true
        obj.horizontalScrollElasticity = .none
        obj.layer?.masksToBounds = true
        obj.autoresizingMask = NSView.AutoresizingMask(rawValue: NSView.AutoresizingMask.width.rawValue | NSView.AutoresizingMask.height.rawValue)
        return obj
    }()
    
    private lazy var lbTitle:NSTextField = {
        let obj = NSTextField()
        obj.stringValue = "使用方法：git仓库路径;git仓库路径;git仓库路径 \nExample:/Users/houlin/Desktop/CSCZip"
        obj.isEditable = false
        obj.wantsLayer = true
        obj.isBordered = false
        obj.backgroundColor = NSColor.clear
        obj.layer?.backgroundColor = NSColor.clear.cgColor
        obj.textColor = NSColor.darkGray
        return obj
    }()
    
    private lazy var btnSync:NSButton = {
        let obj = NSButton()
        obj.title = "同步"
        return obj
    }()
    
    private lazy var btnPop:NSPopUpButton = {
        let obj = NSPopUpButton()
        obj.addItems(withTitles: ["1 hour", "2 hour", "4 hour"])
        return obj
    }()
}

extension ViewController {
    @objc private func sync() {
        let text = self.tv.string
        if text == self.dirsStr {
            self.view.window?.orderOut(nil)
            return
        }
        self.dirsStr = text
        
        UserDefaults.standard.setValue(self.dirsStr, forKey: WSGitDirsKey)
        
        self.view.window?.orderOut(nil)
    }
    
    private func upload() {
        self.preTime = Date().timeIntervalSince1970
        let arr = dirsStr.replacingOccurrences(of: " ", with: "").components(separatedBy: ";\n")
        
        for dir in arr {
            if dir.count > 0 {
                WYGitBash.syncToRemote(path: dir)
            }
        }
    }
    
    @objc private func checkoutTime() {
        let btTime:TimeInterval = Date().timeIntervalSince1970 - self.preTime
        
        if btTime > TimeInterval(0) * 3600 {
            upload()
        }
    }
    
    @objc private func popUpBtnAction(btn:NSPopUpButton) {
        let index = btn.indexOfSelectedItem;
        if index == 1 {
            hourMargin = 1
        }
        else if index == 2 {
            hourMargin = 2
        }
        else if index == 3 {
            hourMargin = 4
        }
    }
}
