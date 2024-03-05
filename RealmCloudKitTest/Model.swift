//
//  Model.swift
//  RealmCloudKitTest
//
//  Created by A_Mcflurry on 3/5/24.
//

import Foundation
import RealmSwift
import CloudKit
import IceCream
//class Dog: Object {
//	 @objc dynamic var id = NSUUID().uuidString
//	 @objc dynamic var name = ""
//	 @objc dynamic var age = 0
//	 @objc dynamic var isDeleted = false
//	 @objc dynamic var avatar: CreamAsset?
//
//	init(name: String = "", age: Int = 0, isDeleted: Bool = false, avatar: CreamAsset? = nil) {
//		self.name = name
//		self.age = age
//		self.isDeleted = isDeleted
//		self.avatar = avatar
//	}
//	
//	required init() {
//		fatalError("init() has not been implemented")
//	}
//}

class Person: Object {
	@objc dynamic var id = NSUUID().uuidString
	@objc dynamic var name: String = ""
	@objc dynamic var isDeleted = false

	override class func primaryKey() -> String? {
			  return "id"
		 }
}

extension Person: CKRecordConvertible & CKRecordRecoverable { }
