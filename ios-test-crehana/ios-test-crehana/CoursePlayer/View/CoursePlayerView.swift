//
//  CoursePlayerView.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import UIKit
import AVFoundation

class CoursePlayerView: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var detailCourseView: UIView!
    @IBOutlet weak var titleCourseLabel: UILabel!
    @IBOutlet weak var imageCourseView: UIImageView!
    @IBOutlet weak var teacherCourseLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pauseImage: UIImageView!
    @IBOutlet weak var back15: UIImageView!
    @IBOutlet weak var forward15: UIImageView!    
    
    var viewModel: CoursePlayerViewModelProtocol = CoursePlayerViewModel(service: CoursePlayerService())
    var lessons: [CoursePlayerLesson] = []
    var course: Course?
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(
            UINib(nibName: "CoursePlayerTableViewCell", bundle: nil),
            forCellReuseIdentifier: "CoursePlayerTableViewCell")
        
        viewModel.delegate = self
        tableView.dataSource = self
//        tableView.delegate = self        
        
        guard let course = course else {
            return
        }
        let request = CoursePlayerRequest(courseId: course.id)
        viewModel.getLessons(request: request)
        configure()
        
        let url = URL(string: "https://crehana-videos.akamaized.net/outputs/trailer/89ef7d652e4549709347f89aa7be0f57/1f68b3fffd1641c0b03d1457a53808d4.m3u8")
        player = AVPlayer(url: url!)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        
        videoView.layer.addSublayer(playerLayer)
    }
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
    }
    
    func configure() {
        guard let course = course else {
            return
        }

        self.titleCourseLabel.text = course.title
        self.imageCourseView.image = course.promoImage
        self.teacherCourseLabel.text = course.professorFullName
        self.teacherCourseLabel.textColor =  UIColor(red: 0.765, green: 0.796, blue: 0.839, alpha: 1)

        self.imageCourseView.frame = CGRect(x: 0, y: 0, width: 23.87, height: 24)
        self.imageCourseView.backgroundColor = .white
        self.imageCourseView.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.21, b: 0, c: 0, d: 1.12, tx: -0.11, ty: -0.06))
        self.imageCourseView.layer.bounds = view.bounds
        self.imageCourseView.layer.position = view.center
        self.imageCourseView.layer.cornerRadius = 12
    }
}

extension CoursePlayerView: CoursePlayerViewModelDelegate {
    func getLessons(lessons: [CoursePlayerLesson]?, error: Error?) {
        self.lessons = []
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        if let error = error {
            self.showError(message: error.localizedDescription)
            return
        }
        
        if let lessons = lessons {
            self.lessons = lessons
            print(self.lessons)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension CoursePlayerView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.lessons.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let lessonCell = self.tableView.dequeueReusableCell(withIdentifier: "CoursePlayerTableViewCell", for: indexPath) as? CoursePlayerTableViewCell
        
        let lesson = self.lessons[indexPath.row]
        lessonCell?.configure(lesson: lesson)
        
        return lessonCell!
    }
}
