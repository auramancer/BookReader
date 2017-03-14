import XCTest
@testable import BookReader

class NavigationManagerTests: XCTestCase {
  private var manager: NavigationManager!
  private var navigationController: NavigationControllerSpy!
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
    manager.navigationController = navigationController
  }
  
  // MARK: Push
  
  func testPushOne_WhenStackIsEmpty() {
    manager.navigationHelper?.beginSchedule().push(vc1).endSchedule()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  func testPushOne_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    manager.navigationHelper?.beginSchedule().push(vc2).endSchedule()
    
    assertNavigationController(contains: [vc1, vc2], presents: nil)
  }

  func testPushMultiple_WhenStackIsEmpty() {
    manager.navigationHelper?.beginSchedule().push(vc1).push(vc2).push(vc3).endSchedule()
    
    assertNavigationController(contains: [vc1, vc2, vc3], presents: nil)
  }
  
  // MARK: Pop
  
  func testPopOne_WhenStackIsEmpty() {
    manager.navigationHelper?.beginSchedule().pop().endSchedule()
    
    assertNavigationController(contains: [], presents: nil)
  }
  
  func testPopOne_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    manager.navigationHelper?.beginSchedule().pop().endSchedule()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  func testPopOne_WhenStackContainsMultiple() {
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    manager.navigationHelper?.beginSchedule().pop().endSchedule()
    
    assertNavigationController(contains: [vc1, vc2], presents: nil)
  }
  
  func testPopMultiple_WhenStackContainsMultiple() {
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    manager.navigationHelper?.beginSchedule().pop().pop().pop().endSchedule()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  // MARK: Pop to root
  
  func testPopToRoot_WhenStackIsEmpty() {
    manager.navigationHelper?.beginSchedule().popToRoot().endSchedule()
    
    assertNavigationController(contains: [], presents: nil)
  }
  
  func testPopToRoot_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    manager.navigationHelper?.beginSchedule().popToRoot().endSchedule()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  func testPopToRoot_WhenStackContainsMultiple() {
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    manager.navigationHelper?.beginSchedule().popToRoot().endSchedule()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  // MARK: Pop to
  
  func testPopTo_WhenStackIsEmpty() {
    manager.navigationHelper?.beginSchedule().popTo({ $0 == self.vc1 }).endSchedule()
    
    assertNavigationController(contains: [], presents: nil)
  }
  
  func testPopTo_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    manager.navigationHelper?.beginSchedule().popTo({ $0 == self.vc1 }).endSchedule()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  func testPopTo_WhenStackContainsMultiple() {
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    manager.navigationHelper?.beginSchedule().popTo({ $0 == self.vc2 }).endSchedule()
    
    assertNavigationController(contains: [vc1, vc2], presents: nil)
  }
  
  // MARK: Pop while
  
  func testPopWhile_WhenStackIsEmpty() {
    manager.navigationHelper?.beginSchedule().popWhile({ $0 != self.vc1 }).endSchedule()
    
    assertNavigationController(contains: [], presents: nil)
  }
  
  func testPopWhile_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    manager.navigationHelper?.beginSchedule().popWhile({ $0 != self.vc1 }).endSchedule()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  func testPopWhile_WhenStackContainsMultiple() {
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    manager.navigationHelper?.beginSchedule().popWhile({ $0 != self.vc2 }).endSchedule()
    
    assertNavigationController(contains: [vc1, vc2], presents: nil)
  }
  
  // MARK: Present

  func testPresent_WhenStackIsEmpty() {
    manager.navigationHelper?.beginSchedule().present(vc1).endSchedule()
    
    assertNavigationController(contains: [], presents: vc1)
  }

  func testPresent_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    manager.navigationHelper?.beginSchedule().present(vc2).endSchedule()
    
    assertNavigationController(contains: [vc1], presents: vc2)
  }
  
  // MARK: Dismiss
  
  func testDismissNothing_WhenStackIsEmpty() {
    manager.navigationHelper?.beginSchedule().dismiss().endSchedule()
    
    assertNavigationController(contains: [], presents: nil)
  }
  
  func testDismissSomthing_WhenStackIsEmpty() {
    navigationController.presentedViewController = vc1
    
    manager.navigationHelper?.beginSchedule().dismiss().endSchedule()
    
    assertNavigationController(contains: [], presents: nil)
  }
  
  func testDismissNothing_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    manager.navigationHelper?.beginSchedule().dismiss().endSchedule()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  func testDismissSomething_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    navigationController.presentedViewController = vc2
    
    manager.navigationHelper?.beginSchedule().dismiss().endSchedule()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  // MARK: Mixed
  
  func testSequence1() {
    navigationController.viewControllers = [vc1, vc2]
    navigationController.presentedViewController = vc3
    
    manager.navigationHelper?.beginSchedule().dismiss().popToRoot().push(vc4).present(vc5).endSchedule()
    
    assertNavigationController(contains: [vc1, vc4], presents: vc5)
  }
  
  func assertNavigationController(contains viewControllers: [UIViewController],
                                  presents presentedViewController: UIViewController?) {
    XCTAssertEqual(navigationController.viewControllers, viewControllers)
    XCTAssertEqual(navigationController.presentedViewController, presentedViewController)
  }
}
