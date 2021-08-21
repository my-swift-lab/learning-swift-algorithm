import XCTest
@testable import bitset

public struct BitSet {
    private(set) public var size: Int

    private let N = 64
    public typealias Word = UInt64
    fileprivate(set) public var words: [Word]

    public init(size: Int) {
        precondition(size > 0)
        self.size = size

        // 64의 배수로 만들기
        let n = (size + (N - 1)) / N
        words = [Word](repeating: 0, count: n)
    }

    // position이 [Word] 배열 중 어디 인덱스에 포함되어 있는지 검사한다.
    // (position이 속한 [Word] 배열에서 Word 인덱스, position이 1로 set 되었을 때의 값)
    // position은 0부터 시작(2^0은 1이므로)
    // 예) indexOf(3) -> (0, 2^3 = 8)
    private func indexOf(_ position: Int) -> (Int, Word) {
        precondition(position >= 0)
        precondition(position < size)
        let o = position / N
        let m = Word(position - o*N)
        return (o, 1 << m)
    }

    // 해당 위치의 비트를 1로 설정한다.
    public mutating func set(at position: Int) {
        let (j, m) = indexOf(position)
        words[j] |= m
    }

    // 해당 위치의 비트를 0으로 설정한다.
    public mutating func clear(at position: Int) {
        let (j, m) = indexOf(position)
        words[j] &= ~m
    }

    // 해당 위치의 비트가 1로 설정되어 있는지 검사한다.
    public func isSet(at position: Int) -> Bool {
        let (j, m) = indexOf(position)
        return (words[j] & m) != 0
    }

    // subscript 지원. 좀 더 쉽게 설정 및 클리어
    public subscript(position: Int) -> Bool {
        get { return isSet(at: position) }
        set { newValue ? set(at: position) : clear(at: position) }
    }

    // 해당 위치의 비트를 0이면 1로, 1이면 0으로 flip한다.
    public mutating func flip(at position: Int) -> Bool {
        let (j, m) = indexOf(position)
        words[j] ^= m
        return (words[j] & m) != 0
    }
}

// Debugging
extension UInt64 {
    // little-endian 순으로 비트를 화면에 출력한다. LSB가 제일 처음 출력된다.
    // 숫자 1의 비트는 1000 이 출력된다.
    public func bitsToString() -> String {
        var s = ""
        var n = self
        for _ in 1...64 {
            s += ((n & 1 == 1) ? "1" : "0")
            n >>= 1
        }
        return s
    }
}

extension BitSet: CustomStringConvertible {
    public var description: String {
        var s = ""
        for x in words {
            s += x.bitsToString()
        }
        return s
    }
}

final class bitsetTests: XCTestCase {
    func test_BitSet_생성() {
        let bits = BitSet(size: 140)

        // 140비트이면 총 3개(192bit)의 Word가 필요하다.
        XCTAssertEqual(bits.words.count, 3)
    }

    func test_BitSet_비트출력() {
        let bits = BitSet(size: 4)
        XCTAssertEqual(bits.description, BitSet.Word(0).bitsToString())
    }

    func test_BitSet_비트설정_1() {
        var bits = BitSet(size: 64)
        bits.set(at: 0)
        XCTAssertEqual(bits.description, BitSet.Word(1).bitsToString())

        bits = BitSet(size: 64)
        bits.set(at: 1)
        XCTAssertEqual(bits.description, BitSet.Word(2).bitsToString())

        bits = BitSet(size: 64)
        bits.set(at: 2)
        XCTAssertEqual(bits.description, BitSet.Word(4).bitsToString())
    }

    func test_BitSet_비트설정_2() {
        var bits = BitSet(size: 64)
        bits.set(at: 0)
        XCTAssertEqual(bits.description, BitSet.Word(1).bitsToString())

        bits.set(at: 1)
        XCTAssertEqual(bits.description, BitSet.Word(3).bitsToString())

        bits.set(at: 2)
        XCTAssertEqual(bits.description, BitSet.Word(7).bitsToString())
    }

    func test_BitSet_비트클리어() {
        var bits = BitSet(size: 64)
        bits.set(at: 0)
        bits.set(at: 1)
        bits.set(at: 2)
        XCTAssertEqual(bits.description, BitSet.Word(7).bitsToString())

        bits.clear(at: 1)
        XCTAssertEqual(bits.description, BitSet.Word(5).bitsToString())
    }

    func test_BitSet_비트설정_검사() {
        var bits = BitSet(size: 64)
        bits.set(at: 0)
        bits.set(at: 1)
        bits.set(at: 2)
        bits.clear(at: 1)

        XCTAssertTrue(bits.isSet(at: 0))
        XCTAssertTrue(bits.isSet(at: 2))
        XCTAssertFalse(bits.isSet(at: 1))
    }

    func test_BitSet_비트설정_subscript() {
        var bits = BitSet(size: 64)
        bits[0] = true
        bits[1] = true
        bits[2] = true
        XCTAssertEqual(bits.description, BitSet.Word(7).bitsToString())

        bits[1] = false
        XCTAssertEqual(bits.description, BitSet.Word(5).bitsToString())
    }

    func test_BitSet_비트_뒤집기() {
        var bits = BitSet(size: 64)
        bits[1] = true
        let result = bits.flip(at: 1)
        XCTAssertEqual(result, false)
        XCTAssertEqual(bits.description, BitSet.Word(0).bitsToString())
    }
}
