import UIKit

protocol PhotoListRouting {
    func showFullscreen(for photo: Photo)
}

protocol PhotoListInteracting {
    func onViewDidLoad()
    func onTapTryAgain()
    func onReachBottom()
}

typealias PhotoListViewControllerOutput = PhotoListInteracting

final class PhotoListViewController: UIViewController {
    var output: PhotoListViewControllerOutput?
    var router: PhotoListRouting?

    private var allPhotos: [Photo] = [] {
        didSet {
            filteredPhotos = allPhotos
        }
    }

    private var filteredPhotos: [Photo] = [] {
        didSet {
            guard filteredPhotos != oldValue else { return }
            reloadTableView()
        }
    }

    private var photos: [Photo] {
        filteredPhotos
    }

    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(PhotoCell.self, forCellReuseIdentifier: String(describing: PhotoCell.self))
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private let errorView = EmptyView()

    private let loadingView = LoadingPhotoListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        setupHierarchy()
        setupConstraints()
        setupDependencies()
        output?.onViewDidLoad()
    }

    private func setupStyle() {
        title = "Photos"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        errorView.isHidden = true
    }

    private func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(loadingView)
        view.addSubview(errorView)
    }

    private func setupConstraints() {
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func setupDependencies() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        tableView.delegate = self
        tableView.dataSource = self

        errorView.action = { [unowned self] in
            tryAgain()
        }
    }

    private func tryAgain() {
        output?.onTapTryAgain()
    }

    private func reloadTableView() {
        DispatchQueue.main.async { [unowned self] in
            tableView.reloadData()
        }
    }

    private func hideError(_ isHidden: Bool) {
        DispatchQueue.main.async { [unowned self] in
            errorView.isHidden = isHidden
        }
    }

    private func hideLoading(_ isHidden: Bool) {
        DispatchQueue.main.async { [unowned self] in
            loadingView.isHidden = isHidden
        }
    }

    private func setupEmptyView(systemImageName: String, title: String, subtitle: String, actionTitle: String) {
        DispatchQueue.main.async { [unowned self] in
            errorView.setupData(systemImageName: systemImageName, title: title, subtitle: subtitle, buttonTitle: actionTitle)
        }
    }
}

extension PhotoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.isEmpty else {
            filteredPhotos = allPhotos
            return
        }

        filteredPhotos = allPhotos.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
}

extension PhotoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row >= photos.count - 1 else {
            return
        }

        output?.onReachBottom()
    }
}

extension PhotoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotoCell.self), for: indexPath) as! PhotoCell
        cell.setupData(for: photos[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        output?.onReachBottom()
    }
}

extension PhotoListViewController: PhotoListDisplaying {
    func displayPhotos(_ photos: [Photo]) {
        allPhotos = photos
        reloadTableView()
        hideError(true)
        hideLoading(true)
    }

    func displayError(systemImageName: String, title: String, subtitle: String, actionTitle: String) {
        hideError(false)
        hideLoading(true)
        setupEmptyView(systemImageName: systemImageName, title: title, subtitle: subtitle, actionTitle: actionTitle)
    }
}
