//
//  ViewController.swift
//  MoviesSearch
//
//  Created by Camille Mince on 1/14/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let api_key = "f859ec43c5b76de1d1a8555fa6eb514d"
    var queryString: String = ""
    var results: [MovieData] = []
    var images: [UIImage] = []
    
    @IBOutlet weak var ResultsView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ResultsView.delegate = self
        ResultsView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel!.text = results[indexPath.row].title
        cell.detailTextLabel!.text = results[indexPath.row].overview
        cell.detailTextLabel!.contentMode = .scaleToFill
        cell.detailTextLabel!.numberOfLines = 0
        return cell
    }
    
    @IBAction func query(_ sender: UITextField) {
        self.queryString = sender.text!
    }
    
    @IBAction func searchClicked(_ sender: UIButton) {
        let search = toValidSearchString(s: &queryString)
        searchMovies(searchString: search, completion: {
            (self.ResultsView.reloadData())
        })
    }
    
    func displayAlert() {
        let alert = UIAlertController(title: "Something went wrong...", message: "There were no results for your search. Please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadImages(completion: () -> ()) {
        //had trouble linking UIImage to ImageView in TableViewCell...
        for i in 0...results.count-1 {
            let poster_path_at_index = results[i].poster_path!
            let imageUrlString = "https://image.tmdb.org/t/p/w600_and_h900_bestv2" + poster_path_at_index + ".jpg"
            let imageUrl = URL(string: imageUrlString)!
            let imageData = try! Data(contentsOf: imageUrl)
            let image = UIImage(data: imageData)
            images.append(image!)
        }
        completion()
    }
    
    func searchMovies(searchString: String, completion: @escaping () -> ()) {
        //generate URL
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=f859ec43c5b76de1d1a8555fa6eb514d&query=" + searchString
        let url = URL(string: urlString)
        
        if (url == nil) {
            //display alert that input was invalid
            self.displayAlert()
        } else {
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            guard let data = data else { return }
            
            if error == nil {
                let decoder = JSONDecoder()
                    
                do {
                    //decode JSON data
                    let decodedData = try decoder.decode(ResultsType.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.results = decodedData.results!
                        completion()
                        }
                    
                } catch {
                        debugPrint("Error in JSON parsing")
                    }
            } else {
                print("There was an error")
            }
        })
        task.resume()
    }
    }


}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}








