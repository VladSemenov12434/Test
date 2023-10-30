//
//  MainTabBarControllerViewController.swift
//  Itunes_testTask_youTube
//
//  Created by MacBook Pro on 25/10/2023.
//

import UIKit

class MainTabBarControllerViewController: UITabBarController {
    
    private let searchController = UISearchController(searchResultsController: nil)

    var albums = [Album]()
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
        
        generateTabBar()
        setTabBarAppearance()
        
        setupViews()
        setupDelegate()
        setConstraints()


//        setNavigationBar()
//        setupSearchController()

        
        navigationItem.searchController = searchController
    }
    
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: Search(),
                title: "Головна",
                image: UIImage(systemName: "house.fill")
            ),
            generateVC(
                viewController: UserInfoViewController(),
                title: "Вибране",
                image: UIImage(systemName: "slider.horizontal.3")
            ),
            generateVC(
                viewController: UserInfoViewController(),
                title: "Профіль",
                image: UIImage(systemName: "person.fill")
                
            )
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setTabBarAppearance() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBar.bounds.minY - positionOnY,
                width: width,
                height: height
            ),
            cornerRadius: height / 2
        )
        
        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.mainWhite.cgColor
        
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(AlbumsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }

    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self

        searchController.searchBar.delegate = self
    }
    
    private func fetchAlbums(albumName: String) {
        let urlString = "https://itunes.apple.com/search?term=\(albumName)&entity=movie&attribute=actorTerm&attribute=genreIndex&attribute=releaseYearTerm"

        NetworkDataFetch.shared.fetchAlbum(urlString: urlString) { [weak self] albumModel, error in


            let albom: [Album] = [Album(trackName: "A", artworkUrl100: nil, primaryGenreName: "", releaseDate: "")]
            if error == nil {

                guard let albumModel = albumModel else { return }

                self?.albums = albom
                print(self?.albums)
                self?.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    class Search: UIViewController {

        let one = UITabBarItem(title: "one", image: nil, tag: 0)
        let two = UITabBarItem(title: "one", image: nil, tag: 0)

//        private let tableView: UITableView = {
//            let tableView = UITableView()
//            tableView.backgroundColor = .white
//            tableView.register(AlbumsTableViewCell.self, forCellReuseIdentifier: "cell")
//            tableView.translatesAutoresizingMaskIntoConstraints = false
//            return tableView
//        }()

        private let searchController = UISearchController(searchResultsController: nil)

//        override func viewDidLoad() {
//            super.viewDidLoad()
//            setupViews()
//            setupDelegate()
//            setConstraints()
//
//
//            setNavigationBar()
//            setupSearchController()
//
//        }

//        private func setupViews() {
//            view.backgroundColor = .white
//            view.addSubview(tableView)
//        }
//
//        private func setupDelegate() {
//            tableView.delegate = self
//            tableView.dataSource = self
//
//            searchController.searchBar.delegate = self
//        }

        private func setNavigationBar() {
        navigationItem.title = "Albums"

            navigationItem.searchController = searchController

           let userInfoButton = createCustomButton(selector: #selector(userInfoButtonTapped))
            navigationItem.rightBarButtonItem = userInfoButton
        }

        private func setupSearchController() {
            searchController.searchBar.placeholder = "Search"
            searchController.obscuresBackgroundDuringPresentation = false
        }

        @objc private func userInfoButtonTapped() {
            let userInfoViewController = UserInfoViewController()
            navigationController?.pushViewController(userInfoViewController, animated: true)

        }

//        private func fetchAlbums(albumName: String) {
//            let urlString = "https://itunes.apple.com/search?term=\(albumName)&entity=movie&attribute=actorTerm&attribute=genreIndex&attribute=releaseYearTerm"
//
//            NetworkDataFetch.shared.fetchAlbum(urlString: urlString) { [weak self] albumModel, error in
//
//
//                let albom: [Album] = [Album(trackName: "A", artworkUrl100: nil, primaryGenreName: "", releaseDate: "")]
//                if error == nil {
//
//                    guard let albumModel = albumModel else { return }
//
//                    self?.albums = albom
//                    print(self?.albums)
//                    self?.tableView.reloadData()
//                } else {
//                    print(error!.localizedDescription)
//                }
//            }
//        }

    }
}

//MARK: - UITableViewDataSource

extension MainTabBarControllerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlbumsTableViewCell
        let album = albums[indexPath.row]
        cell.configureAlbumCell(album: album)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension MainTabBarControllerViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailAlbumViewController = DetailAlbumViewController()
        let album = albums[indexPath.row]
        detailAlbumViewController.album = album
        detailAlbumViewController.title = album.trackName

        navigationController?.pushViewController(detailAlbumViewController, animated: true)
    }
}

//MARK: - UISearchBarDelegate


extension MainTabBarControllerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText != "" {

            timer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                self?.fetchAlbums(albumName: searchText)

            })


        }
    }
}

//MARK: - SetConstraints

extension MainTabBarControllerViewController {

    private func setConstraints() {

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

extension UIColor {
    static var tabBarItemAccent: UIColor {
        #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
    }
    static var mainWhite: UIColor {
        #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    }
    static var tabBarItemLight: UIColor {
        #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 0.5084592301)
    }
}



