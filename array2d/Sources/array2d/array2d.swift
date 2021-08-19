func dim<T>(_ count: Int, _ value: T) -> [T] {
    return [T](repeating: value, count: count)
}

public struct Array2D<T> {
    public let columns: Int
    public let rows: Int
    fileprivate var array: [T]

    public init(columns: Int, rows: Int, initialValue: T) {
        self.columns = columns
        self.rows = rows
        array = .init(repeating: initialValue, count: rows * columns)
    }

    public subscript(column: Int, row: Int) -> T {
        get {
            precondition(0 <= column && column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(0 <= row && row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            return array[row * columns + column]
        }
        set {
            precondition(0 <= column && column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(0 <= row && row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            array[row * columns + column] = newValue
        }
    }
}