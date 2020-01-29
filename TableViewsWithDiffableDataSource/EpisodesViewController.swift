import UIKit

class EpisodesViewController: UIViewController {
    
    // MARK: - Internal Classes
    
    class EpisodesTableViewDiffibleDataSource: UITableViewDiffableDataSource<Season, Episode> {
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Season \(seasonNumber(from: section))"
        }
    }
    
    // MARK: - Internal Properties

    var episodesTableView: UITableView = {
       let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "episodeCell")
        return tv
    }()
    
    var seasons = [Season]() {
        didSet {
            updateTableView()
        }
    }
    
    var dataSource: EpisodesTableViewDiffibleDataSource?
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureConstraints()
        configureDataSource()
        loadData()
    }
    
    // MARK: - Private Methods
    
    private func loadData() {
        let fetchingService = BundleFetchingService<Episode>()
        let fetchedEpisodes = fetchingService.getArray(from: "officeEpisodes", ofType: "json")
        seasons = createSeasons(from: fetchedEpisodes)
    }
    
    private func createSeasons(from fetchedEpisodes: [Episode]) -> [Season] {
        var fetchedSeasons = seasonNumbers(from: fetchedEpisodes)
            .map { Season(episodes: [], number: $0) }
            .sorted(by: { $0.number < $1.number })
            
        for episode in fetchedEpisodes {
            guard let matchingSeason = fetchedSeasons.first(where: { $0.number == episode.season } ),
                  let seasonIndex = fetchedSeasons.firstIndex(of: matchingSeason) else {
                continue
            }
            fetchedSeasons[seasonIndex].episodes.append(episode)
        }
        
        return fetchedSeasons.map { season in
            Season(episodes: season.episodes.sorted { $0.number < $1.number }, number: season.number)
        }
    }
    
    private func seasonNumbers(from episodes: [Episode]) -> [Int] {
        var seasonNumbers = Set<Int>()
        for episode in episodes {
            seasonNumbers.insert(episode.season)
        }
        return seasonNumbers.map { $0 }
    }
    
    private func configureDataSource() {
        dataSource = EpisodesTableViewDiffibleDataSource(tableView: episodesTableView) { [weak self] (tableView, indexPath, _) -> UITableViewCell? in
            guard let self = self else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
            guard let allEpisodesForSeason = self.seasons.first(where: { $0.number == EpisodesViewController.seasonNumber(from: indexPath) }),
                 let episode = allEpisodesForSeason.episodes.first(where: { $0.number == EpisodesViewController.episodeNumber(from: indexPath) }) else {
                    return UITableViewCell()
            }
            cell.textLabel?.text = "Episode \(episode.number): \(episode.name)"
            return cell
        }

        episodesTableView.dataSource = dataSource
    }
    
    private func updateTableView() {
        var snapshot = NSDiffableDataSourceSnapshot<Season, Episode>()
        snapshot.appendSections(seasons)
        for season in seasons {
            snapshot.appendItems(season.episodes, toSection: season)
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func addSubviews() {
        view.addSubview(episodesTableView)
    }
    
    private func configureConstraints() {
        episodesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            episodesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            episodesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private static func seasonNumber(from indexPath: IndexPath) -> Int {
        return indexPath.section + 1
    }
    
    private static func seasonNumber(from section: Int) -> Int {
        return section + 1
    }
    
    private static func episodeNumber(from indexPath: IndexPath) -> Int {
        return indexPath.row + 1
    }
}
