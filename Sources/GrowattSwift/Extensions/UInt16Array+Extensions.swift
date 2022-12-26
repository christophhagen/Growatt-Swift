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

extension MutableCollection where Element == UInt16, Index == Int {

    mutating func write(_ value: String, in range: ClosedRange<Int>) {
        write(value.raw, in: range)
    }

    mutating func write(_ values: [UInt16], in range: ClosedRange<Int>) {
        for (offset, element) in values.prefix(range.count).enumerated() {
            write(element, at: range.lowerBound + offset)
        }
    }

    mutating func write<T>(_ value: T) where T: DecodableRegister {
        write(value.rawValue, at: T.register)
    }

    mutating func write(_ value: UInt16, at index: Int) {
        self[startIndex + index] = value
    }

    mutating func write(_ value: Float, at index: Int, scale: Float) {
        write(value.raw(scale: scale), at: index)
    }

    mutating func write(_ value: Bool, at index: Int) {
        write(value ? 1 : 0, at: index)
    }

    mutating func write(_ value: Int, at index: Int) {
        write(UInt16(value), at: index)
    }

    mutating func write(_ value: Date, in range: ClosedRange<Int>) {
        write(value.raw, in: range)
    }
}
