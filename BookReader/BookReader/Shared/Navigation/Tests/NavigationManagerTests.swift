import XCTest
@testable import BookReader

class NavigationManagerTests: XCTestCase {
  private var manager: NavigationManager!
  internal var navigationController: NavigationControllerSpy!
  private var window: UIWindow!
  
  let vc1 = ViewControllerSpy("1")
  let vc2 = ViewControllerSpy("2")
  let vc3 = ViewControllerSpy("3")
  let vc4 = ViewControllerSpy("4")
  let vc5 = ViewControllerSpy("5")
  
  override func setUp() {
    super.setUp()
    
    navigationController = NavigationControllerSpy()
    
    manager = NavigationManager()
  }
  
  var navigationHelper: NavigationHelper {
    return manager.navigationHelper(for: navigationController)
  }
  
  // MARK: Mixed
  
  func testSequence1() {
    navigationController.viewControllers = [vc1, vc2]
    navigationController.presentedViewController = vc3
    
    navigationHelper.schedule().dismiss().popToRoot().push(vc4).present(vc5).run()
    
    assert(navigationController, contains: [vc1, vc4], presents: vc5)
  }
  
  func assert(_ navigationController: UINavigationController,
              contains viewControllers: [UIViewController],
              presents presentedViewController: UIViewController?,
              file: StaticString = #file,
              line: UInt = #line) {
    XCTAssertEqual(navigationController.viewControllers, viewControllers, file: file, line: line)
    XCTAssertEqual(navigationController.presentedViewController, presentedViewController, file: file, line: line)
  }
  
  func assert(_ viewController: ViewControllerSpy, received data: String?, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(viewController.data, data, file: file, line: line)
  }
}
