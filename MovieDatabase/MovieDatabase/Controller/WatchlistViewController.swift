//
//  WatchlistViewController.swift
//  MovieDatabase
//
//  Created by arturs.olekss on 22/11/2023.
//
import UIKit
import CoreData

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
    
    private func loadWatchList(){
        let request: NSFetchRequest<MovieItems> = MovieItems.fetchRequest()
        
        do{
            self.watchlistItems = try(self.context?.fetch(request))!
        }
        catch{
            
        }
    }
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
