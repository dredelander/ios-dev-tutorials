import UIKit
import Foundation
import OSLog


class NetworkManager{
    var errorMessage = ""
    var hasError = false
    
    private let logger = Logger(subsystem: "RestAPICalls-IOS-Tutorial", category: "Network Manager")
    private var session: URLSession{
        let config = URLSessionConfiguration.default

        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 300

        let session = URLSession(configuration: config)
        
        return session
    }
    private var request: URLRequest{
        let url = URL(string: "https://ios17fundamentals.azurewebsites.net/api/improvements")!
        var request = URLRequest(url: url)
        request.setValue("KYk_sGbZ-38bXWFgoHqWP9yNwT7e2nHOid6r61KpCy7bAzFuZ1H5ig==", forHTTPHeaderField: "X-Functions-Key")
        return request
    }
    
    func getImprovementIdeas() async {
            
            do{
                let result = try await session.data(for: request)
                
                guard let response = result.1 as? HTTPURLResponse else {return}
                guard (200...299).contains(response.statusCode) else {
                    handleServerError(response.statusCode)
                    return
                }
                guard response.mimeType == "text/plain" else {return}
                
                
                let content = String(data:result.0, encoding: .utf8)}
        catch {
            handleClientError(error)
        }
        
    }
    
    func handleClientError(_ error: Error){
        self.errorMessage = error.localizedDescription
        self.hasError = true
        logger.error("\(self.errorMessage)")
    }
    
    func handleServerError(_ statusCode: Int){
        switch statusCode{
        case 500...599:
            self.errorMessage = "Something is wrong with the server"
            logger.error("\(self.errorMessage)")
        default:
            self.errorMessage = "Error: Status code \(statusCode)"
            logger.error("\(self.errorMessage)")
        }
        self.hasError = true
    }
}




// WAY TO HIT ENDPOINT PRIOR MAKING IN INTO A CLASS

let logger = Logger(subsystem: "RestAPICalls-IOS-Tutorial", category: "Playground")

/*
 API URL: https://ios17fundamentals.azurewebsites.net/api/improvements
 HTTP Header Field: X-Functions-Key
 API Key: KYk_sGbZ-38bXWFgoHqWP9yNwT7e2nHOid6r61KpCy7bAzFuZ1H5ig==
 */

//Checking for connectivity
let config = URLSessionConfiguration.default

config.waitsForConnectivity = true
config.timeoutIntervalForResource = 300

let session = URLSession(configuration: config)

let url = URL(string: "https://ios17fundamentals.azurewebsites.net/api/improvements")!
var request = URLRequest(url: url)
request.setValue("KYk_sGbZ-38bXWFgoHqWP9yNwT7e2nHOid6r61KpCy7bAzFuZ1H5ig==", forHTTPHeaderField: "X-Functions-Key")

Task.init {
    
    do{
        let result = try await session.data(for: request)
        
        guard let response = result.1 as? HTTPURLResponse else {return}
        guard (200...299).contains(response.statusCode) else {return}
        guard response.mimeType == "text/plain" else {return}
        
        let content = String(data:result.0, encoding: .utf8)}
    catch let error as URLError{
        print(error.code)
        print(error.localizedDescription)
    }
}
