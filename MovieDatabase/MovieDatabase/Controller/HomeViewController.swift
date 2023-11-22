//
//  ViewController.swift
//  MovieDatabase
//
//  Created by arturs.olekss on 22/11/2023.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {

    private var movies:[Movie] = []
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var homeTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies(url: Constants.API.popularMoviesUrl)
    }

    private func getMovies(url:String){
        
        NetworkManager.fetchMovies(url:url){
            movies in
            self.movies = movies.results ?? []
            DispatchQueue.main.sync{
                self.homeTableView.reloadData()
        
            }
            
        }
        
    }
    

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func activityIndicator(activityIndicatorView: UIActivityIndicatorView, animated: Bool) {
        DispatchQueue.main.async{
            if animated{
                activityIndicatorView.isHidden = false
                activityIndicatorView.startAnimating()
            }
            else{
                activityIndicatorView.isHidden = true
                activityIndicatorView.startAnimating()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5){
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell",for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        let movie = movies[indexPath.row]
        
        cell.titleLabel.text = movie.title
        cell.overviewLabel.text = Constants.Icon.overview + (movie.overview != "" ? movie.overview! : "Plot unknown")
        
        if movie.voteAverage != 0.0 {
            cell.ratingLabel.isHidden = false
//            cell.ratingLabel.text = Constants.Icon.rating + movie.voteAverage.stringValue
        }else{
            cell.ratingLabel.isHidden = true
        }
        
        cell.releaseDateLabel.text = Constants.Icon.releaseDate + movie.releaseDate!
        cell.posterImageView.sd_setImage(with: URL(string: Constants.API.posterUrl.appending(movie.posterPath ?? "")))
        cell.selectionStyle = .none
        
        return cell
    }
}

