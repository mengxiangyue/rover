

import Foundation
import Guaka

//guard let utils = ProjectUtils(projectPath: "/Users/Xiangyue.Meng/Downloads/TestFramework/TestFramework.xcodeproj") else {
//    fatalError("can't open the project")
//}
//for proj in utils.listAllProjects() {
//    print(proj.name)
//}
//for target in utils.listTargets() {
//    print(target.name)
//}
//
//try utils.removeLinkedFramework(frameworkName: "CoreService")

//let generation = Generation(buildFoler: "/Users/xiangyue/Downloads/build")
//generation.buildTarget(project: "/Users/xiangyue/Downloads/TestFramework/TestFramework.xcworkspace", scheme: "UserService", type: .simulator)
//generation.buildTarget(project: "/Users/xiangyue/Downloads/TestFramework/TestFramework.xcworkspace", scheme: "UserService", type: .realDevice)
//generation.generationFramework(name: "UserService")


let task = Process()
task.currentDirectoryPath = "/Users/xiangyue/Downloads/TestFramework/UserService"
task.launchPath = "/usr/bin/env"
task.arguments = ["sh", "gen.sh"]
task.launch()
task.waitUntilExit()
task.terminationStatus




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
    print("add linkedFramework")
}

let removeCommand = Command(usage: "remove") { _, _ in
    print("list all target")
}

let genCommand = Command(usage: "gen") { _, args in
    
}

command.add(subCommands: [listCommand, addCommand, removeCommand, genCommand])
command.execute()




