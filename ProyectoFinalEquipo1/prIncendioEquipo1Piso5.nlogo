;;
;;
;; utileriasPrIncendio.nlogo
;;
;; Dr. Wulfrano Arturo Luna Ramírez
;; Universidad Autonoma Metropolitana-Cuajimalpa
;; Informática FCA-UNAM
;; wluna[at]correo.cua.uam.mx
;;
;;
;; BASADO EN LA SIMULACIÓN TRÁFICO "CUMBAYO", de Victor Aguiar
;; y AI CSD3610 Resit Practical 2005
;;
;; Maqueta para un BDI-SOMAS aplicado al dominio de
;; Rescate en situacion de Desastre Urbano (sismo)
;;
;; UNAM-FCA Sistemas de IA para la Toma de Decisiones 2024
;; Sem. 24-1
;;
;; Proyecto FINAL (3 prácticas)
;; Utilerías para Práctica 1
;;


;; Funciones para cargar mapas
globals[
  mapa-dataset
  pasillos pared sal-ofn obst ;; bosque my-neighbors
  contador
  rad-vista cono-vista ;; variables para autos radio vista cono-vista
  tam
  color-sal-ofn  color-pasillos  color-bordes  color-base  color-nada
  ;; Redefinir o eliminar
  num-agentes
  MAPASC
  MIMAGE
  lista-salidas
  tiempo
  limite
]

breed [brigadistas brigadista]
breed [estudiantes estudiante]
breed [autoridades autoridad]
breed [señales señal]


extensions [ gis ]

;; Propiedades de parches
patches-own [mapa]



;; FALTA (1) Definir aquí las razas de agentes
;; breed [nombre-colectivo nombre-individual]

;; FALTA (2) Definir las propiedades de las razas de agentes
;; nombre-colectivo-own [lista de propiedades]


;;
;; Funciones para cargar el mapa en el ambiente
;;
;; SE CARGA UN ARCHIVO asc o raster de GIS, generado en Gimp+Python
;;
to ponMapaAsc [mapa-asc]
  set mapa-dataset gis:load-dataset mapa-asc
  gis:set-world-envelope (gis:envelope-union-of (gis:envelope-of mapa-dataset))
end

;; Funcion observer para mostrar el mapa.
to despliega-mapa
  gis:paint mapa-dataset 0
end

;; Mostrar el mapa como patches
to despliegaMapaEnParches
  gis:apply-raster mapa-dataset mapa
  let min-mapa gis:minimum-of mapa-dataset
  let max-mapa gis:maximum-of mapa-dataset
  ask patches
  [ if (mapa <= 0) or (mapa >= 0)
;;-  [set pcolor scale-color black mapa min-mapa max-mapa ]]
  [set pcolor scale-color blue mapa min-mapa max-mapa ]]
end

;; Muestrar el mapa con los patches
to muestreaMapaConParches
   let min-mapa gis:minimum-of mapa-dataset
  let max-mapa gis:maximum-of mapa-dataset
  ask patches
  [ set mapa gis:raster-sample mapa-dataset self
    if (mapa <= 0) or (mapa >= 0)
;;    [ set pcolor scale-color black mapa min-mapa max-mapa ] ]
  ;;-  [ set pcolor scale-color black mapa min-mapa max-mapa ] ]
  [ set pcolor scale-color black mapa min-mapa max-mapa ] ]
end

;; Hacer que las celdas del mapa GIS coincidan con los patches.
to tejeCeldasConParches
  gis:set-world-envelope gis:raster-world-envelope mapa-dataset 0 0
  cd
  ct
end

;; Configura los mapas del ambiente
to configMapas [num-piso]
  ;; Ajustar según convenga
  let dir (word "C:/Users/cmart/OneDrive/Documentos/ProyectoFinalEquipo1/Piso" num-piso "/")
  set MAPASC (word dir "Pisox.asc")
  set MIMAGE (word dir "Piso" num-piso ".png")
end

;; FALTA (3) crear agentes
to creaAgentes
  create-brigadistas 80 [ let x random-pxcor
    let y random-pycor
    ask patch x y [
      if pcolor = color-pasillos [
        sprout-brigadistas 1 [
          set color blue
          set size tam / 3
          set heading 0
          set shape "person"
        ]
      ]
    ]
  ]
create-estudiantes 80 [ let x random-pxcor
    let y random-pycor
    ask patch x y [
      if pcolor = color-pasillos [
        sprout-brigadistas 1 [
          set color red
          set size tam / 3
          set heading 0
          set shape "person"
        ]
      ]
    ]
  ]
  create-autoridades 80 [ let x random-pxcor
    let y random-pycor
    ask patch x y [
      if pcolor = color-pasillos [
        sprout-brigadistas 1 [
          set color yellow
          set size tam / 3
          set heading 0
          set shape "person"
        ]
      ]
    ]
  ]

