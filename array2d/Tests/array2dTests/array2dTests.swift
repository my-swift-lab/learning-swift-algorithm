    import XCTest
    @testable import array2d

    final class array2dTests: XCTestCase {
        func test_2차원_배열_생성() {
            var cookies = [[Int]]()
            for _ in 1...9 {
                var row = [Int]()
                for _ in 1...7 {
                    row.append(0)
                }
                cookies.append(row)
            }

            let myCookie = cookies[3][6]
            XCTAssertEqual(myCookie, 0)
        }

        func test_배열생성자로_2차원_배열_생성() {
            let cookies = [[Int]](repeating: [Int](repeating: 0, count: 7), count: 9)
            let myCookie = cookies[3][6]
            XCTAssertEqual(myCookie, 0)
        }

        func test_dim함수로_2차원_배열_생성() {
            let cookies = dim(9, dim(7, 0))
            let myCookie = cookies[3][6]
            XCTAssertEqual(myCookie, 0)
        }

        func test_dim함수로_3차원_배열_생성() {
            let threeDimensions = dim(2, dim(3, dim(4, 0)))
            let element = threeDimensions[1][1][1]
            XCTAssertEqual(element, 0)
        }

        func testArray2D() {
            var cookies = Array2D(columns: 9, rows: 7, initialValue: 0)
            XCTAssertEqual(cookies.columns, 9)
            XCTAssertEqual(cookies.rows, 9)
        
            var myCookie = cookies[3, 6]
            XCTAssertEqual(myCookie, 0)
            cookies[3, 6] = 10
            myCookie = cookies[3, 6]
            XCTAssertEqual(myCookie, 10)
        }
    }
