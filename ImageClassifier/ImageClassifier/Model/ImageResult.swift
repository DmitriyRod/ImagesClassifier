//
//  ImageResult.swift
//  ImageClassifier
//
//  Created by Admin on 06.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct ImageResult {
  let identifier: String
  let confidence: Int
  
  var description: String {
    return "This is \(identifier) with \(confidence)% confidence"
  }
}
