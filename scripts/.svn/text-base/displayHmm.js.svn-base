// Command line for the spidermonkey version.  Will probably switch to Node.
load('x86.js/opcodes.js');

function readLines() {
  var line, lines = [];
  while ((line = readline()) !== null) {
    lines.push(line);
  }
  return lines;
}

function HmmState(stateName) {
  this.stateName = stateName;
  this.transProbs = [];
  this.outputProbs = [];
}
HmmState.prototype.setTransProbs = function(line) {
  var i, probs,
      ln = line.match(/A (.*) /)[1];

  probs = ln.split(' ');
  for (i=0; i<probs.length; i++) {
    this.transProbs[i] = probs[i];
  }
}
HmmState.prototype.displayTransProbs = function() {
  var i, p;
  for (i=0; i<this.transProbs.length; i++) {
    p = Number(this.transProbs[i]).toFixed(2);
    if (p === 0) continue;
    print ("  trans to " + i + " -> " + p);
  }
}
HmmState.prototype.setOpProbs = function(line) {
  var i, probs, opCode, p,
      ln = line.match(/\[(.*) \]/)[1];
  probs = ln.split(' ');
  for (i=0; i<probs.length; i++) {
    opCode = reverseLookup[i] || '[label]';
    p = probs[i];
    if (p === '0.0') continue;
    this.outputProbs[opCode] = p;
  }
}
HmmState.prototype.displayOpsProbs = function() {
  var opCode, p;
  for (opCode in this.outputProbs) {
    p = Number(this.outputProbs[opCode]).toFixed(2);
    print('  ' + opCode + ': ' + p);
  }
}


function buildStates(lines) {
  var i, line, initProb, num, state,
      states = [],
      stNum = -1;
  for (i=0; i<lines.length; i++) {
    line = lines[i];
    if (line.match(/NbStates/)) {
      num = line.match(/NbStates (.*)/)[1];
      print('HMM with ' + num + ' states');
      print();
    }
    else if (line === 'State') {
      stNum++;
      states[stNum] = new HmmState(stNum);
    }
    else if (line.match(/^Pi /)) {
      initProb = line.match(/Pi (.*)/)[1];
      states[stNum].initProb = initProb;
    }
    else if (line.charAt(0) === 'A') {
      states[stNum].setTransProbs(line);
    }
    else if (line.match(/IntegerOPDF/)) {
      states[stNum].setOpProbs(line);
    }
  }
  return states;
}

function display(states) {
  var i, state;
  for (i=0; i<states.length; i++) {
    state = states[i];
    print(state.stateName + ' (' + Number(state.initProb).toFixed(2) + ')');
    state.displayTransProbs();
    print('  ---');
    state.displayOpsProbs();
    print();
  }
}


// Main
var lines = readLines();
var states = buildStates(lines);
display(states);

