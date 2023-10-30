//
//  AlbumModel.swift
//  Itunes_testTask_youTube
//
//  Created by MacBook Pro on 27/10/2023.
//

import Foundation

struct albumModel: Decodable {
    let results: [Album]
}

struct Album: Decodable {
    
    let trackName: String
    let artworkUrl100: String?
    let primaryGenreName: String
    let releaseDate: String
    
}
