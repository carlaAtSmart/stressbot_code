float getAverageIBI() {
  float _bpmAvg = 0;
  for (int i=0; i<beatIntervals.size(); i++) {
    _bpmAvg += beatIntervals.get(i); //add up all the IBI values
  }
  return _bpmAvg / beatIntervals.size(); //get the average IBI value
}

int getAverageBPM() {
  float _avgIBI = getAverageIBI(); //get the average Interbeat interval in seconds
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
	int _lowIBIPoint = beatIntervals.get(0);
	int _highIBIPoint = beatIntervals.get(0);
	long _startMillis = 0;
	int _startBeat = 0;
	for (int i=0; i<beatIntervals.size(); i++) {
		if (beatIntervals.get(i) < _lowIBIPoint) _lowIBIPoint = beatIntervals.get(i);
		else if (_startMillis == 0 && _startBeat == 0)
		if (beatIntervals.get(i) > _highIBIPoint) _highIBIPoint = beatIntervals.get(i);
	}
}