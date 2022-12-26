import Foundation

extension String {

    init<T>(_ data: T) where T: RandomAccessCollection, T.Element == UInt16, T.Index == Int {
        self = data.map {
            [$0 >> 8, $0 & 0xFF].compactMap(Unicode.Scalar.init).map { String($0) }.joined()
        }.joined()
    }

    var raw: [UInt16] {
        let bytes = unicodeScalars.map { UInt8($0.value) }
        return stride(from: 0, to: bytes.count, by: 2).map {
            let high = UInt16(bytes[$0]) << 8
            guard $0 + 1 < bytes.count else {
                return high
            }
            let low = bytes[$0+1]
            return high | UInt16(low)
        }
    }
}
