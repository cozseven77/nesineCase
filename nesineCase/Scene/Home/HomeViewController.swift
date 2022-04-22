//
//  HomeViewController.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//

import UIKit
import TinyConstraints

final class HomeViewController: BaseViewController<HomeViewModel> {
    
    lazy var searchField: UITextField = {
        var textfield = UITextField(frame: .zero)
        textfield.placeholder = "Ara"
        textfield.backgroundColor = .white
        textfield.textColor = .black
        textfield.borderStyle = .roundedRect
        textfield.textAlignment = .left
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ImageCell.self)
        collectionView.registerHeader(SectionTitleHeaderView.self)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        configureContents()
        subscribeViewModel()
    }
    
    private func addEmptyView() {
        let emptyView = EmptyView()
        collectionView.addSubview(emptyView)
        emptyView.edgesToSuperview(insets: .init(top: 0, left: 8, bottom: 0, right: 8),
                                   usingSafeArea: true)
    }
    
    private func removeEmptyView() {
        collectionView.subviews.filter({ $0 is EmptyView }).forEach({ $0.removeFromSuperview() })
    }
}

// MARK: - UILayout
extension HomeViewController {
    
    private func addSubViews() {
        addSearchBar()
        addCollectionView()
    }
    
    private func addSearchBar() {
        view.addSubview(searchField)
        searchField.edgesToSuperview(excluding: .bottom,
                                     insets: .left(8) + .right(8),
                                     usingSafeArea: true)
        searchField.height(50)
    }
    
    private func addCollectionView() {
        view.addSubview(collectionView)
        collectionView.edgesToSuperview(excluding: .top, insets: .right(8) + .left(8), usingSafeArea: true)
        collectionView.topToBottom(of: searchField).constant = 4
    }
}

// MARK: - Configure & SetLocalize
extension HomeViewController {
    
    private func subscribeViewModel() {
        viewModel.reloadData = { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
        
        viewModel.addEmptyView = { [weak self] in
            self?.addEmptyView()
        }
        viewModel.removeEmptyView = { [weak self] in
            self?.removeEmptyView()
        }
    }
    
    private func configureContents() {
        view.backgroundColor = .lightGray
        navigationItem.title = "Search"
        searchField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - Route
extension HomeViewController {
    
    func routeToDetail(indexPath: IndexPath) {
        var cellItem: ImageCellProtocol?
        let sectionType = SectionType(rawValue: indexPath.section)
        switch sectionType {
        case .small:
            cellItem = viewModel.zeroToHundredCellItemAt(indexPath: indexPath)
        case .medium:
            cellItem = viewModel.hundredToTwoHundredCellItemAt(indexPath: indexPath)
        case .large:
            cellItem = viewModel.twoHundredAndHalfToFiveCellItemAt(indexPath: indexPath)
        case .xLarge:
            cellItem = viewModel.fiveHundredAndMoreCellItemAt(indexPath: indexPath)
        case .none:
            break
        }
        let viewModel = HomeDetailViewModel(image: cellItem?.image ?? UIImage())
        let viewController = HomeDetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Actions
extension HomeViewController {
    
    @objc func editingChanged(_ textfield: UITextField) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(debouncer),
            object: nil
        )
        perform(#selector(debouncer), with: nil, afterDelay: 1)
    }
    
    @objc func debouncer() {
        guard let query = searchField.text else { return }
        viewModel.getSearchData(text: query)
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.routeToDetail(indexPath: indexPath)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SectionType(rawValue: section) {
        case .small:
            return viewModel.zeroToHundredNumberOfItemsAt(section: section)
        case .medium:
            return viewModel.hundredToTwoHundredNumberOfItems(section: section)
        case .large:
            return viewModel.twoHundredAndHalfToFiveNumberOfItems(section: section)
        case .xLarge:
            return viewModel.fiveHundredAndMoreNumberOfItems(section: section)
        default:
            break
        }
        return viewModel.zeroToHundredNumberOfItemsAt(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SectionType(rawValue: indexPath.section) {
        case .small:
            let cell: ImageCell = collectionView.dequeueReusableCell(for: indexPath)
            let cellItem = viewModel.zeroToHundredCellItemAt(indexPath: indexPath)
            cell.set(viewModel: cellItem)
            return cell
        case .medium:
            let cell: ImageCell = collectionView.dequeueReusableCell(for: indexPath)
            let cellItem = viewModel.hundredToTwoHundredCellItemAt(indexPath: indexPath)
            cell.set(viewModel: cellItem)
            return cell
        case .large:
            let cell: ImageCell = collectionView.dequeueReusableCell(for: indexPath)
            let cellItem = viewModel.twoHundredAndHalfToFiveCellItemAt(indexPath: indexPath)
            cell.set(viewModel: cellItem)
            return cell
        case .xLarge:
            let cell: ImageCell = collectionView.dequeueReusableCell(for: indexPath)
            let cellItem = viewModel.fiveHundredAndMoreCellItemAt(indexPath: indexPath)
            cell.set(viewModel: cellItem)
            return cell
        default:
            break
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width / 2) - 16
        return .init(width: cellWidth, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.size.width
        return .init(width: width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            return setHeaderView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
        return UICollectionReusableView()
    }
    
    private func setHeaderView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        switch SectionType(rawValue: section) {
        case .small:
            let smallSectionHeader: SectionTitleHeaderView = collectionView.dequeueReusableCell(ofKind: kind, for: indexPath)
            smallSectionHeader.title = "0-100kb"
            return smallSectionHeader
        case .medium:
            let mediumSectionHeader: SectionTitleHeaderView = collectionView.dequeueReusableCell(ofKind: kind, for: indexPath)
            mediumSectionHeader.title = "100-250kb"
            return mediumSectionHeader
        case .large:
            let largeSectionHeader: SectionTitleHeaderView = collectionView.dequeueReusableCell(ofKind: kind, for: indexPath)
            largeSectionHeader.title = "250-500kb"
            return largeSectionHeader
        case .xLarge:
            let xLargeSectionHeader: SectionTitleHeaderView = collectionView.dequeueReusableCell(ofKind: kind, for: indexPath)
            xLargeSectionHeader.title = "500+kb"
            return xLargeSectionHeader
        default:
            return UICollectionReusableView()
        }
    }
}

