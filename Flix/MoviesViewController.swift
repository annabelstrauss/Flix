//
//  MoviesViewController.swift
//  Flix
//
//  Created by Annabel Strauss on 6/21/17.
//  Copyright © 2017 Annabel Strauss. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [Movie] = []
    var filteredMovies: [Movie] = []
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        activityIndicator.startAnimating() //starts the spinny wheel in center of screen
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        fetchMovies()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    /*
     *This is where we set the contents of the cell
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        cell.movie = filteredMovies[indexPath.row]
        
        return cell
    }
    
    //THIS IS PULL TO REFRESH
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        activityIndicator.startAnimating() //starts the spinny wheel in center of screen
        fetchMovies()
    }
    
    func fetchMovies() {
        
        MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
            if let movies = movies {
                self.filteredMovies = movies
                self.movies = movies
                self.tableView.reloadData()
            }
        }
        
        // Tell the refreshControl to stop spinning
        self.refreshControl.endRefreshing()
        //Tell the activityIndicator to stop spinning
        self.activityIndicator.stopAnimating()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell //get this to find the index path
        if let indexPath = tableView.indexPath(for: cell) {//get this to find the actual movie
            let movie = filteredMovies[indexPath.row] //get the current movie
            let detailViewController = segue.destination as! DetailViewController //tell it its destination
            detailViewController.movie = movie //set the detailViewController's movie variable as the movie we just clicked on!
        }
    }
    
    /*
     * This makes the grey selection go away when you go back to table view
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     * This shows the network error message if the network request fails
     */
    func showErrorMessage() {
        let alertController = UIAlertController(title: "Cannot Get Movies", message: "Check your internet connection", preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here. Doing nothing will dismiss the view.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        
        //actually make the error message pop up
        present(alertController, animated: true) {}
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
            filteredMovies = movies.filter { (movie: Movie) -> Bool in
                // If dataItem matches the searchText, return true to include it
                let title = movie.title
                return title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        }
        
        tableView.reloadData()
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
