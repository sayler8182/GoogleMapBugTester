import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var openUrlButton: UIButton!
    @IBOutlet weak var openMapButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func copyUrlButtonTouchUpInside(_ sender: UIButton) {
        let url = generateURL()
        debugLabel.text = "Url copied: " + url.absoluteString
        UIPasteboard.general.string = url.absoluteString
    }
    
    @IBAction func openMapButtonTouchUpInside(_ sender: UIButton) {
        let url = generateURL()
        debugLabel.text = url.absoluteString
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func generateURL() -> URL {
        var components = URLComponents()
        components.scheme = "comgooglemaps"
        components.host = ""
        components.queryItems = getQueryItems().URLQueryItems()

        guard let url = components.url else {
            fatalError("Not possible to create callbackUrl from URLComponents")
        }
        print("Generated:")
        print(url.absoluteString)
        return url
    }
    
    private func getQueryItems() -> [GoogleMapsQueryItem] {
        let lat = 56.674676171943425
        let lng = 12.852880892572248
        let center = "\(lat),\(lng)"
        
        return [.init(key: .daddr, value: center),
                .init(key: .center, value: center),
                .init(key: .directionsMode, value: .walking)]
    }
}

// MARK: GoogleMapsQueryItem
private struct GoogleMapsQueryItem {
    public enum Key: String {
        case daddr
        case center
        case directionsMode = "directionsmode"
    }

    public enum Value: String {
        case walking
    }
    
    let key: Key
    let value: String?
    
    public init(key: Key, value: String?) {
        self.key = key
        self.value = value
    }
    
    public init(key: Key, value: Value) {
        self.key = key
        self.value = value.rawValue
    }
}

// MARK: [GoogleMapsQueryItem]
private extension Sequence where Element == GoogleMapsQueryItem {
    func URLQueryItems() -> [URLQueryItem] {
        return compactMap { URLQueryItem(name: $0.key.rawValue, value: $0.value) }
    }
}
