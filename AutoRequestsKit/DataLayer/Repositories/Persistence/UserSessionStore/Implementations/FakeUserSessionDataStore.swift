//
//  FakeUserSessionDataStore.swift
//  AutoRequestsKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import Foundation
import PromiseKit

public class FakeUserSessionDataStore: UserSessionDataStore {

  // MARK: - Properties
  let hasToken: Bool

  // MARK: - Methods
  public init(hasToken: Bool) {
    self.hasToken = hasToken
  }

  public func save(userSession: UserSession) -> Promise<(UserSession)> {
    return .value(userSession)
  }

  public func delete(userSession: UserSession) -> Promise<(UserSession)> {
    return .value(userSession)
  }

  public func readUserSession() -> Promise<UserSession?> {
    switch hasToken {
    case true:
      return runHasToken()
    case false:
      return runDoesNotHaveToken()
    }
  }

  public func runHasToken() -> Promise<UserSession?> {
    let profile = UserProfile(id: "test", name: "Test User", mobileNumber: "+9 (999) 999-99-99")
    let remoteSession = RemoteUserSession(token: "000000")
    return .value(UserSession(profile: profile, remoteSession: remoteSession))
  }

  func runDoesNotHaveToken() -> Promise<UserSession?> {
    return .value(nil)
  }
}
