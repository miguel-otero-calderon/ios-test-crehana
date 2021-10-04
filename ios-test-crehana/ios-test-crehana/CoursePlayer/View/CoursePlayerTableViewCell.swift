//
//  CoursePlayerTableViewCell.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import UIKit

class CoursePlayerTableViewCell: UITableViewCell {
    @IBOutlet weak var lessonTitleLabel: UILabel!
    @IBOutlet weak var detailLessonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(lesson: CoursePlayerLesson) {
        self.lessonTitleLabel.text = lesson.title
        self.detailLessonLabel.text = "3m 30s (10MB)"
    }
}
