# Kakuro

Este archivo contiene una pequeña descripción de nuestra implementación del proyecto Kakuro, 
proyecto para el curso CI3661 - Laboratorio de Lenguajes de Programación del trimestre Enero-Marzo
2021 en la Universidad Simón Bolívar.

Elaborado por:

Jesus De Aguiar 15-10360 \
Neil Villamizar 15-11523 \
Jesus Wahrman 15-11540

## Implementación

La implementación del proyecto se realiza principalmente en dos partes: la primera que revisa si el kakuro es valido y la segunda que revisa que haya una solucion y sea unica.

Para revisar que sea valido hacemos varias cosas:
1. Revisar que todas las clues vayan hacia abajo o hacia la derecha: para esto ordenamos los blank, le anadimos uno mas que tendra las coordenadas del clue y revisamos que los blanks vayan aumentando de 1 en 1 en alguna coordenada pero no en ambas.
2. Revisar que no hayan mas de 2 clues en una casilla: aqui mapeamos los clues a casillas y luego vemos que la que mas veces aparezca no lo haga mas de 2 veces.
3. Revisar que una casilla no contenga un clue y un blank: aqui mapeamos clues y blanks a predicados xy(X,Y) y revisamos que no se intersecten.
4. Revisar que las clues no tengan coordenadas negativas.
5. Revisar que en una casilla no hayan dos clues cuyos blanks vayan a la misma direccion: para esto mapeamos las clues a r(X,Y) o d(X,Y) donde X y Y son las coordenadas y r y d son las direcciones, luego solo vemos si la que mas aparece lo hace mas de 1 vez.

Luego para conseguir una solucion unica hacemos lo siguiente:
1. Conseguir el numero mas grande en los blank para crear una matriz de tamano Max x Max, que usaremos para unificar sus casillas con los numeros del 1 al 9.
2. Conseguir una solucion para cada clue que no viole la solucion de otra clue.
3. Si no la encontramos entonces no hay solucion, si la encontramos ahora revisamos si existe otra, de existir el kakuro no es valido, de no existir transformamos la matriz al formato de [fill(...), ...]


### Ejecución

Para usar el codigo hay que instalar swipl, hacer:

```bash
swipl
```

cargar el archivo y luego:

```
?- valid(kakuro(...), Sol).
```

o

```
?- readKakuro(Kakuro), valid(Kakuro, Sol).
```