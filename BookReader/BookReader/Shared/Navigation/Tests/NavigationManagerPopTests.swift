import XCTest
@testable import BookReader

class NavigationManagerPopTests: NavigationManagerTests {
  // MARK: Pop
  
  func testPopOne_WhenStackIsEmpty() {
    navigationHelper.schedule().pop().run()
    
    assert(navigationController, contains: [], presents: nil)
  }
  
  func testPopOne_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    navigationHelper.schedule().pop().run()
    
    assert(navigationController, contains: [vc1], presents: nil)
  }
  
  func testPopOne_WhenStackContainsMultiple() {
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    navigationHelper.schedule().pop().run()
    
    assert(navigationController, contains: [vc1, vc2], presents: nil)
  }
  
  func testPopMultiple_WhenStackContainsMultiple() {
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    navigationHelper.schedule().pop().pop().pop().run()
    
    assert(navigationController, contains: [vc1], presents: nil)
  }
  
  func testPassData_WhenPopping() {
    let data = "pop"
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    navigationHelper.schedule().pop(data: data).run()
    
    assert(vc2, received: data)
  }
  
  // MARK: Pop to root
  
  func testPopToRoot_WhenStackIsEmpty() {
    navigationHelper.schedule().popToRoot().run()
    
    assert(navigationController, contains: [], presents: nil)
  }
  
  func testPopToRoot_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    navigationHelper.schedule().popToRoot().run()
    
    assert(navigationController, contains: [vc1], presents: nil)
  }
  
  func testPopToRoot_WhenStackContainsMultiple() {
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    navigationHelper.schedule().popToRoot().run()
    
    assert(navigationController, contains: [vc1], presents: nil)
  }
  
  func testPassData_WhenPoppingToRoot() {
    let data = "popToRoot"
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    navigationHelper.schedule().popToRoot(data: data).run()
    
    assert(vc1, received: data)
  }
  
  // MARK: Pop to
  
  func testPopTo_WhenStackIsEmpty() {
    navigationHelper.schedule().popTo({ $0 == self.vc1 }).run()
    
    assert(navigationController, contains: [], presents: nil)
  }
  
  func testPopTo_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    navigationHelper.schedule().popTo({ $0 == self.vc1 }).run()
    
    assert(navigationController, contains: [vc1], presents: nil)
  }
  
  func testPopTo_WhenStackContainsMultiple() {
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    navigationHelper.schedule().popTo({ $0 == self.vc2 }).run()
    
    assert(navigationController, contains: [vc1, vc2], presents: nil)
  }
  
  // MARK: Pop while
  
  func testPopWhile_WhenStackIsEmpty() {
    navigationHelper.schedule().popWhile({ $0 != self.vc1 }).run()
    
    assert(navigationController, contains: [], presents: nil)
  }
  
  func testPopWhile_WhenStackContainsOne() {
    navigationController.viewControllers = [vc1]
    
    navigationHelper.schedule().popWhile({ $0 != self.vc1 }).run()
    
    assert(navigationController, contains: [vc1], presents: nil)
  }
  
  func testPopWhile_WhenStackContainsMultiple() {
    navigationController.viewControllers = [vc1, vc2, vc3]
    
    navigationHelper.schedule().popWhile({ $0 != self.vc2 }).run()
    
    assert(navigationController, contains: [vc1, vc2], presents: nil)
  }
}
