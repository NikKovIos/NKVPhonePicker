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

public final class CountriesViewController: UIViewController {
    // MARK: - API
    
    /// A class function for retrieving standart controller for picking countries.
    ///
    /// - Returns: Instance of the country picker controller.
    public class func standardController() -> CountriesViewController {
        return UIStoryboard(name: "NKVPhonePicker", bundle: Bundle(for: self)).instantiateViewController(withIdentifier: "CountryPickerVC") as! CountriesViewController
    }
    
    /// Cancel bar button Item (thank you CAP :).
    @IBOutlet weak public var cancelBarButtonItem: UIBarButtonItem!
    
    /// You can choose to hide or show a cancel button with this property.
    public var shouldHideCancelButton: Bool = false { didSet { updateCancelButton() } }
    
    /// A delegate for <CountriesViewControllerDelegate>
    public var delegate: CountriesViewControllerDelegate?

    @IBOutlet public weak var countriesVCNavigationItem: UINavigationItem!
    
    public var filteredCountries: [[Country]]!
    public var unfilteredCountries: [[Country]]! { didSet { filteredCountries = unfilteredCountries } }
    public var selectedCountry: Country?
    public var majorCountryLocaleIdentifiers: [String] = []
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        updateCancelButton()
        setupCountries()
        setupSearchController()
        setupTableView()
    }
    
    // MARK: - Private
    fileprivate var searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    @IBAction private func cancel(sender: UIBarButtonItem) {
        delegate?.countriesViewControllerDidCancel(self)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func updateCancelButton() {
        if let cancelBarButtonItem = cancelBarButtonItem {
            navigationItem.leftBarButtonItem = shouldHideCancelButton ? nil: cancelBarButtonItem
        }
    }
    
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        tableView.sectionIndexTrackingBackgroundColor = UIColor.clear
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    private func setupCountries() {
        unfilteredCountries = partioned(array: NKVSourcesHelper.countries, usingSelector: #selector(getter: Country.name))
        unfilteredCountries.insert(Countries.countriesFrom(countryCodes: majorCountryLocaleIdentifiers), at: 0)
        tableView.reloadData()
        
        if let selectedCountry = selectedCountry {
            for (index, countries) in unfilteredCountries.enumerated() {
                if let countryIndex = countries.index(of: selectedCountry) {
                    let indexPath = NSIndexPath(row: countryIndex, section: index) as IndexPath
                    tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                    break
                }
            }
        }
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

// MARK: - Table View
extension CountriesViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return filteredCountries.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries[section].count
    }
    
    public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        let country = filteredCountries[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = "+" + country.phoneExtension
        
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
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let countries = filteredCountries[section]
        if countries.isEmpty {
            return nil
        }
        if section == 0 {
            return ""
        }
        return UILocalizedIndexedCollation.current().sectionTitles[section - 1]
    }
    
    public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return searchController.isActive ? nil : UILocalizedIndexedCollation.current().sectionTitles
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index + 1)
    }
}

extension CountriesViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.countriesViewController(self, didSelectCountry: filteredCountries[indexPath.section][indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Search
extension CountriesViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        tableView.reloadSectionIndexTitles()
    }
    public func willDismissSearchController(_ searchController: UISearchController) {
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
