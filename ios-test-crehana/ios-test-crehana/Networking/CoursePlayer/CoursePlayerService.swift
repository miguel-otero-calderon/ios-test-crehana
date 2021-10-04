//
//  CoursePlayerService.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import Foundation
import Alamofire

protocol CoursePlayerServiceProtocol{
    func getLessons(request: CoursePlayerRequest, completion: @escaping ([CoursePlayerResponse]?, Error?) -> Void)
}
class CoursePlayerService: CoursePlayerServiceProtocol {
    
    func getLessons(request: CoursePlayerRequest, completion: @escaping ([CoursePlayerResponse]?, Error?) -> Void) {
        let coursePlayerEndPoint = CoursePlayerEndPoint.getLessons(courseId: request.courseId)
        AF.request(
            coursePlayerEndPoint.toURL(),
            method: coursePlayerEndPoint.metohd)
            .response {[weak self] response in
                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        return
                    }
                    do {
                        let response = try JSONDecoder().decode([CoursePlayerResponse].self, from: data)
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
