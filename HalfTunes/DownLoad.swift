//
//  DownLoad.swift
//  HalfTunes
//
//  Created by GK on 2018/8/10.
//  Copyright © 2018年 Ray Wenderlich. All rights reserved.
//

import Foundation

class Download {
  var track: Track
  init(track: Track) {
    self.track = track
  }
  
  var task: URLSessionDownloadTask?
  var isDownloading = false
  var resumeData: Data?
  
  var progress: Float = 0
  var totalSize: String = ""
}
