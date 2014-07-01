//
//  DetailViewController.swift
//  MoviePlayer
//
//  Created by Ryosuke Miyazawa on 2014/06/23.
//  Copyright (c) 2014年 R.Miyazawa. All rights reserved.
//

import UIKit
import MediaPlayer

class DetailViewController: UIViewController, UISplitViewControllerDelegate {

	@IBOutlet var detailDescriptionLabel: UILabel
	var masterPopoverController: UIPopoverController? = nil


	var path: String? {
		didSet {
			self.configureView()
			
		    if self.masterPopoverController != nil {
		        self.masterPopoverController!.dismissPopoverAnimated(true)
		    }
		}
	}
	
	var moviePlayerController : MPMoviePlayerController?
	

	func configureView() {
		
		if(!path){
			return
		}
		
		self.navigationItem.title = path?.lastPathComponent;
		
		let url = NSURL.fileURLWithPath(self.path);
		let player = MPMoviePlayerController(contentURL: url);
		self.moviePlayerController = player;
		
		if(player != nil){
			
			self.configurePlayer(player);
			player.contentURL = url;
			
			player.view.frame = self.view.bounds;
			self.view?.addSubview(player.view);
			
			
		}
		
		player.play();
		
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// #pragma mark - Split view

	func splitViewController(splitController: UISplitViewController, willHideViewController viewController: UIViewController, withBarButtonItem barButtonItem: UIBarButtonItem, forPopoverController popoverController: UIPopoverController) {
	    barButtonItem.title = "Master" // NSLocalizedString(@"Master", @"Master")
	    self.navigationItem.setLeftBarButtonItem(barButtonItem, animated: true)
	    self.masterPopoverController = popoverController
	}

	func splitViewController(splitController: UISplitViewController, willShowViewController viewController: UIViewController, invalidatingBarButtonItem barButtonItem: UIBarButtonItem) {
	    // Called when the view is shown again in the split view, invalidating the button and popover controller.
	    self.navigationItem.setLeftBarButtonItem(nil, animated: true)
	    self.masterPopoverController = nil
	}
	func splitViewController(splitController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
	    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
	    return true
	}
	
	func configurePlayer(player : MPMoviePlayerController){

		player.scalingMode = MPMovieScalingMode.AspectFit;
		player.repeatMode = MPMovieRepeatMode.One;
		player.shouldAutoplay = true;
		
		let center = NSNotificationCenter.defaultCenter();

		center.addObserver(self, selector:"finishPreload:", name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification, object:player);
		
		center.addObserver(self, selector:"finishPlayback:", name:MPMoviePlayerPlaybackDidFinishNotification, object:player);
		
	
	}
	
	func finishPreload(sender:NSNotification?){
		NSLog("finishPreload");
	}
	
	func finishPlayback(sender:NSNotification?){
		NSLog("finishPlayback");
	}

}

