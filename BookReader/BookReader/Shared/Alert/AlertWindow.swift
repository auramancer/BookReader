import UIKit

class AlertWindow: UIWindow {
  var backgroundViewController = AlertBackgroundViewController()
  var alert: Alert?
  
  var alertController: UIViewController? {
    get {
      return backgroundViewController.alertController
    }
    set {
      backgroundViewController.alertController = newValue
      newValue?.modalTransitionStyle = .crossDissolve
    }
  }
  
  init() {
    super.init(frame: UIApplication.shared.keyWindow!.bounds)
    
    backgroundColor = UIColor(white: 0, alpha: 0.1)
    rootViewController = backgroundViewController
    windowLevel = UIWindowLevelAlert
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func present() {
    backgroundViewController.window = self
    isHidden = false
  }
  
  func dismiss(completion: (()->Void)?) {
    if backgroundViewController.alertPresented {
      backgroundViewController.dismiss(animated: false) {
        completion?()
      }
    }
    else {
      completion?()
    }
  }
  
  func close() {
    isHidden = true
  }
}

class AlertBaseViewController: UIViewController {
  var mainNavigationController: UINavigationController? {
    return AlertManager.shared.navigationController
  }
  
  override var prefersStatusBarHidden: Bool {
    let mainNav = mainNavigationController
    let underneathViewController = mainNav?.presentedViewController ?? mainNav?.topViewController
    
    return underneathViewController?.prefersStatusBarHidden ?? false
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    let mainNav = mainNavigationController
    let underneathViewController = mainNav?.presentedViewController ?? mainNav?.topViewController
    
    return underneathViewController?.preferredStatusBarStyle ?? .default
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    let mainNav = mainNavigationController
    let underneathViewController = mainNav?.presentedViewController ?? mainNav
    
    return underneathViewController?.supportedInterfaceOrientations ?? .landscape
  }
}

class AlertBackgroundViewController: AlertBaseViewController {
  var alertController: UIViewController?
  var window: AlertWindow?
  var alertPresented = false
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    guard let window = window, !window.isHidden, let alertController = alertController else { return }

    present(alertController, animated: true) { [weak self] in
      self?.alertPresented = true
    }
  }
}
