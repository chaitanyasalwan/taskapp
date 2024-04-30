enum Flavor {
  dev,
  uat,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Task Dev App';
      case Flavor.uat:
        return 'Task Test App';
      case Flavor.prod:
        return 'Task';
      default:
        return 'title';
    }
  }

}
