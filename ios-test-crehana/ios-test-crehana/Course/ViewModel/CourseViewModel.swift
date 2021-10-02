//
//  CourseViewModel.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import Foundation
import UIKit

protocol CourseViewModelProtocol: AnyObject {
    func getCourses()
    
    var delegate: CourseViewModelDelegate? {get set}
    var service: CourseServiceProtocol { get }
    var courses: [Course] { get }
}

protocol CourseViewModelDelegate: AnyObject {
    func getCourses(courses: [Course]?, error: Error?)
}

class CourseViewModel: CourseViewModelProtocol {
    
    var courses: [Course]
    var service: CourseServiceProtocol
    var delegate: CourseViewModelDelegate?
    
    private let cachePromoImage = NSCache<NSString, UIImage>()
    
    init(service: CourseServiceProtocol) {
        self.service = service
        self.courses = []
    }
    
    func getCourses() {
        self.service.getCourses(request: nil) {[weak self] response, error in
            
            self?.courses = []
            
            if let error = error {
                self?.delegate?.getCourses(courses: nil, error: error)
                return
            }
                        
            if let coursesResponse = response {
                for courseResponse in coursesResponse {
                    
                    var course = Course(courseResponse: courseResponse)
                    
                    let id = course.id as NSString
                    
                    if let cacheImage = self?.cachePromoImage.object(forKey: id) {
                        course.promoImage = cacheImage
                        print("CACHE: \(course.id)")
                    } else {
                        if let promoImage = courseResponse.promoImage {
                            if let urlPromoImage = URL(string: promoImage) {
                                if let dataPromoImage = try? Data(contentsOf: urlPromoImage) {
                                    if let image = UIImage(data: dataPromoImage) {
                                        course.promoImage = image
                                        print("SERVICE: \(course.id)")
                                        self?.cachePromoImage.setObject(image, forKey: id)
                                    }
                                }
                            }
                        }
                    }
                    
                    self?.courses.append(course)
                    self?.delegate?.getCourses(courses: self?.courses, error: nil)
                }
            }
        }
    }
}
