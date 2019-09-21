struct Discount: Equatable {
    var percentage: Int?
    var minus: Int?
    var slice: Slice?
    
    init(percentage: Int?, minus: Int?, slice: Slice?) {
        self.percentage = percentage
        self.minus = minus
        self.slice = slice
    }
    
    func getBestDiscount(forPrice price: Int) -> Int {
        if let sliceValue = slice?.sliceValue,
            let value = slice?.value,
            price > sliceValue {
                let numberOfSlice = Int((Double(price)/Double(sliceValue)).rounded(.down))
                return [percentage, minus, numberOfSlice*value].compactMap({$0}).max() ?? 0
            }
        return [percentage, minus].compactMap({$0}).max() ?? 0
    }
}

struct Slice: Equatable {
    var sliceValue: Int
    var value: Int
    
    init(sliceValue: Int, value: Int) {
        self.sliceValue = sliceValue
        self.value = value
    }
}
