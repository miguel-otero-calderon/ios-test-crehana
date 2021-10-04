//
//  ViewController.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import UIKit

class CourseView: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viemModel: CourseViewModelProtocol = CourseViewModel(service: CourseService())
    var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(
            UINib(nibName: "CourseTableViewCell", bundle: nil),
            forCellReuseIdentifier: "CourseTableViewCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.viemModel.delegate = self
        self.viemModel.getCourses()
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
        
        self.courses = []
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
        
        if let error = error {
            self.showError(message: error.localizedDescription)
            return
        }
    
        if let courses = courses {
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension CourseView: UITableViewDataSource {    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.courses.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let courseCell = self.tableView.dequeueReusableCell(withIdentifier: "CourseTableViewCell", for: indexPath) as? CourseTableViewCell
        
        let course = self.courses[indexPath.row]
        courseCell?.configure(course: course)
        
        return courseCell!
    }
}

extension CourseView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let course = self.courses[indexPath.row]
        DispatchQueue.main.async {
            let coursePlayerView = self.storyboard?.instantiateViewController(withIdentifier: "CoursePlayerView") as! CoursePlayerView
            coursePlayerView.course = course
            
            self.present(coursePlayerView, animated: true, completion: nil)
        }
    }
}
