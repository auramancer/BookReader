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
  }
  
  var navigationHelper: NavigationHelper {
    return manager.navigationHelper(for: navigationController)
  }
  
  // MARK: Push
  
  func testPushOne_WhenStackIsEmpty() {
    navigationHelper.schedule().push(vc1).run()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  func testPushOne_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    navigationHelper.schedule().push(vc2).run()
    
    assertNavigationController(contains: [vc1, vc2], presents: nil)
  }

  func testPushMultiple_WhenStackIsEmpty() {
    navigationHelper.schedule().push(vc1).push(vc2).push(vc3).run()
    
    assertNavigationController(contains: [vc1, vc2, vc3], presents: nil)
  }
  
  // MARK: Pop
  
  func testPopOne_WhenStackIsEmpty() {
    navigationHelper.schedule().pop().run()
    
    assertNavigationController(contains: [], presents: nil)
  }
  
  func testPopOne_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    navigationHelper.schedule().pop().run()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  func testPopOne_WhenStackContainsMultiple() {
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    navigationHelper.schedule().pop().run()
    
    assertNavigationController(contains: [vc1, vc2], presents: nil)
  }
  
  func testPopMultiple_WhenStackContainsMultiple() {
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    navigationHelper.schedule().pop().pop().pop().run()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  // MARK: Pop to root
  
  func testPopToRoot_WhenStackIsEmpty() {
    navigationHelper.schedule().popToRoot().run()
    
    assertNavigationController(contains: [], presents: nil)
  }
  
  func testPopToRoot_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    navigationHelper.schedule().popToRoot().run()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  func testPopToRoot_WhenStackContainsMultiple() {
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    navigationHelper.schedule().popToRoot().run()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  // MARK: Pop to
  
  func testPopTo_WhenStackIsEmpty() {
    navigationHelper.schedule().popTo({ $0 == self.vc1 }).run()
    
    assertNavigationController(contains: [], presents: nil)
  }
  
  func testPopTo_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    navigationHelper.schedule().popTo({ $0 == self.vc1 }).run()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  func testPopTo_WhenStackContainsMultiple() {
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    navigationHelper.schedule().popTo({ $0 == self.vc2 }).run()
    
    assertNavigationController(contains: [vc1, vc2], presents: nil)
  }
  
  // MARK: Pop while
  
  func testPopWhile_WhenStackIsEmpty() {
    navigationHelper.schedule().popWhile({ $0 != self.vc1 }).run()
    
    assertNavigationController(contains: [], presents: nil)
  }
  
  func testPopWhile_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    navigationHelper.schedule().popWhile({ $0 != self.vc1 }).run()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  func testPopWhile_WhenStackContainsMultiple() {
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    navigationHelper.schedule().popWhile({ $0 != self.vc2 }).run()
    
    assertNavigationController(contains: [vc1, vc2], presents: nil)
  }
  
  // MARK: Present

  func testPresent_WhenStackIsEmpty() {
    navigationHelper.schedule().present(vc1).run()
    
    assertNavigationController(contains: [], presents: vc1)
  }

  func testPresent_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    navigationHelper.schedule().present(vc2).run()
    
    assertNavigationController(contains: [vc1], presents: vc2)
  }
  
  // MARK: Dismiss
  
  func testDismissNothing_WhenStackIsEmpty() {
    navigationHelper.schedule().dismiss().run()
    
    assertNavigationController(contains: [], presents: nil)
  }
  
  func testDismissSomthing_WhenStackIsEmpty() {
    navigationController.presentedViewController = vc1
    
    navigationHelper.schedule().dismiss().run()
    
    assertNavigationController(contains: [], presents: nil)
  }
  
  func testDismissNothing_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    navigationHelper.schedule().dismiss().run()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  func testDismissSomething_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    navigationController.presentedViewController = vc2
    
    navigationHelper.schedule().dismiss().run()
    
    assertNavigationController(contains: [vc1], presents: nil)
  }
  
  // MARK: Mixed
  
  func testSequence1() {
    navigationController.viewControllers = [vc1, vc2]
    navigationController.presentedViewController = vc3
    
    navigationHelper.schedule().dismiss().popToRoot().push(vc4).present(vc5).run()
    
    assertNavigationController(contains: [vc1, vc4], presents: vc5)
  }
  
  func assertNavigationController(contains viewControllers: [UIViewController],
                                  presents presentedViewController: UIViewController?,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
    XCTAssertEqual(navigationController.viewControllers, viewControllers, file: file, line: line)
    XCTAssertEqual(navigationController.presentedViewController, presentedViewController, file: file, line: line)
  }
}
