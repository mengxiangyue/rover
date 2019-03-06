//
//  File.swift
//  AEXML
//
//  Created by Xiangyue Meng on 2019/3/6.
//

import Foundation
import xcodeproj
import PathKit

public struct ProjectUtils {
    public enum ParseError: Error {
        case frameworkNotFound
        case frameworkBuildPhaseNotFound
    }
    
    
    let path: Path
    let xcodeproj: XcodeProj
    let mainTarget: PBXTarget
    init?(projectPath path: String) {
        self.path = Path(path)
        do {
            xcodeproj = try XcodeProj(path: self.path)
            guard let target = xcodeproj.pbxproj.targets(named: "TestFramework").first else {
                return nil
            }
            mainTarget = target
        } catch {
            return nil
        }
    }
    
    func listAllProjects() -> [PBXProject] {
        return xcodeproj.pbxproj.projects
    }
    
    func listTargets(project: PBXProject? = nil) -> [PBXTarget] {
        if project != nil {
            return project?.targets ?? []
        }
        return xcodeproj.pbxproj.projects.flatMap({ (project) -> [PBXTarget] in
            return project.targets
        })
    }
    
    func addLinkedFramework(frameworkName name: String) throws {
        guard let framework = xcodeproj.pbxproj.targets(named: name).first else {
            throw ParseError.frameworkNotFound
        }
        guard let frameworkRef = framework.product else {
            throw ParseError.frameworkNotFound
        }
        let buildFile = PBXBuildFile(file: frameworkRef)
        
        guard let frameworksBuildPhase = mainTarget.buildPhases.filter({ $0.buildPhase == .frameworks}).first else {
            throw ParseError.frameworkBuildPhaseNotFound
        }
        frameworksBuildPhase.files.append(buildFile)
        
        try xcodeproj.write(path: path)
    }
    
    func removeLinkedFramework(frameworkName name: String) throws {
        guard let frameworksBuildPhase = mainTarget.buildPhases.filter({ $0.buildPhase == .frameworks}).first else {
            throw ParseError.frameworkBuildPhaseNotFound
        }
        frameworksBuildPhase.files.removeAll { (buildFile) -> Bool in
            return buildFile.file?.path == "\(name).framework"
        }
        
        try xcodeproj.write(path: path)
    }
    
}

// 主要是为了能够使用 guard let else return
func main() throws {
    let path = Path("/Users/Xiangyue.Meng/Downloads/TestFramework/TestFramework.xcodeproj")
    let xcodeproj = try XcodeProj(path: path)
    
    
    guard let target = xcodeproj.pbxproj.targets(named: "TestFramework").first else {
        print("not find")
        return
    }
    
    let frameworksBuildPhase = xcodeproj.pbxproj.buildPhases.filter({ (phase) -> Bool in
        return target.buildPhases.contains(phase) && phase.buildPhase == .frameworks
    })
    if let files = frameworksBuildPhase.first?.files {
        for file in files {
            print("\(file.file?.path)")
        }
    }
    
    //    frameworksBuildPhase.first?.files.removeAll()
    //
    //
    guard let coreServiceTarget = xcodeproj.pbxproj.targets(named: "CoreService").first else { fatalError() }
    guard let coreServiceRef = coreServiceTarget.product else { fatalError() }
    let coreServiceBuildFile = PBXBuildFile(file: coreServiceRef)
    frameworksBuildPhase.first?.files.append(coreServiceBuildFile)
    
    
    try xcodeproj.write(path: path)
    
}
