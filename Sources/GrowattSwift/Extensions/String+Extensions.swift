import Foundation

extension String {

    init<T>(_ data: T) where T: RandomAccessCollection, T.Element == UInt16, T.Index == Int {
        self = data.map {
            [$0 >> 8, $0 & 0xFF].compactMap(Unicode.Scalar.init).map { String($0) }.joined()
        }.joined()
    }
}
