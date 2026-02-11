param(
    [string]$flavor = "cliente",
    [string]$target = ""
)

if ($target -eq "") {
    switch ($flavor) {
        "cliente" { $target = "lib/main_cliente.dart" }
        "repartidor" { $target = "lib/main_repartidor.dart" }
        "admin" { $target = "lib/main_admin.dart" }
        default { Write-Error "flavor desconocido"; exit 1 }
    }
}

Write-Host "building flavor=$flavor target=$target"

# ejemplo para android apk
flutter pub get
flutter build apk -t $target --dart-define=FLAVOR=$flavor

# para web admin usar build web
if ($flavor -eq 'admin') {
    flutter build web -t $target --dart-define=FLAVOR=$flavor
}
