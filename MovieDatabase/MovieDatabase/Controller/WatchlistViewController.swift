//
//  WatchlistViewController.swift
//  MovieDatabase
//
//  Created by arturs.olekss on 22/11/2023.
//
import UIKit
import CoreData
import SDWebImage

class WatchlistViewController: UIViewController {
    
    @IBOutlet weak var watchListTableView: UITableView!
    @IBOutlet weak var emptyWatchlistButton: UIBarButtonItem!
    
    private var watchlistItems:[MovieItems] = []
    private var context:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadContext()
        self.loadWatchList()
        
    }
    
    private func loadContext(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func emptyWatchListTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Empty watchlist", message: "Do you want to delete all movies from your watchlist?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.emptyWatchlist()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    private func setupView(){
        
    }
    
    private func saveCoreData(){
        do {
            try context?.save()
        }catch{
            print(error)
        }
        self.loadWatchList()
    }
    
    private func emptyWatchlist(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieItems")
        let entityRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context?.execute(entityRequest)
            basicAlert(title: "Emptied!", message: "All movies has been successfully deleted from your watchlist.")
            saveCoreData()
        }catch{
            print(error)
        }
    }
    
    private func loadWatchList(){
        let request: NSFetchRequest<MovieItems> = MovieItems.fetchRequest()
        
        do{
            self.watchlistItems = try(self.context?.fetch(request))!
            if self.watchlistItems.count == 0{
                self.emptyWatchlistButton.isEnabled = false
                self.watchListTableView.setEmptyView(title: "You don't have any movies in your watchlist", message: "Your favorited movies will be here")
            }
            else{
                self.emptyWatchlistButton.isEnabled = true
                self.watchListTableView.restore()
            }
            
        }
        catch{
            print(error)
        }
        self.watchListTableView.reloadData()
        self.navigationItem.title = "Watchlist(\(String(self.watchListTableView.numberOfRows(inSection: 0)))"
        
    }
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.watchlistItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "watchlistCell", for: indexPath) as? WatchlistTableViewCell else { return UITableViewCell() }
        
        let movie = watchlistItems[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.releaseDate.text = Constants.Icon.releaseDate + movie.releaseDate.stringValue
        cell.runtimeLabel.text = Constants.Icon.runtime + movie.runtime.stringValue
        if movie.rating != "0.0" {
            cell.ratingLabel.isHidden = false
            cell.ratingLabel.text = Constants.Icon.rating + movie.rating.stringValue
        }else {
            cell.ratingLabel.isHidden = true
        }
        if let poster = movie.poster {
            cell.posterImageView.sd_setImage(with: URL(string: poster))
        }else{
            cell.posterImageView.sd_setImage(with: URL(string: Constants.Image.posterPlaceholder))
        }
        cell.accessoryType = movie.watched ? .checkmark : .none
        cell.tintColor = .yellow
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.RowHeight.watchlistTableViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5) {
            cell.transform = CGAffineTransform.identity
        }
    }
}
