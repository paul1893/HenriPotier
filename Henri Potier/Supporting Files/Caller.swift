import Foundation

protocol Caller {
    func get(with url: URL) -> (Data?, Error?)
}

class CallerImpl : Caller {
    func get(with url: URL) -> (Data?, Error?) {
        var receivedData: Data?
        var receivedError: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            receivedError = error
            receivedData = data
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
        return (receivedData, receivedError)
    }
}
