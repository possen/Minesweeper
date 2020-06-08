//
//  ViewController.swift
//  MineSweeper
//
//  Created by Paul Ossenbruggen on 6/7/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak private var gridContainer: UIStackView!
    var game: Game?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetBoard(mines: 50)
    }

    func displayAlert(message: String) {
        let alertController = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert
        )
        let resetAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            DispatchQueue.main.async {
                self?.askNewGame()
            }
        }
        alertController.addAction(resetAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func askNewGame() {
        let alertController = UIAlertController(
            title: nil,
            message: "How many mines? ",
            preferredStyle: .alert
        )
        alertController.addTextField(configurationHandler: { (textfield: UITextField) in
            textfield.placeholder = "50"
            textfield.keyboardType = .numberPad
        })
        let resetAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            let number = alertController.textFields?.first?.text
            self?.resetBoard(mines: Int(number ?? "50") ?? 50)
        }
        alertController.addAction(resetAction)
        present(alertController, animated: true, completion: nil)

    }

    private func resetBoard(mines: Int) {
        do {
            let board = try Board(dimensions: (20, 40), mines: mines)
            game = Game(board: board)
            gridContainer.subviews.forEach { $0.removeFromSuperview() }
            setupGrid(rows: board.dimensions.1, columns: board.dimensions.0)
        } catch {
            displayAlert(message: error.localizedDescription)
        }
    }
    
    func processTap(tap: Bool, column: Int, row: Int) {
        DispatchQueue.main.async {
            do {
                guard let game = self.game else {
                    self.displayAlert(message: "No Game")
                    return
                }
                let board = game.board
                if tap {
                    try game.reveal(x: column, y: row)
                    if game.checkLose() {
                        self.setupGrid(rows: board.dimensions.1, columns: board.dimensions.0)
                        self.displayAlert(message: "You Lose!")
                        self.game = nil
                        self.askNewGame()
                    }
                } else {
                    try game.mark(x: column, y: row)
                    if game.checkWin() {
                        self.displayAlert(message: "You Win!")
                        self.game = nil
                        self.askNewGame()
                    }
                }
//                print(game.board.description)
                self.setupGrid(rows: board.dimensions.1, columns: board.dimensions.0)
            } catch {
                self.displayAlert(message: error.localizedDescription)
            }
        }
    }

    private func setupGrid(rows: Int, columns: Int) {
        guard let game = game else {
            displayAlert(message: "No Game")
            return
        }
        gridContainer.subviews.forEach { $0.removeFromSuperview() }
        let board = game.board
        (0..<rows).forEach { row in
            var rowContents: [Box] = []
            let rowContainer = UIStackView()
            rowContainer.axis = .horizontal
            self.gridContainer.addArrangedSubview(rowContainer)
            (0..<columns).forEach { column in
                var value = board.piece(x: column, y: row)
                value = value == .empty ? .blank : value
                value = value == .hidden ? .covered : value
                let box = Box(row: row, column: column, value: value?.rawValue ?? " " ) { [unowned self] in
                    self.processTap(tap: $0, column: column, row: row)
                }
                rowContents.append(box)
                rowContainer.addArrangedSubview(box)
                box.widthAnchor
                    .constraint(equalTo: self.gridContainer.widthAnchor, multiplier: 1.0 / CGFloat(columns))
                    .isActive = true
                box.heightAnchor
                    .constraint(equalTo: self.gridContainer.heightAnchor, multiplier: 1.0 / CGFloat(rows))
                    .isActive = true
            }
        }
    }
}

class Box: UILabel {
    private(set) var isPothole = false
    private(set) var row: Int
    private(set) var column: Int
    let tap: (Bool) -> Void

    init(row: Int, column: Int, value: String, tap: @escaping (Bool) -> Void) {
        self.row = row
        self.column = column
        self.tap = tap
        super.init(frame: .zero)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.textAlignment = .center
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognizer(_:)))
//        longPress.delaysTouchesBegan = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(_:)))
 //       tapGesture.delaysTouchesBegan = true
        tapGesture.require(toFail: longPress)
        self.addGestureRecognizer(longPress)
        self.addGestureRecognizer(tapGesture)
//        self.font = UIFont.systemFont(ofSize: 35)
        self.text = value
        self.lineBreakMode = .byClipping
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapGestureRecognizer(_: Any) {
        tap(true)
    }
    
    @objc func longPressGestureRecognizer(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            tap(false)
            layer.backgroundColor = UIColor.systemRed.cgColor
        } else {
            layer.backgroundColor = UIColor.systemBackground.cgColor
        }
    }
}
