//
//  CoursePlayerLesson.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import Foundation
import UIKit

struct CoursePlayerLesson {
    let title: String
    let url: String
    let id: String
    let courseId: String
    
    internal init(coursePlayerResponse: CoursePlayerResponse) {
        if let title = coursePlayerResponse.title {
            self.title = title
        } else {
            self.title = ""
        }

        if let url = coursePlayerResponse.url {
            self.url = url
        } else {
            self.url = ""
        }
        
        if let id = coursePlayerResponse.id {
            self.id = id
        } else {
            self.id = ""
        }
        
        if let courseId = coursePlayerResponse.courseId {
            self.courseId = courseId
        } else {
            self.courseId = ""
        }
    }
}
