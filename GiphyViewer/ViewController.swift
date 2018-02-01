//
//  ViewController.swift
//  GiphyViewer
//
//  Created by Antons Aleksandrovs on 31/01/2018.
//  Copyright © 2018 Antons Aleksandrovs. All rights reserved.
//

import UIKit
import SwiftyGif
import GiphySwift
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let colours = Colours()
    let gifManager = SwiftyGifManager(memoryLimit: 20)
    
    var arrayOfGifs = [GiphyImageResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appNameLabel.backgroundColor = colours.lighGreen
        appNameLabel.textColor = colours.darkGreen
        searchBar.barTintColor = colours.lighGreen
        requestGiphy(searchText: nil)
        setupCollectionViewCells()
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
        return arrayOfGifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? GiphyCell else {
            fatalError()
        }
        
        let image = arrayOfGifs[indexPath.row]
        if let url = URL(string: image.images.fixedHeight.downsampled.gif.url) {
            
            Alamofire.request(url).responseData { (response) in
                guard let data = response.result.value else {
                    return
                }
            
                let newGiphy = UIImage(gifData: data, levelOfIntegrity: 0.5)
                cell.giphyImageView.setGifImage(newGiphy, manager: self.gifManager)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == arrayOfGifs.count - 1 {
            requestGiphy(searchText: searchBar.text ?? nil)
        }
    }
    
    func requestGiphy(searchText: String?) {
        if let searchText = searchText {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Giphy.Gif.request(.search(searchText), completionHandler: { (result) in
                    
                    switch result {
                        
                    case .success(result: let gifs, properties: _):
                        
                        for gif in gifs {
                            self.arrayOfGifs.append(gif)
                        }
                        
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        }
                        
                    case .error(let error):
                        print(error)
                        
                    }
                })
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
    func hideKeyboard() {
        DispatchQueue.main.async {
            self.searchBar.resignFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            hideKeyboard()
        } else {
            requestGiphy(searchText: searchText)
        }
    }
}
