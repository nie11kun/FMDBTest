//
//  ViewController.swift
//  FMDBTest
//
//  Created by Marco Nie on 28/07/2017.
//  Copyright © 2017 Marco Nie. All rights reserved.
//

import UIKit

struct MovieInfo {
    var movieID: Int!
    var title: String!
    var category: String!
    var year: Int!
    var movieURL: String!
    var coverURL: String!
    var watched: Bool!
    var likes: Int!
}

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblMovies: UITableView!
    
    var movies: [MovieInfo]!
    var selectedMovieIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tblMovies.delegate = self
        tblMovies.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectedMovieIndex = tblMovies.indexPath(for: sender as! UITableViewCell)?.row
        if let identifier = segue.identifier {
            if identifier == "idSegueMovieDetails" {
                let movieDetailViewController = segue.destination as! MovieDetailsViewController
                movieDetailViewController.movieID = movies[selectedMovieIndex].movieID
            }
        }
    }
    
    // MARK: UITableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (movies != nil) ? movies.count : 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let currentMovie = movies[indexPath.row]
        
        cell.textLabel?.text = currentMovie.title
        cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: URL(string: currentMovie.coverURL)!, completionHandler: { (imageData, response, error) in
            if let data = imageData {
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data)
                    cell.layoutSubviews()
                }
            }
        }).resume()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovieIndex = indexPath.row
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        movies = DBManager.shared.loadMovies()
        tblMovies.reloadData()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if DBManager.shared.deleteMovie(withID: movies[indexPath.row].movieID) {
                movies.remove(at: indexPath.row)
                tblMovies.reloadData()
            }
        }
    }
    
}

