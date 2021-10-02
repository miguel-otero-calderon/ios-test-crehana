//
//  Course.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import Foundation
import UIKit

struct Course {
    let id: String
    let title: String
    var promoImage: UIImage?
    let professorFullName: String
    var professorImage: UIImage?
    
    init(courseResponse: CourseResponse) {
        if let id = courseResponse.id {
            self.id = id
        } else {
            self.id = ""
        }
        
        if let title = courseResponse.title {
            self.title = title
        } else {
            self.title = ""
        }
    
        if let professorFullName = courseResponse.professorFullName {
            self.professorFullName = professorFullName
        } else {
            self.professorFullName = ""
        }
        
        self.promoImage = nil
        self.professorImage = nil
    }
}
