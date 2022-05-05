import Foundation
import SwiftUI
import CryptoKit

//MARK: Array

public extension Array where Element == String {
    
    public func hashValues() -> String {
        var valueString = ""
        for each in 0..<self.count {
            valueString.append(self[each])
        }
        let hash = SHA256.hash(data: String(valueString).data(using: .utf8)!)
        return(hash.hexStr)
    }
    
    public func useAsKeyValues() -> String {
        var valueString = ""
        for each in 0..<self.count {
            valueString.append(self[each])
        }
        return(valueString)
    }
}

//MARK: Data

public extension Data {
    public func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

//MARK: Date

public extension Date {
    public var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

//MARK: Digest

public extension Digest {
    public var bytes: [UInt8] { Array(makeIterator()) }
    public var data: Data { Data(bytes) }
    public var hexStr: String {
        bytes.map { String(format: "%02X", $0) }.joined()
    }
}

//MARK: Double

public extension Double {

    public var asBNBAmount:String {
        func asBNB() -> String {
            //let number = self/pow(10,18)
            var convertedDouble = String(format: "%0.2f", self)
                let decimalPoint = convertedDouble.firstIndex(of: ".")!
                let totalZeroes = convertedDouble.distance(from: decimalPoint, to: convertedDouble.endIndex)
                if totalZeroes == 2 {
                    convertedDouble.insert("0", at: convertedDouble.endIndex)
                }
                let dollars = convertedDouble[..<decimalPoint]
                switch dollars.count {
                case 4...5: convertedDouble = convertedDouble.addCommas(positions: [-6])
                case 6...8: convertedDouble = convertedDouble.addCommas(positions: [-6,-10])
                case 9...12: convertedDouble = convertedDouble.addCommas(positions: [-6,-10,-14])
                default: convertedDouble = String(format: "%0.2f", self)
                }
            let dollarString = ("\(convertedDouble) BNB")
            return dollarString
        }
        return asBNB()
    }
    
    public var asDollarAmount:String {
        func asDollar() -> String {
            let number = self
            var convertedDouble = String(format: "%0.2f", number)
                let decimalPoint = convertedDouble.firstIndex(of: ".")!
                let totalZeroes = convertedDouble.distance(from: decimalPoint, to: convertedDouble.endIndex)
                if totalZeroes == 2 {
                    convertedDouble.insert("0", at: convertedDouble.endIndex)
                }
                let dollars = convertedDouble[..<decimalPoint]
                switch dollars.count {
                case 4...5: convertedDouble = convertedDouble.addCommas(positions: [-6])
                case 6...8: convertedDouble = convertedDouble.addCommas(positions: [-6,-10])
                case 9...12: convertedDouble = convertedDouble.addCommas(positions: [-6,-10,-14])
                default: convertedDouble = String(format: "%0.2f", self)
                }
            let dollarString = ("$\(convertedDouble)")
            return dollarString
        }
        return asDollar()
    }
    
    public func asFractionalDollarAmount(places:Int=7) -> String {
        let number = self
        var convertedDouble = String(format: "%0.\(places)f", number)
        let decimalPoint = convertedDouble.firstIndex(of: ".")!
        let totalZeroes = convertedDouble.distance(from: decimalPoint, to: convertedDouble.endIndex)
        if totalZeroes == 2 {
            convertedDouble.insert("0", at: convertedDouble.endIndex)
        }
        let dollars = convertedDouble[..<decimalPoint]
        switch dollars.count {
        case 4...5: convertedDouble = convertedDouble.addCommas(positions: [-6])
        case 6...8: convertedDouble = convertedDouble.addCommas(positions: [-6,-10])
        case 9...12: convertedDouble = convertedDouble.addCommas(positions: [-6,-10,-14])
        default: convertedDouble = String(format: "%0.\(places)f", self)
        }
        let dollarString = ("$\(convertedDouble)")
        return dollarString
    }
    
    public var asPercent:String {
        func asPercent() -> String {
            let number = self * 100
            let convertedDouble = String(format: "%0.2f",number)
            let percentString = "\(convertedDouble)%"
            return percentString
        }
        return asPercent()
    }
}

//MARK: String

public extension String {
    
    public func addCommas(positions:[Int]) -> String {
        var text = self
        for each in 0..<positions.count {
            text.insert(",", at: (text.index(text.endIndex, offsetBy: positions[each])))
        }
        return text
    }
    
    public func shortenAddress(front:Int=5,end:Int=4) -> String {
        var returnString = ""
        if self.count == 42 && self.dropLast(40) == "0x" {
            let prefix = self.dropLast(42 - front)
            let suffix = self.dropFirst(42 - end)
            returnString =  String("\(prefix)...\(suffix)")
        } else if self == "" {
            returnString = "No address provided."
        } else {
            returnString = "Address isn't formatted correctly."
        }
        return returnString
    }
    
    
    public func asMoralisABI(params:[AnyObject] = [AnyObject]()) -> String {
        let prefix = "{\"abi\":"
        var suffix = ""
        if params.isEmpty {
            suffix = ",\"params\": {}}"
        } else {
            suffix = ",\"params\": {\(params)}}"
        }
        return String("\(prefix)\(self)\(suffix)")
    }
}

//MARK: Int

public extension Int {
    
    public var asDollarAmount:String {
        func asDollar() -> String {
            let baseInt = self
            var convertedInt = String(baseInt)
            switch convertedInt.count {
            case 4...6: convertedInt = convertedInt.addCommas(positions: [-3])
            case 7...9: convertedInt = convertedInt.addCommas(positions: [-3,-7])
            case 10...12: convertedInt = convertedInt.addCommas(positions: [-3,-7,-11])
            default: convertedInt = String(format: "%0.2f", self)
            }
            let dollarString = ("$\(convertedInt)")
            return dollarString
        }
        return asDollar()
    }
    
    public var asString:String {
        return String(self)
    }
    
}
