//
//  ViewController.swift
//  iCloud Manager
//
//  Created by Ezekiel Elin on 4/5/17.
//  Copyright © 2017 Ezekiel Elin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func dialogOKCancel(title: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = title
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.warning
        myPopup.addButton(withTitle: "Continue")
        myPopup.addButton(withTitle: "Cancel")
        return myPopup.runModal() == NSAlertFirstButtonReturn
    }
    
    func getFiles(message: String) -> [URL] {
        let dialog = NSOpenPanel()
        
        dialog.title = message
        dialog.showsResizeIndicator = true
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = true
        
        if (dialog.runModal() == NSModalResponseOK) {
            return dialog.urls
        } else {
            return []
        }
    }
    
    @IBAction func removeLocal(sender: Any?) {
        let results = getFiles(message: "Choose files to purge...")
        for url in results {
            do {
                try FileManager.default.evictUbiquitousItem(at: url)
            } catch {
                if !dialogOKCancel(title: "Error", text: "Unable to purge \(url)") {
                    break
                }
            }
        }
    }

    
    @IBAction func downloadLocal(sender: Any?) {
        let results = getFiles(message: "Choose files to download...")
        for url in results {
            do {
                try FileManager.default.startDownloadingUbiquitousItem(at: url)
            } catch {
                if !dialogOKCancel(title: "Error", text: "Unable to download \(url)") {
                    break
                }
            }
        }
    }

}

