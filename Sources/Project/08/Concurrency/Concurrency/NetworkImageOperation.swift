import UIKit

/// Should take either a `String` representing a  URL or an actual `URL`
/// Should download the data at the specified URL
/// If a `URLSession`-type completion handler is provided, use that instead of decoding
/// If successful. tthere's no completion handler and it's an image, should set an optional `UIImage` value.

final class NetworkImageOperation: AsyncOperation {
  var image: UIImage?
  
  private let url: URL
  private let completion: ((Data?, URLResponse?, Error?) -> Void)?
  
  init(url: URL, completion: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
    self.url = url
    self.completion = completion
    
    super.init()
  }
  
  convenience init?(string: String, completion: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
    guard  let url = URL(string: string) else {
      return nil
    }
    self.init(url: url, completion: completion)
  }
  
  override func main() {
    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      guard let self = self else { return }
      defer { self.state = .finished }
      
      if let completion = self.completion {
        completion(data, response, error)
        return
      }
      
      guard error == nil, let data = data else { return }
      
      self.image = UIImage(data: data)
    }.resume()
  }
}
