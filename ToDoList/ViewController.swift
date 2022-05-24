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
    // 追記：インスタンスの生成
//    これで、UserDefaultsというローカルにデータを保存するインスタンスを生成
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // 追記：データ読み込み, 配列はarray, String型はstring, int型はintegerになる。
        if let storedTodoList = userDefaults.array(forKey: "todoList") as? [String] {
//            todoListの最後に、storedTodoListの内容を追加する。
            todoList.append(contentsOf: storedTodoList)
        }
    }

    @IBAction func addBtnAction(_ sender: Any) {
//        表示画面
//        preferredStyle: 表示方法の設定(alertとかActionSheetとか)
        let alertController = UIAlertController(title: "ToDo追加", message: "ToDoを入力してください。", preferredStyle: UIAlertController.Style.alert)
//        アラート内にテキストフィールドを設定
//        ここでの入力値は、UIAlertControllerのtextFieldsプロパティに格納される
        alertController.addTextField(configurationHandler: nil)
        
//        OKボタンの設定
//        UIAlertAction.Style.defaultはOKボタン
        let okAction = UIAlertAction(title: "追加する", style: UIAlertAction.Style.default) { (acrion: UIAlertAction) in
            // 追加：OKをタップした時の処理
            if let textField = alertController.textFields?.first {
//                第一引数で挿入したい要素、第二引数で挿入したいindexを指定 -> textField.textの値を配列の0番目に挿入する
                self.todoList.insert(textField.text!, at: 0)
//                with: 行を挿入または削除する時に使用するアニメーションのタイプを指定
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                // 追記：追加したToDoを保存, 第一引数の配列に保存。取り出す時用のキーを第2引数にセット。
                self.userDefaults.set(self.todoList, forKey: "todoList")
            }
        }
//        OKボタンを追加
        alertController.addAction(okAction)
        
//        キャンセルボタンの設定
//        UIAlertAction.Style.cancelはキャンセルボタン
        let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
//        キャンセルボタンを追加
        alertController.addAction(cancelButton)
        
//        UIAlertControllerの起動
//      第一引数: 遷移先のUIViewController
//      第二引数：　アニメーションの指定（true: アニメーション有 / false: アニメーション無）
//      第三引数：　コールバック関数
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
            print(todoList)
//            データ削除
            todoList.remove(at: indexPath.row)
//            それに対応するセルの削除
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            userDefaults.set(todoList, forKey: "todoList")
        }
    }
}

