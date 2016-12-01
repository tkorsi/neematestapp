//
//  NTJsonParser.swift
//  NeemaTestApp
//
//  Created by User on 12/1/16.
//  Copyright © 2016 Iegor Shapanov. All rights reserved.
//

import Foundation

enum ParsingStatus {
    case stopped, parsing, succeed, aborted, failed;
}

protocol NTFeedParserDelegate {
    func feedParser(_ parser: NTJsonParser, successfullyParsedURL url: String, withObjects: [[String:String]])
    func feedParser(_ parser: NTJsonParser, parsingFailedReason reason: String)
    func feedParserParsingAborted(_ parser: NTJsonParser)
}

class NTJsonParser: NSObject {
    
    // MARK: Constants 
    let NAME = "name"
    let DATA = "data"
    
    var delegate: NTFeedParserDelegate?
    
    var feedURL: String
    var parsingStatus: ParsingStatus
    var feedRawContents: Data?
    var feedParser: JSON?
    
    init(feedURL: String) {
        self.feedURL = feedURL
        self.parsingStatus = .stopped
    }
    
    func reset() {
        if (parsingStatus == .parsing) {
            feedParser = nil
        }
        parsingStatus = .stopped
    }
    
    func abortParsing() {
        if (parsingStatus == .parsing) {
            feedParser = nil
        }
        parsingStatus = .aborted
        delegate?.feedParserParsingAborted(self)
    }
    
    func parse() {
        if (parsingStatus == .parsing) {
            delegate?.feedParser(self, parsingFailedReason: NSLocalizedString("another_parsing_in_process", comment:""))
            return
        }
        self.reset()
        
        // Request the feed and start parsing.
        
        if (feedRawContents == nil) { // already downloaded content?
            if let url = URL(string: self.feedURL) {
                feedRawContents = try? Data(contentsOf: url)
            }
        }
        // retrieve content and start parsing.
        feedParser = JSON(data: feedRawContents!)
        
        if (feedParser == nil) { // unable to retrieve content
            self.parsingStatus = .failed
            self.delegate?.feedParser(self, parsingFailedReason: NSString(format: "%@: %@", NSLocalizedString("unable_retrieve_feed_contents",comment: ""), self.feedURL) as String)
        } else {
            self.parsingStatus = .parsing
            self._parse()
        }
    }
    
    // NT parsing business logic
    
    func _parse() {
        var items = [[String:String]]()
        for result in feedParser! {
            let (_, json) = result
            let name = json[NAME].stringValue
            let website = json["website"].stringValue
            items.append([NAME: name, DATA: website])
        }
        self.delegate?.feedParser(self, successfullyParsedURL: self.feedURL, withObjects: items)
    }
    
}
