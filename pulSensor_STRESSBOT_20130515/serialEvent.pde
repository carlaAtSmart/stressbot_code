
void serialEvent(Serial port){   
   String inData = port.readStringUntil('\n');  
   
   if (inData.charAt(0) == 'Q'){          // leading 'Q' means time between beats in milliseconds
     inData = inData.substring(1);        // cut off the leading 'Q'
     inData = trim(inData);               // trim the \n off the end
     IBI = int(inData); 
     addBeat(IBI);                  // convert ascii string to integer IBI 
     println("IBI: " + IBI);                
     return;     
   }
   
   if (inData.charAt(0) == 'S'){          // leading 'S' means sensor data
     inData = inData.substring(1);        // cut off the leading 'S'
     inData = trim(inData);               // trim the \n off the end
     ppgY = int(inData);                  // convert the ascii string to ppgY
   return;     
   }   
   
    if (inData.charAt(0) == 'F'){          // leading 'S' means sensor data
     inData = inData.substring(1);        // cut off the leading 'F'
     inData = trim(inData);               // trim the \n off the end
   return;     
   }  
}// END OF SERIAL EVENT

void addBeat(int _beatInterval) {
  beatIntervals.add(_beatInterval);
}
