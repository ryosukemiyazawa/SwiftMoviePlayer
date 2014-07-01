//
//  MasterViewController.swift
//  MoviePlayer
//
//  Created by Ryosuke Miyazawa on 2014/06/23.
//  Copyright (c) 2014年 R.Miyazawa. All rights reserved.
//

import UIKit
import AVFoundation;
import CoreMedia;

class MovieEntry{
	
	var path : String?
	var title : String?
	var image : UIImage?
	
}

class MasterViewController: UITableViewController {

	var detailViewController: DetailViewController!
	var objects = NSMutableArray()
	var testValue : String?
	var fileManager : NSFileManager?
	var imageHelper : ImageHelper?

	override func awakeFromNib() {
		super.awakeFromNib()
		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
		    self.clearsSelectionOnViewWillAppear = false
		    self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
		}
		
		
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let split = self.splitViewController {
		    let controllers = split.viewControllers
		    self.detailViewController = controllers[controllers.endIndex-1].topViewController as? DetailViewController
		}
		
		if !self.testValue {
			println("\(self.testValue)");
			self.testValue = "200"
			println("\(self.testValue)");

		}
		
		
		self.loadData();
		
	}
	
	override func shouldAutorotate() -> Bool{
		return true;
	}
	
	override func supportedInterfaceOrientations() -> Int{
		return Int(UIInterfaceOrientationMask.Landscape.toRaw())
	}
	

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
		
	}

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

		let entry = objects[indexPath.row] as MovieEntry
		
		cell.imageView.image = entry.image;
		cell.textLabel.text = entry.title;
		
		
		return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
		    let object = objects[indexPath.row] as String
			self.detailViewController!.path = object
		}
	}
	
	//for stroyboard
	override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!){
		
		if(segue.identifier == "showDetail"){
			let destinationViewController = (((segue.destinationViewController as UINavigationController).topViewController as DetailViewController)) as DetailViewController;
			let indexPath = self.tableView.indexPathForSelectedRow()
			let entry = objects[indexPath.row] as MovieEntry;
			destinationViewController.path = entry.path
		}
		
	}
	
	func loadData(){
		//load local files
		let homeDir = NSHomeDirectory();
		
		let paths = NSSearchPathForDirectoriesInDomains(
			NSSearchPathDirectory.DocumentDirectory,
			NSSearchPathDomainMask.UserDomainMask,
			true
			) as String[];
		
		
		/*
		let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
		println(documentsPath)
		*/
		
		
		
		//let docDir = "/Users"
		let docDir = paths[0];
		
		//list up all files
		if let fileManager = fileManager {
			//do nothing
		}else{
			self.fileManager = NSFileManager()
		}
		var error : NSError?
		
		let contents = self.fileManager!.contentsOfDirectoryAtPath(docDir, error: &error) as String[];
		
		if(error){
			println("error");
		}else{
			for path in contents {
				let fullPath = docDir.stringByAppendingPathComponent(path);
				let entry = MovieEntry();
				entry.path = fullPath
				entry.image = createThumbnailFromPath(fullPath)
				entry.title = path.lastPathComponent
				objects.addObject(entry);
			}
		}
		
		//reload
		self.tableView.reloadData();
	}
	
	
	
	func createThumbnailFromPath(path: String) -> UIImage?{
		
		
		if let imageHelper = self.imageHelper{
			
		}else{
			self.imageHelper = ImageHelper();
		}
		
		return self.imageHelper!.createImageFromPath(path) as UIImage;
		
		/*
		let asset = AVURLAsset(URL: NSURL.URLWithString(path), options: nil)
		
		//check type of asset
		if (!asset.tracksWithMediaType(AVMediaTypeVideo)) {
			return nil;
		}
		
		let imageGen = AVAssetImageGenerator(asset:asset);
		imageGen.appliesPreferredTrackTransform = true;
		
		let durationSeconds = CMTimeGetSeconds(asset.duration);
		let midpoint = CMTimeMakeWithSeconds(0.0, 600);
 
		var error : NSError?
		var actualTimeObject = CMTimeMakeWithSeconds(durationSeconds/2.0, Int32(NSEC_PER_SEC));
		
		var imageRef = imageGen.copyCGImageAtTime(midpoint, actualTime:nil, error: &error);
		
		if(error){
			//NSLog("failed create image:%@ %f", error.description, actualTimeObject.value);
			return nil;
		}
		
		var image = UIImage(CGImage: imageRef);
		CGImageRelease(imageRef);

		return image;
		*/
		
	}


}

