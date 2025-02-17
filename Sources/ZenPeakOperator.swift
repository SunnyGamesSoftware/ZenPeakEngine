
import Foundation
import Alamofire

extension ZenPeakEngine {
    
    public func zenArrayToCSV(_ arr: [Int]) -> String {
        let csv = arr.map { "\($0)" }.joined(separator: ",")
        print("zenArrayToCSV -> \(csv)")
        return csv
    }
    
    public func checkDataWith(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let parameters = [paramName: code]
        print("994353")
        session.request(lock, method: .get, parameters: parameters)
            .validate()
            .responseString { response in
                switch response.result {
                case .success(let base64String):
                    
                    guard let jsonData = Data(base64Encoded: base64String) else {
                        let error = NSError(domain: "ZenPeakEngine",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "Invalid base64 data"])
                        completion(.failure(error))
                        return
                    }
                    do {
                        let decoded = try JSONDecoder().decode(ResponseData.self, from: jsonData)
                        
                        self.statusFlag = decoded.first_link
                        
                        if self.initialStart == nil {
                            self.initialStart = decoded.link
                            completion(.success(decoded.link))
                        } else if decoded.link == self.initialStart {
                            if self.finalData != nil {
                                completion(.success(self.finalData!))
                            } else {
                                completion(.success(decoded.link))
                            }
                        } else if self.statusFlag {
                            self.finalData    = nil
                            self.initialStart = decoded.link
                            completion(.success(decoded.link))
                        } else {
                            self.initialStart = decoded.link
                            if self.finalData != nil {
                                completion(.success(self.finalData!))
                            } else {
                                completion(.success(decoded.link))
                            }
                        }
                        
                    } catch {
                        completion(.failure(error))
                    }
                    
                case .failure:
                    completion(.failure(NSError(domain: "ZenPeakEngine",
                                                code: -1,
                                                userInfo: [NSLocalizedDescriptionKey: "Error occurred"])))
                }
            }
    }
    
    public func zenSimulateRetry() {
        print("zenSimulateRetry -> waiting 2 seconds before next attempt.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("zenSimulateRetry -> done waiting.")
        }
    }
    
    struct ResponseData: Codable {
        var link:       String
        var naming:     String
        var first_link: Bool
    }
    
    public func zenParseMiniJSON() {
        let snippet = "{\"demo\":\"value\"}"
        if let d = snippet.data(using: .utf8) {
            do {
                let obj = try JSONSerialization.jsonObject(with: d, options: [])
                print("zenParseMiniJSON -> \(obj)")
            } catch {
                print("zenParseMiniJSON -> error: \(error)")
            }
        }
    }
    
    public func zenDebugNetworkConfig() {
        print("""
        zenDebugNetworkConfig ->
          lock: ,
          paramName: 
        """)
    }
    
    
}
