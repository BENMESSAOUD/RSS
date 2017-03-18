//
//  NewsTableViewController.swift
//  News
//
//  Created by Mahmoud Ben Messaoud on 17/03/2017.
//  Copyright © 2017 Mahmoud Ben Messaoud. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    var channel = Channel()
    var rssManager = RSSManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News"
        self.refreshControl?.addTarget(self, action: #selector(NewsTableViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        refreshData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        refreshData(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell

        let item = channel.items[indexPath.row]
        cell.configure(with: item)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = channel.items[indexPath.row]
        let detailController = storyboard?.instantiateViewController(withIdentifier: "DetailNewsViewController") as! DetailNewsViewController
        detailController.news = item
        self.navigationController?.pushViewController(detailController, animated: true)
    }

    private func refreshData(_ refreshControl: UIRefreshControl? = nil){
        rssManager.loadChannel { (channelResult, error) in
            if let error = error {
                let alertController = UIAlertController(title: "News", message: error.message, preferredStyle: .alert)
                alertController.addCancelActionWithTitle("Fermer")
                alertController.show()
            }
            else if let channel = channelResult {
                self.channel = channel
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if let refreshControl = refreshControl {
                        refreshControl.endRefreshing()
                    }
                }
            }
        }
    }

}
