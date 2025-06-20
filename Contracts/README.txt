#Contrato de Subasta - Trabajo Final Módulo 2

Este proyecto contiene un contrato inteligente de subasta desarrollado como parte del trabajo final del Módulo 2. El contrato fue escrito en Solidity y desplegado en la red Sepolia.

#Descripción

La subasta permite que varios usuarios hagan ofertas por un artículo. Cada nueva oferta debe superar a la anterior en al menos un 5%. El contrato registra las ofertas, permite ver al ganador al finalizar, y también devuelve los depósitos a quienes no ganaron, descontando una comisión del 2%.

Si una oferta válida se realiza en los últimos 10 minutos antes de que termine la subasta, el tiempo se extiende automáticamente 10 minutos más. Además, durante la subasta, los participantes pueden retirar el exceso de ofertas anteriores si realizaron más de una.

#Funcionalidades

- Ofertar por un artículo con validación del 5% mínimo.
- Mostrar al ganador de la subasta.
- Listar todas las ofertas realizadas.
- Permitir el retiro del depósito a los no ganadores.
- Descontar una comisión del 2% al finalizar.
- Extender el tiempo si se oferta en los últimos minutos.
- Reembolsar el excedente de ofertas pasadas durante la subasta.

#Cómo desplegar

1. Abrir [Remix](https://remix.ethereum.org/).
2. Seleccionar el entorno "Injected Provider - MetaMask".
3. Compilar el contrato (Solidity versión 0.8.20).
4. En la parte de despliegue, escribir la duración de la subasta en minutos (por ejemplo, 30).
5. Confirmar el despliegue con MetaMask.

#Contrato en la red Sepolia

Aquí se encuentra la dirección del contrato verificado:  
https://sepolia.etherscan.io/address/0x34577FaBc0D4FD7FF8323179736047a938eb48B9#code
