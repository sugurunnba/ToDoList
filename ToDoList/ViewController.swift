//
//  ViewController.swift
//  ToDoList
//
//  Created by 高木克 on 2022/05/22.
//

import UIKit

//①変更：プロトコル（UITableViewDataSource, UITableViewDelegate）の追加
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    // ②追加：テーブルに表示するデータの箱
    var todoList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addBtnAction(_ sender: Any) {
//        表示画面
        let alertController = UIAlertController(title: "ToDo追加", message: "ToDoを入力してください。", preferredStyle: UIAlertController.Style.alert)
//        アラート内にテキストフィールドを設定
        alertController.addTextField(configurationHandler: nil)
        
//        OKボタンの設定
        let okAction = UIAlertAction(title: "追加する", style: UIAlertAction.Style.default) { (acrion: UIAlertAction) in
            // 追加：OKをタップした時の処理
            if let textField = alertController.textFields?.first {
                self.todoList.insert(textField.text!, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
            }
        }
//        OKボタンを追加
        alertController.addAction(okAction)
        
//        キャンセルボタンの設定
        let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
//        キャンセルボタンを追加
        alertController.addAction(cancelButton)
        
//        UIAlertControllerの起動
        present(alertController, animated: true, completion: nil)
    }

    // ③追加：セルの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }

    // ④追加：セルの中身を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        cell.textLabel?.text = todoList[indexPath.row]
        return cell
    }
    
    // 追加：セルの削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        .deleteのみでも可
        if editingStyle == UITableViewCell.EditingStyle.delete {
//            データ削除
            todoList.remove(at: indexPath.row)
//            それに対応するセルの削除
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

