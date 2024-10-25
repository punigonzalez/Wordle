package wordle;

import java.util.Random;
import java.util.Scanner;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    // Arreglo de palabras de 5 letras
    private static final String[] PALABRAS = {"SALUD", "CASAS","GATOS","PERRO", "LOGRO", "LIBRO", "COMER", "MUNDO"};
    private static final int MAX_INTENTOS = 6;

    // Máximo número de jugadores
    private static final int MAX_JUGADORES = 10;

    // Arreglos para almacenar los nombres de los jugadores y sus puntajes
    private static String[] nombresJugadores = new String[MAX_JUGADORES];
    private static int[] puntajesJugadores = new int[MAX_JUGADORES];
    private static int cantidadJugadores = 0;

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Random random = new Random();

        boolean jugar = true;

        while (jugar) {
            // Pedir el nombre del jugador
            System.out.print("Ingrese su nombre: ");
            String nombreJugador = scanner.nextLine();

            // Seleccionar una palabra secreta aleatoria del arreglo
            String palabraSecreta = PALABRAS[random.nextInt(PALABRAS.length)];

            System.out.println("¡Bienvenido a Wordle, " + nombreJugador + "!");
            System.out.println("Tienes 6 intentos para adivinar la palabra de 5 letras.");

            int intentos = 0;
            boolean adivinada = false;
            int puntos = 0;

            while (intentos < MAX_INTENTOS && !adivinada) {
                System.out.print("\nIntento " + (intentos + 1) + ": ");
                String intento = scanner.nextLine().toUpperCase();

                // Validar que la palabra tenga 5 letras
                if (intento.length() != 5) {
                    System.out.println("La palabra debe tener 5 letras.");
                    continue;
                }

                // Mostrar pistas
                String resultado = verificarPalabra(intento, palabraSecreta);
                System.out.println(resultado);

                if (intento.equals(palabraSecreta)) {
                    adivinada = true;

                    // Asignar puntos según el intento
                    switch (intentos) {
                        case 0:
                            puntos = 25;
                            break;
                        case 1:
                            puntos = 20;
                            break;
                        case 2:
                            puntos = 15;
                            break;
                        case 3:
                            puntos = 10;
                            break;
                        case 4:
                            puntos = 5;
                            break;
                    }

                    System.out.println("¡Felicidades, " + nombreJugador + "! Adivinaste la palabra.");
                    System.out.println("Obtuviste " + puntos + " puntos.");
                }

                intentos++;
            }

            if (!adivinada) {
                System.out.println("Lo siento, " + nombreJugador + ". Has perdido. La palabra correcta era: " + palabraSecreta);
            }

            // Actualizar el ranking
            actualizarRanking(nombreJugador, puntos);

            // Mostrar el ranking actual
            mostrarRanking();

            // Preguntar si quiere jugar otro jugador
            System.out.print("\n¿Desea que otro jugador juegue? (si/no): ");
            String respuesta = scanner.nextLine().toLowerCase();
            if (!respuesta.equals("si")) {
                jugar = false;
            }
        }

        scanner.close();
    }

    // Método para verificar la palabra y generar las pistas
    private static String verificarPalabra(String intento, String palabraSecreta) {
        String resultado = "";

        for (int i = 0; i < 5; i++) {
            char letraIntento = intento.charAt(i);
            char letraSecreta = palabraSecreta.charAt(i);

            if (letraIntento == letraSecreta) {
                // Letra correcta en la posición correcta (verde)
                resultado += letraIntento + " (verde) ";
            } else if (palabraSecreta.contains(String.valueOf(letraIntento))) {
                // Letra correcta pero en la posición incorrecta (amarillo)
                resultado += letraIntento + " (amarillo) ";
            } else {
                // Letra incorrecta (gris)
                resultado += letraIntento + " (gris) ";
            }
        }

        return resultado;
    }

    // Método para actualizar el ranking
    private static void actualizarRanking(String nombreJugador, int puntos) {
        // Buscar si el jugador ya está en el ranking
        boolean jugadorEncontrado = false;

        for (int i = 0; i < cantidadJugadores; i++) {
            if (nombresJugadores[i].equals(nombreJugador)) {
                // Si ya existe, sumar los puntos
                puntajesJugadores[i] += puntos;
                jugadorEncontrado = true;
                break;
            }
        }

        // Si el jugador no está en el ranking, agregarlo
        if (!jugadorEncontrado && cantidadJugadores < MAX_JUGADORES) {
            nombresJugadores[cantidadJugadores] = nombreJugador;
            puntajesJugadores[cantidadJugadores] = puntos;
            cantidadJugadores++;
        }
    }

    // Método para mostrar el ranking
    private static void mostrarRanking() {
        System.out.println("\nRanking actual:");

        // Ordenar el ranking manualmente usando burbuja simple (por puntos en orden descendente)
        for (int i = 0; i < cantidadJugadores - 1; i++) {
            for (int j = 0; j < cantidadJugadores - i - 1; j++) {
                if (puntajesJugadores[j] < puntajesJugadores[j + 1]) {
                    // Intercambiar puntajes
                    int tempPuntos = puntajesJugadores[j];
                    puntajesJugadores[j] = puntajesJugadores[j + 1];
                    puntajesJugadores[j + 1] = tempPuntos;

                    // Intercambiar nombres
                    String tempNombre = nombresJugadores[j];
                    nombresJugadores[j] = nombresJugadores[j + 1];
                    nombresJugadores[j + 1] = tempNombre;
                }
            }
        }

        // Mostrar los jugadores con sus puntajes
        for (int i = 0; i < cantidadJugadores; i++) {
            System.out.println(nombresJugadores[i] + ": " + puntajesJugadores[i] + " puntos");
        }
    }




}