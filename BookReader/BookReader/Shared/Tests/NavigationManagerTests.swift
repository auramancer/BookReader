import XCTest
@testable import BookReader

class NavigationManagerTests: XCTestCase {
  private var manager: NavigationManager!
  private var navigationController: NavigationControllerSpy!
  
  let vc1 = ViewControllerSpy("1")
  let vc2 = ViewControllerSpy("2")
  let vc3 = ViewControllerSpy("3")
  
  override func setUp() {
    super.setUp()
    
    navigationController = NavigationControllerSpy()
    
    manager = NavigationManager()
    manager.navigationController = navigationController
  }
  
  func testPushOntoEmptyStack() {
    manager.navigationHelper?.beginSchedule().push(vc1).endSchedule()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  func testPushOnToAnotherViewController() {
    navigationController.viewControllers = [vc1]
    
    manager.navigationHelper?.beginSchedule().push(vc2).endSchedule()
    
    assertNavigationController(contains: [vc1, vc2], presents: nil)
  }

  func testPushMultipleViewControllers() {
    manager.navigationHelper?.beginSchedule().push(vc1).push(vc2).push(vc3).endSchedule()
    
    assertNavigationController(contains: [vc1, vc2, vc3], presents: nil)
  }
  
  func testPopEmptyStack() {
    manager.navigationHelper?.beginSchedule().pop().endSchedule()
    
    assertNavigationController(contains: [], presents: nil)
  }
  
  func testPopLastViewController() {
    navigationController.viewControllers = [vc1]
    
    manager.navigationHelper?.beginSchedule().pop().endSchedule()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  func testPresent() {
    navigationController.viewControllers = [vc1]
    
    manager.navigationHelper?.beginSchedule().present(vc2).endSchedule()
    
    assertNavigationController(contains: [vc1], presents: vc2)
  }
//
//  func testPresent() {
//    let vc = UIViewController()
//    
//    manager.navigationHelper?.beginSchedule().present(vc).endSchedule()
//    
//    XCTAssertTrue(navigationController.viewControllers.count == 1)
//  }
//  
//  func testDismiss() {
//    manager.navigationHelper?.beginSchedule().dismiss().endSchedule()
//    
//    XCTAssertTrue(navigationController.viewControllers.count == 1)
//  }
  
  func assertNavigationController(contains viewControllers: [UIViewController], presents presentedViewController: UIViewController?) {
    XCTAssertEqual(navigationController.viewControllers, viewControllers)
    XCTAssertEqual(navigationController.presentedViewController, presentedViewController)
  }
}
