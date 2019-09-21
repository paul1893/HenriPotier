@testable import Henri_Potier

class MockExecutor : Executor {
    override func run(function: @escaping () -> ()) {
        function()
    }
    
    override func runOnMain(function: @escaping () -> ()) {
        function()
    }
}
