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
    print ("  transition to " + i + " -> " + p);
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
  var opCode, p, s=' & : & \\mbox{', i=-1;
  for (opCode in this.outputProbs) {
    if (++i === 7) {
      s += '}\\\\\n & : & \\mbox{';
      i=0;
    }
    p = Number(this.outputProbs[opCode]).toFixed(2);
    //print('  ' + opCode + ': ' + p);
    if (p > 0.30) s += '{\\bf ' + opCode + '(' + p + ')} ';
    else s += opCode + '(' + p + ') ';
  }
  return s + '}\\\\';
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
  print('\\[');
  print('\\begin{array}{ccl}');
  print('\\mbox{State} & & \\mbox{Observation probabilities} \\\\');
  print('\\hline');
  for (i=0; i<states.length; i++) {
    state = states[i];
    //print(state.stateName + ' (' + Number(state.initProb).toFixed(2) + ')');
    print(state.stateName);
    print(state.displayOpsProbs());
    //print(state.stateName + s);
    //state.displayTransProbs();
    //print('  ---');
  }
  print('\\end{array}');
  print('\\]')
}


// Main
var lines = readLines();
var states = buildStates(lines);
display(states);

