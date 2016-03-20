//
//  RecordedAudio.swift
//  PicthPerfect
//
//  Created by Latha Doddikadi on 3/3/16.
//  Copyright © 2016 demo. All rights reserved.
//
// This is the basic model that has the recorded audio passed between the segues
import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePath: NSURL, title: String){
        self.filePathUrl = filePath
        self.title = title
    }
}