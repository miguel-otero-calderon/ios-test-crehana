//
//  CoursePlayerEndPoint.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import Foundation
import Alamofire

enum CoursePlayerEndPoint: EndPoint {
    
    case getLessons(courseId: String)
    
    var baseURL: String {
        return "https://61572bb98f7ea60017985113.mockapi.io"
    }
    
    var path: String {
        switch self {
        case .getLessons(let courseId):
            return "/api/v1/Course/\(courseId)/Video"
        }
    }
    
    var metohd: HTTPMethod {
        switch self {
        case .getLessons:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getLessons:
            return URLEncoding.default
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getLessons:
            return nil
        }
    }
}
