//
//  CoursePlayerView.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import UIKit
import AVFoundation

class CoursePlayerView: UIViewController {
    
    var viewModel: CoursePlayerViewModelProtocol = CoursePlayerViewModel(service: CoursePlayerService())
    var lessons: [CoursePlayerLesson] = []
    var course: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        guard let course = course else {
            return
        }
        let request = CoursePlayerRequest(courseId: course.id)
        viewModel.getLessons(request: request)
    }
}

extension CoursePlayerView: CoursePlayerViewModelDelegate {
    func getLessons(lessons: [CoursePlayerLesson]?, error: Error?) {
        if let lessons = lessons {
             print(lessons)
        }
    }
}
