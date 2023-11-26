//
//  ProductsListViewController.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//

import UIKit

final class ProductsListViewController: UIViewController { // final 😕
    
    private let productsTableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .white // WHITE!
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.color = .white
        return indicator
    }()
    
    private let totalPriceLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "total: 0$"
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()
    
    private var errorAlertController = UIAlertController(title: "Error", message: "", preferredStyle: .alert) //for error handling
    
    private let productsViewModel = ProductsListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupProductsViewModel()
        productsViewModel.viewDidLoad()
        activityIndicator.startAnimating()
    }
    
    //MARK: setup UI
    private func setupUI() { // private
        view.backgroundColor = .white // just changed to white
        setupTableView()
        setupIndicator()
        setupTotalPriceLbl()
    }
    
    private func setupTableView() { // private
        view.addSubview(productsTableView)
        
        NSLayoutConstraint.activate([
            productsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            productsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        productsTableView.delegate = self // added delegate and dataSource
        productsTableView.dataSource = self
        productsTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
    }
    
    private func setupIndicator() { // private
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTotalPriceLbl() { // private
        view.addSubview(totalPriceLbl)
        
        NSLayoutConstraint.activate([
            totalPriceLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalPriceLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalPriceLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: Setup delegates
    private func setupProductsViewModel() {
        productsViewModel.delegate = self
    }
}

extension ProductsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productsViewModel.products?.count ?? 0 // changed from 10 to this
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let currentProduct = productsViewModel.products?[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell
        else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.reload(with: currentProduct)
        return cell
    }
}

extension ProductsListViewController: ProductsListViewModelDelegate {
    
    func productsAmountChanged() {
        totalPriceLbl.text = "Total price: \(productsViewModel.totalPrice ?? 0)"
    }
    
    func productsFetched() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating() // both actions should happen on main thread
        }
        
        DispatchQueue.main.async {
            self.productsTableView.reloadData()
        }
    }
    
    func errorAlert(with message: Error) {
        DispatchQueue.main.async {
            self.errorAlertController.message = message.localizedDescription
            self.errorAlertController.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(self.errorAlertController, animated: true, completion: nil)
        }
    }
}

extension ProductsListViewController: ProductCellDelegate {
    func addProduct(for cell: ProductCell) {
        if let indexPath = productsTableView.indexPath(for: cell) {
            productsViewModel.addProduct(at: indexPath.row) // + 1 was not required
            productsTableView.reloadRows(at: [indexPath], with: .automatic) 
        }
    }
    
    func removeProduct(for cell: ProductCell) {
        if let indexPath = productsTableView.indexPath(for: cell) {
            productsViewModel.removeProduct(at: indexPath.row) // + 1 was not required
            productsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}


