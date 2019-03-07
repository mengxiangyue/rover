//
//  Generation.swift
//  rover
//
//  Created by Xiangyue Meng on 2019/3/6.
//

import Foundation
// https://github.com/tuist/shell.git
//import Shell

public struct Generation {
    public enum BuildType {
        case realDevice
        case simulator
    }
    let buildFoler: String
    init(buildFoler: String) {
        self.buildFoler = buildFoler + (buildFoler.hasSuffix("/") ? "" : "/")
    }
    
    // xcodebuild -project '../TestFramework.xcodeproj' -scheme "${FMK_NAME}" -configuration Release -sdk iphoneos -derivedDataPath 'build/iphoneos' clean archive
    // xcodebuild -project '../TestFramework.xcodeproj' -scheme "${FMK_NAME}" -configuration Release -sdk iphonesimulator clean build -derivedDataPath 'build/iphonesimulator'
    func buildTarget(project: String, scheme: String, type: BuildType) {
        let sdk: String
        let derivedDataPath: String
        let command: String
        switch type {
        case .realDevice:
            sdk = "iphoneos"
            derivedDataPath = buildFoler + "build/iphoneos"
            command = "archive"
        case .simulator:
            sdk = "iphonesimulator"
            derivedDataPath = buildFoler + "build/iphonesimulator"
            command = "build"
        }
//        let shell = Shell()
        let params = ["xcodebuild", "-workspace", project, "-scheme", scheme, "-configuration", "Release", "-sdk", sdk, "-derivedDataPath", derivedDataPath, "clean", command]
        print(params.joined(separator: " "))
//        let result = shell.sync(params)
//        print(result)
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = params
        task.launch()
        task.waitUntilExit()
        print("result ---> \(task.terminationStatus)")
    }
    
    // this function has errors, so change to use shell script to implement this function
    func generationFramework(name: String) {
        let deviceDir = " \(buildFoler)build/iphoneos/Build/Intermediates.noindex/ArchiveIntermediates/\(name)/IntermediateBuildFilesPath/UninstalledProducts/iphoneos/\(name).framework"
        let simulatorDir = "\(buildFoler)build/iphonesimulator/Build/Products/Release-iphonesimulator/\(name).framework"
        // lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"
        let params = ["lipo", "\(deviceDir)/\(name)", "\(simulatorDir)/\(name)", "-output", "\(buildFoler)\(name)", "-create"]
        let code = runShell(params: params)
        print("rs code --> \(code)")
    }
    
    private func runShell(params: [String]) -> Int32 {
        print(params.joined(separator: " "))
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = params
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
}

func generationFramework(path: String, workspace: String, target: String) -> Int {
    let task = Process()
    
    let outpipe = Pipe()
    task.standardOutput = outpipe
    let errpipe = Pipe()
    task.standardError = errpipe
    
    task.currentDirectoryPath = path
    task.launchPath = "/usr/bin/env"
    task.arguments = ["sh", "gen.sh", workspace, target]
    task.launch()
    let errdata = errpipe.fileHandleForReading.availableData
    let errString = String(data: errdata, encoding: String.Encoding.utf8) ?? ""
    if errString != "" {
        print("run command with error: \(errString)")
        print("command:")
        print(task.arguments?.joined(separator: " "))
    }
    outpipe.fileHandleForReading.readabilityHandler = { fileHandle in
        if let string = String(data: fileHandle.availableData, encoding: String.Encoding.utf8), string.count > 0 {
            // maybe need to write this log into somewhere
//            print("------ \(Date()) \(string)")
        }
    }
    task.waitUntilExit()
    let code = task.terminationStatus
    return Int(code)
}

