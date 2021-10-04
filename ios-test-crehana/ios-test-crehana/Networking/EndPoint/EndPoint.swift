//
//  EndPoint.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import Foundation
import Alamofire

protocol EndPoint {
    var baseURL: String { get }
    var path: String { get }
    var metohd: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
}
extension EndPoint {
    func toURL() -> URLConvertible {
        return baseURL + path
    }
}
