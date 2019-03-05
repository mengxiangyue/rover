import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(command_toolTests.allTests),
    ]
}
#endif