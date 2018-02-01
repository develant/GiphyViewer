//
//  CollectionViewController.swift
//  GiphyViewer
//
//  Created by Antons Aleksandrovs on 31/01/2018.
//  Copyright © 2018 Antons Aleksandrovs. All rights reserved.
//

import UIKit
import SwiftyGif
import GiphySwift
import Alamofire

class CollectionViewController: UICollectionViewController {

    let colours = Colours()
    let gifManager = SwiftyGifManager(memoryLimit: 20)
    
    var arrayOfGifs = [GiphyImageResult]()
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
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
        
        layout.headerReferenceSize = CGSize(width: view.frame.size.width, height: 40)
        
        collectionView?.collectionViewLayout = layout
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfGifs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? GiphyCell else {
            fatalError()
        }
        
        let image = arrayOfGifs[indexPath.row]
        let url = URL(string: image.images.fixedHeight.downsampled.gif.url)!
        
        Alamofire.request(url).responseData { (response) in
            guard let data = response.result.value else {
                return
            }
            
            let newGiphy = UIImage(gifData: data, levelOfIntegrity: 0.5)
            cell.giphyImageView.setGifImage(newGiphy, manager: self.gifManager)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
        reusableView.addSubview(searchBar)
        searchBar.sizeToFit()
        return reusableView
    }

    func requestGiphy(searchText: String?) {
        if let searchText = searchText {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Giphy.Gif.request(.search(searchText), completionHandler: { (result) in
                    
                    switch result {
                        
                    case .success(result: let gifs, properties: _):
                        
                    self.arrayOfGifs = gifs
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        }
                        
                    case .error(let error):
                        print(error)
                        
                    }
                })
            }
        }
    }
}

extension CollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                //                self.collectionView?.reloadData()
                searchBar.resignFirstResponder()
            }
        } else {
            requestGiphy(searchText: searchText)
        }
    }
}
