//
//  NetworkDataFetch.swift
//  Itunes_testTask_youTube
//
//  Created by MacBook Pro on 28/10/2023.
//

import Foundation

class NetworkDataFetch {

    static let shared = NetworkDataFetch()

    private init() {}

    func fetchAlbum(urlString: String, responce: @escaping(albumModel?, Error?) -> Void ) {

        NetworkRequest.shared.requestData(urlString: urlString) { result in

            switch result {

            case .success(let data):
                do {
                    let albums = try JSONDecoder().decode(albumModel.self, from: data)
                    responce(albums, nil)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }

            case .failure(let error):
                print("Error received reuesting data: \(error.localizedDescription)")
                responce(nil, error)
            }

        }
        
    }

}

