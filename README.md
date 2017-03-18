# Context
- - - -
L'application News a été développée dans le cadre d'un test technique demandé par [Sprint Technology](http://www.sprintechnology.com/).
# A propos de News
- - - -
![Swift 3.0+](https://img.shields.io/badge/Swift-3.0+-orange.svg) ![Platform](https://img.shields.io/badge/platforms-iOS%2010.0+-333333.svg) ![Devices](https://img.shields.io/badge/Device-iPhone%20|%20iPad-333333.svg)

News est une application qui permet d'afficher les actualités à la une à partir d'un [flux RSS](http://www.lemonde.fr/rss/une.xml).
![picture alt](https://drive.google.com/uc?export=view&id=0Bz7VLJsUViniUEtIb2ZiMFpTakU "Liste des actualités") ![picture alt](https://drive.google.com/uc?export=view&id=0Bz7VLJsUViniZGhReHgtRFphM1E "Détails d'une actualité")
# Détails techniques
- - - -
### Language et outils de développement
---
##### 1. language de programmation :
J'ai choisi de développer l'application en Swift 3 avec un xcode 8.2.1 pour mettre en avant mon niveau de maitrise de ce language de programmation que j'ai commencé depuis un ans et demi.
##### 2. Pods utilisés
###### - [SwiftyXMLParser](https://github.com/yahoojapan/SwiftyXMLParser)
C'est un parser XML simple développé en Swift. J'ai utilisé ce pod pour parser le XML récupéré du flux RSS. c'est la première fois que j'utilise ce pod et personnellement je l'ai choisi pour sa simplicité d'utilisation et le faite qu'on peut accèder au noeuds du XML avec des "subscript". Je le recommande fortement.
###### - [Kingfisher](https://github.com/onevcat/Kingfisher)
Kingfisher est un pod écrit en Swift qui permet le téléchargement et la mise en cache d'images. J'utilisé ce pod dans le but de rendre le téléchargement des images des news fluide, rapide et asynchrone. C'est un pod facile à utiliser et contient plusieurs fonctionnalité avancées. Je l'utilise souvent dans mes projets. 
##### 3. Test Unitaire
Pour les tests unitaire j'ai utilisé XCTest de xCode.
##### 4. Gestionaire de source
Git, Source Tree.
### Architecture
---
Pour ce projet j'ai opté pour une architecture trois tiers. L'application est divisée en trois niveaux ou couches :
- couche présentation
- couche métier
- couche accès aux données (je l'appelerai couche service)
##### - Couche service
Cette couche constirue le pont entre l'application est le monde exterieur (le Flux RSS dans notre cas). Elle est responsable des appels WS. Dans le projet cette couche est manifestée par la class _Connector.swift_. Pour la les appels WS je n'ai pas utilisé des pods vu la simplicité de la tâche dans ce projet. Du coup j'ai décidé de l'implementer moi même en utilisant la class _URLSession_.
L'implémentation de ma class Connector est très simple, efficace et générique dans le sens où on peut l'utilisé dans n'importe quel autre projet pour récupérer des XML.
voici l'implmentation de ma class: 
##### Connector.swift
```
class Connector {
    var session: URLSession
    init(_ session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    public func loadRSS(_ rssURL: String, completion: @escaping (String?, ConnectorError?) -> Void) {
        guard let url = URL(string: rssURL) else {
            completion(nil, ConnectorError.url)
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            if let data = data , httpResponse.statusCode == 200 && error == nil {
                if let xmlString = String(data: data, encoding: .utf8) {
                    completion(xmlString, nil)
                }
                else{
                    completion(nil, ConnectorError.xml)
                }
            }
            else {
                completion(nil, ConnectorError.server)
            }
        }
        task.resume()
    }
}
```
###### difficulté rencontrée
L'une des déficulté que j'ai rencontré pendant le développement de cette class était lors de l'écriture des tests unitaires. Il est connu que pour tester une méthode il faut casser tout ses dépendances. Dans ma méthode `public func loadRSS(_ rssURL: String, completion: @escaping (String?, ConnectorError?) -> Void)` j'avais une dépendance forte avec la class _URLSession_ qui se manifeste dans l'appel de la méthode de _URLSession_ `func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask`. Pour casser cette dépendance j'ai utilisé l'injection de dépendance en ajoutant l'instance de _URLSeesion_ comme paramètre dans le constructor de ma class avec une valuer par défaut. Cette approche ma permit de mocker très facilement la class URLSession. 
Voici le mock de _URLSession_ :
```
class MockURLSession: URLSession {
    var data: Data?
    var response:URLResponse?
    var error: Error?
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = MockURLSessionDataTask()
        completionHandler(self.data, self.response, self.error)
        return task
    }
}
class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() {

    }
}
```
#### - Couche Métier
Elle correspond à la partie fonctionnelle de l'application, celle qui implémente la « logique », et qui décrit les opérations de l'application. Les différentes règles de gestion et de contrôle du système sont mises en œuvre dans cette couche.
Dans cette couche on distingue deux parties :
- les objets métier : 
    * Channel.swift : Elle reprensente l'ensemble des actualités et les données relatives au disviseur des actualités (Lemonde.fr dans notre cas). 
    * Item.swift : Elle represente les données d'une actualité lamda
- un manager : RSSManager.swift : cette calsse représente la canal de communication entre la couche presentation et la couche service. elle joue le rôle d'un data provider pour l'alimentation des données de l'UI. Dans le context de notre projet, cette classe contient une seuls méthode public (`func loadChannel(completion:@escaping (Channel?, ConnectorError?) -> Void)`). Elle permet de faire une demande de récupération du flux RSS au _Connector_. Une fois le ce dernier renvoi la réponse, le manager va transformer ce flux en objet _Channel_ qui contient tout les _Item_. Cette transformation est réalisée en utilisant le paser XML _SwiftyXMLParser_.
 Voici l'implémentaion de cette mèthode : 
 ```
 func loadChannel(completion:@escaping (Channel?, ConnectorError?) -> Void){
        self.connector.loadRSS(leMondeRSSURL) { (xml, error) in
            guard let xml = xml else {
                completion(nil, error)
                return
            }
            if let dictionary = self.parseRSS(xml){
                let channel = Channel(dictionary: dictionary)
                completion (channel, nil)
            }
            else{
                completion (nil, ConnectorError.xml)
            }
        }
    }
 ```
Pour les tests unitaires, j'ai utlisé la même technique (injection de dépendance) pour cassé la dépendance entre le _RSSManage_ et le _Connector_. Ensuite j'ai créé un mock pour le Connector : 
```
class MockConnector: Connector {
    var xml :String?
    var error: ConnectorError?
    var loadRSSIsCalled = false
    override func loadRSS(_ rssURL: String, completion: @escaping (String?, ConnectorError?) -> Void) {
        loadRSSIsCalled = true
        completion(xml, error)
    }
}
```
- Couche Présentation : L'interface de l'application est trés simple et basique. Il se compose d'un UITableViewController _NewsTableViewController_ pour afficher la liste des actualités du flux. Et un UIViewController _DetailNewsViewController_ pour afficher le détail d'une actualité. L'implémentation de ces deux interfaces est trés simple.

##### Temps de réalisation du projet
- Développement : ~ 7h
- Documentation : ~ 4h