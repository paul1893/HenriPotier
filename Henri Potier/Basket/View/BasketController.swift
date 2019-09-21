protocol BasketController {
    func viewWillAppear()
}

class BasketControllerImpl : BasketController {
    private let interactor: BasketInteractor
    private let executor: Executor
    
    init(
        with interactor: BasketInteractor,
        executor: Executor = Executor()
        ) {
        self.interactor = interactor
        self.executor = executor
    }
    
    func viewWillAppear() {
        executor.run {
            self.interactor.loadBasket()
        }
        
    }
}
