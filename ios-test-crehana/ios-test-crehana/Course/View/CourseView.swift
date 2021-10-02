//
//  ViewController.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import UIKit

class CourseView: UIViewController {
    
    var viemModel: CourseViewModelProtocol = CourseViewModel(service: CourseService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viemModel.delegate = self
        viemModel.getCourses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension CourseView: CourseViewModelDelegate {
    func getCourses(courses: [Course]?, error: Error?) {
        if let courses = courses {
            print(courses)
        }
    }
}

