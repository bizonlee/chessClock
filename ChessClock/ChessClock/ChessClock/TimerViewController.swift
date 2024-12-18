//
//  TimerViewController.swift
//  ChessClock
//
//  Created by Zhdanov Konstantin on 16.12.2024.
//
import UIKit

class TimerViewController: UIViewController {
    private let timeControl: Double
    private let timePlus: Double
    private var player1Time: Double
    private var player2Time: Double
    
    private let player1Button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Игрок 1", for: .normal)
        button.addTarget(self, action: #selector(player1Tapped), for: .touchUpInside)
        return button
    }()
    
    private let player2Button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Игрок 2", for: .normal)
        button.addTarget(self, action: #selector(player2Tapped), for: .touchUpInside)
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сброс", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        return button
    }()
    
    private let pauseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пауза", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
        return button
    }()
    
    private var currentPlayer: Int = 0 // 0: игра не началась, 1: игрок 1, 2: игрок 2
    private var timer: Timer?
    
    init(timeControl: Double, timePlus: Double) {
        self.timeControl = timeControl
        self.timePlus = timePlus
        self.player1Time = timeControl
        self.player2Time = timeControl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        updateButtons()
    }
    
    private func setupViews() {
        view.addSubview(player1Button)
        view.addSubview(player2Button)
        view.addSubview(resetButton)
        view.addSubview(pauseButton)
    }
    
    private func setupConstraints() {
        player1Button.translatesAutoresizingMaskIntoConstraints = false
        player2Button.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            player1Button.topAnchor.constraint(equalTo: view.topAnchor),
            player1Button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            player1Button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            player1Button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.47),
            resetButton.topAnchor.constraint(equalTo: player1Button.bottomAnchor),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resetButton.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            pauseButton.topAnchor.constraint(equalTo: player1Button.bottomAnchor),
            pauseButton.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pauseButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            player2Button.topAnchor.constraint(equalTo: resetButton.bottomAnchor),
            player2Button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            player2Button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            player2Button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.47)
        ])
    }
    
    private func updateButtons() {
        player1Button.setTitle(formattedTime(player1Time, isLast20Seconds: player1Time < 20), for: .normal)
        player2Button.setTitle(formattedTime(player2Time, isLast20Seconds: player2Time < 20), for: .normal)
        
        if currentPlayer == 1 {
            player1Button.backgroundColor = player1Time < 20 ? .red : .green
            player2Button.backgroundColor = .lightGray
        } else if currentPlayer == 2 {
            player2Button.backgroundColor = player2Time < 20 ? .red : .green
            player1Button.backgroundColor = .lightGray
        } else {
            player1Button.backgroundColor = .lightGray
            player2Button.backgroundColor = .lightGray
        }
    }
    
    private func formattedTime(_ time: Double, isLast20Seconds: Bool) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time) % 60
        let milliseconds = Int((time - Double(seconds)) * 100)
        
        if isLast20Seconds {
            return "\(minutes):\(String(format: "%02d", seconds)).\(String(format: "%02d", milliseconds))"
        } else {
            return "\(minutes):\(String(format: "%02d", seconds))"
        }
    }
    
    @objc private func player1Tapped() {
        guard currentPlayer == 0 || currentPlayer == 1 else { return }
        switchPlayer(to: 2)
    }
    
    @objc private func player2Tapped() {
        guard currentPlayer == 0 || currentPlayer == 2 else { return }
        switchPlayer(to: 1)
    }
    
    private func switchPlayer(to newPlayer: Int) {
        // Остановим текущий таймер
        timer?.invalidate()
        // Добавим добавочное время для предыдущего игрока
        if currentPlayer == 1 {
            player1Time += timePlus
        } else if currentPlayer == 2 {
            player2Time += timePlus
        }
        // Обновим текущего игрока
        currentPlayer = newPlayer
        // Запустим таймер для нового игрока
        startTimer(for: newPlayer)
        updateButtons()
    }
    
    private func startTimer(for player: Int) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if player == 1 {
                self.player1Time -= 0.01
                if self.player1Time <= 0 {
                    self.endGame(winner: 2)
                }
            } else if player == 2 {
                self.player2Time -= 0.01
                if self.player2Time <= 0 {
                    self.endGame(winner: 1)
                }
            }
            self.updateButtons()
        }
    }
    
    private func endGame(winner: Int) {
        timer?.invalidate()
        timer = nil
        let alert = UIAlertController(
            title: "Игра окончена",
            message: "Победитель: Игрок \(winner)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func resetTapped() {
        timer?.invalidate()
        timer = nil
        player1Time = timeControl
        player2Time = timeControl
        currentPlayer = 0
        updateButtons()
    }
    
    @objc private func pauseTapped() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        } else {
            startTimer(for: currentPlayer)
        }
    }
}
