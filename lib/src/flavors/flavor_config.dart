enum Flavor { cliente, repartidor, admin }

class FlavorConfig {
  static late final Flavor flavor;

  static void setup(Flavor f) {
    flavor = f;
  }

  static bool get isCliente => flavor == Flavor.cliente;
  static bool get isRepartidor => flavor == Flavor.repartidor;
  static bool get isAdmin => flavor == Flavor.admin;
}
