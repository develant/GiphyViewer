//
//  ViewController.swift
//  GiphyViewer
//
//  Created by Antons Aleksandrovs on 31/01/2018.
//  Copyright © 2018 Antons Aleksandrovs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let colours = Colours()
    var giphyArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        setupCollectionViewCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.backgroundColor = colours.lighGreen
        titleLabel.textColor = colours.darkGreen
        searchBar.barTintColor = colours.lighGreen
    }

    func setupCollectionViewCells() {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        let padding: CGFloat = 10
        let itemWidth = screenWidth/3 - padding
        let itemHeight = screenWidth/3 - padding
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView.collectionViewLayout = layout
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return giphyArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? GiphyCell else {
            fatalError()
        }
        
        cell.giphyImageView.image = UIImage(named: "testIcon")
        
        return cell
    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.startSearchingGiphy(text: searchText)
        }
     
        startSearchingGiphy(text: searchText)
    }
    
    func startSearchingGiphy(text: String) {
        
 

        
    }
}
