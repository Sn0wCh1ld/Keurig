//
//  shell.swift
//  Java BuildRun
//
//  Created by Justin Proulx on 2019-01-08.
//  Copyright © 2019 Royal Apps. All rights reserved.
//

import Foundation

class Shell
{
    func run(launchPath: String, arguments: [String] = [], activeDirectoryPath: URL?) -> (output: String?, error: String?)
    {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments
        
        if (activeDirectoryPath != nil)
        {
            task.currentDirectoryURL = activeDirectoryPath!
        }
        
        let pipe = Pipe()
        task.standardOutput = pipe
        let errorpipe = Pipe()
        task.standardError = errorpipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        let errordata = errorpipe.fileHandleForReading.readDataToEndOfFile()
        let error = String(data: errordata, encoding: .utf8)
        
        return (output: output, error: error)
    }
}
