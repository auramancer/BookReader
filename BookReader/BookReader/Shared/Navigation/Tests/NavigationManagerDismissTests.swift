import XCTest
@testable import BookReader

class NavigationManagerDismissTests: NavigationManagerTests {
  func testDismissNothing_WhenStackIsEmpty() {
    navigationHelper.schedule().dismiss().run()
    
    assert(navigationController, contains: [], presents: nil)
  }
  
  func testDismissSomthing_WhenStackIsEmpty() {
    navigationController.presentedViewController = vc1
    
    navigationHelper.schedule().dismiss().run()
    
    assert(navigationController, contains: [], presents: nil)
  }
  
  func testDismissNothing_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    navigationHelper.schedule().dismiss().run()
    
    assert(navigationController, contains: [vc1], presents: nil)
  }
  
  func testDismissSomething_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    navigationController.presentedViewController = vc2
    
    navigationHelper.schedule().dismiss().run()
    
    assert(navigationController, contains: [vc1], presents: nil)
  }
}
