import UIKit
import WebKit

class BrowserViewController: ViewController {
  @IBOutlet weak var addressField: UITextField!
  @IBOutlet weak var webViewContainer: UIView!
  var webView: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpWebView()
  }
  
  private func setUpWebView() {
    createWebView()
    addView(webView, to: webViewContainer)
  }
  
  private func createWebView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    
    if let url = load() {
      webView.load(URLRequest(url: url))
    }
  }
  
  @IBAction func loadRequest(_ sender: UITextField) {
    if let address = sender.text {
      let fullAddress = addPrefix(to: address)
  
      if let url = URL(string: fullAddress) {
        webView.load(URLRequest(url: url))
      }
    }
  }
  
  func save(_ url: URL) {
    UserDefaults.standard.set(url, forKey: "URL")
  }
  
  func load() -> URL? {
    return UserDefaults.standard.url(forKey: "URL")
  }
  
  private func addPrefix(to address: String) -> String {
    if address.hasPrefix("http://") || address.hasPrefix("https://") {
      return address
    }
    else {
      return "http://\(address)"
    }
  }
  
  @IBAction func download(_ sender: Any) {
    webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { (html, error) in
      guard let html = html as? String else { return }
      
      let urls = self.matches(of: "\"[^\"]*?[0-9]*\\.html", in: html)
      urls.forEach { print($0) }
    }
  }
  
  private func matches(of pattern: String, in text: String) -> [String] {
    do {
      let regularExpression = try NSRegularExpression(pattern: pattern)
      let nsString = text as NSString
      let results = regularExpression.matches(in: text, range: NSRange(location: 0, length: nsString.length))
      return results.map { nsString.substring(with: $0.range)}
    }
    catch {
      return []
    }
  }
}

extension BrowserViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    if let url = webView.url {
      save(url)
    }
  }
}
