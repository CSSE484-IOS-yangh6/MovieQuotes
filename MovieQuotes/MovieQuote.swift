//
//  MovieQuote.swift
//  MovieQuotes
//
//  Created by Hanyu Yang on 2021/1/11.
//

import Foundation
import Firebase

class MovieQuote {
    var quote: String
    var movie: String
    var id: String?
    
    
    init(quote: String, movie: String) {
        self.quote = quote
        self.movie = movie
    }
    
    init(documentSnapshot: DocumentSnapshot) {
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()!
        self.quote = data["quote"] as! String
        self.movie = data["movie"] as! String
    }
}
