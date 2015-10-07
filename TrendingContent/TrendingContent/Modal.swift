//
//  Modal.swift
//  TrendingContent
//
//  Created by Prakash Gupta on 20/06/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import Foundation

class Feed : NSObject, JSONJoy, NSCoding {
    var image: String?
    var published: String?
    var link: String?
    var desc: String?
    var title: String?
    var trends: String?
    var htmlCode: String?
    
    var kind: String?
    var artist: String?
    
    var userInfo: Any?
    
    override init() {
        
    }
    
    required init(_ decoder: JSONDecoder) {
        image = decoder["image"].string
        if image == nil {
            image = decoder["image_url"].string
        }
        published = decoder["published"].string
        link = decoder["link"].string
        desc = decoder["description"].string
        title = decoder["title"].string
        trends = decoder["trends"].string
        htmlCode = decoder["code"].string
        
        kind = decoder["type"].string
        artist = decoder["artist"].string
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.title = decoder.decodeObjectForKey("title") as? String
        self.trends = decoder.decodeObjectForKey("trends") as? String
        self.image = decoder.decodeObjectForKey("image") as? String
        self.link = decoder.decodeObjectForKey("link") as? String
        self.published = decoder.decodeObjectForKey("published") as? String
        self.desc = decoder.decodeObjectForKey("description") as? String
        self.htmlCode = decoder.decodeObjectForKey("htmlCode") as? String
        
        self.kind = decoder.decodeObjectForKey("type") as? String
        self.artist = decoder.decodeObjectForKey("artist") as? String
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.trends, forKey: "trends")
        coder.encodeObject(self.image, forKey: "image")
        coder.encodeObject(self.link, forKey: "link")
        coder.encodeObject(self.published, forKey: "published")
        coder.encodeObject(self.desc, forKey: "description")
        coder.encodeObject(self.htmlCode, forKey: "htmlCode")
        
        coder.encodeObject(self.kind, forKey: "type")
        coder.encodeObject(self.artist, forKey: "artist")
    }
}

struct BusinessFeeds {
    var feeds: [Feed]
    
    init() {
        feeds = Array<Feed>()
    }
    
    init(_ decoder: JSONDecoder) {
        feeds = Array<Feed>()
        if let fs = decoder["result"]["Business-feeds"].array {
            for f in fs {
                feeds.append(Feed(f))
            }
        }
    }
}

struct EntertainmentFeeds {
    var feeds: [Feed]
    
    init() {
        feeds = Array<Feed>()
    }
    
    init(_ decoder: JSONDecoder) {
        feeds = Array<Feed>()
        if let fs = decoder["result"]["Entertainment-feeds"].array {
            for f in fs {
                feeds.append(Feed(f))
            }
        }
    }
}

struct LifestyleFeeds {
    var feeds: [Feed]
    
    init() {
        feeds = Array<Feed>()
    }
    
    init(_ decoder: JSONDecoder) {
        feeds = Array<Feed>()
        if let fs = decoder["result"]["Lifestyle-feeds"].array {
            for f in fs {
                feeds.append(Feed(f))
            }
        }
    }
}

struct NewsFeeds {
    var feeds: [Feed]
    
    init() {
        feeds = Array<Feed>()
    }
    
    init(_ decoder: JSONDecoder) {
        feeds = Array<Feed>()
        if let fs = decoder["result"]["News-feeds"].array {
            for f in fs {
                feeds.append(Feed(f))
            }
        }
    }
}

struct SportsFeeds {
    var feeds: [Feed]
    
    init() {
        feeds = Array<Feed>()
    }
    
    init(_ decoder: JSONDecoder) {
        feeds = Array<Feed>()
        if let fs = decoder["result"]["Sports-feeds"].array {
            for f in fs {
                feeds.append(Feed(f))
            }
        }
    }
}

struct TwitterFeeds {
    var feeds: [Feed]
    
    init() {
        feeds = Array<Feed>()
    }
    
    init(_ decoder: JSONDecoder) {
        feeds = Array<Feed>()
        if let fs = decoder["result"]["twitter-trends"].array {
            for f in fs {
                feeds.append(Feed(f))
            }
        }
    }
}

struct YoutubeFeeds {
    var feeds: [Feed]
    
    init() {
        feeds = Array<Feed>()
    }
    
    init(_ decoder: JSONDecoder) {
        feeds = Array<Feed>()
        if let fs = decoder["result"]["youtube-trends"].array {
            for f in fs {
                feeds.append(Feed(f))
            }
        }
    }
}

struct SocialFeeds {
    var feeds: [Feed]
    
    init() {
        feeds = Array<Feed>()
    }
    
    init(_ decoder: JSONDecoder) {
        feeds = Array<Feed>()
        if let fs = decoder["result"]["social"].array {
            for f in fs {
                feeds.append(Feed(f))
            }
        }
    }
}

struct TopFeeds {
    var feeds: [Feed]
    
    init() {
        feeds = Array<Feed>()
    }
    
    init(_ decoder: JSONDecoder) {
        feeds = Array<Feed>()
        if let fs = decoder["result"]["top3-trends"].array {
            for f in fs {
                feeds.append(Feed(f))
            }
        }
    }
}

