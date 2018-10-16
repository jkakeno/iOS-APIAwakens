//
//  ViewController.swift
//  APIAwakens
//
//  Created by EG1 on 10/1/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBAction func characterButton(_ sender: UIButton) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//        detailVC.chategory = "Character"
        detailVC.category = .character
        navigationController?.pushViewController(detailVC, animated: true)
    }
    @IBAction func vehicleButton(_ sender: UIButton) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//        detailVC.chategory = "Vehicle"
        detailVC.category = .vehicle
        navigationController?.pushViewController(detailVC, animated: true)
    }
    @IBAction func starshipButton(_ sender: UIButton) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//        detailVC.chategory = "Starship"
        detailVC.category = .starship
        navigationController?.pushViewController(detailVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

