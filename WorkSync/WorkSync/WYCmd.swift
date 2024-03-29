//
//  WYCmd.swift
//  WorkSync
//
//  Created by houlin on 2019/12/19.
//  Copyright © 2019 houlin. All rights reserved.
//

import Foundation

class WYCmd {
    class func execCmd(arguments: [String]) -> String {
        let task = Process()     // 创建NSTask 实例
        let dict = ProcessInfo.processInfo.environment
        let shellString = dict["SHELL"]
        task.launchPath = shellString
        task.arguments = arguments
        let output = Pipe()
        task.standardOutput = output
        let envDict = ["HOME" : NSHomeDirectory(), "USER" : NSUserName()] as! [String : String]
        task.environment = envDict
        task.launch()
        task.waitUntilExit()
        let data = output.fileHandleForReading.readDataToEndOfFile()      // 获取执行结果数据
        return String(data: data, encoding: String.Encoding.utf8) ?? ""     // 返回结果
    }
}
