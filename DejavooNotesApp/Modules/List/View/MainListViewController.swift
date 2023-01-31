import UIKit
import SnapKit

class MainListViewController: UIViewController {
    var presenter: AnyObject?
    weak var output: MainListViewOutput?
    private var items = [ListItem]()
    let tableView: UITableView = {
        let table = UITableView()
        table.register(CustomCell.self, forCellReuseIdentifier: CustomCell.reuseIdentifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        navigationItem.title = "List of notes".localized
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        output?.updateItems()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addItem))
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func addItem() {
        let alert = UIAlertController(title: "Enter element title".localized,
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit".localized,
                                      style: .cancel,
                                      handler: { [weak self] _ in
            guard let textField = alert.textFields?.first,
                    let text = textField.text,
                    !text.isEmpty else { return }
            self?.output?.addItem(title: text)
        }))
        present(alert, animated: true)
    }
}

extension MainListViewController: MainListViewInput {
    func updateTableView(data: [ListItem]) {
        self.items = data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func performError(string: String) {
        let alertController = UIAlertController(title: string, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MainListViewController: UITableViewDelegate {}

extension MainListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.reuseIdentifier, for: indexPath) as! CustomCell
        cell.configure(dataModel: items[indexPath.row], delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            output?.deleteItem(item: items[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        output?.openTaskVC(item: item)
    }
}

extension MainListViewController: MainCellDelegate {
    func moreButtonPressed(_ item: DataDelegate) {
        let sheet = UIAlertController(title: "Edit element".localized,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel".localized,
                                      style: .cancel,
                                      handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit".localized,
                                      style: .default,
                                      handler: {  [weak self] _ in
            let alert = UIAlertController(title: "Enter element title".localized,
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.addAction(UIAlertAction(title: "Submit".localized,
                                          style: .cancel,
                                          handler: { [weak self] _ in
                guard let textField = alert.textFields?.first,
                        let text = textField.text,
                        !text.isEmpty else { return }
                self?.output?.editItem(item: item as! ListItem, title: text)
            }))
            self?.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete".localized,
                                      style: .destructive,
                                      handler: { [weak self] _ in
            self?.output?.deleteItem(item: item as! ListItem)
        }))
        present(sheet, animated: true)
    }
    
    func taskButtonPressed(_ item: DataDelegate) {}
}
