//
//  CourseService.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import Foundation
import Alamofire

protocol CourseServiceType {
    func getCourses(request: CourseRequest?, completion: @escaping ([CourseResponse]?, Error?) -> Void)
}
class CourseService: CourseServiceType {
    
    func getCourses(request: CourseRequest?, completion: @escaping ([CourseResponse]?, Error?) -> Void) {
        AF.request(
            CourseEndPoint.getCourses.toURL(),
            method: CourseEndPoint.getCourses.metohd)
            .response {[weak self] response in
                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        return
                    }
                    do {
                        let response = try JSONDecoder().decode([CourseResponse].self, from: data)
                        completion(response, nil)
                    } catch {
                        completion(nil,error)
                    }
                case .failure(let error):
                    completion(nil,error)
                }
            }
    }
}
