//
//  CoursePlayerResponse.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import Foundation

// MARK: - CoursePlayerResponse
struct CoursePlayerResponse: Codable {
    let title: String?
    let url: String?
    let id: String?
    let courseId: String?

    enum CodingKeys: String, CodingKey {
        case title, url, id
        case courseId = "CourseId"
    }
}
