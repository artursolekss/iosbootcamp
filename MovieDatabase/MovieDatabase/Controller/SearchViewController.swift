//
//  SearchViewController.swift
//  MovieDatabase
//
//  Created by arturs.olekss on 22/11/2023.
//

import UIKit

class SearchViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var searchTableView: UITableView!
    let searchVC = UISearchController(searchResultsController: nil)
    private var movies:[Movie] = []
    var keyword:String  = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSearchBar()
    }
    
    private func createSearchBar(){
        self.navigationItem.searchController = self.searchVC
        searchVC.searchBar.placeholder = "Tap here to search movies by keyword"
        searchVC.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty else{return}
        let fixedKeyword = keyword.replacingOccurrences(of: " ", with: "-")
        self.getMovies(keyword: fixedKeyword)
    }
    
    private func getMovies(keyword:String){
        NetworkManager.fetchMoviesByKeyword(keyword: keyword) { movies in
            self.movies = movies.results ?? []
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        }
    }
    
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movies.count == 0 {
            searchTableView.setEmptyView(title: "No search results", message: "Your search results will be displayed here")
        } else {
            tableView.restore()
        }
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.overviewLabel.text = Constants.Icon.overview + (movie.overview != "" ? movie.overview! : "Plot unknown")
        
        if movie.voteAverage != 0.0 {
            cell.ratingLabel.isHidden = false
            cell.ratingLabel.text = Constants.Icon.rating + movie.voteAverage.stringValue
        }else{
            cell.ratingLabel.isHidden = true
        }
        
        if movie.releaseDate != "" {
            cell.releaseDateLabel.isHidden = false
            cell.releaseDateLabel.text = Constants.Icon.releaseDate + movie.releaseDate.longDateString
        }else{
            cell.releaseDateLabel.isHidden = true
        }
        
        if let poster = movie.posterPath {
            cell.posterImageView.sd_setImage(with: URL(string: Constants.API.posterUrl.appending(poster)))
        }else{
            cell.posterImageView.sd_setImage(with: URL(string: Constants.Image.posterPlaceholder))
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.RowHeight.searchTableViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5) {
            cell.transform = CGAffineTransform.identity
        }
    }
}