end


;; FALTA (4) crear parámetros de agentes
;; Crea parametros de agentes y ambiente
to ponParametros
  ;; Configurar parámetros
  set color-sal-ofn  gray
  set color-pasillos  blue
  set color-bordes  yellow
  set color-nada black
  set tam 10
  set num-agentes 1
  set rad-vista 1
  ;; configurar los demás parámetros
  show "Poniendo parámetros de agentes"
end

;; FALTA(5) poner formas a los agentes
to ponFormasAg
;;  set-default-shape nombre-plural "nombre-de-forma"
;; Ej.   set-default-shape turtles "person" lumberjack"
  set-default-shape turtles "person"
  show "poniendo formas a agentes"
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;; Iniciar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FALTA (6) crear botón Iniciar
;; Funcion asociada a botón iniciar
;;
to iniciar [num-piso]
  ca
  reset-ticks
  configMapas num-piso
  ponMapaAsc MAPASC

  ponParametros
  ;; Cargar mapas
  ;; Configura el mapa segun los parches definidos
  despliegaMapaEnParches
  ;; Ajusta el mapa sobre los parches
  muestreaMapaConParches
  creaPasillos
  ;;
  ;;creaAgentes 3

  ;; Carga imagen fachada - Cambiar aquí para cualquier otro piso/imagen
  import-drawing MIMAGE
  ; Define las salidas como un agentset
  set lista-salidas patches with [pxcor = -60 and pycor = 50 or
                            pxcor = 60 and pycor = 50 or
                            pxcor = 65 and pycor = -58]
  poner-señales
  creaAgentes
  set limite 29999
  set tiempo 0
  show "terminando de cargar ambiente"

end


;;
;; Funciones auxiliares
;;

;; Crear pasillos
to creaPasillos
  let umbral1 9.9 ;;10
  let umbral2 0  ;;9.8
  set pasillos patches with [pcolor <= umbral1 and pcolor >= umbral2]
  ask pasillos [ set pcolor color-pasillos]
  set sal-ofn patches with [pcolor != color-pasillos and pcolor != black]
  ask sal-ofn [set pcolor color-sal-ofn]
  creaBordes
end

;; Crear Bordes oficina/salon-pasillo
to creaBordes
   ask patches [
   if pcolor = color-pasillos
   [
     let c pcolor
   if any? patches in-radius 1 with [(pcolor = color-sal-ofn and pcolor != color-bordes and pcolor != c)]
   [
        set pcolor color-bordes
        ]
   ]
   ]
end

;; Funciones de comportamiento de agentes
;; Esta función de debe adaptar
to moverseEnAmb
  let di 0
  show "mover agentes"
  ifelse es-pasillo?
  [fd 1]
  [
    set di random 1
    ifelse di < 1
    [lt random 180 ;set heading heading - random 5 ;lt random 3
      ]
    [rt random 180 ;set heading heading + random 2 ;rt random 30
      ]
    ]
end

;; Crear agentes sólo en bordes y pasillos
;; FALTA (7) Modificar esta función para adaptarla a todas las razas
to creaAgenteX
  let x 0 let y 0
  let c 1
  while [c <= num-ag]
  [
    set x random-pxcor set y random-pycor
    ask patch x y
    [
      if pcolor = color-pasillos
      [
        sprout 1 [
          set color blue
          set size tam / 2
          set heading 0
;; Editar conforme se requiera para poner la forma adecuada al agente o modificar la funcion ponFormas
          set shape "person"
          ]
        set c c + 1
      ]
    ]
  ]
end


;;INICIO DEL CÓDIGO
to-report es-pasillo?  ; Patch reporter
  report pcolor = color-pasillos or pcolor = color-bordes
end

