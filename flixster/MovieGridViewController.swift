//
//  MovieGridViewController.swift
//  flixster
//
//  Created by Eduardo Garcia on 2/3/20.
//  Copyright © 2020 Eduardo Garcia. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var movies = [[String:Any]]()

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        
       let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
              layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
              layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
              layout.minimumLineSpacing = 2
              collectionView!.collectionViewLayout = layout

//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//
//        layout.minimumLineSpacing = 4
//        layout.minimumInteritemSpacing = 0
//
//        let width  = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
//        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
    
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            
            self.movies = dataDictionary["results"] as! [[String:Any]]
            self.collectionView.reloadData()
            
            print(self.movies)
    

           }
        }
        task.resume()
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
    
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        
        cell.posterView.af_setImage(withURL: posterURL!)
        
        return cell
    }

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        
        let movie = movies[indexPath.row]
        
        let details2ViewController = segue.destination as! MovieDetail2ViewController
        
        details2ViewController.movie = movie
        
        }

    
    
    
    
}
