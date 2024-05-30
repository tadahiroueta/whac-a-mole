//
//  ViewController.swift
//  whac-a-mole
//
//  Created by Ueta, Lucas T on 8/29/23.
//

import UIKit

class ViewController: UIViewController {
    
    var width = 0, screenHeight = 0, score = 0, timer = Timer(), everyOther = true, moles: [UIButton] = [], previousScore = 0
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.backgroundColor = UIColor(red: 0.365, green: 0.58, blue: 0.976, alpha: 1).cgColor // #5D94F9
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 125
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "PressStart2P-Regular", size: 24)
        updateScore()
        stack.addArrangedSubview(label)
        label.centerXAnchor.constraint(equalTo: stack.centerXAnchor).isActive = true

        let floors = UIStackView()
        floors.axis = .vertical
        floors.alignment = .center
        floors.spacing = 75
        stack.addArrangedSubview(floors)
        floors.centerXAnchor.constraint(equalTo: stack.centerXAnchor).isActive = true
        
        for _ in 0 ... 3 {
            let grass = UIImageView(image: UIImage(named: "grass.png"))
            grass.contentMode = .scaleAspectFit
            floors.addArrangedSubview(grass)
            NSLayoutConstraint.activate([
                grass.widthAnchor.constraint(equalTo: floors.widthAnchor),
                grass.heightAnchor.constraint(equalToConstant: 100)
        ])}
        
        addMole()
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }

    func formattedScore(_ score: Int) -> String {
        if score < -99 { return "-99" }
        if score < -9 { return String(score) }
        if score < 0 { return "-0\(abs(score))" }
        if score < 10 { return "00\(score)" }
        if score < 100 { return "0\(score)" }
        if score < 1000 { return String(score) }
        return "999"
    }
    
    func updateScore() { label.text = "\(formattedScore(score)) Whac-A-Mole" }
    
    func move(_ mole: UIButton) { mole.frame = CGRect(x: Int.random(in: 10...285), y: 175 * Int.random(in: 0...3) + 170, width: 100, height: 100) }
    
    func addMole() {
        let mole = UIButton()
        move(mole)
        mole.setImage(UIImage(named: "mole.png"), for: .normal)
        mole.contentMode = .scaleAspectFit
        mole.addTarget(self, action: #selector(whac(_:)), for: .touchUpInside)
        view.addSubview(mole)
        moles.append(mole)
        
    }
    
    func updateNMoles() {
        let nMolesToAdd = (score < 0 ? 1 : score / 10 + 1) - moles.count
        
        if nMolesToAdd < 0 { for _ in nMolesToAdd ... -1 { moles.removeLast().removeFromSuperview() }}
        else if nMolesToAdd > 0 { for _ in 1 ... nMolesToAdd { addMole() }}
    }
    
    @objc func whac(_ sender: UIButton) {
        sender.removeFromSuperview()
        score += 1
        updateScore()
    }
    
    @objc func tick() {
        everyOther.toggle()

        if previousScore == score {
            // slower if struggling
            if score < 0 && everyOther { return }
            
            score -= 1
            updateScore()
        }
        else { for mole in moles { view.addSubview(mole) }}
        
        previousScore = score
        updateNMoles()
        for mole in moles { move(mole) }
}}
