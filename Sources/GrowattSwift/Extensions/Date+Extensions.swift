import Foundation

extension Date {

    init?<T>(_ data: T) where T: RandomAccessCollection, T.Element == UInt16, T.Index == Int {
        let components = DateComponents(
            year:   Int(data[data.startIndex]),
            month:  Int(data[data.startIndex+1]),
            day:    Int(data[data.startIndex+2]),
            hour:   Int(data[data.startIndex+3]),
            minute: Int(data[data.startIndex+4]),
            second: Int(data[data.startIndex+5]))
        guard let date = Calendar.current.date(from: components) else {
            return nil
        }
        self = date
    }
}
