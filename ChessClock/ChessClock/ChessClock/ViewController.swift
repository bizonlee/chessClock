//
//  ViewController.swift
//  ChessClock
//
//  Created by Zhdanov Konstantin on 15.12.2024.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chessSplash") // Убедитесь, что имя файла соответствует вашему логотипу
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Изменил типы time и timePlus на Double
    private let data: [(title: String, subtitle: String, time: Double, timePlus: Double)] = {
        let presets = [
            ("Пуля", "1+0", 60.0, 0.0),
            ("Пуля", "2+1", 120.0, 1.0),
            ("Блиц", "3+0", 180.0, 0.0),
            ("Блиц", "3+2", 180.0, 2.0),
            ("Блиц", "5+0", 300.0, 0.0),
            ("Блиц", "5+3", 300.0, 2.0),
            ("Рапид", "10+0", 600.0, 0.0),
            ("Рапид", "10+5", 600.0, 5.0),
            ("Рапид", "15+10", 900.0, 10.0),
            ("Классика", "30+0", 1800.0, 0.0),
            ("Классика", "30+20", 1800.0, 20.0),
            ("Классика", "45+15", 2700.0, 15.0),
            ("Армагеддон", "5+4", 300.0, 4.0),
            ("Армагеддон", "4+3", 300.0, 3.0),
            ("Армагеддон", "3+2", 300.0, 2.0)
        ]
        var items = presets
        items.append(("Задать свой", "", 0.0, 0.0))
        return items
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ШАХБОКС KEA-Fighting"
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(logoImageView)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        view.addSubview(collectionView)
    }
       
 private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Логотип
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 100), // Высота логотипа
            logoImageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.6), // Ширина логотипа
            // Коллекция
            collectionView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor)
        ])
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            fatalError("Unable to dequeue CustomCollectionViewCell")
        }
        let item = data[indexPath.item]
        cell.configure(title: item.title, subtitle: item.subtitle)
        let isBlack = (indexPath.item / 4 + indexPath.item % 4) % 2 == 0
        cell.contentView.backgroundColor = isBlack ? .black : .white
        cell.titleLabel.textColor = isBlack ? .white : .black
        cell.subtitleLabel.textColor = isBlack ? .lightGray : .darkGray
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let totalSpacing = spacing * 3
        let width = (collectionView.frame.width - totalSpacing) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.item]
        // Передаем значения времени как Double
        let timerVC = TimerViewController(timeControl: item.time, timePlus: item.timePlus)
        navigationController?.pushViewController(timerVC, animated: true)
    }
}

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
