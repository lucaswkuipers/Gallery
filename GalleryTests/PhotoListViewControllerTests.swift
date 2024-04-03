import XCTest
@testable import Gallery

final class PhotoListViewControllerTests: XCTestCase {
    func testViewDidLoad_callsOutputCorrectly() {
        // Given
        let outputSpy = OutputSpy()
        let sut = PhotoListViewController()
        sut.output = outputSpy

        // When
        sut.viewDidLoad()

        // Then
        XCTAssertEqual(outputSpy.receivedMessages, [.onViewDidLoad])
    }

    private final class OutputSpy: PhotoListViewControllerOutput {
        private(set) var receivedMessages: [Message] = []

        enum Message: Equatable {
            case onViewDidLoad
            case onTapTryAgain
            case onReachBottom
        }

        func onViewDidLoad() {
            receivedMessages.append(.onViewDidLoad)
        }
        
        func onTapTryAgain() {
            receivedMessages.append(.onTapTryAgain)
        }
        
        func onReachBottom() {
            receivedMessages.append(.onReachBottom)
        }
    }
}
