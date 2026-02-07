let show = 0;
let score = 0;
let words = [];

// load the TSV dictionary
async function loadTSV(url) {
	try {
		const response = await fetch(url);
		// Check if ok
		if (!response.ok) throw new Error("Could not load file.");

		// prepare text
		const text = await response.text();
		const lines = text.trim().split('\n');
		words = [];

		// Parsing
		lines.forEach(line => {
		// split by tabs (duh)
			const [word, def] = line.split('\t');
			words.push({ word, def});
		});
		
		// Enable the button after loading the file
		document.getElementById('startgame').disabled = false;
		document.getElementById('gword').textContent = 'Language ready! Have fun!';
		// Make buttons and text visible (only once)
		if (show === 0) {
			document.getElementById('buttons').classList.toggle('hidden');
			document.getElementById('restart').classList.toggle('hidden');
			document.getElementById('scorecount').textContent = `Score: ${score}`;
			show = 1;
		}
	} catch (error) {
		document.getElementById('gword').textContent = error.message;
	}
}

// Game loop
function guesser() {
	if (words.length > 0) {
		const rnd = Math.floor(Math.random() * words.length);
		const dict = words[rnd];
		const pos = Math.floor(Math.random() * 4);

		document.getElementById('gword').textContent = dict.word;

		// Loop through option buttons
		const bt = document.querySelectorAll('.options');
		
		bt.forEach((btn, index) => {
			// display the correct word in random places
			if (index === pos) {
				btn.textContent = dict.def;
			} else {
				let rndindex;
				do {
					// choose another random word
					rndindex = Math.floor(Math.random() * words.length);
				} while (rndindex === rnd); // don't choose the same word
				btn.textContent = words[rndindex].def;
			}
			btn.onclick = () => checkword(index, pos, dict.def);
		});
	} else {
		document.getElementById('gword').textContent = 'Choose and load a language first!';
	}
}

function checkword(index, pos, answer) {
	if (index === pos) {
		score++;
		document.getElementById('message').style.color = "green";
		document.getElementById('message').textContent = `Correct!`;
	} else {
		score--;
		document.getElementById('message').style.color = "red";
		document.getElementById('message').textContent = `Wrong! Correct word: ${answer}`;
	}
	document.getElementById('scorecount').textContent = `Score: ${score}`;
	guesser();
}

// load a language
document.getElementById('load').addEventListener('click', function() {
	const file = document.getElementById('lang').value;
	loadTSV(file);
	score = 0;
	document.getElementById('scorecount').textContent = `Score: ${score}`;
	document.getElementById('message').style.color = "black";
	document.getElementById('message').textContent = "";
});

// Game start
document.getElementById('startgame').addEventListener('click', guesser);
document.getElementById('restart').addEventListener('click', function() {
	score = 0;
	document.getElementById('scorecount').textContent = `Score: ${score}`;
	document.getElementById('message').style.color = "black";
	document.getElementById('message').textContent = "Game reset.";
	//document.getElementById(`restart`).classList.add('hidden');
	guesser();
});
