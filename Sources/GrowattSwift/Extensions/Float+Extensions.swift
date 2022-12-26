import Foundation

extension Float {

    init(_ value: UInt16, scale: Float) {
        self = Float(value) / scale
    }

    init?(_ value: UInt16, in range: ClosedRange<Float>, scale: Float) {
        self.init(value, scale: scale)
        guard range.contains(self) else {
            return nil
        }
    }

    func raw(scale: Float) -> UInt16 {
        UInt16((self * scale).rounded())
    }

    init(signedHigh high: UInt16, low: UInt16, scale: Float) {
        let unsigned = UInt32(high) << 16 + UInt32(low)
        let value = Int32(bitPattern: unsigned)
        self = Float(value) / scale
    }

    init(unsignedHigh high: UInt16, low: UInt16, scale: Float) {
        let value = UInt32(high) << 16 + UInt32(low)
        self = Float(value) / scale
    }
}
