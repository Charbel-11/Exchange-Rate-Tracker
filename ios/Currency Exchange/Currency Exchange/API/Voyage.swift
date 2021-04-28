import Foundation

class Voyage {
    
    public func get<Response: Codable>(with url: URL,
                                    completion: @escaping(Response) -> Void,
                                    fail: @escaping(Error) -> Void,
                                    bearerToken: String? = nil) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = bearerToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                DispatchQueue.main.async {
                    fail(error)
                }
                
            } else if let safeData = data {
                
                if let response: Response = self.decodeResponse(from: safeData) {
                    DispatchQueue.main.async {
                        completion(response)
                    }
                }
                
            }
        }
        // Starting the task (it says resume() but it actually just starts it)
        task.resume()
    }
    
    public func post<Body: Codable, Response: Codable>(with url: URL,
                                    body: Body,
                                    completion: @escaping(Response) -> Void,
                                    fail: @escaping(Error) -> Void,
                                    bearerToken: String? = nil) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let token = bearerToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = encodeBody(from: body)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                DispatchQueue.main.async {
                    fail(error)
                }
                
            } else if let safeData = data {
                
                if let response: Response = self.decodeResponse(from: safeData) {
                    DispatchQueue.main.async {
                        completion(response)
                    }
                }
                
            }
        }
        task.resume()
        
        
    }
    
    private func encodeBody<Model: Codable>(from model: Model) -> Foundation.Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        do {
            let jsonData = try encoder.encode(model)
            return jsonData
        } catch {
            print(error)
            return nil
        }
    }
    
    private func decodeResponse<Model: Codable>(from data: Foundation.Data) -> Model? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedData = try decoder.decode(Model.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
}
