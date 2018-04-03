//
//  ViewController.swift
//  SecurityNetWork
//
//  Created by dai nguyen on 4/2/18.
//  Copyright © 2018 dai nguyen. All rights reserved.
//

import Cocoa
import CryptoSwift
//import CryptorRSA

class ViewController: NSViewController {
    enum Alogrithm {
        case ASE192
        case ASE256
        case RSA1
    }

    @IBOutlet weak var textFieldKey: NSTextFieldCell!
    @IBOutlet weak var textFileOutput: NSTextField!
    @IBOutlet weak var textFieldSelected: NSTextField!

    var selectedFolder : String = ""
    var stringExtension : String = ""
    var outPutFolder : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
 
    @IBOutlet weak var openFile: NSButton!
    
    @IBAction func selectFileInput(_ sender: Any) {
        guard let window = view.window else { return }
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        // 3
        panel.beginSheetModal(for: window) { (result) in
            if result == NSApplication.ModalResponse.OK {
                // 4
                self.selectedFolder = panel.urls[0].path
                self.textFieldSelected.stringValue = (self.selectedFolder)
                self.stringExtension = (self.textFieldSelected.stringValue as NSString).pathExtension
            }
        }
    }
    
    @IBAction func selectOutputFile(_ sender: Any) {
        
        guard let window = view.window else { return }
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        // 3
        panel.beginSheetModal(for: window) { (result) in
            if result == NSApplication.ModalResponse.OK {
                // 4
                self.outPutFolder = panel.urls[0].path
                self.textFileOutput.stringValue = (self.outPutFolder)
            }
        }
    }
    
    
    
    // MARK : Select decrypt or encrypt
    @IBOutlet weak var radioDecrypt: NSButton!
    @IBOutlet weak var radioEncrypt: NSButton!
    var isEncrypt : Bool = true
    @IBAction func selectEncrypt(_ sender: Any) {
        isEncrypt = !isEncrypt
        radioEncrypt.state = isEncrypt ? .on : .off
        radioDecrypt.state = isEncrypt ? .off : .on
       
    }
    @IBAction func selectDecrypt(_ sender: Any) {
        isEncrypt = !isEncrypt
        radioEncrypt.state = isEncrypt ? .on : .off
        radioDecrypt.state = isEncrypt ? .off : .on
    }
    
    var isStart = false
    @IBOutlet weak var Start: NSButton!
    @IBAction func onStart(_ sender: Any) {
//        if(textFieldSelected.stringValue.count == 0 || textFieldNameFile.stringValue.count == 0 || textFileOutput.stringValue.count == 0 || textFieldKey.stringValue.count == 0 ){
//            return
//        }
        
        isStart = !isStart
        Start.title = isStart ? "Cancel" : "Start"
        startCipher()
    }
    
    func startCipher(){
        if(isEncrypt){
            if(isSelect256 != .RSA1){
                startEncrypt()
            }else{
                encryptRSA()
            }
        }else{
            startDecrypt()
        }
    }
    func readFile() ->Data? {
        let file: FileHandle? = FileHandle(forReadingAtPath: textFieldSelected.stringValue)
        if file != nil {
            // Read all the data
            let data = file?.readDataToEndOfFile()
            // Close the file
            file?.closeFile()
            return data
        }
        else {
            print("Ooops! Something went wrong!")
            return nil
        }
    }
    
    func  startEncrypt()  {
        guard let data = readFile() else { return }
        if (textFieldKey.title.count < 8) {
            return;
        }
        
        var bytes = textFieldKey.title.md5().bytes
        if(isSelect256 == .ASE192){
            bytes = bytes.splitBy(subSize: 16)
        }
        do {
            let cipler = try AES(key: bytes, blockMode: .ECB)
//            let str = String.init(data: data, encoding: .utf8)
            let res = try data.encrypt(cipher: cipler)
    
            //let result = try str!.encryptToBase64(cipher: cipler)
            saveFile(result: res)
        } catch  {
            print("error")
        }
    }
    func encryptRSA() -> String {
//        let datakey = "daideptraibest".data(using: .utf8)
//        do{
//            let publicKey = try CryptorRSA.createPublicKey(with: datakey!)
//            let privateKey = try CryptorRSA.createPrivateKey(with: datakey!)
//            print(publicKey.type.hashValue)
//            print(privateKey.type.hashValue)
//        }catch{
//    
//        }
        
        return "aaa"
    }
    
    func startDecrypt()  {
        guard let data = readFile() else { return }
        if (textFieldKey.title.count < 8) {
            return;
        }
        
        var bytes = textFieldKey.title.md5().bytes
        if(!true){
            bytes = bytes.splitBy(subSize: 16)
        }
        do {
            let cipler = try AES(key: bytes, blockMode: .ECB)
            let str = try data.decrypt(cipher: cipler)
            saveFile(result: str)
        } catch  {
            print("error")
        }
    }
    @IBOutlet weak var aes192: NSButton!
    @IBOutlet weak var aes256: NSButton!
    @IBOutlet weak var rsa: NSButton!

    var isSelect256 = Alogrithm.ASE256
    
    @IBAction func changeState192(_ sender: Any) {
      
            isSelect256 = Alogrithm.ASE192
            aes256.state = .off
            aes192.state = .on
            rsa.state = .off
            
        
    }
    
    @IBAction func changeState256(_ sender: Any) {
       
            isSelect256 = Alogrithm.ASE256
            aes256.state = .on
            aes192.state = .off
            rsa.state = .off
            
        
    }
    
    @IBAction func changeStaterRSA(_ sender: Any) {
      
            isSelect256 = Alogrithm.RSA1
            aes256.state = .off
            aes192.state = .off
            rsa.state = .on
            
    
    }
    
    @IBOutlet weak var textFieldNameFile: NSTextField!
    
    func saveFile(result : Data){
        // 1
        let path = (self.textFileOutput.stringValue as NSString).appending("/").appending(textFieldNameFile.stringValue).appending(".").appending(stringExtension)
        let file: FileHandle? = FileHandle(forWritingAtPath: path)
        if file == nil {
            let filemgr = FileManager.default
            do {
//                let data = result.data(using: .utf8)
                try filemgr.createFile(atPath: path, contents: result, attributes: nil)
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        }

    }
    
    
}

extension Array {
    func splitBy(subSize: Int) -> [UInt8] {
        var result : [UInt8] = []
        for i in 0..<subSize {
            result.append(self[i] as! UInt8)
        }
        return result
    }
}

