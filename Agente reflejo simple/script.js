// Solicitar al usuario el tamaño del grid
const gridSize = parseInt(prompt("¿Qué tamaño quiere que sea el grid? Recuerde que el grid es un cuadrado."), 10);

// Validar la entrada del usuario
if (isNaN(gridSize) || gridSize <= 0) {
  alert("Por favor, ingrese un número válido para el tamaño del grid.");
  throw new Error("Se ingresó un tamaño de grid inválido.");
}

const grid = document.getElementById('grid');
const numObstacles = Math.floor(gridSize * gridSize * 0.1);
const numFood = Math.floor(gridSize * gridSize * 0.15);
let gameRunning = true;
let agentInterval;

// Asegurarse de que el grid esté vacío antes de empezar
grid.innerHTML = '';
grid.style.gridTemplateColumns = `repeat(${gridSize}, 1fr)`;
grid.style.gridTemplateRows = `repeat(${gridSize}, 1fr)`;

// Crear la rejilla
for (let i = 0; i < gridSize * gridSize; i++) {
  const cell = document.createElement('div');
  cell.classList.add('cell');
  grid.appendChild(cell);
}

// Distribuir obstáculos y comida
const cells = Array.from(document.querySelectorAll('.cell'));
randomlyPlaceItems(cells, numObstacles, 'obstacle');
randomlyPlaceItems(cells, numFood, 'food');

// Colocar obstáculos y comida de manera aleatoria
function randomlyPlaceItems(cells, count, className) {
  for (let i = 0; i < count; i++) {
      let cellIndex;
      do {
          cellIndex = Math.floor(Math.random() * cells.length);
      } while (cells[cellIndex].classList.contains('obstacle') || cells[cellIndex].classList.contains('food'));
      cells[cellIndex].classList.add(className);
  }
}

// Crear y posicionar el agente
const agent = document.createElement('div');
agent.classList.add('agent');
let agentCellIndex = 0; // Comenzar en la esquina superior izquierda
cells[agentCellIndex].appendChild(agent);

// Función para obtener la posición actual del agente en la cuadrícula
function getAgentPosition() {
  return cells.findIndex(cell => cell.contains(agent));
}

// Función para detectar si hay comida en la casilla actual
function detectFood() {
  const agentPosition = getAgentPosition();
  return cells[agentPosition].classList.contains('food');
}

// Función para que el agente "coma" la comida en la casilla actual
function eatFood() {
  const agentPosition = getAgentPosition();
  if (cells[agentPosition].classList.contains('food')) {
      cells[agentPosition].classList.remove('food');
      console.log('Comida consumida en la posición:', agentPosition);
  }
}

// Función para detectar si hay un obstáculo en una dirección específica
function detectObstacle(direction) {
  const currentPosition = getAgentPosition();
  let targetIndex;
  switch (direction) {
      case 'left':
          targetIndex = currentPosition % gridSize === 0 ? -1 : currentPosition - 1;
          break;
      case 'right':
          targetIndex = (currentPosition + 1) % gridSize === 0 ? -1 : currentPosition + 1;
          break;
      case 'up':
          targetIndex = currentPosition < gridSize ? -1 : currentPosition - gridSize;
          break;
      case 'down':
          targetIndex = currentPosition >= gridSize * (gridSize - 1) ? -1 : currentPosition + gridSize;
          break;
      default:
          return false; 
  }

  // Si el índice objetivo es -1, significa que el agente está en el borde de la cuadrícula en esa dirección
  if (targetIndex === -1) {
      return true; // Consideramos que el borde de la cuadrícula es como un obstáculo
  }

  // Verificar si el índice está dentro del rango y si hay un obstáculo
  return cells[targetIndex] && cells[targetIndex].classList.contains('obstacle');
}


// Función para que el agente se mueva solo
function autonomousMove() {
  if (!gameRunning) return;
  const direction = ['left', 'right', 'up', 'down'];
  let moveMade = false;

  while (!moveMade) {
    const randomDirection = direction[Math.floor(Math.random() * direction.length)];
    if (canMove(randomDirection)) {
      moveAgent(randomDirection);
      moveMade = true;
    }
  }
}

// Función para verificar si el agente puede moverse en una dirección dada
function canMove(direction) {
  const currentPosition = getAgentPosition();
  switch (direction) {
    case 'left':
      return currentPosition % gridSize !== 0 && !detectObstacle('left');
    case 'right':
      return (currentPosition + 1) % gridSize !== 0 && !detectObstacle('right');
    case 'up':
      return currentPosition >= gridSize && !detectObstacle('up');
    case 'down':
      return currentPosition < gridSize * (gridSize - 1) && !detectObstacle('down');
    default:
      return false;
  }
}

// Función para mover el agente
function moveAgent(direction) {
  const currentPosition = getAgentPosition();
  let newPosition = currentPosition;

  switch (direction) {
    case 'left':
      newPosition -= 1;
      break;
    case 'right':
      newPosition += 1;
      break;
    case 'up':
      newPosition -= gridSize;
      break;
    case 'down':
      newPosition += gridSize;
      break;
  }

  // Mueve al agente si la nueva posición es válida
  if (canMove(direction)) {
    cells[currentPosition].removeChild(agent);
    cells[newPosition].appendChild(agent);
    eatFood();
  }
}

// Inicia el movimiento autónomo del agente
agentInterval = setInterval(autonomousMove, 500);

// Escuchar la tecla ESC para detener el juego
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') {
    clearInterval(agentInterval);
    gameRunning = false;
  }
});
