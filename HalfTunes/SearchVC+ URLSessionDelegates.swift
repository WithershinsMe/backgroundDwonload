//
//  SearchVC+ URLSessionDelegates.swift
//  HalfTunes
//
//  Created by GK on 2018/8/10.
//  Copyright © 2018年 Ray Wenderlich. All rights reserved.
//

import UIKit

extension SearchViewController: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    print("thread: \(Thread.current) Finished downloading to \(location).")
    
    //移动下载的临时文件到Documents目录
    guard let sourceURL = downloadTask.currentRequest?.url else { return }
    let download = downloadService.activeDownloads[sourceURL]
    downloadService.activeDownloads[sourceURL] = nil
    
    let destinationURL = localFilePath(for: sourceURL)
    print(destinationURL)
    
    let fileManager = FileManager.default
    try? fileManager.removeItem(at: destinationURL)
    do {
      try fileManager.copyItem(at: location, to: destinationURL)
      download?.track.downloaded = true
    } catch let error {
      print("Could not copy file to disk: \(error.localizedDescription)")
    }
    
    if let index = download?.track.index {
      DispatchQueue.main.async {
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
      }
    }
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    guard let url = downloadTask.currentRequest?.url, let download = downloadService.activeDownloads[url] else {
      return
    }
    
    download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    
    let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
    download.totalSize = totalSize
    DispatchQueue.main.async {
      if let trackCell = self.tableView.cellForRow(at: IndexPath(row: download.track.index, section: 0)) as? TrackCell {
        trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
      }
    }
  }
}

extension SearchViewController: URLSessionDelegate {
  // Standard background session handler

  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
      DispatchQueue.main.async {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
          let completionHandler = appDelegate.backgroundSessionCompletionHandler {
          appDelegate.backgroundSessionCompletionHandler = nil
          completionHandler()
        }
      }
    }
  }
}
