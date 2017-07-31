//
//  MovieDetailsViewController.swift
//  FMDBTest
//
//  Created by Marco Nie on 28/07/2017.
//  Copyright © 2017 Marco Nie. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imgMovieCover: UIImageView!
    @IBOutlet weak var btnMovieTitle: UIButton!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblMovieYear: UILabel!
    @IBOutlet weak var swWatched: UISwitch!
    @IBOutlet weak var lblWatchedDiscription: UILabel!
    @IBOutlet weak var stLikes: UIStepper!
    @IBOutlet weak var lblLikeDIscription: UILabel!
    
    
    var movieID: Int!
    var movieInfo: MovieInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setValueToViews() {
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: URL(string: movieInfo.coverURL)!, completionHandler: { (imageData, response, error) in
            if let data = imageData {
                DispatchQueue.main.async {
                    self.imgMovieCover.image = UIImage(data: data)
                }
            }
        }).resume()
        
        btnMovieTitle.setTitle(movieInfo.title, for: UIControlState.normal)
        lblCategory.text = movieInfo.category
        lblMovieYear.text = String(movieInfo.year)
        swWatched.isOn = movieInfo.watched
        stLikes.value = Double(movieInfo.likes)
        lblLikeDIscription.text = messageForLikes()
    }
    
    func messageForLikes() -> String {
        switch movieInfo.likes {
        case 0:
            return "I didn't like it at all."
        case 1:
            return "Interesting, but not exciting."
        case 2:
            return "Nice movie!"
        default:
            return "I loved it!"
        }
    }
    
    @IBAction func updateWatchedState(_ sender: UISwitch) {
        movieInfo.watched = swWatched.isOn
    }
    
    @IBAction func changeNumberOfLikes(_ sender: UIStepper) {
        movieInfo.likes = Int(stLikes.value)
        lblLikeDIscription.text = messageForLikes()
    }
    
    @IBAction func saveChange(_ sender: UIBarButtonItem) {
        DBManager.shared.updateMovie(withID: movieID, watched: movieInfo.watched, likes: movieInfo.likes)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openMovieWebpage(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: movieInfo.movieURL)!, options: [:], completionHandler: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let id = movieID {
            DBManager.shared.loadMovie(withID: id, completionHandler: { (movie) in
                DispatchQueue.main.async {
                    if movie != nil {
                        self.movieInfo = movie
                        self.setValueToViews()
                    }
                }
            })
        }
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
