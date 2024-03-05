//
//  CKManager.swift
//  RealmCloudKitTest
//
//  Created by A_Mcflurry on 3/5/24.
//

import Foundation
import CloudKit
import RealmSwift

class CKManager {
	func DownloadDatabaseFromICloud()
	{
		 let fileManager = FileManager.default
		 // Browse your icloud container to find the file you want
		 if let icloudFolderURL = DocumentsDirectory.iCloudDocumentsURL,
			  let urls = try? fileManager.contentsOfDirectory(at: icloudFolderURL, includingPropertiesForKeys: nil, options: []) {

			  // Here select the file url you are interested in (for the exemple we take the first)
			  if let myURL = urls.first {
					// We have our url
					var lastPathComponent = myURL.lastPathComponent
					if lastPathComponent.contains(".icloud") {
						 // Delete the "." which is at the beginning of the file name
						 lastPathComponent.removeFirst()
						 let folderPath = myURL.deletingLastPathComponent().path
						 let downloadedFilePath = folderPath + "/" + lastPathComponent.replacingOccurrences(of: ".icloud", with: "")
						 var isDownloaded = false
						 while !isDownloaded {
							  if fileManager.fileExists(atPath: downloadedFilePath) {
									isDownloaded = true
									print("REALM FILE SUCCESSFULLY DOWNLOADED")
									self.copyFileToLocal()

							  }
							  else
							  {
									// This simple code launch the download
									do {
										 try fileManager.startDownloadingUbiquitousItem(at: myURL )
									} catch {
										 print("Unexpected error: \(error).")
									}
							  }
						 }


						 // Do what you want with your downloaded file at path contains in variable "downloadedFilePath"
					}
			  }
		 }
	}

	func copyFileToLocal() {
		 if isCloudEnabled() {
			  deleteFilesInDirectory(url: DocumentsDirectory.localDocumentsURL)
			  let fileManager = FileManager.default
			  let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.iCloudDocumentsURL!.path)
			  while let file = enumerator?.nextObject() as? String {

					do {
						 try fileManager.copyItem(at: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file), to: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file))

						 print("Moved to local dir")

						 //HERE ACCESSING DATA AVAILABLE IN REALM GET FROM ICLOUD
						 let realm =  ㄲㄷ미ㅡ()
						 let array = realm.FetchObjects(type: Mood.self)
						 print(array?.count)

					} catch let error as NSError {
						 print("Failed to move file to local dir : \(error)")
					}
			  }
		 }
	}

	func uploadDatabaseToCloudDrive()
	{
		 if(isCloudEnabled() == false)
		 {
			  self.iCloudSetupNotAvailable()
			  return
		 }

		 let fileManager = FileManager.default

		 self.checkForExistingDir()

		 let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents", isDirectory: true)

		 let iCloudDocumentToCheckURL = iCloudDocumentsURL?.appendingPathComponent("\(memberId)_default.realm", isDirectory: false)

		 let realmArchiveURL = iCloudDocumentToCheckURL//containerURL?.appendingPathComponent("MyArchivedRealm.realm")

		 if(fileManager.fileExists(atPath: realmArchiveURL?.path ?? ""))
		 {
			  do
			  {
					try fileManager.removeItem(at: realmArchiveURL!)
					print("REPLACE")
					let realm = try! Realm()
					try! realm.writeCopy(toFile: realmArchiveURL!)

			  }catch
			  {
					print("ERR")
			  }
		 }
		 else
		 {
			  print("Need to store ")
			  let realm = try! Realm()
			  try! realm.writeCopy(toFile: realmArchiveURL!)
		 }
	}
	func isCloudEnabled() -> Bool {
		 if DocumentsDirectory.iCloudDocumentsURL != nil { return true }
		 else { return false }
	}

	struct DocumentsDirectory {
		 static let localDocumentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last!
		 static let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
	}
}
