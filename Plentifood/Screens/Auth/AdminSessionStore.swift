//
//  AdminSessionStore.swift
//  Plentifood
//
//  Created by Mami on 2/6/26.
//

import Foundation

enum AdminSessionStore {
   private static let userIdKey = "admin_user_id"
   private static let usernameKey = "admin_username"
   private static let orgIdKey = "admin_org_id"

   static func save(userId: Int, username: String, organizationId: Int) {
      UserDefaults.standard.set(userId, forKey: userIdKey)
      UserDefaults.standard.set(username, forKey: usernameKey)
      UserDefaults.standard.set(organizationId, forKey: orgIdKey)
   }

   static func loadUserId() -> Int? {
      let id = UserDefaults.standard.integer(forKey: userIdKey)
      return id == 0 ? nil : id
   }

   static func loadUsername() -> String? {
      UserDefaults.standard.string(forKey: usernameKey)
   }

   static func loadOrganizationId() -> Int? {
      let id = UserDefaults.standard.integer(forKey: orgIdKey)
      return id == 0 ? nil : id
   }

   static func clear() {
      UserDefaults.standard.removeObject(forKey: userIdKey)
      UserDefaults.standard.removeObject(forKey: usernameKey)
      UserDefaults.standard.removeObject(forKey: orgIdKey)
   }
}

