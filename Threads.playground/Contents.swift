import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

public struct Bread {
    public enum BreadType: UInt32 {
        case small = 1
        case medium
        case big
    }
    
    public let breadType: BreadType
    
    public static func make() -> Bread {
        guard let breadType = Bread.BreadType(rawValue: UInt32(arc4random_uniform(3) + 1)) else {
            fatalError("Incorrect random value")
        }
        
        return Bread(breadType: breadType)
    }
    
    public func bake() {
        let bakeTime = breadType.rawValue
        sleep(UInt32(bakeTime))
    }
}



//MARK: - Storage

///Класс для хранилища хлеба. Хранилище типа LIFO
class BreadStorage {
    private let condvar = NSCondition()
    
    private var array: [Bread] = []
    
    ///Функция, убирающая хлеб
    func pop() {
        condvar.lock()
        guard !array.isEmpty else {
            print("Waiting for a bread..")
            condvar.wait()
            array.removeFirst()
            print("Bread removed")
            condvar.unlock()
            condvar.signal()
            return
        }
        array.removeFirst()
        condvar.unlock()
        condvar.signal()
        print("Bread removed")
    }
    
    ///Функция, добавляющая хлеб
    func push(_ element: Bread) {
        condvar.lock()
        array.append(element)
        condvar.unlock()
        condvar.signal()
        print("Bread added")
    }
    
    ///Функция проверки - пусто ли хранилище
    func isEmty() -> Bool {
        return array.isEmpty
    }
}

private let mainStorage = BreadStorage()

//MARK: - Threads

///Сабкласс для производящего потока
class OrgThread: Thread {
    ///Передача хранилища через инициализатор
    var storage: BreadStorage
    
    required init(storage: BreadStorage) {
        self.storage = storage
    }
    
    ///Таймер, который каждые две секунды добавляет хлеб в хранилище
    private lazy var timer: Timer = {
        let timer = Timer(timeInterval: 2, repeats: true, block: {(timer) in
            ///Когда первый поток закончит работу, таймер уничтожиться
            guard !self.isFinished else {
                timer.invalidate()
                return
            }
            self.storage.push(Bread.make())})
        return timer
    }()
    
    override func main() {
        ///RunLoop для потока
        let runloop = RunLoop.current
        runloop.add(timer, forMode: .default)
        ///Запускаем RunLoop на 20 секунд
        runloop.run(until: Date(timeIntervalSinceNow: 20))
    }
}



///Сабкласс для рабочего потока
class WorkThread: Thread {
    ///Передача хранилища через инициализатор
    var storage: BreadStorage
    
    required init(storage: BreadStorage) {
        self.storage = storage
    }
    
    ///Таймер, который каждую секунду пробует "испечь хлеб"
    private lazy var timer: Timer = {
       let timer = Timer(timeInterval: 1, repeats: true, block: {(timer) in
        ///Когда первый поток закончит работу, таймер уничтожиться
        guard !firstThread.isFinished && self.storage.isEmty() else {
            timer.invalidate()
            return
        }
        self.storage.pop()
        })
        return timer
    }()
    
    override func main() {
        ///RunLoop для потока
        let runloop = RunLoop.current
        runloop.add(timer, forMode: .default)
        ///Запускаем RunLoop
        runloop.run()
    }
}

//Код, который создает экземпляры потоков и заупскает их
let firstThread = OrgThread(storage: mainStorage)
let secondThread = WorkThread(storage: mainStorage)
firstThread.start()
secondThread.start()


