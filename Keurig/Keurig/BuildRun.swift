//
//  BuildRun.swift
//  Java BuildRun
//
//  Created by Justin Proulx on 2019-01-08.
//  Copyright © 2019 Royal Apps. All rights reserved.
//

import Foundation
import Cocoa

class BuildRun
{
    func build(filepath: String) -> (String, String, Bool)
    {
        let shell = Shell.init()
        let dirpathURL = URL(fileURLWithPath: filepath)
        let dirpath = dirpathURL.deletingLastPathComponent().relativePath
        
        // get java compiler path
        let javacPath = getToolLocation("javac")
        
        // move to correct directory
        let _ = shell.run(launchPath: "/usr/bin/cd", arguments: [dirpath])
        
        let error: String = shell.run(launchPath: javacPath, arguments: [filepath]).error ?? ""
        if error.count > 0
        {
            return ("Failed to Build", error, false)
        }
        else
        {
            return ("","", true)
        }
    }
    
    func run(filepath: String) -> (String, String, Bool)
    {
        let shell = Shell.init()
        let dirpathURL = URL(fileURLWithPath: filepath)
        let dirpath = dirpathURL.deletingLastPathComponent().relativePath
        
        let javaPath = getToolLocation("java")
        
        // move to correct directory
        let _ = shell.run(launchPath: "/usr/bin/cd", arguments: [dirpath])
        
        let returnedValues = shell.run(launchPath: javaPath, arguments: [filepath])
        let error = returnedValues.error ?? ""
        let output = returnedValues.output ?? ""
        if error.count > 0
        {
            return ("Runtime Error", error, false)
        }
        else
        {
            return ("Result", output, true)
        }
    }
    
    func getToolLocation(_ tool: String) -> String
    {
        let shell = Shell.init()
        return shell.run(launchPath: "/usr/bin/which", arguments: [tool]).output?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ("/usr/bin/" + tool)
    }
}
