class DummyProfile{
  String name;
  String imagePath;
  String job;
  List<String> skill;

  DummyProfile(this.name, this.imagePath, this.job, this.skill);

}
String folderPath = 'assets/images/DummyAccounts/';
String format = '.jpg';

List<DummyProfile> DummyProfileList = [
  DummyProfile('Jimmy', '${folderPath}1${format}', 'Flutter Developer', ['Dart','Java','Kotlin']),
  DummyProfile('Sarah', '${folderPath}2${format}', 'Tech Lead', ['AI','Python','Node.JS']),
  DummyProfile('James', '${folderPath}3${format}', 'DevOps Engineer', ['CI CD','AWS','TS']),
  DummyProfile('Emma', '${folderPath}4${format}', 'Java Developer', ['JAVA','Github','Android']),
  DummyProfile('Eithan', '${folderPath}5${format}', 'Full Stack Developer', ['PHP','HTML','JavaScript']),
  DummyProfile('Chloe', '${folderPath}6${format}', 'Data Engineer', ['Kafka','AWS','Spark']),
  DummyProfile('Lily', '${folderPath}7${format}', 'Graphics Designer', ['AI','Illustration','3D']),
  DummyProfile('Riley', '${folderPath}8${format}', 'Resource Manager', ['Commun','AWS','PHP']),
  DummyProfile('Riley', '${folderPath}9${format}', 'IOS Developer', ['Swift','Java','Kotlin']),
];