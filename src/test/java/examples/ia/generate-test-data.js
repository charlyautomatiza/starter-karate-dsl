function() {
    var scenarios = [
      "Reserva de vuelos con nombre, fecha, número de vuelo y clase.",
      "Detalles de transacciones bancarias con usuario, monto y fecha.",
      "Catálogo de productos con nombre, categoría, precio y disponibilidad.",
      "Información de libros con autor, título, fecha de publicación y género.",
      "Simulación de compras en línea con usuario, productos y total."
    ];
  
    var prompt = "Genera datos JSON realistas para los siguientes escenarios: " + scenarios.join(" ");
    var response = karate.call('http://localhost:11400/generate', { prompt: prompt });
    return response.data;
}
  