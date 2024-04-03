import UIKit

final class LoadingPhotoListView: UIView {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(LoadingPhotoCell.self, forCellReuseIdentifier: String(describing: LoadingPhotoCell.self))
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    init() {
        super.init(frame: .zero)
        setupStyle()
        setupHierarchy()
        setupConstraints()
        setupDependencies()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        backgroundColor = .systemBackground
    }

    private func setupHierarchy() {
        addSubview(tableView)
    }

    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

        ])
    }

    private func setupDependencies() {
        tableView.dataSource = self
    }
}

extension LoadingPhotoListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: String(describing: LoadingPhotoCell.self), for: indexPath) as! LoadingPhotoCell
    }
}

#Preview {
    LoadingPhotoListView()
}

