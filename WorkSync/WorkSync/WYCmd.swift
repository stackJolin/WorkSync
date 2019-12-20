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
        task.launchPath = "/bin/bash"
        task.arguments = arguments
        let output = Pipe()
        task.standardOutput = output
        task.launch()
        task.waitUntilExit()
        let data = output.fileHandleForReading.readDataToEndOfFile()      // 获取执行结果数据
        return String(data: data, encoding: String.Encoding.utf8) ?? ""     // 返回结果
    }
}
