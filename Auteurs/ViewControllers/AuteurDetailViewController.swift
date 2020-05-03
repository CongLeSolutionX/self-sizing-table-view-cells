

import UIKit

class AuteurDetailViewController: UIViewController {
  var selectedAuteur: Auteur!
  let moreInfoText = "Tap For Details >"
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // allows the cell dynamically grow based on its content 
    // with an estimated row height as 300 
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 300
    
    title = selectedAuteur.name
    self.tableView.contentInsetAdjustmentBehavior = .never
  }
}

//MARK: - TableViewDataSource
extension AuteurDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedAuteur.films.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FilmTableViewCell
    let film = selectedAuteur.films[indexPath.row]
    
    // adding info for the cell
    cell.filmTitleLabel.text = film.title
    cell.filmImageView.image = UIImage(named: film.poster)
    
    // configure the UI elements 
    cell.filmTitleLabel.textColor = .white
    cell.filmTitleLabel.textAlignment = .center
    cell.moreInforTextView.textColor = .red
    cell.selectionStyle = .none
    
    // if a cell previously in a expanded state, refresh the cell to its origin state
    cell.moreInforTextView.text = film.isExpanded ? film.plot : moreInfoText
    cell.moreInforTextView.textAlignment = film.isExpanded ? .left : .center
    cell.moreInforTextView.textColor = film.isExpanded ?
      UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0) : .red
    
    return cell
  }
}

//MARK: - UITableViewDelegate
extension AuteurDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // ge tthe reference of the cell at the selected indexPAth and downcast into FilmTableViewCell
    guard let cell = tableView.cellForRow(at: indexPath) as? FilmTableViewCell else {
      return
    }
    // get the corresponding Film object in the cell
    var film = selectedAuteur.films[indexPath.row]
    
    // toggle the isExpanded state and add the Film back into the array
    film.isExpanded = !film.isExpanded
    selectedAuteur.films[indexPath.row] = film
    
    // if we expand the textView,
    // we change the content, color, and aligment of the textView accordingly
    cell.moreInforTextView.text = film.isExpanded ? film.plot : moreInfoText
    cell.moreInforTextView.textAlignment = film.isExpanded ? .left : .center
    cell.moreInforTextView.textColor = film.isExpanded ?
      UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0) : .red
    
    // refresh the table cell heights
    tableView.beginUpdates()
    tableView.endUpdates()
    
    // tell the table view to scroll the selected row
    // to the top of the table view animatedly
    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    
  }
}
