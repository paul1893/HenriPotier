import Foundation

class Executor {
    func run(function: @escaping () -> ()) {
        DispatchQueue.global().async {
            function()
        }
    }
    
    func runOnMain(function: @escaping () -> ()) {
        DispatchQueue.main.async {
            function()
        }
    }
}
