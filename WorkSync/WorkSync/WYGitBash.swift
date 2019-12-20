//
//  WYBash.swift
//  WorkSync
//
//  Created by houlin on 2019/12/19.
//  Copyright © 2019 houlin. All rights reserved.
//

import Foundation

class WYGitBash {
    class func syncToRemote(path:String) {
        let argument = "cd \(path); git add .; git commit -m 'update'; git push; cd ..;"
        let result = WYCmd.execCmd(arguments: ["-c", argument])
    }
}
