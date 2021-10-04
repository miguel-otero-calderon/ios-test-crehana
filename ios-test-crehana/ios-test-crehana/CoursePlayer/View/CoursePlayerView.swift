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
        tableView.delegate = self
        
        guard let course = course else {
            return
        }
        let request = CoursePlayerRequest(courseId: course.id)
        viewModel.getLessons(request: request)
        configure()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchHappen))
        videoView.isUserInteractionEnabled = true
        videoView.addGestureRecognizer(tap)
    }
    
    @objc func touchHappen() {
        
        pauseButton.isHidden = !pauseButton.isHidden
        backButton.isHidden = !backButton.isHidden
        forwardButton.isHidden = !forwardButton.isHidden
    
        pauseAction()
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
    
    lazy var goBackButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "goBack")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        
        button.addTarget(self, action: #selector(goBackAction), for: .touchUpInside)
        return button
    }()
  
    @objc func forwardAction() {
        guard let duration = player?.currentItem?.duration else {
            return
        }
        let currenTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currenTime + 15.0
        
        let totalSeconds = CMTimeGetSeconds(duration)
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

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.pauseButton.isHidden = true
                self.backButton.isHidden = true
                self.forwardButton.isHidden = true
            }
            
        }
        isPlaying = !isPlaying
    }
    
    @objc func goBackAction() {
        self.dismiss(animated: true) {
            self.player.replaceCurrentItem(with: nil)
        }
    }
    
    let controlsVideoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            controlsVideoView.backgroundColor = .clear
            goBackButton.isHidden = false
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
        guard let playerLayer = self.playerLayer else {
            return
        }
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
        
        guard let lessons = lessons, lessons.count > 0 else {
            return
        }
        
        self.lessons = lessons

        guard let url = URL(string: self.lessons[0].url) else {
            return
        }
        print("courseId: \(self.lessons[0].courseId) , title: \(self.lessons[0].title), url: \(url)")
        
        DispatchQueue.main.async {

            self.player = AVPlayer(url: url)
            
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer.videoGravity = .resize
            
            self.videoView.layer.addSublayer(self.playerLayer)
            
            self.player?.play()
            
            self.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: [.new], context: nil)
            
            self.controlsVideoView.frame = self.videoView.frame
            self.videoView.addSubview(self.controlsVideoView)
            
            self.controlsVideoView.addSubview(self.pauseButton)
            self.pauseButton.centerXAnchor.constraint(equalTo: self.videoView.centerXAnchor).isActive = true
            self.pauseButton.centerYAnchor.constraint(equalTo: self.videoView.centerYAnchor).isActive = true
            self.pauseButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
            self.pauseButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
            
            self.controlsVideoView.addSubview(self.backButton)
            self.backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
            self.backButton.heightAnchor.constraint(equalToConstant: 21.75).isActive = true
            self.backButton.centerYAnchor.constraint(equalTo: self.videoView.centerYAnchor).isActive = true
            self.backButton.leadingAnchor.constraint(equalTo: self.pauseButton.leadingAnchor, constant: -60).isActive = true
            
            self.controlsVideoView.addSubview(self.forwardButton)
            self.forwardButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
            self.forwardButton.heightAnchor.constraint(equalToConstant: 21.75).isActive = true
            self.forwardButton.centerYAnchor.constraint(equalTo: self.videoView.centerYAnchor).isActive = true
            self.forwardButton.trailingAnchor.constraint(equalTo: self.pauseButton.trailingAnchor, constant: 60).isActive = true

            self.controlsVideoView.addSubview(self.goBackButton)
            self.goBackButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
            self.goBackButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            self.tableView.reloadData()
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

extension CoursePlayerView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let lesson = self.lessons[indexPath.row]
        let url = URL(string: lesson.url)
        let playerItem = AVPlayerItem(url: url!)
        player.replaceCurrentItem(with: playerItem)
        isPlaying = false
        pauseAction()
        
        pauseButton.isHidden = true
        forwardButton.isHidden = true
        backButton.isHidden = true
    }
}
