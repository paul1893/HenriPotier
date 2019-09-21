import Foundation
import SwiftyJSON

class BasketParser : Parser {
    typealias T = BasketJSON?
    func parse(_ data: Data) throws -> BasketJSON? {
        do {
            guard let offersJSON = try JSON(data: data).dictionaryValue["offers"] else { return nil }
            let offers = offersJSON.arrayValue
            var basketJson = BasketJSON()
            offers.map({ (json) -> [String : JSON] in json.dictionaryValue }).forEach({ (offer) in
                guard let value = offer["value"]?.intValue else { return }
                guard let type = offer["type"]?.stringValue else { return }
                switch(type) {
                case "percentage":
                    basketJson.percentage = value
                    break
                case "minus":
                    basketJson.minus = value
                    break
                case "slice":
                    guard let sliceValue = offer["sliceValue"]?.intValue else { return }
                    basketJson.slice = SliceJSON(sliceValue: sliceValue, value: value)
                    break
                default: break
                }
            })
            return basketJson
            // TODO PBA T.U
        } catch {
            throw RepositoryError.parsingError
        }
    }
}

struct BasketJSON {
    var percentage: Int?
    var minus: Int?
    var slice: SliceJSON?
}

struct SliceJSON {
    var sliceValue: Int
    var value: Int
    
    init(
        sliceValue: Int,
        value: Int
        ) {
        self.sliceValue = sliceValue
        self.value = value
    }
}
