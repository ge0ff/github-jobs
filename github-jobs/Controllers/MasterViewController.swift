//
//  MasterViewController.swift
//  github-jobs
//
//  Created by Geoff Cornwall on 11/29/17.
//  Copyright © 2017 cornbits. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Job]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // sort bar button
        let sortButton = UIButton.init(type: .custom)
        sortButton.setImage(UIImage(named: "SortBarButton"), for: UIControlState.normal)
        sortButton.addTarget(self, action: #selector(presentSortActionSheet(_:)), for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: sortButton)
        barButton.tintColor = UIColor.blue
        navigationItem.rightBarButtonItem = barButton

        // ipad setup
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

        // add refresh control
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshJobData(_:)), for: .valueChanged)

        // fetch data
        fetchJobData()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath)  as! JobTableViewCell

        let job = objects[indexPath.row]
        cell.jobTitleLabel!.text = job.title
        cell.companyLabel!.text = "Company: \(job.company!)"
        cell.cityLabel!.text = "Location: \(job.location!)"
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    // MARK: - Data
    
    @objc private func refreshJobData(_ sender: Any) {
        fetchJobData()
    }
    
    private func fetchJobData() {
        APIManager.sharedInstance.fetchJobs() {
            self.objects = $0
            self.sortObjects(sortBy: .title)
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }

    // MARK: - Sorting

    @objc private func presentSortActionSheet(_ sender: Any) {
        let alertController = UIAlertController(title: "Sort jobs by", message: nil, preferredStyle: .actionSheet)
        
        let titleAction = UIAlertAction(title: "Title", style: .default) { (action:UIAlertAction) in
            self.sortObjects(sortBy: .title)
        }
        let companyAction = UIAlertAction(title: "Company", style: .default) { (action:UIAlertAction) in
            self.sortObjects(sortBy: .company)
        }
        let locationAction = UIAlertAction(title: "Location", style: .default) { (action:UIAlertAction) in
            self.sortObjects(sortBy: .location)
        }
        let dateAction = UIAlertAction(title: "Date", style: .default) { (action:UIAlertAction) in
            self.sortObjects(sortBy: .date)
        }

        alertController.addAction(titleAction)
        alertController.addAction(companyAction)
        alertController.addAction(locationAction)
        alertController.addAction(dateAction)
        
        alertController.popoverPresentationController?.sourceView = self.view

        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func sortObjects(sortBy: SortBy) {
        switch sortBy {
        case .title:
            self.objects.sort(by: { $0.title < $1.title })
        case .company:
            self.objects.sort(by: { $0.company < $1.company })
        case .location:
            self.objects.sort(by: { $0.location < $1.location })
        case .date:
            self.objects.sort(by: { $0.createdAt < $1.createdAt })
        }

        self.tableView.reloadData()
    }

    private enum SortBy {
        case title
        case company
        case location
        case date
    }
}

