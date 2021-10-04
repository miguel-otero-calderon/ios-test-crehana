//
//  CoursePlayerViewModel.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import Foundation
import UIKit

protocol CoursePlayerViewModelProtocol: AnyObject {
    func getLessons(request: CoursePlayerRequest)
    
    var delegate: CoursePlayerViewModelDelegate? {get set}
    var service: CoursePlayerServiceProtocol { get }
}

protocol CoursePlayerViewModelDelegate: AnyObject {
    func getLessons(lessons: [CoursePlayerLesson]?, error: Error?)
}

class CoursePlayerViewModel: CoursePlayerViewModelProtocol {
                   
    var service: CoursePlayerServiceProtocol
    var delegate: CoursePlayerViewModelDelegate?
    
    init(service: CoursePlayerServiceProtocol) {
        self.service = service
    }
    
    func getLessons(request: CoursePlayerRequest) {
        self.service.getLessons(request: request) { [weak self] response, error in
            
            var lessons:[CoursePlayerLesson] = []
            
            if let error = error {
                self?.delegate?.getLessons(lessons: nil, error: error)
                return
            }
            
            if let coursesPlayerResponse = response {
                for coursePlayerResponse in coursesPlayerResponse {
                    
                    let lesson = CoursePlayerLesson(coursePlayerResponse: coursePlayerResponse)
                    
                    lessons.append(lesson)
                }
                self?.delegate?.getLessons(lessons: lessons, error: nil)
            }
        }
    }
}
