//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

import UIKit

public protocol CountriesViewControllerDelegate {
    func countriesViewControllerDidCancel(_ sender: CountriesViewController)
    func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country)
}

public final class CountriesViewController: UITableViewController {
    @IBOutlet public weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet public weak var countriesVCNavigationItem: UINavigationItem!
   
    // MARK: - API
    
    /// A class function for retrieving standart controller for picking countries.
    ///
    /// - Returns: Instance of the country picker controller.
    public class func standardController() -> CountriesViewController {
        return UIStoryboard(name: "CountriesViewController", bundle: Bundle(for: self)).instantiateViewController(withIdentifier: "CountryPickerVC") as! CountriesViewController
    }
    
    /// Use this var for setting countries in the top of the tableView
    /// Ex:
    ///
    ///     countryVC.favoriteCountriesLocaleIdentifiers = ["RU", "JM", "GB"]
    public var favoriteCountriesLocaleIdentifiers: [String] = []

    /// You can choose to hide or show a cancel button with this property.
    public var isCancelButtonHidden: Bool = false { didSet { configurateCancelButton() } }
    
    /// Set to 'false' if you don't need to scroll to selected country in CountryPickerViewController
    public var shouldScrollToSelectedCountry: Bool = true

    /// A delegate for <CountriesViewControllerDelegate>.
    public var delegate: CountriesViewControllerDelegate?

    /// The current selected country.
    public var selectedCountry: Country?
    
    /// The font of textLabel and detailedTextLabel
    public var cellsFont : UIFont?

    override public func viewDidLoad() {
        super.viewDidLoad()
    
        configurateCancelButton()
        setupCountries()
        setupSearchController()
        setupTableView()
    }
    
    deinit {
        self.searchController.view.removeFromSuperview()
    }
    
    // MARK: - Private
    fileprivate var searchController = UISearchController(searchResultsController: nil)
    /// An array with which all countries are presenting. This array works with search controller and tableView.
    fileprivate var filteredCountries: [[Country]]!
    /// An array with all countries, we have.
    fileprivate var unfilteredCountries: [[Country]]! { didSet { filteredCountries = unfilteredCountries } }
    
    @IBAction private func cancel(sender: UIBarButtonItem) {
        delegate?.countriesViewControllerDidCancel(self)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupCountries() {
        unfilteredCountries = partioned(array: NKVSourcesHelper.countries, usingSelector: #selector(getter: Country.name))
        unfilteredCountries.insert(Country.countriesBy(countryCodes: favoriteCountriesLocaleIdentifiers), at: 0)
        tableView.reloadData()
        
        if let selectedCountry = selectedCountry, shouldScrollToSelectedCountry {
            for (index, countries) in unfilteredCountries.enumerated() {
                if let countryIndex = countries.index(of: selectedCountry) {
                    let indexPath = NSIndexPath(row: countryIndex, section: index) as IndexPath
                    tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                    break
                }
            }
        }
    }

    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.backgroundColor = UIColor.white
        searchController.extendedLayoutIncludesOpaqueBars = true

        definesPresentationContext = true
    }
    
    private func configurateCancelButton() {
        if let cancelBarButtonItem = cancelBarButtonItem {
            navigationItem.leftBarButtonItem = isCancelButtonHidden ? nil: cancelBarButtonItem
        }
    }
    
    private func setupTableView() {
        tableView.sectionIndexTrackingBackgroundColor = UIColor.clear
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.sectionIndexColor = UIColor.black
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.scrollsToTop = true
    }
    
    fileprivate func partioned<T: AnyObject>(array: [T], usingSelector selector: Selector) -> [[T]] {
        let collation = UILocalizedIndexedCollation.current()
        let numberOfSectionTitles = collation.sectionTitles.count
        
        var unsortedSections: [[T]] = Array(repeating: [], count: numberOfSectionTitles)
        for object in array {
            let sectionIndex = collation.section(for: object, collationStringSelector: selector)
            unsortedSections[sectionIndex].append(object)
        }
        
        var sortedSections: [[T]] = []
        for section in unsortedSections {
            let sortedSection = collation.sortedArray(from: section, collationStringSelector: selector) as! [T]
            sortedSections.append(sortedSection)
        }
        return sortedSections
    }
}

// MARK: - TableView Data Source
extension CountriesViewController {
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return filteredCountries.count
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries[section].count
    }
    
    public  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        let country = filteredCountries[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = country.name
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.5
        
        cell.detailTextLabel?.text = "+" + country.phoneExtension
        
        // Setting custom font
        if let cellsFont = cellsFont {
            cell.textLabel?.font = cellsFont
            cell.detailTextLabel?.font = cellsFont
        }

        let flag = NKVSourcesHelper.getFlagImage(by: country.countryCode)
        cell.imageView?.image = flag
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.clipsToBounds = true
        cell.imageView?.layer.cornerRadius = 3
        cell.imageView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        cell.accessoryType = .none
        if let selectedCountry = selectedCountry, country == selectedCountry {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    // Sections headers
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let countries = filteredCountries[section]
        if countries.isEmpty {
            return nil
        }
        if section == 0 {
            return ""
        }
        return UILocalizedIndexedCollation.current().sectionTitles[section - 1]
    }
    
    // Indexes
    public override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return searchController.isActive ? nil : UILocalizedIndexedCollation.current().sectionTitles
    }
    
    public override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index + 1)
    }
}

// MARK: TableView Delegate
extension CountriesViewController {
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.countriesViewController(self, didSelectCountry: filteredCountries[indexPath.section][indexPath.row])
        if searchController.isActive { searchController.dismiss(animated: false, completion: nil) }
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Search
extension CountriesViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.searchBarStyle = .default
        tableView.reloadSectionIndexTitles()
    }
    public func willDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.searchBarStyle = .minimal
        tableView.reloadSectionIndexTitles()
    }
}

extension CountriesViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text ?? ""
        searchForText(searchString)
        tableView.reloadData()
    }
    
    private func searchForText(_ text: String) {
        if text.isEmpty {
            filteredCountries = unfilteredCountries
        } else {
            let allCountriesArray: [Country] = NKVSourcesHelper.countries.filter { $0.name.range(of: text) != nil }
            filteredCountries = partioned(array: allCountriesArray, usingSelector: #selector(getter: Country.name))
            filteredCountries.insert([], at: 0) //Empty section for our favorites
        }
        tableView.reloadData()
    }
}

extension CountriesViewController: UISearchBarDelegate {
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        filteredCountries = unfilteredCountries
        tableView.reloadData()
    }
}