to poner-señales
  ; Define las coordenadas donde quieres que aparezcan las señales
  let coordenadas-senales [
    [-45 45] [-30 45] [-10 45] [10 45] [30 45] [50 45] [65 45] [35 35] [55 35] [55 15] [55 -15] [-45 0] [-30 0] [-10 0] [10 0] [30 0] [50 0]
    [-50 -35] [-30 -35] [-10 -35] [10 -35] [30 -35] [50 -35] [70 -35] [10 -15] [-66 20] [-66 45] [-55 30] [-55 10] [-55 -10] [-65 -10] [-65 -30]
  ]

  ; Crea las señales en las coordenadas especificadas
  ;REVISAR SI SE PUEDE REPRESENTAR CON PARCHES
  foreach coordenadas-senales [
    coords -> ask patch (item 0 coords) (item 1 coords) [
      if es-pasillo? [
        sprout-señales 1 [
          set color green
          set shape "arrow"
          set size 3
          set label-color black
          ; La orientación inicial de la señal se puede ajustar aquí si es necesario
        ]
      ]
    ]
  ]

  let destino patch 65 -50 ; Suponemos que el punto de destino es el patch en (65 -50)

  ask señales [
    ; Calcula la diferencia en x y y hacia esa salida
    let delta-x [pxcor] of destino - pxcor
    let delta-y [pycor] of destino - pycor

    ; Determina si la distancia horizontal o vertical es mayor para decidir la dirección
    ifelse abs delta-x > abs delta-y [
      ; Si la distancia horizontal es mayor, orienta la señal hacia la derecha o izquierda
      ifelse delta-x > 0 [
        set heading 90  ; Derecha
      ] [
        set heading 270 ; Izquierda
      ]
    ] [
      ; Si la distancia vertical es mayor, orienta la señal hacia arriba o abajo
      ifelse delta-y > 0 [
        set heading 0   ; Arriba
      ] [
        set heading 180 ; Abajo
      ]
    ]
  ]
end

to evacuar
  set tiempo tiempo + 1
  while [tiempo < limite] [
  let destino patch 65 -50

  ask brigadistas [
    mover-hacia-destino destino
  ]

  ask estudiantes [
    mover-hacia-destino destino
  ]

  ask autoridades [
    mover-hacia-destino destino
  ]
  evacuar
  ]
end

to mover-hacia-destino [destino]
  let delta-x [pxcor] of destino - pxcor
  let delta-y [pycor] of destino - pycor

  ; Decide si moverse horizontal o verticalmente
  ifelse abs delta-x > abs delta-y [
    mover-horizontalmente delta-x
  ] [
    mover-verticalmente delta-y
  ]
end

to mover-horizontalmente [delta-x]
  ; Establecer la dirección horizontal
  set heading ifelse-value (delta-x > 0) [90] [270]
  let patch-delante patch-ahead 1

  ; Intenta moverse horizontalmente si el patch delante es un pasillo
  ifelse patch-delante != nobody and [es-pasillo?] of patch-delante [
    fd 0.01
  ] [
    ; Si hay un borde, intenta moverte verticalmente en cambio
    intentar-movimiento-vertical
  ]
end

to mover-verticalmente [delta-y]
  ; Establecer la dirección vertical
  set heading ifelse-value (delta-y > 0) [0] [180]
  let patch-delante patch-ahead 1

  ; Intenta moverse verticalmente si el patch delante es un pasillo
  ifelse patch-delante != nobody and [es-pasillo?] of patch-delante [
    fd 0.01
  ] [
    ; Si hay un borde, intenta moverte horizontalmente en cambio
    intentar-movimiento-horizontal
  ]
end

to intentar-movimiento-vertical
  ; Verifica ambos lados verticalmente para ver si hay un pasillo
  ifelse [es-pasillo?] of patch-at-heading-and-distance 0 1 [
    set heading 0
    fd 0.01
  ] [
    ifelse [es-pasillo?] of patch-at-heading-and-distance 180 1 [
      set heading 180
      fd 0.01
    ] [
      ; Si no hay pasillo en ninguna dirección vertical, no mover
    ]
  ]
end

to intentar-movimiento-horizontal
  ; Verifica ambos lados horizontalmente para ver si hay un pasillo
  ifelse [es-pasillo?] of patch-at-heading-and-distance 90 1 [
    set heading 90
    fd 0.01
  ] [
    ifelse [es-pasillo?] of patch-at-heading-and-distance 270 1 [
      set heading 270
      fd 0.01
    ] [
      ; Si no hay pasillo en ninguna dirección horizontal, no mover
    ]
  ]
end

to replegar
  ; Solo mover brigadistas, estudiantes y autoridades
  ask (brigadistas) [
    mover-hacia-bordes
  ]
  ask (estudiantes) [
    mover-hacia-bordes
  ]
  ask (autoridades) [
    mover-hacia-bordes
  ]
  tick ; Incrementa el número de ticks después de que todos se han movido
  comprobar-ticks ; Llama al procedimiento para comprobar los ticks
end

to mover-hacia-bordes
  ; Encuentra el borde más cercano (parche con color-bordes)
  let borde-mas-cercano min-one-of (patches with [pcolor = color-bordes]) [distance myself]

  ; Mueve el agente hacia ese borde
  face borde-mas-cercano
  move-to borde-mas-cercano
  ; No llames aquí a evacuar, será llamado después según los ticks
