import xcodeproj
import PathKit

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

//try main()
import Guaka

let version = Flag(longName: "version", value: false, description: "Prints the version")

let command = Command(usage: "moon", flags: [version]) { flags, args in
    if let hasVersion = flags.getBool(name: "version"),
        hasVersion == true {
        print("Version is 1.0.0")
        return
    }
}

let listCommand = Command(usage: "list") { _, _ in
    print("list all target")
}

let addCommand = Command(usage: "add") { _, _ in
    print("list all target")
}

let removeCommand = Command(usage: "remove") { _, _ in
    print("list all target")
}

let genCommand = Command(usage: "gen") { _, args in
    
}

command.add(subCommands: [listCommand, addCommand, removeCommand, genCommand])
command.execute()




