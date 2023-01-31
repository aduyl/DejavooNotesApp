import UIKit

final class TasksViewController: UIViewController {
    var presenter: AnyObject?
    weak var output: TasksViewOutput?
    private var item = ListItem()
    private var data = [TaskItem]()
    let tableView: UITableView = {
        let table = UITableView()
        table.register(CustomCell.self, forCellReuseIdentifier: CustomCell.reuseIdentifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        output?.updateItems()
        navigationItem.title = item.wrappedTitle
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addTask))
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func addTask() {
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
            self?.output?.addTask(title: text)
        }))
        present(alert, animated: true)
    }
}

extension TasksViewController: TasksViewInput {
    func updateTableView(data: ListItem) {
        self.item = data
        self.data = data.taskArray
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

extension TasksViewController: UITableViewDelegate {}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.reuseIdentifier, for: indexPath) as! CustomCell
        cell.configure(dataModel: data[indexPath.row], delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            output?.deleteTask(item: data[indexPath.row])
        }
    }
}

extension TasksViewController: MainCellDelegate {
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
                self?.output?.editTask(item: item as! TaskItem, title: text, state: nil)
            }))
            self?.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete".localized,
                                      style: .destructive,
                                      handler: { [weak self] _ in
            self?.output?.deleteTask(item: item as! TaskItem)
        }))
        present(sheet, animated: true)
    }
    
    func taskButtonPressed(_ item: DataDelegate) {
        output?.editTask(item: item as! TaskItem, title: nil, state: true)
    }
}

