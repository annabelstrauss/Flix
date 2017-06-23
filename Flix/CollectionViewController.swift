//
//  CollectionViewController.swift
//  Flix
//
//  Created by Annabel Strauss on 6/22/17.
//  Copyright © 2017 Annabel Strauss. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var movies: [[String: Any]] = []
    var filteredMovies: [[String: Any]] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        //the next few lines lay out the items in the collection view nicely 
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        let numCellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (numCellsPerLine - 1)
        let width = collectionView.frame.size.width / numCellsPerLine - interItemSpacingTotal / numCellsPerLine
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        fetchMovies()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return filteredMovies.count
    }

    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuperheroCell", for:
            indexPath as IndexPath) as! SuperheroCell
        
        let movie = filteredMovies[indexPath.row]
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: baseURLString + posterPathString)!
        cell.superheroImageView.af_setImage(withURL: posterURL)
        
        return cell
    }
    
    func fetchMovies() {
        // ... Create the URLRequest `myRequest` ...
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // ... Use the new data to update the data source ...
            let dataDictionary = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            //Re-Get the array of movies
            let movies = dataDictionary["results"] as! [[String: Any]]
            //Re-Store the movies in a property to use elsewhere
            self.movies = movies
            self.filteredMovies = movies
            
            // Reload now that there is new data
            self.collectionView.reloadData()
            
        }
        task.resume()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) {//get this to find the actual movie
            let movie = filteredMovies[indexPath.row] //get the current movie
            let detailViewController = segue.destination as! DetailViewController //tell it its destination
            detailViewController.movie = movie //set the detailViewController's movie variable as the movie we just clicked on!
        }
    }
    
    /*
     * This makes the search bar functional aka filters the movies
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredMovies = movies
        }
        else {
            // creates smaller array of movies based on search text
            filteredMovies = movies.filter { (movie: [String: Any]) -> Bool in
                // If dataItem matches the searchText, return true to include it
                let title = movie["title"] as! String
                return title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        }
        
        collectionView.reloadData()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
