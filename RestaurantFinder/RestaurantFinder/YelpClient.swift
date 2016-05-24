
import Foundation
import UIKit


// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys


enum YelpSortMode: Int {
    case BestMatched = 0, Distance, HighestRated
}

class YelpClient: BDBOAuth1RequestOperationManager {
    
    var accessToken: String!
    var accessSecret: String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = NSURL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String, parameters: Dictionary<String, String>? = nil, offset: Int = 0, sort: Int = 1, limit: Int = 20, radius_filter: Int = 16093, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (operation: AFHTTPRequestOperation?, error: NSError!) -> Void) -> AFHTTPRequestOperation! {
        let params: NSMutableDictionary = [
            "term": term,
            "limit": limit,
            "radius_filter": radius_filter,
            "sort": sort
        ]
        for (key, value) in parameters! {
            params.setValue(value, forKey: key)
        }
        return self.GET("search", parameters: params, success: success, failure: failure)
    }
    
}