//
//  MyError.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import Foundation
public enum MyError: Error {
    case customError
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .customError:
            return NSLocalizedString("Message of Error Custom", comment: "My error")
        }
    }
}
