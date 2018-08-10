#  背景下载

     Enable background transfer
     
     这使得app处于backgrounded or crashes 时，也能继续执行backgroudn download task
     OS 维护了一个单独的线程去管理background transfer tasks
     当任务完成之后，这个进程在background重启app,app将重建background session,接收相关的完成信息，执行必要的操作
     When a task completes, the daemon will relaunch the app in the background. The re-launched app will re-create the background session, to receive the relevant completion delegate messages, and perform any required actions such as persisting downloaded files to disk.
     

     Note: If the user terminates the app by force-quiting from the app switcher, the system will cancel all of the session’s background transfers, and won’t attempt to relaunch the app.

     创建一个background Session
     Note: You must not create more than one session for a background configuration, because the system uses the configuration‘s identifier to associate tasks with the session.

    If a background task completes when the app isn’t running, the app will be relaunched in the background.
  
    application(_:handleEventsForBackgroundURLSession:) wakes up the app to deal with the completed background task. You need to handle two things in this method:
  
    First, the app needs to re-create the appropriate background configuration and session, using the identifier provided by this delegate method. But since this app creates the background session when it instantiates SearchViewController, you’re already reconnected at this point!
    Second, you’ll need to capture the completion handler provided by this delegate method. Invoking the completion handler tells the OS that your app’s done working with all background activities for the current session, and also causes the OS to snapshot your updated UI for display in the app switcher.
