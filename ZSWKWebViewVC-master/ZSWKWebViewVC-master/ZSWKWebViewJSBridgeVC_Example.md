#  ZSWKWebViewJSBridgeVC_Example

``` swift
import UIKit

class BillProtocolWebVC: ZSWKWebViewVC {
    
    var billProtocol: BillProtocol?
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        if let filePath = Bundle.main.path(forResource: "trans_agreement", ofType: "html") {
            wkWebView.loadFileURL(URL(fileURLWithPath: filePath), allowingReadAccessTo: URL(fileURLWithPath: Bundle.main.bundlePath))
            
            javascriptBridge.registerHandler("inputPlateNum") { [weak self] (data, responseCallback) in
                responseCallback?(self?.billProtocol?.truckNo)
            }
            javascriptBridge.registerHandler("inputPhone") { [weak self] (data, responseCallback) in
                responseCallback?(self?.billProtocol?.mobile)
            }
            javascriptBridge.registerHandler("inputFirstParty") { [weak self] (data, responseCallback) in
                responseCallback?(self?.billProtocol?.partyA)
            }
            javascriptBridge.registerHandler("inputSecondParty") { [weak self] (data, responseCallback) in
                responseCallback?(self?.billProtocol?.partyB)
            }
            javascriptBridge.registerHandler("inputIdNum") { [weak self] (data, responseCallback) in
                responseCallback?(self?.billProtocol?.idCard)
            }
            javascriptBridge.registerHandler("inputYear") { [weak self] (data, responseCallback) in
                responseCallback?(self?.billProtocol?.year)
            }
            javascriptBridge.registerHandler("inputMonth") { [weak self] (data, responseCallback) in
                responseCallback?(self?.billProtocol?.month)
            }
            javascriptBridge.registerHandler("inputDay") { [weak self] (data, responseCallback) in
                responseCallback?(self?.billProtocol?.day)
            }
        }
        
    }
    
}

```