end

to comprobar-ticks
  ; Comprueba la cantidad de ticks y actúa en consecuencia
  ifelse ticks < 100 [
    tick ; Incrementa el número de ticks si es menor que 5
  ] [
    if ticks >= 100 [
      ask turtles [ evacuar ] ; Llama a evacuar cuando ticks es igual a 5
    ]
  ]
end

to correr [num-piso]
  ifelse num-piso = 1[
    evacuar
  ][
    replegar
    while [ticks < 15] [
      tick
      wait 0.5  ; Espera para ralentizar el bucle
    ]
    evacuar
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
1023
624
-1
-1
5.0
1
10
1
1
1
0
0
0
1
-80
80
-60
60
0
0
1
ticks
30.0

BUTTON
48
85
152
118
Cargar mapa
iniciar nPiso
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1056
82
1228
115
num-ag
num-ag
0
100
100.0
1
1
NIL
HORIZONTAL

BUTTON
1088
41
1186
74
creaAgenteX
creaAgenteX
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
35
21
173
66
nPiso
nPiso
1 4 5 8
2

BUTTON
39
138
170
171
Iniciar simulación
correr nPiso
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
### ¿QUÉ ES?

Este modelo simula la respuesta a un desastre urbano, específicamente un sismo, dentro de un entorno universitario. Utiliza datos geoespaciales para recrear el espacio físico de un campus universitario y modela el comportamiento de distintos agentes (brigadistas, estudiantes y autoridades) durante un evento de evacuación. El objetivo es estudiar y mejorar las estrategias de evacuación y rescate en situaciones de emergencia.

### ¿CÓMO FUNCIONA?

Los agentes en el modelo siguen reglas simples para simular el comportamiento durante una evacuación. Los estudiantes y autoridades buscan las salidas más cercanas, mientras que los brigadistas ayudan a guiar a otros agentes y asegurar su evacuación. El modelo incorpora elementos geoespaciales para definir obstáculos y rutas de evacuación. La interacción entre los agentes y el entorno se basa en reglas de movimiento hacia objetivos específicos, evitación de obstáculos y seguimiento de señalizaciones.

### ¿CÓMO SE USA?

Para usar el modelo, se deben seguir estos pasos:

1. **Iniciar**: Configura el entorno cargando un mapa específico y crea los agentes.
2. **Correr**: Inicia el proceso de simulación, donde primero se ejecuta la acción de replegar y luego, tras alcanzar un número determinado de ticks, se activa la evacuación.
3. **Observar**: Visualiza cómo los agentes interactúan con el entorno y entre sí durante el proceso de evacuación.

Cada elemento en la pestaña de Interfaz, como botones y deslizadores, permite al usuario controlar la simulación, ajustar parámetros y observar diferentes comportamientos y resultados.

### COSAS PARA NOTAR

Es importante observar cómo diferentes configuraciones de agentes y entorno afectan la eficacia de la evacuación. Presta atención a los puntos de congestión y cómo las señales influyen en el movimiento de los agentes.

### COSAS PARA INTENTAR

Experimenta con diferentes números de agentes, cambia la distribución de las salidas o modifica las rutas de evacuación para ver cómo estos cambios afectan la dinámica de la evacuación.

### EXTENDIENDO EL MODELO

Considera añadir diferentes tipos de desastres, como incendios o inundaciones, que requieran estrategias de evacuación distintas. También podrías implementar comportamientos más complejos para los agentes, como el pánico o la cooperación.

### CARACTERÍSTICAS DE NETLOGO

Este modelo utiliza la extensión GIS para cargar y manipular datos geoespaciales, lo cual permite una representación realista del entorno. La simulación de comportamientos de evacuación y rescate también demuestra el potencial de NetLogo para modelar sistemas multiagente complejos.

### MODELOS RELACIONADOS

Explora otros modelos en la biblioteca de NetLogo relacionados con la evacuación, respuesta a desastres y comportamiento de multitudes para comparar enfoques y técnicas.

### CRÉDITOS Y REFERENCIAS

Este modelo fue desarrollado por el Dr. Wulfrano Arturo Luna Ramírez de la Universidad Autónoma Metropolitana-Cuajimalpa y la Facultad de Contaduría y Administración de la UNAM, basándose en trabajos anteriores de Victor Aguiar y el proyecto AI CSD3610 Resit Practical 2005. Para más información, contactar a wluna[at]correo.cua.uam.mx.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
