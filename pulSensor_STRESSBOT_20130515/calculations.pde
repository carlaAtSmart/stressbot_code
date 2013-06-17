float getAverageIBI() {
  float _bpmAvg = 0;
  for (int i=0; i<beatIntervals.size(); i++) {
    _bpmAvg += beatIntervals.get(i); //add up all the IBI values
  }
  return _bpmAvg / beatIntervals.size(); //get the average IBI value
}

int getAverageBPM() {
  float _avgIBI = getAverageIBI()/1000; //get the average interbeat interval in 
  return round(60/_avgIBI); //divide 60 by the average IBI to get BPM. Round and return as int
}

float getAvgIBIDelta() {
	int[] _deltaVals = new int[beatIntervals.size()-1];
	for (int i=0; i<_deltaVals.length; i++) {
		_deltaVals[i] = beatIntervals.get(i+1) - beatIntervals.get(i); //fill the _deltaVals array with the difference between IBIs
	}
	float _totalDelta = 0;
	for (int i=0; i<_deltaVals.length; i++) {
		_totalDelta += _deltaVals[i]; //add up the delta values
	}
	return _totalDelta / _deltaVals.length; //return the average delta value
}

int getIBICycleLength() {
	int _startBeat = -1;
	for (int i=0; i<beatIntervals.size(); i++) {
		if (beatIntervals.get(i) == beatIntervals.min()) {
			_startBeat = i; //should be the trough of a wave
		}
		if (_startBeat > -1) {
			if (beatIntervals.get(i+1) < beatIntervals.get(i)) {
				return i - _startBeat; //should be the length of half a wave
			}
		}
	}
	return -1;
}

int getIBICycleCrestPoint() { //get the lowest point of the first IBI cycle. This is used to sync up the IBI wave with the sample sine wave
	for (int i=0; i<beatIntervals.size(); i++) {
		if (beatIntervals.get(i) == beatIntervals.max()) return i;
	}
	return -1;
}