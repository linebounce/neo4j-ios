//
//  Session.swift
//  Cory D. Wiles
//
//  Created by Cory D. Wiles on 9/11/14.
//  Copyright (c) 2014 Theo. All rights reserved.
//

import Foundation

open class Configuration {
  
    fileprivate let requestTimeout: Double  = 10
    fileprivate let resourceTimeout: Double = 20

    var sessionConfiguration: URLSessionConfiguration

    lazy fileprivate var cache: URLCache = {

    let memoryCacheLimit: Int = 10 * 1024 * 1024;
    let diskCapacity: Int = 50 * 1024 * 1024;

   /**
    * http://nsscreencast.com/episodes/91-afnetworking-2-0
    */

    let cache:URLCache = URLCache(memoryCapacity: memoryCacheLimit, diskCapacity: diskCapacity, diskPath: nil)
        return cache
    }()

    init() {

        let additionalHeaders: [String:String] = ["Accept": "application/json", "Content-Type": "application/json; charset=UTF-8"]

        self.sessionConfiguration = URLSessionConfiguration.default
        
        self.sessionConfiguration.requestCachePolicy         = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        self.sessionConfiguration.timeoutIntervalForRequest  = self.requestTimeout
        self.sessionConfiguration.timeoutIntervalForResource = self.resourceTimeout
        self.sessionConfiguration.httpAdditionalHeaders      = additionalHeaders
//        self.sessionConfiguration.URLCache                   = self.cache
    }
}

// TODO: Move all session request to utilize this delegate.
// Right now these are NOT called because I'm setting the URLCredential on the 
// session configuration
private class TheoTaskSessionDelegate: NSObject {
    
    // For Session based challenges
    @objc func URLSession(_ session: Foundation.URLSession, didReceiveChallenge challenge: URLAuthenticationChallenge, completionHandler: (Foundation.URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("session based challenge")
    }
    
    // For Session Task based challenges
    @objc func URLSession(_ session: Foundation.URLSession, task: URLSessionTask, didReceiveChallenge challenge: URLAuthenticationChallenge, completionHandler: (Foundation.URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("session task based challenge")    
    }
}

class Session {
  
    private static var __once: () = {
            Static.instance = Session(queue: SessionParams.queue)
        }()
  
    // MARK: Private methods

    fileprivate let sessionDescription = "com.graphstory.session"
    fileprivate struct Static {
        static var token : Int = 0
        static var instance : Session?
    }
    fileprivate let sessionDelegate: TheoTaskSessionDelegate = TheoTaskSessionDelegate()

    // MARK: open properties

    var session: URLSession
    var sessionDelegateQueue: OperationQueue = OperationQueue.main
    var configuration: Configuration = Configuration()
  
    // MARK: Structs and class vars

    struct SessionParams {
        static var queue: OperationQueue?
    }
  
    class var sharedInstance: Session {
    
        _ = Session.__once

        return Static.instance!
    }
  
    // MARK: Constructors
    
    /// Designated initializer
    ///
    /// The session delegate is set to nil and will use the "system" provided
    /// delegate
    ///
    /// - parameter NSOperationQueue?: queue
    /// - returns: Session
    required init(queue: OperationQueue?) {

        if let operationQueue = queue {
            self.sessionDelegateQueue = operationQueue
        }

        self.session = URLSession(configuration: configuration.sessionConfiguration, delegate: nil, delegateQueue: self.sessionDelegateQueue)

        self.session.sessionDescription = sessionDescription
    }
  
    /// Convenience initializer
    ///
    /// The operation queue param is set to nil which translates to using 
    /// NSOperationQueue.mainQueue
    ///
    /// - returns: Session
    convenience init() {
        self.init(queue: nil);
    }
}
