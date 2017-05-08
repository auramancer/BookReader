import XCTest
@testable import BookReader

class NavigationManagerPushTests: NavigationManagerTests {
  
  func testPushOne_WhenStackIsEmpty() {
    navigationHelper.schedule().push(vc1).run()
    
    assert(navigationController, contains: [vc1], presents: nil)
  }
  
  func testPushOne_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    navigationHelper.schedule().push(vc2).run()
    
    assert(navigationController, contains: [vc1, vc2], presents: nil)
  }
  
  func testPushMultiple_WhenStackIsEmpty() {
    navigationHelper.schedule().push(vc1).push(vc2).push(vc3).run()
    
    assert(navigationController, contains: [vc1, vc2, vc3], presents: nil)
  }
  
  func testPassData_WhenPushing() {
    let data = "push"
    
    navigationHelper.schedule().push(vc1, data: data).run()
    
    assert(vc1, received: data)
  }
}
