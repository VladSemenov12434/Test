//
//  AlbumTableViewCell.swift
//  Itunes_testTask_youTube
//
//  Created by MacBook Pro on 23/10/2023.
//

import UIKit

struct Contact: Codable {
    
    var favoriteStatus: Bool
    
}

class AlbumsTableViewCell: UITableViewCell {
    
    var contact: Contact!
    
    func configure(with contact: Contact, cellIndex: Int) {
        self.contact = contact
        let content = defaultContentConfiguration()
        contentConfiguration = content
    }
    
    private let albumLogo: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Name album name"
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
         label.text = "Name artist name"
         label.font = UIFont.systemFont(ofSize: 16)
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let trackCountLabel: UILabel = {
        let label = UILabel()
         label.text = "16 tracks"
         label.font = UIFont.systemFont(ofSize: 16)
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let likeProductButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .red
        button.addTarget(nil, action: #selector(buttonAction), for: .touchUpInside)
        return button
        
        
    }()
    
    @objc func buttonAction() {
        print("1234")
    }
    
    var stackView = UIStackView()
    var stackViewLike = UIStackView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumLogo.layer.cornerRadius = albumLogo.frame.width / 2
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.addSubview(albumLogo)
    
        
        stackView = UIStackView(arrangedSubviews: [artistNameLabel, trackCountLabel],
                                axis: .horizontal,
                                spacing: 10,
                                distribution: .equalCentering)
        
        stackViewLike = UIStackView(arrangedSubviews: [albumNameLabel, likeProductButton],
                                axis: .horizontal,
                                spacing: 10,
                                    distribution: .equalCentering)
        self.addSubview(stackViewLike)
        self.addSubview(stackView)
    }

    func configureAlbumCell(album: Album) {
        
        if let urlString = album.artworkUrl100 {
            NetworkRequest.shared.requestData(urlString: urlString) { result in
                switch result {
                    
                case .success(let data):
                    let image = UIImage(data: data)
                    self.albumLogo.image = image
                case .failure(let error):
                    self.albumLogo.image = nil
                    print("No album logo" + error.localizedDescription)
                }
            }
        } else {
            albumLogo.image = nil
        }
        
        albumNameLabel.text = album.trackName
        artistNameLabel.text = album.primaryGenreName
        trackCountLabel.text = album.releaseDate
    }
    
    private func setConstraints() {

        NSLayoutConstraint.activate([
            albumLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15),
            albumLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            albumLogo.heightAnchor.constraint(equalToConstant: 60),
            albumLogo.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            stackViewLike.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            stackViewLike.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: 10),
            stackViewLike.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: stackViewLike.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
       
    }
}
