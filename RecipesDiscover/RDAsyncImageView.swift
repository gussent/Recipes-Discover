//
//  RDAsyncImageView.swift
//  RecipesDiscover
//
//  Created by Dmitry Kovalev on 03/03/2018.
//  Copyright © 2018 Dmitry Kovalev. All rights reserved.
//

import UIKit

class RDAsyncImageView: UIImageView
{
    var activityIndicator: UIActivityIndicatorView?
    var loadingTask: URLSessionDataTask?
    
    func downloadImage(_ urlString: String, completionHandler: (()->())? = nil)
    {
        guard let url = URL(string: urlString) else {return}
        
        let request = URLRequest(url: url)
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let cachedImage = UIImage(data: cachedResponse.data)
        {
            image = cachedImage
            completionHandler?()
            return
        }
        
        let session = URLSession(configuration: .default)
        loadingTask = session.dataTask(with: request)
        { (data, response, error) in

            guard error == nil else {print("Error downloadind image: \(error!)"); return}
            guard (response as? HTTPURLResponse) != nil else {print("No response from server"); return}
            guard let imageData = data else {print("Image file is currupted"); return}

            DispatchQueue.main.async
            {
                self.image = UIImage(data: imageData)
                self.hideActivityIndicator()
            }
            
            self.loadingTask = nil
        }
        
        image = nil
        showActivityIndicator()
        loadingTask?.resume()
    }

    func cancelDownload()
    {
        if let task = loadingTask {task.cancel()}
    }
    
    private func showActivityIndicator()
    {
        backgroundColor = .gray
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        let indicator = activityIndicator!
        
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
        [
            indicator.topAnchor.constraint(equalTo: topAnchor),
            indicator.leftAnchor.constraint(equalTo: leftAnchor),
            indicator.rightAnchor.constraint(equalTo: rightAnchor),
            indicator.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        indicator.startAnimating()
    }
    
    private func hideActivityIndicator()
    {
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
        backgroundColor = .clear
    }

}
