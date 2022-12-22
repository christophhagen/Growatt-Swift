import Foundation

/**
 Internal functions used to decode values from the received register data
 */
extension RandomAccessCollection where Element == UInt16, Index == Int {

    func integer(at index: Int) -> Int {
        Int(get(index))
    }

    func float(int32At index: Int, scale: Float) -> Float {
        let high = get(index)
        let low = get(index+1)
        return .init(signedHigh: high, low: low, scale: scale)
    }

    func float(uint32At index: Int, scale: Float) -> Float {
        let high = get(index)
        let low = get(index+1)
        return .init(unsignedHigh: high, low: low, scale: scale)
    }

    func float(at index: Int, scale: Float) -> Float {
        .init(get(index), scale: scale)
    }

    private func part(_ range: ClosedRange<Int>) -> SubSequence {
        self[range.lowerBound+startIndex...range.upperBound+startIndex]
    }

    func range<T>(_ range: ClosedRange<Int>, conversion: (Self.SubSequence) -> T?) throws -> T {
        let values = part(range)
        guard let result = conversion(values) else {
            throw ContentError(value: values.first!, register: range.lowerBound)
        }
        return result
    }

    func range<T>(_ range: ClosedRange<Int>, conversion: (Self.SubSequence) -> T) -> T {
        let values = part(range)
        return conversion(values)
    }

    func date(in range: ClosedRange<Int>) -> Date? {
        Date(part(range))
    }

    func string(in range: ClosedRange<Int>) -> String {
        String(part(range))
    }

    func at<T>(_ index: Int, conversion: (UInt16) -> T?) throws -> T {
        let value = get(index)
        guard let result = conversion(value) else {
            throw ContentError(value: value, register: index)
        }
        return result
    }

    func at<T>(_ index: Int) throws -> T where T: RawRepresentable, T.RawValue == UInt16 {
        try at(index, conversion: T.init)
    }

    func at<T>(_ index: Int) -> T where T: DecodableEnum {
        .init(get(index))
    }

    func get<T>() -> T where T: DecodableRegister {
        at(T.register)
    }

    func bool(at index: Int) -> Bool {
        get(index) > 0
    }

    func get(_ index: Int) -> UInt16 {
        return self[startIndex + index]
    }
}
