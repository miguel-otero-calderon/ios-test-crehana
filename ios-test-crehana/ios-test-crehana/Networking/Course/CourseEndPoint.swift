//
//  CourseEndPoint.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import Foundation
import Alamofire

enum CourseEndPoint: EndPoint {
    
    case getCourses
    
    var baseURL: String {
        return "https://61572bb98f7ea60017985113.mockapi.io"
    }
    
    var path: String {
        switch self {
        case .getCourses:
            return "/api/v1/Course"
        }
    }
    
    var metohd: HTTPMethod {
        switch self {
        case .getCourses:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getCourses:
            return URLEncoding.default
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getCourses:
            return nil
        }
    }
}
