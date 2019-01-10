//
//  AppDelegate.swift
//  Java BuildRun
//
//  Created by Justin Proulx on 2019-01-08.
//  Copyright © 2019 Royal Apps. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTextFieldDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet var pathTextField: NSTextField!
    
    @IBOutlet var justinLabel: NSTextField!
    @IBOutlet var royalAppsLabel: NSTextField!

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        // Insert code here to initialize your application
        pathTextField.delegate = self
        pathTextField.tag = 0
        
        pathTextField.stringValue = UserDefaults.standard.string(forKey: "workingDirectory") ?? ""
        
        // enter key to do action
        //pathTextField.target = self
        //pathTextField.action = #selector(objcBuildAndRun)
        
        setUpPromoLabelActions(label: justinLabel, selector: #selector(justinTwitter))
        setUpPromoLabelActions(label: royalAppsLabel, selector: #selector(royalAppsWebsite))
    }
    
    func setUpPromoLabelActions(label: NSTextField, selector: Selector)
    {
        let gesture = NSClickGestureRecognizer()
        gesture.buttonMask = 0x1 // left mouse
        gesture.numberOfClicksRequired = 1
        gesture.target = self
        gesture.action = selector
        
        label.addGestureRecognizer(gesture)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func controlTextDidEndEditing(_ obj: Notification)
    {
        let control = obj.object as! NSTextField
        
        if (control.tag == 0)
        {
            savePath()
        }
    }
    
    func savePath()
    {
        UserDefaults.standard.set(pathTextField.stringValue, forKey: "workingDirectory")
    }
    
    func showAlert(title: String, result: String)
    {
        let alert = NSAlert()
        alert.messageText = title.uppercased() + ": "
        alert.informativeText = result
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.beginSheetModal(for: self.window!, completionHandler: nil)
    }
    
    //MARK: – Build and Run functions
    func build() -> Bool
    {
        let br = BuildRun()
        let buildResult = br.build(filepath: pathTextField!.stringValue)
        if buildResult.0.count > 0
        {
            showAlert(title: buildResult.0, result: buildResult.1)
        }
        return buildResult.2
    }
    
    func run() -> Bool
    {
        let br = BuildRun()
        let runResult = br.run(filepath: pathTextField!.stringValue)
        showAlert(title: runResult.0, result: runResult.1)
        return runResult.2
    }
    
    func buildAndRun()
    {
        savePath()
        if build()
        {
            let _ = run()
        }
    }
    
    @objc func objcBuildAndRun()
    {
        buildAndRun()
    }
    
    //MARK:– IBActions
    @IBAction func buildButtonClicked(sender: NSButton)
    {
        savePath()
        let _ = build()
    }
    
    @IBAction func buildAndRunButtonClicked(sender: NSObject)
    {
        buildAndRun()
    }
    
    @IBAction func runButtonClicked(sender: NSButton)
    {
        let _ = run()
    }
    
    @IBAction func chooseFile(sender: NSButton)
    {
        let dialog = NSOpenPanel();
        
        dialog.title = "Choose a .java file or a folder containing one";
        dialog.showsResizeIndicator = true;
        dialog.showsHiddenFiles = false;
        dialog.canChooseDirectories = true;
        dialog.canCreateDirectories = false;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes = ["java"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK)
        {
            let result = dialog.url // Pathname of the file
            
            if (result != nil)
            {
                let path = result!.path
                pathTextField.stringValue = path
                savePath()
            }
        } else
        {
            // User clicked on "Cancel"
            return
        }
    }
    
    @objc func justinTwitter(sender: NSTextField)
    {
        openWebsite(promourl: "https://twitter.com/JustinAlexP")
    }
    
    @objc func royalAppsWebsite(sender: NSTextField)
    {
        openWebsite(promourl: "https://www.royalapps.xyz")
    }
    
    // MARK:– Miscellaneous functions
    func openWebsite(promourl: String)
    {
        if let url = URL(string: promourl), NSWorkspace.shared.open(url)
        {
            print("default browser was successfully opened")
        }
    }
}

