//
//  ViewController.swift
//  RealmCloudKitTest
//
//  Created by A_Mcflurry on 3/5/24.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

	var personData: Results<Person>!
	let realm = try! Realm()
	override func viewDidLoad() {
		super.viewDidLoad()


	 personData = realm.objects(Person.self)


	}

	@IBAction func insertData(_ sender: UIButton) {
		try! realm.write {
			let newData = Person()
			newData.name = "\(Int.random(in: 0...100000))"
			realm.add(newData)
		}
	}
	
	@IBAction func clickButton(_ sender: UIButton) {
		print(personData)
	}
}

