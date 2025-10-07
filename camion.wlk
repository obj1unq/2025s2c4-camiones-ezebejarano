
import cosas.*
import almacen.*


object camion {
    const property cosas = #{}
	const tara = 1000
	const pesoMax = 2500

    method cargar(unaCosa) {
        if(cosas.contains(unaCosa)){
            throw new Exception(message = "El camion ya tiene cargada la cosa")        
        }
        cosas.add(unaCosa)
    }

    method descargar(unaCosa) {
        if (!cosas.contains(unaCosa)) {
            throw new Exception(message = "El camión no contiene esa cosa")            
        }
        cosas.remove(unaCosa) 
    }

    method cosasCargadas() {
        return cosas
    }

    method esPesoPar() { 
		return cosas.all({ cosa => cosa.peso().even() })
	}

    method hayAlgunoQuePesa(peso) {
        return cosas.any({ unaCosa => unaCosa.peso() == peso })
    }

	method pesoCamion(){
		return (tara + cosas.sum({ cosa => cosa.peso()}) )
	}
	
	method excedidoDePeso() {
		return (self.pesoTotal() > pesoMax)
	}

	method elDeNivel(nivel) {
    var resultado = cosas.find({ cosa => cosa.nivelPeligrosidad() == nivel })
    if (resultado == null) { 
        throw new Exception(message = "No hay ningún objeto con nivel de peligrosidad " + nivel)
    }
    return resultado
}

	method objetosQueSuperanPeligrosidad(nivel) {
		return (cosas.filter({ cosa => cosa.nivelPeligrosidad() > nivel }))
	}


	method objetosMasPeligrososQue(cosa) {
		return (cosas.filter({ cosaD => cosaD.esMasPeligrosaQue(cosa) }))
	}

	method ningunoSuperaNivelDePeligro(niv) {
		return self.objetosQueSuperanPeligrosidad(niv) == #{}
	}

	method puedeCircular(nivelPeligrosidad) {
		return (!(self.excedidoDePeso())) && (self.objetosQueSuperanPeligrosidad(nivelPeligrosidad) == #{})

	}

	method tieneAlgoQuePesaEntre(min,max) {
		return (cosas.any({ cosa => (cosa.peso() >= min) and (cosa.peso() <= max) }))
	}

	method cosaMasPesada() {
		return (cosas.max({ cosa => cosa.peso() }))
	}

	method pesos() {
		return (cosas.map({ cosa => cosa.peso() }))
	}

	method totalBultos() {
		return (cosas.map({ cosa => cosa.valorBulto() })).sum()
	}
	method sufrirAccidente(){
		cosas.forEach({unaCosa => unaCosa.sufrirAccidente()})
	}
	method pesoTotal() {
    	return cosas.sum({ unaCosa => unaCosa.peso() })
	}

	method nivelPeligrosidadTotal() {
    	return cosas.sum({ unaCosa => unaCosa.nivelPeligrosidad() })
	
	}

	method transportar(destino, camino) {
		self.validarTransporte(destino, camino)
		destino.cargar(cosas)
		cosas.removeAll(cosas)
	}

	method validarTransporte(destino,camino) {
		self.validarPeso()
		self.validarBultos(destino)
		self.validarCamino(camino)
	}

	method validarPeso() {
		if (self.excedidoDePeso()) {self.error("esta excedido de peso")}
	}

	method validarBultos(destino) { 
		if ((self.totalBultos() + destino.totalBultos()) > destino.bultosMax()) {self.error("esta excedido de bultos")}
	}

	method validarCamino(camino) {
		if (not camino.camionPuedePasar(self)) {self.error("esta excedido de peligrosidad")}
		if (not camino.camionPuedePasar(self)) {self.error("no puede pasar por " + camino)}
	}

    // =========================
    // Alias agregado para compatibilidad con rutas
    method puedeCircularEnRuta(nivelPeligrosidad) {
        return self.puedeCircular(nivelPeligrosidad)
    }
    // =========================
}

object rutaNueve {
	const nivelPeligrosidad = 11

	method camionPuedePasar(camionD) {
		return camionD.puedeCircularEnRuta(nivelPeligrosidad)
	}
}

object vecinales {
	var property  pesoMax = 0

	method camionPuedePasar(camionD) {
		return (camionD.pesoTotal() < pesoMax)
	}
}