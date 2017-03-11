//
//  CategoryDetailViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/10.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

class CategoryDetailViewController: BaseViewController ,SegMenuDelegate,UITableViewDataSource,UITableViewDelegate{
    
    var id:String? = ""
    var books:NSArray? = []
    fileprivate let iden = "TopDetailCell"
    fileprivate let header = "TopicDetailHeaderCell"
    
    var param = ["":""]
    
    
    fileprivate var booksModel = [Book]()
    
    fileprivate var headerModel:TopicDetailHeader?
    
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 104, width: ScreenWidth, height: ScreenHeight - 104), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = 10
        tableView.rowHeight = 93
        tableView.register(UINib (nibName: self.iden, bundle: nil), forCellReuseIdentifier: self.iden)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "主题书单"
        initSubview()
        requestDetail()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    fileprivate func initSubview(){
        let segView = SegMenu(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 40), WithTitles: ["新书","热度","口碑","完结"])
        segView.menuDelegate = self
        view.addSubview(segView)
    }

    
    fileprivate func requestDetail(){
        //        http://api.zhuishushenqi.com/book/by-categories?gender=male&type=new&major=都市&minor=&start=0&limit=50
        let urlString = "\(baseUrl)/book/by-categories"
        QSNetwork.request(urlString, method: HTTPMethodType.get, parameters: param, headers: nil) { (response) in
            print(response.json ?? "No Data")
            do{
                if let books = response.json?.object(forKey: "books"){
                    self.booksModel =  try XYCBaseModel.model(withModleClass: Book.self, withJsArray:books as! [AnyObject])  as! [Book]
                }
            }catch{
                
            }
            DispatchQueue.main.sync {
                
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
            }
        }
    }
    
    func didSelectAtIndex(_ index:Int){
        let urlString = "\(baseUrl)/book/by-categories"
        let types = ["new","hot","reputation","over"]
        
        let major = param["major"] ?? ""
        let gender = param["gender"] ?? ""
        let type = types[index]
        let params = ["gender":gender,"type":type,"major":"\(major)","minor":"","start":"0","limit":"50"]
        
        QSNetwork.request(urlString, method: HTTPMethodType.get, parameters: params , headers: nil) { (response) in
            print(response.json ?? "No Data")
            do{
                if let books = response.json?.object(forKey: "books"){
                    self.booksModel =  try XYCBaseModel.model(withModleClass: Book.self, withJsArray:books as! [AnyObject])  as! [Book]
                }
            }catch{
                
            }
            DispatchQueue.main.sync {
                
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.booksModel.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TopDetailCell? = tableView.dequeueReusableCell(withIdentifier: iden,for: indexPath) as? TopDetailCell
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell!.model = booksModel.count  > indexPath.row ? booksModel[indexPath.row ]:nil
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionFooterHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let bookDetailVC = BookDetailViewController()
            let book:Book? = booksModel[indexPath.row]
            bookDetailVC.id = book?._id ?? ""
            self.navigationController?.pushViewController(bookDetailVC, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
