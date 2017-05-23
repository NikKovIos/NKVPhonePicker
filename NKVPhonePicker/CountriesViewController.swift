//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

import UIKit

public protocol CountriesViewControllerDelegate: class {
    func countriesViewControllerDidCancel(_ sender: CountriesViewController)
    func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country)
}

public final class CountriesViewController:UIViewController {
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
    public weak var delegate: CountriesViewControllerDelegate?

    public var unfilteredCountries: [[Country]]! { didSet { filteredCountries = unfilteredCountries } }
    public var filteredCountries: [[Country]]!
    public var selectedCountry: Country?
    public var majorCountryLocaleIdentifiers: [String] = []
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        updateCancelButton()
        setupCountries()
        setupSearchController()
    }
    
    // MARK: - Private
    private var searchController = UISearchController(searchResultsController: nil)
    @IBOutlet fileprivate weak var tableView: UITableView!

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
    
    //MARK: Viewing Countries
    private func setupCountries() {
        
        unfilteredCountries = partioned(array: Countries.countries, usingSelector: Selector("name"))
        unfilteredCountries.insert(Countries.countriesFromCountryCodes(countryCodes: majorCountryLocaleIdentifiers), at: 0)
        tableView.reloadData()
        
        if let selectedCountry = selectedCountry {
            for (index, countries) in unfilteredCountries.enumerate() {
                if let countryIndex = countries.indexOf(selectedCountry) {
                    let indexPath = NSIndexPath(forRow: countryIndex, inSection: index)
                    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
                    break
                }
            }
        }
    }
    
    @IBAction private func cancel(sender: UIBarButtonItem) {
        delegate?.countriesViewControllerDidCancel(self)
    }
}

private func partioned<T: AnyObject>(array: [T], usingSelector selector: Selector) -> [[T]] {
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

// MARK: - Table View
extension CountriesViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return filteredCountries.count

    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries[section].count
    }
    
    public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        let country = filteredCountries[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = "+" + country.phoneExtension
        
        cell.accessoryType = .None
        
        if let selectedCountry = selectedCountry where country == selectedCountry {
            cell.accessoryType = .Checkmark
        }
        
        return cell
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let countries = filteredCountries[section]
        if countries.isEmpty {
            return nil
        }
        if section == 0 {
            return ""
        }
        return UILocalizedIndexedCollation.currentCollation().sectionTitles[section - 1]
    }
    
    public override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return searchController.active ? nil : UILocalizedIndexedCollation.currentCollation().sectionTitles
    }
    
    public override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return UILocalizedIndexedCollation.currentCollation().sectionForSectionIndexTitleAtIndex(index + 1)
    }
}

extension CountriesViewController: UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        delegate?.countriesViewController(self, didSelectCountry: filteredCountries[indexPath.section][indexPath.row])
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
            let allCountriesArray: [Country] = Countries.countries.filter { $0.name.range(of: text) != nil }
            filteredCountries = partioned(array: allCountriesArray, usingSelector: Selector("name"))
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
