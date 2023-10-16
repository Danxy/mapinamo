//
//  BasicAPI+Requests.swift
//  Mapinamo
//
//  Created by Daniel on 2023-10-12.
//

import Foundation
import Alamofire

typealias HeaderTuple = (key: String, value: String)

extension BasicAPI {
    
    func uploadMultipartData(
        path: String,
        data: @escaping (MultipartFormData) -> Void,
        completionHandler:  @escaping ((Bool, Error?) -> Void)
    ) {
        AF.upload(
            multipartFormData: data,
            to: endpoint(path),
            method: .post,
            headers: ["Content-type": "multipart/form-data", "Content-Disposition" : "form-data"])
            .uploadProgress(queue: .main, closure: { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON { response in
                completionHandler(true, nil)
            }
    }
    
    func post<K: Codable, V: Codable>(
        path: String,
        body: K? = nil,
        headers: [HeaderTuple]? = [("Accept","application/json")],
        completionHandler: @escaping ((V?, Error?) -> Void)) {
        
        var request = createRequest(path: path, httpMethod: .post)
        request.addBody(body, withEncoder: configuration.encoder)
        request.addHeaders(headers)
        
        requestWithDecodableResponse(request, completionHandler: completionHandler)
    }
    
    func get<V: Codable>(
        path: String,
        parameters: Parameters? = nil,
        headers: [HeaderTuple]? = [("Accept","application/json")],
        completionHandler:  @escaping (V?, Error?) -> Void) {
        var request = createRequest(path: path, httpMethod: .get)
        if parameters != nil {
            do {
                let encoding: ParameterEncoding = URLEncoding.default
                let encodedURLRequest = try encoding.encode(request, with: parameters)
                request = encodedURLRequest
            } catch { }
        }
        
        request.addHeaders(headers)
        requestWithDecodableResponse(request, completionHandler: completionHandler)
    }
    
    private func requestWithDecodableResponse<V: Codable>(
        _ request: URLRequest,
        completionHandler: @escaping ((V?, Error?) -> Void)) {
        
        AF.request(request)
            .validate(statusCode: 200...201)
            .responseDecodable(decoder: configuration.decoder, completionHandler: { (response: AFDataResponse<V>) in
                switch response.result {
                case .success(let data):
                    completionHandler(data, nil)
                case .failure(let error):
                    completionHandler(nil, self.getError(fromError: error, andResponse: response))
                }
            })
    }
    
    private func requestWithBooleanResponse(
        _ request: URLRequest,
        completionHandler: @escaping ((Bool, Error?) -> Void)) {
        
        AF.request(request)
            .validate(statusCode: 200...201)
            .responseData(completionHandler: { response in
                switch response.result {
                case .success:
                    completionHandler(true, nil)
                case .failure(let error):
                    completionHandler(false, self.getError(fromError: error, andResponse: response))
                }
            })
    }
    
    func post<K: Codable>(
        path: String,
        body: K? = nil,
        headers: [HeaderTuple]? = [("Accept","application/json")],
        completionHandler: @escaping ((Bool, Error?) -> Void)) {
        
        var request = createRequest(path: path, httpMethod: .post)
        request.addBody(body, withEncoder: configuration.encoder)
        request.addHeaders(headers)
        
        requestWithBooleanResponse(request, completionHandler: completionHandler)
    }
    
    func post(
        path: String,
        headers: [HeaderTuple]? = [("Accept","application/json")],
        completionHandler: @escaping ((Bool, Error?) -> Void)) {
        
        var request = createRequest(path: path, httpMethod: .post)
        request.addHeaders(headers)
        requestWithBooleanResponse(request, completionHandler: completionHandler)
    }
    
    func get(
        path: String,
        headers: [HeaderTuple]? = [("Accept","application/json")],
        completionHandler: @escaping ((Bool, Error?) -> Void)) {
        
        var request = createRequest(path: path, httpMethod: .get)
        request.addHeaders(headers)
        
        requestWithBooleanResponse(request, completionHandler: completionHandler)
    }
}

private extension BasicAPI {
    func createRequest(path: String, httpMethod: HTTPMethod) -> URLRequest {
        let url = endpoint(path)
        var request = URLRequest(url: URL(string: url)!)
        let delaySec = TimeInterval(15)
        request.timeoutInterval = delaySec
        request.httpMethod = httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func getError<V: Codable>(
        fromError error: Error,
        andResponse response: AFDataResponse<V>
    ) -> Error {
        
        let result = (error.isNetworkError() ? MError.networkError : nil)
            ?? decodeErrorResponse(fromResponse: response)
            ?? error
        
        return result
    }
    
    func decodeErrorResponse<V: Codable>(fromResponse response: AFDataResponse<V>) -> Error? {
        if let data = response.data, let statusCode = response.response?.statusCode, statusCode > 0 {
            do {
                let errorResponse = try self.configuration.decoder.decode(ErrorResponse.self, from: data)
                return MError.mError(
                    httpCode: statusCode,
                    code: errorResponse.code,
                    message: errorResponse.message )
            } catch {
                return MError.mError(
                    httpCode: statusCode,
                    code: ERROR_GENERAL_ERROR,
                    message: "Unknown Error" )
            }
        }
        return nil
    }
    
}

private extension Data {
    func printAsString() {
        print(String(data: self, encoding: .utf8) ?? "" )
    }
}

private extension URLRequest {
    mutating func addBody<K: Codable>(_ body: K?, withEncoder encoder: JSONEncoder) {
        guard let body = body else { return }
        do {
            self.httpBody = try encoder.encode(body)
        } catch (let error) {
            print("Can't encode body. Error: \(error)")
        }
    }
    
    mutating func addHeaders(_ headers: [HeaderTuple]?) {
        headers?.forEach { header in
            self.setValue(header.value, forHTTPHeaderField: header.key)
        }
    }
}

private extension Error {
    func isNetworkError() -> Bool {
        return (self as NSError).domain == "NSURLErrorDomain"
    }
}
