//
//  CourseResponse.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import Foundation

// MARK: - CourseResponse
struct CourseResponse: Codable {
    let id: String?
    let title: String?
    let promoImage: String?
    let professorFullName: String?
    let professorImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, title, promoImage, professorFullName
        case professorImageURL = "professorImageUrl"
    }
}
