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
    
    var viewModel: CoursePlayerViewModelProtocol = CoursePlayerViewModel(service: CoursePlayerService())
    var lessons: [CoursePlayerLesson] = []
    var course: Course?
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(
            UINib(nibName: "CoursePlayerTableViewCell", bundle: nil),
            forCellReuseIdentifier: "CoursePlayerTableViewCell")
        
        viewModel.delegate = self
        tableView.dataSource = self
        
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
        
        player?.play()
        
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: [.new], context: nil)
        
        controlsVideoView.frame = videoView.frame
        videoView.addSubview(controlsVideoView)
        
        controlsVideoView.addSubview(pauseButton)
        pauseButton.centerXAnchor.constraint(equalTo: videoView.centerXAnchor).isActive = true
        pauseButton.centerYAnchor.constraint(equalTo: videoView.centerYAnchor).isActive = true
        pauseButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        pauseButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        controlsVideoView.addSubview(backButton)
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 21.75).isActive = true
        backButton.centerYAnchor.constraint(equalTo: videoView.centerYAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: pauseButton.leadingAnchor, constant: -60).isActive = true
        
        controlsVideoView.addSubview(forwardButton)
        forwardButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        forwardButton.heightAnchor.constraint(equalToConstant: 21.75).isActive = true
        forwardButton.centerYAnchor.constraint(equalTo: videoView.centerYAnchor).isActive = true
        forwardButton.trailingAnchor.constraint(equalTo: pauseButton.trailingAnchor, constant: 60).isActive = true
    }
    
    lazy var pauseButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        
        button.addTarget(self, action: #selector(pauseAction), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "back15")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return button
    }()
    
    lazy var forwardButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "forward15")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        
        button.addTarget(self, action: #selector(forwardAction), for: .touchUpInside)
        return button
    }()
  
    @objc func forwardAction() {
        guard let duration = player?.currentItem?.duration else {
            return
        }
        let currenTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currenTime + 15.0
        
        let totalSeconds = CMTimeGetSeconds(duration) - 15.0
        if newTime < totalSeconds {
            let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
            player.seek(to: time)
        }
    }
    
    @objc func backAction() {
        let currenTime = CMTimeGetSeconds(player.currentTime())
        var newTime = currenTime - 15.0
        
        if newTime < 0 {
            newTime = 0
        }
        
        let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
        player.seek(to: time)
    }
    
    @objc func pauseAction() {
        if isPlaying {
            player?.pause()
            pauseButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            player?.play()
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    let controlsVideoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            controlsVideoView.backgroundColor = .clear
            pauseButton.isHidden = false
            backButton.isHidden = false
            forwardButton.isHidden = false
            isPlaying = true
        }
    }
    
    func getTimeString(time: CMTime) -> String {
        let cmTimeGetSeconds = CMTimeGetSeconds(time)
        let hours = Int(cmTimeGetSeconds/3600)
        let minutes = Int(cmTimeGetSeconds/60) % 60
        let seconds = Int(cmTimeGetSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        } else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
