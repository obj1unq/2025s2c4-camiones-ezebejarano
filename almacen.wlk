object almacen {
    const property cosas = #{}
    var property bultosMax = 3

    method cargar(cosasNuevas) {
        cosas.addAll(cosasNuevas)
    }

    method totalBultos() {
        return (cosas.map({ cosa => cosa.valorBulto() })).sum()
    }
}
