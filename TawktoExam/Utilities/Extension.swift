//
//  Extension.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 7/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation
import UIKit


protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

extension UIView {
    func setRoundView()
    {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}

extension UIImageView {
    func invert()
    {
        //add inverted filter to the image and set it again on uiimageview
        let defaultImage = CIImage(image: self.image ?? UIImage())
        guard let beginImage = defaultImage else {
            return
        }
        if let filter = CIFilter(name: "CIColorInvert") {
            filter.setValue(beginImage, forKey: kCIInputImageKey)
            guard let image = filter.outputImage
                else { return }
            let newImage = UIImage(ciImage: image)
            self.image = newImage
        }
    }
    
    func load(placeholder:UIImage?,imgUrl:String,completion:@escaping (UIImage?) -> Void){
        
        // load placeholder image while doing the operation
        if let placeholderImage = placeholder
        {
            self.image = placeholderImage
        }
        
        var urlcatch = imgUrl.replacingOccurrences(of: "/", with: "#")
        let documentpath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        urlcatch = documentpath + "/" + "\(urlcatch)"
        
        let imageFromUrl = UIImage(contentsOfFile:urlcatch)
        guard let loadedImage = imageFromUrl
            else {
                //download new image and save to disk
                if let url = URL(string: imgUrl){
                    
                    DispatchQueue.global(qos: .background).async {
                        () -> Void in
                        let imgdata = NSData(contentsOf: url)
                        DispatchQueue.main.async {
                            () -> Void in
                            imgdata?.write(toFile: urlcatch, atomically: true)
                            let imageFromUrl = UIImage(contentsOfFile:urlcatch)
                            completion(imageFromUrl)
                            if imageFromUrl != nil  {
                                self.image = imageFromUrl!
                            }
                        }
                    }
                }
                return
        }
        
        //image is existing on disk (cached)
        self.image = loadedImage
        completion(loadedImage)
    }
}

extension UINavigationBar {
    func setClearNavigationBar()
    {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}
