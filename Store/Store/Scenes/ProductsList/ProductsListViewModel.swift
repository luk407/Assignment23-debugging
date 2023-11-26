//
//  ProductsListViewModel.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//

import Foundation

protocol ProductsListViewModelDelegate: AnyObject {
    func productsFetched()
    func productsAmountChanged()
    func errorAlert(with message: Error)
}

final class ProductsListViewModel { // switched to final class

    weak var delegate: ProductsListViewModelDelegate?
    
    var products: [ProductModel]? // switched to private var
    var totalPrice: Double? { products?.reduce(0) { $0 + $1.price * Double(($1.selectedAmount ?? 0))} }
    
    func viewDidLoad() {
        fetchProducts()
    }
    
    private func fetchProducts() {
        NetworkManager.shared.fetchProducts { [weak self] response in
            switch response {
            case .success(let products):
                self?.products = products
                self?.delegate?.productsFetched()
            case .failure(let error):
                //MARK: handle Error. HANDLED?
                self?.products = []
                self?.delegate?.errorAlert(with: error)
            }
        }
    }
    
    func addProduct(at index: Int) {
        var product = products?[index]
        //MARK: handle if products are out of stock. HANDLED!!!
        if (product?.stock ?? 0) > 0 {
            product?.selectedAmount = (products?[index].selectedAmount ?? 0 ) + 1
            product?.stock -= 1
            products?[index].selectedAmount = product!.selectedAmount // products array was not updated at all in original code
            products?[index].stock = product?.stock ?? 0
        }
        delegate?.productsAmountChanged()
    }
    
    func removeProduct(at index: Int) {
        var product = products?[index]
        //MARK: handle if selected quantity of product is already 0. HANDLED!!!
        if (product?.selectedAmount ?? 0) > 0 {
            product?.selectedAmount = (products?[index].selectedAmount ?? 0 ) - 1
            product?.stock += 1
            products?[index].selectedAmount = product!.selectedAmount
            products?[index].stock = product?.stock ?? 0
        } else {
            product?.selectedAmount = 0
            products?[index].selectedAmount = 0
        }
        delegate?.productsAmountChanged()
    }
}
