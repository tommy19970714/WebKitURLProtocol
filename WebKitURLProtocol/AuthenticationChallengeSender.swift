//
//  AuthenticationChallengeSender.swift
//  WebKitURLProtcol
//
//  Created by 冨平準喜 on 2020/05/30.
//  Copyright © 2020 冨平準喜. All rights reserved.
//

import Foundation
import WebKit

class AuthenticationChallengeSender : NSObject, URLAuthenticationChallengeSender {
    
    typealias AuthenticationChallengeHandler = (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    
    let handler: AuthenticationChallengeHandler
    
    init(handler: @escaping AuthenticationChallengeHandler) {
        self.handler = handler
        super.init()
    }
    
    func use(_ credential: URLCredential, for challenge: URLAuthenticationChallenge) {
        handler(.useCredential, credential)
    }
    
    func continueWithoutCredential(for challenge: URLAuthenticationChallenge) {
        handler(.useCredential, nil)
    }

    func cancel(_ challenge: URLAuthenticationChallenge) {
        handler(.cancelAuthenticationChallenge, nil)
    }

    func performDefaultHandling(for challenge: URLAuthenticationChallenge) {
        handler(.performDefaultHandling, nil)
    }

    func rejectProtectionSpaceAndContinue(with challenge: URLAuthenticationChallenge) {
        handler(.rejectProtectionSpace, nil)
    }
}
