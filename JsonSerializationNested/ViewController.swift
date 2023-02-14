//
//  ViewController.swift
//  JsonSerializationNested
//
//  Created by Sejal on 14/02/23.
//

import UIKit

class ViewController: UIViewController {
 
    @IBOutlet weak var productCollectionView: UICollectionView!
    var productData = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchApi()
       let nib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        productCollectionView.register(nib, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
    
        
    }
        
        func fetchApi() {
            
            let urlString = "https://fakestoreapi.com/products"
            let url = URL(string: urlString)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: request) { data, response, error in
                
               // print("data received \(data)")
              //  print(response!)
              //  print(error)
                
                let getJSONObject = try! JSONSerialization.jsonObject(with: data!) as! [[String : Any]]
                
                print(getJSONObject)
                for eachProduct in getJSONObject {
                    
                    let id = eachProduct["id"] as! Int
                    let title = eachProduct["title"] as! String
                    let price = eachProduct["price"] as! Double
                    let rating = eachProduct["rating"] as! [String : Any]
                    let rate = rating["rate"] as! Double
                    let count = rating["count"] as! Int
                    
                    let newProduct = Product(id: id, title: title, price: price, rate: rate, count: count)
                    
                    self.productData.append(newProduct)
                    
                }
                print("product count is \(self.productData.count)")
                DispatchQueue.main.async {
                    self.productCollectionView.reloadData()
                }
            }
            dataTask.resume()
        }
        
    }
extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        let product = productData[indexPath.row]
        item.idLabel.text = "\(product.id)"
        item.titleLabel.text = product.title
        item.countLabel.text = "\(product.count)"
        item.pricelabel.text = "\(product.price)"
        item.rateLabel.text = "\(product.rate)"
        return item
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: (collectionView.frame.size.width - 10) / 2, height: (collectionView.frame.size.height - 50) / 3)
    }
    
    
    
}
