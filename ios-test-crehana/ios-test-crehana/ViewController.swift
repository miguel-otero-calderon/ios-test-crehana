//
//  ViewController.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let service = CourseService()
        service.getCourses(request: nil) { response, error in
            print(response)
        }
    }


}

