//
//  CourseTableViewCell.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var promoImage: UIImageView!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        teacherLabel.textColor = UIColor(red: 0.765, green: 0.796, blue: 0.839, alpha: 1)
        
        lineView.layer.borderWidth = 1
        lineView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1).cgColor
        
        promoImage.layer.cornerRadius = 5.85
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(course: Course) {
        self.titleLabel.text = course.title
        self.teacherLabel.text = course.professorFullName
        self.promoImage.image = course.promoImage
    }
}
