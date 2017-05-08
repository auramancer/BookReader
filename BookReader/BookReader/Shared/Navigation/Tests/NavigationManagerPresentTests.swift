import XCTest
@testable import BookReader

class NavigationManagerPresentTests: NavigationManagerTests {
  func testPresent_WhenStackIsEmpty() {
    navigationHelper.schedule().present(vc1).run()
    
    assert(navigationController, contains: [], presents: vc1)
  }
  
  func testPresent_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    navigationHelper.schedule().present(vc2).run()
    
    assert(navigationController, contains: [vc1], presents: vc2)
  }
  
  func testPassData_WhenPresenting() {
    let data = "present"
    
    navigationHelper.schedule().present(vc1, data: data).run()
    
    assert(vc1, received: data)
  }
}
