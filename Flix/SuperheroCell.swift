//
//  SuperheroCell.swift
//  Flix
//
//  Created by Annabel Strauss on 6/22/17.
//  Copyright © 2017 Annabel Strauss. All rights reserved.
//

import UIKit

class SuperheroCell: UICollectionViewCell {
    
    @IBOutlet weak var superheroImageView: UIImageView!
    
    
    var movie: Movie! {
        willSet(newMovie) {
            print("about to set new movie")
        }
        didSet {
            superheroImageView.af_setImage(withURL: movie.posterURL!)
        }
    }
}
