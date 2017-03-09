//
//  ViewController.swift
//  NetWorking
//
//  Created by planB on 9/3/17.
//  Copyright © 2017 Ioannis. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    
   
override func viewDidLoad() {
    super.viewDidLoad()
    searchingFor("basket")
    
}



func searchingFor(_ searchString:String){
    let chiefExecutive = AFHTTPSessionManager()
    
    //DICTIONARY  for the parameters
    let flickrParameters:[String:Any] = ["method": "flickr.photos.search",
                                         "api_key": "2d5a478ea8237ce5ac9b89790c8d00e2",
                                         "format": "json",
                                         "nojsoncallback": 1,
                                         "text": searchString,
                                         "extras": "url_m",
                                         "per_page": 5]
    
    chiefExecutive.get("https://api.flickr.com/services/rest/",
                       parameters: flickrParameters,//all the parameters
        progress: nil,
        success: { (operation: URLSessionDataTask, responseObject: Any?) in
            if let responseObject = responseObject {
                print("Response: " + (responseObject as AnyObject).description)
                if let photos = (responseObject as AnyObject)["photos"]  as? [String: AnyObject]{//type Any? has no subsript members?????
                    if let arrayOfPics =  photos["photo"] as? [[String: AnyObject]]{
                        self.scrollImages.contentSize = CGSize(width: 320, height: 320*CGFloat(arrayOfPics.count))
                        //here I enter in an array so I enumerate
                        for(i, dictionaryOfEachPic) in arrayOfPics.enumerated(){//dictionaryOfEachPic??????
                            if let stringOfTheURL = dictionaryOfEachPic["url_m"] as? String {
                                let picData = NSData(contentsOf: URL(string: stringOfTheURL)!)
                                if let unwrappedData = picData {
                                    let picView = UIImageView(image: UIImage(data:unwrappedData as Data))
                                    picView.frame = CGRect(x: 0, y: 320*CGFloat(i), width:320, height: 320)
                                    //let picView = UIImageView(frame: CGRect(x: 0, y: 320*CGFloat(i), width:320, height: 320))
                                    // if let url = URL(string: stringOfTheURL){
                                    // picView.setImageWith(url)
                                    self.scrollImages.addSubview(picView)
                                    
                                }
                            }
                        }
                    }
                }
            }
            
            
    }) {(operation: URLSessionDataTask?, error:Error) in
        print("Error: " + error.localizedDescription)
        
    }
}
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    for subview in self.scrollImages.subviews {
        subview.removeFromSuperview()
    }
    searchBar.resignFirstResponder()
    if let searchText = searchBar.text{
        searchingFor(searchText)
    }
}


override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}


}







