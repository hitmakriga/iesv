<!DOCTYPE html>
<html lang="lv">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>💣 Bomb Puzzle Master - GRŪTS REŽĪMS</title>
<style>
/* --- dizains paliek tāds pats kā iepriekš --- */
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Segoe UI',sans-serif;background:linear-gradient(135deg,#0c0c0c 0%,#1a1a2e 50%,#16213e 100%);color:white;min-height:100vh;overflow-x:hidden}
.fullscreen{position:fixed;top:0;left:0;width:100vw;height:100vh;overflow-y:auto}
.container{max-width:1800px;margin:0 auto;padding:20px}
.header{text-align:center;margin-bottom:30px;position:relative}
.title{font-size:3rem;font-weight:bold;background:linear-gradient(45deg,#ff0000,#ff6b6b,#ff0000);-webkit-background-clip:text;-webkit-text-fill-color:transparent;text-shadow:0 0 20px rgba(255,0,0,0.5);margin-bottom:10px}
.subtitle{font-size:1.2rem;color:#ff6b6b;margin-bottom:20px}
.control-panel{position:fixed;top:20px;right:20px;display:flex;flex-direction:column;gap:10px;z-index:1000}
.control-btn{padding:12px 20px;font-size:1rem;font-weight:bold;border:none;border-radius:8px;cursor:pointer;transition:all .3s ease;background:#333;color:white;border:2px solid #555}
.control-btn:hover{transform:scale(1.05);background:#444}
.btn-connect{background:linear-gradient(45deg,#228B22,#32CD32);border-color:#00ff00}
.btn-disconnect{background:linear-gradient(45deg,#cc0000,#ff4444);border-color:#ff6666}
.btn-fullscreen{background:linear-gradient(45deg,#1a1a2e,#16213e);border-color:#00ccff}
.serial-status{padding:10px 15px;border-radius:5px;font-weight:bold;text-align:center;min-width:200px}
.serial-connected{background:rgba(34,139,34,0.2);color:#00ff00;border:2px solid #00ff00}
.serial-disconnected{background:rgba(204,0,0,0.2);color:#ff4444;border:2px solid #ff4444}
.columns{display:flex;gap:30px;margin-bottom:30px}
.hints-column{flex:1;min-width:450px}
.game-column{flex:2;min-width:700px}
.section-title{font-size:1.8rem;font-weight:bold;color:#00ccff;margin-bottom:15px;text-shadow:0 0 10px rgba(0,204,255,0.5);border-bottom:2px solid #00ccff;padding-bottom:5px}
.difficulty-badge{display:inline-block;padding:5px 15px;background:linear-gradient(45deg,#ff0000,#ff6b6b);color:white;border-radius:20px;font-weight:bold;margin-left:15px;font-size:1rem}
.hint-table{background:rgba(26,26,26,0.8);border-radius:15px;padding:20px;margin-bottom:20px;border:2px solid #333;backdrop-filter:blur(10px)}
.hint-row{display:flex;align-items:center;margin-bottom:12px;padding:12px;background:rgba(42,42,42,0.9);border-radius:8px;border-left:4px solid #ff6b6b;transition:all .3s ease}
.color-dot{width:35px;height:35px;border-radius:50%;margin-right:10px;border:3px solid #444;display:inline-block;box-shadow:0 0 10px rgba(0,0,0,0.5)}
.time-display{font-family:'Consolas',monospace;font-size:2.5rem;color:#ff4444;margin-bottom:20px;text-shadow:0 0 15px #ff4444;background:rgba(0,0,0,0.5);padding:15px;border-radius:10px;border:2px solid #ff4444}
.progress-bar{width:100%;height:25px;background:#333;border-radius:12px;overflow:hidden;margin-bottom:20px;border:2px solid #444}
.progress-fill{height:100%;background:linear-gradient(90deg,#ff0000,#ff6b6b,#ff0000);transition:width 1s linear;box-shadow:0 0 10px rgba(255,0,0,0.5)}
.btn{padding:15px 30px;font-size:1.3rem;font-weight:bold;border:none;border-radius:10px;cursor:pointer;transition:all .3s ease;box-shadow:0 5px 15px rgba(0,0,0,0.3)}
.btn-start{background:linear-gradient(45deg,#228B22,#32CD32);color:white}
.btn-stop{background:linear-gradient(45deg,#cc0000,#ff4444);color:white}
.btn-delete{background:linear-gradient(45deg,#444,#666);color:white}
.btn-submit{background:linear-gradient(45deg,#228B22,#32CD32);color:white}
.color-btn{padding:18px 30px;font-size:1.3rem;font-weight:bold;border:none;border-radius:12px;cursor:pointer;transition:all .3s ease;min-width:140px;box-shadow:0 5px 15px rgba(0,0,0,0.3);border:3px solid transparent}
.color-btn:hover{transform:translateY(-3px) scale(1.05);border-color:white}
.history-section{background:rgba(26,26,26,0.8);border-radius:15px;padding:25px;max-height:400px;overflow-y:auto;border:2px solid #333}
.history-row{display:flex;align-items:center;margin-bottom:12px;padding:12px;background:rgba(42,42,42,0.9);border-radius:8px;border-left:4px solid #00ccff}
.victory{color:#00ff00;font-weight:bold}
.defeat{color:#ff4444;font-weight:bold}
@media(max-width:1200px){.columns{flex-direction:column}.control-panel{position:static;flex-direction:row;justify-content:center;margin-bottom:20px}}
</style>
</head>
<body>
<div class="fullscreen">
<div class="control-panel">
<button class="control-btn btn-connect" onclick="connectSerial()">🔌 CONNECT COM</button>
<button class="control-btn btn-disconnect" onclick="disconnectSerial()">🔴 DISCONNECT</button>
<button class="control-btn btn-fullscreen" onclick="toggleFullscreen()">⤢ FULLSCREEN</button>
<div class="serial-status serial-disconnected" id="serialStatus">COM: Nav savienots</div>
</div>

<div class="container">
<div class="header">
<h1 class="title">💣 BOMB PUZZLE MASTER</h1>
<div class="subtitle">GRŪTS REŽĪMS <span class="difficulty-badge">HARD</span></div>
</div>

<div class="columns">
<div class="hints-column">
<h2 class="section-title">Sākotnējie pavedieni: <span class="difficulty-badge">GRŪTI</span></h2>
<div class="hint-table" id="hintsContainer"></div>
</div>

<div class="game-column">
<div class="timer-section">
<div class="time-display" id="timeDisplay">05:00</div>
<div class="progress-bar"><div class="progress-fill" id="progressFill"></div></div>
<div class="timer-controls">
<button class="btn btn-start" onclick="startTimer()">▶️ START</button>
<button class="btn btn-stop" onclick="stopTimer()">⏸️ STOP</button>
</div>
</div>

<div class="current-input">
<h3 class="section-title">Tava pašreizējā kombinācija:</h3>
<div class="current-input-text" id="currentInput">Izvēlies krāsas...</div>
</div>

<div class="actions">
<button class="btn btn-delete" onclick="deleteLast()">⬅️ DZĒST PEDĒJO</button>
<button class="btn btn-submit" onclick="submitGuess()">✅ IESNIEGT KODU</button>
</div>

<div class="color-buttons" id="colorButtons"></div>
<h3 class="section-title">Tavi mēģinājumi:</h3>
<div class="history-section" id="historyContainer"></div>
</div>
</div>
</div>
</div>

<script>
/* ======= Spēles loģika ======= */
const CODE_LENGTH=5, TOTAL_TIME=300, PENALTY=30;
const COLORS={"BTN1":{name:"VIOLETS",color:"#8A2BE2",textColor:"white"},"BTN2":{name:"ZAĻŠ",color:"#2E8B57",textColor:"white"},"BTN3":{name:"BALTS",color:"#F8F8FF",textColor:"black"},"BTN4":{name:"MELNS",color:"#000000",textColor:"white"},"BTN5":{name:"PELĒKS",color:"#808080",textColor:"white"}};
const ORDER=["BTN1","BTN2","BTN3","BTN4","BTN5"];
let gameState={secret:[],current:[],timeLeft:TOTAL_TIME,timerRunning:false,gameOver:false,serialPort:null,reader:null,history:[]};

document.addEventListener('DOMContentLoaded',()=>{initializeGame();setupColorButtons();checkSerialSupport();});
function initializeGame(){gameState.secret=generateSecret();renderHints();updateTimerDisplay();updateCurrentInput();}
function generateSecret(){return Array.from({length:CODE_LENGTH},()=>ORDER[Math.floor(Math.random()*ORDER.length)]);}
function renderHints(){const c=document.getElementById('hintsContainer');c.innerHTML='';gameState.secret.forEach(()=>{const r=document.createElement('div');r.className='hint-row';r.innerHTML='<span class="color-dot"></span><span class="hint-text">?</span>';c.appendChild(r);});}
function setupColorButtons(){const c=document.getElementById('colorButtons');c.innerHTML='';ORDER.forEach(id=>{const col=COLORS[id];const b=document.createElement('button');b.className='color-btn';b.textContent=col.name;b.style.background=col.color;b.style.color=col.textColor;b.onclick=()=>addInput(id);c.appendChild(b);});}
function addInput(id){if(gameState.gameOver||gameState.current.length>=CODE_LENGTH)return;gameState.current.push(id);updateCurrentInput();}
function deleteLast(){gameState.current.pop();updateCurrentInput();}
function updateCurrentInput(){const c=document.getElementById('currentInput');c.innerHTML='';if(!gameState.current.length){c.textContent='Izvēlies krāsas...';return;}gameState.current.forEach(id=>{const col=COLORS[id];const t=document.createElement('span');t.className='color-tag';t.textContent=col.name;t.style.background=col.color;t.style.color=col.textColor;c.appendChild(t);});document.querySelector('.btn-submit').disabled=gameState.current.length!==CODE_LENGTH;}
function evaluateGuess(g){const s=[...gameState.secret],x=[...g];let p=0,w=0;for(let i=CODE_LENGTH-1;i>=0;i--){if(x[i]===s[i]){p++;x.splice(i,1);s.splice(i,1);}}for(let g1 of x){const i=s.indexOf(g1);if(i!==-1){w++;s.splice(i,1);}}return{correctPos:p,wrongPlace:w};}
function submitGuess(){if(gameState.current.length<CODE_LENGTH){alert('❌ Nepilns kods!');return;}const g=[...gameState.current];gameState.current=[];updateCurrentInput();if(g.join()===gameState.secret.join()){endGame(true,g);return;}const hint=evaluateGuess(g);addToHistory(g,hint,'try');gameState.timeLeft=Math.max(0,gameState.timeLeft-PENALTY);updateTimerDisplay();if(gameState.timeLeft<=0)endGame(false);}
function addToHistory(g,h,r){const c=document.getElementById('historyContainer');const row=document.createElement('div');row.className='history-row';g.forEach(id=>{const d=document.createElement('span');d.className='color-dot';d.style.backgroundColor=COLORS[id].color;row.appendChild(d);});const t=document.createElement('span');t.className='hint-text';if(r==='win')t.textContent='🎉 UZVARA!';else if(r==='lose')t.textContent='💣 ZAUDĒJUMS!';else t.textContent=`🔵 ${h.correctPos} vietā, ${h.wrongPlace} citur (-${PENALTY}s)`;row.appendChild(t);c.appendChild(row);c.scrollTop=c.scrollHeight;}
function startTimer(){if(!gameState.timerRunning&&!gameState.gameOver){gameState.timerRunning=true;gameState.timerInterval=setInterval(tick,1000);}}
function stopTimer(){gameState.timerRunning=false;if(gameState.timerInterval)clearInterval(gameState.timerInterval);}
function tick(){if(gameState.timerRunning&&!gameState.gameOver){gameState.timeLeft--;updateTimerDisplay();if(gameState.timeLeft<=0)endGame(false);}}
function updateTimerDisplay(){const m=Math.floor(gameState.timeLeft/60),s=gameState.timeLeft%60;document.getElementById('timeDisplay').textContent=`${m.toString().padStart(2,'0')}:${s.toString().padStart(2,'0')}`;document.getElementById('progressFill').style.width=`${(gameState.timeLeft/TOTAL_TIME)*100}%`;}
function endGame(v,g){gameState.gameOver=true;stopTimer();if(g)addToHistory(g,null,v?'win':'lose');setTimeout(()=>alert(v?'🎉 Tu uzvarēji!':'💣 Zaudēji!'),500);}

/* ======= Web Serial API ======= */
let dataBuffer='',isStable=false,startTime=0;
const STABILIZE_TIME=2000;
async function connectSerial(){
try{
if(!('serial'in navigator))throw new Error('Web Serial API nav atbalstīta');
gameState.serialPort=await navigator.serial.requestPort();
await gameState.serialPort.open({baudRate:9600});
updateSerialStatus(true);
isStable=false;startTime=Date.now();
setTimeout(()=>{isStable=true;},STABILIZE_TIME);
readSerialData();
}catch(e){updateSerialStatus(false,e.message);alert('Savienojuma kļūda: '+e.message);}
}
async function readSerialData(){
const dec=new TextDecoder();
while(gameState.serialPort&&gameState.serialPort.readable){
const reader=gameState.serialPort.readable.getReader();
try{
while(true){
const {value,done}=await reader.read();
if(done)break;
if(value){dataBuffer+=dec.decode(value);const lines=dataBuffer.split('\n');dataBuffer=lines.pop()||'';lines.forEach(l=>handleLine(l.trim()));}
}
}catch{}finally{reader.releaseLock();}
}
}
function handleLine(line){
if(!line)return;
if(!isStable)return; // ignorē karantīnas laikā
const match=line.match(/BTN[1-5]/i);
if(match){addInput(match[0].toUpperCase());}
}
async function disconnectSerial(){
try{
if(gameState.reader)await gameState.reader.cancel();
if(gameState.serialPort)await gameState.serialPort.close();
updateSerialStatus(false);
}catch(e){console.error(e);}
}
function updateSerialStatus(c,msg=''){const el=document.getElementById('serialStatus');if(c){el.textContent='COM: Savienots ✓';el.className='serial-status serial-connected';}else{el.textContent='COM: Nav savienots'+(msg?' - '+msg:'');el.className='serial-status serial-disconnected';}}
function checkSerialSupport(){if(!('serial'in navigator))alert('⚠️ Web Serial API nav atbalstīta. Izmanto Chrome, Edge vai Opera.');}
function toggleFullscreen(){if(!document.fullscreenElement)document.documentElement.requestFullscreen();else document.exitFullscreen();}
</script>
</body>
</html>
