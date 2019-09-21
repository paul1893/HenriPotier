import Network

protocol DeviceManager {
    func isOnline() -> Bool
}

class DeviceManagerImpl : DeviceManager {
    func isOnline() -> Bool {
        var isOnline = false
        let monitor = NWPathMonitor()
        let semaphore = DispatchSemaphore(value: 0)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                isOnline = true
                semaphore.signal()
            } else {
                isOnline = false
                semaphore.signal()
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        _ = semaphore.wait(timeout: .distantFuture)
        monitor.cancel()
        return isOnline
    }
}
