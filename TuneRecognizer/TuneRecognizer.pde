/* Frequency & Period Measurement for Audio
 * connect pin 5,6,7 to input circuit
 *
 * http://interface.khm.de/index.php/lab/experiments/frequency-measurement-library/
 *
 * KHM 2010 /  Martin Nawrath
 * Kunsthochschule fuer Medien Koeln
 * Academy of Media Arts Cologne
 */

#include "FreqPeriod.h"
#include <avr/pgmspace.h> //for storing data in program memory space using PROGMEM
#include "notes.h"

#define filterSamples   15              // filterSamples should  be an odd number, no smaller than 3
#define pin_freqLow 2
#define pin_freqGood 3
#define pin_freqHigh 4
#define pin_freqRecognize 8

#define pin_Buzzer 9

//rounded from http://www.phy.mtu.edu/~suits/notefreqs.html
PROGMEM uint16_t noteTable[] = {
  //C0-B0
  16,17,18,19,21,22,23,25,26,28,29,31,
  //C1-B1
  33,35,37,39,41,44,46,49,52,55,58,62,
  //C2-B2
  65,69,73,78,82,87,93,98,104,110,117,123,
  //C3
  131,139,147,156,165,175,185,196,208,220,233,247,
  //C4
  262,277,294,311,330,349,370,392,415,440,466,494,
  //C5
  523,554,587,622,659,698,740,784,831,880,932,988,
  //C6
  1047,1109,1175,1245,1319,1397,1480,1568,1661,1760,1865,1976,
  //C7
  2093,2217,2349,2489,2637,2794,2960,3136,3322,3520,3729,3951,
  //C8
  4186,4435,4699,4978
};


unsigned long int periodSamples[filterSamples];   // array for holding raw sensor values for sensor1 

unsigned int harryPotter[] = {nB5, nlQuarter, nE6, nlDottedQuarter, nG6, nlEighth, nF6s, nlQuarter,
                              nE6, nlHalf, nB6, nlQuarter, nA6, nlDottedHalf, nF6s, nlDottedHalf,
                              nE6, nlDottedQuarter, nG6, nlEighth, nF6s, nlQuarter,
                              nE6f, nlHalf, nF6, nlQuarter, nB5, nlDottedHalf, nEnd, nEnd};
// http://www.google.com/imgres?imgurl=http://zeldapower.com/images/superBestGuitar/page17.jpg&imgrefurl=http://zeldapower.com/index.php/downloads/sheet_music/the_legend_of_zelda_series_super_best_for_guitar.php&usg=__6R6leG7n8PhF10ZG8BpPd8ygMAY=&h=1615&w=1240&sz=182&hl=en&start=0&zoom=1&tbnid=7Zu22P001eJylM:&tbnh=159&tbnw=129&ei=DWg2Tc66GsOAlAeqx9zkAg&prev=/images%3Fq%3Dzelda%2Bpuzzle%2Bmusic%26um%3D1%26hl%3Den%26biw%3D1013%26bih%3D634%26tbs%3Disch:1&um=1&itbs=1&iact=hc&vpx=595&vpy=236&dur=843&hovh=256&hovw=197&tx=146&ty=139&oei=DWg2Tc66GsOAlAeqx9zkAg&esq=1&page=1&ndsp=12&ved=1t:429,r:6,s:0
unsigned int zeldaPuzzle[] = {nG6, nlSixteenth, nG6f, nlSixteenth, nE6f, nlSixteenth,
                              nA5, nlSixteenth, nA5f, nlSixteenth, nE6, nlSixteenth,
                              nA6f, nlSixteenth, nC7, nlEighth, nEnd, nEnd};

unsigned int* theTune;

#define checksPerSixteenth 10 //=80 per quarter (4 * 20)
#define checkDelay 10 //10ms

//with the two things above, that means a sixteenth is .2 seconds, an a quarter is .8s (of hits, right now)

unsigned long int period;
unsigned long int periodFilt;
double frequency;
double frequencyFilt;


unsigned int* note; // current note
unsigned int noteLength; // current note Length (=nlQuarter, nlEight [4, 2])

unsigned int numHits;
unsigned int numChecks; //number of checks we've done.  percent that's good is numOnTarget/curCheck

int isOnTarget; //cahced from checkNote; 0=on taret, -1=low, 1=high
boolean inNote; //0 means waiting for next note to start, 1 means we're currently checking a note




void setup() {
  theTune = harryPotter;
  //LEDs on four pins sink to Arduino - high them to turn them off
  pinMode(pin_freqLow, OUTPUT);
  pinMode(pin_freqGood, OUTPUT);
  pinMode(pin_freqHigh, OUTPUT);
  pinMode(pin_freqRecognize, OUTPUT);
  pinMode(pin_Buzzer, OUTPUT);
  
  clearLEDs();
  digitalWrite(pin_freqRecognize, HIGH);
  
  Serial.begin(115200);
  FreqPeriod::begin();
  Serial.println("FreqPeriod Library Test");
  
  note = theTune;
  noteLength = *(note+1);
  inNote = 0;
  numHits = 0;
  numChecks = 0;
}

void playTune(unsigned int* theTune) {
  unsigned int* note = theTune;
  unsigned int noteLength = *(note + 1);
  unsigned int frequency;
  unsigned long delayLength;
  
  Serial.println("playing");
  
  while(*note != nEnd) {
    frequency = pgm_read_word_near(noteTable + *note);
    delayLength = noteLength * checksPerSixteenth * 4;
    Serial.print("freq=");
    Serial.print(frequency);
    Serial.print("  delay=");
    Serial.print(delayLength);
    Serial.println(" ");
    
    tone(pin_Buzzer, frequency, delayLength);
    
    delay(1.3 * delayLength);
    noTone(pin_Buzzer);
    
    note = note + 2;
    noteLength = *(note + 1);   
  }
  
  Serial.println("done");
}

void loop() {
  char serialIn;
  if(Serial.available() > 0) {
    serialIn = Serial.read();
    if(serialIn == 'p') playTune(theTune);
    else if(serialIn == 'h') {
      theTune = harryPotter;
      Serial.println("Selected Harry Potter theme");
    } else if(serialIn == 'z') {
      theTune = zeldaPuzzle;
      Serial.println("Selected Zelda puzzle theme"); 
    } else if(serialIn == '?') {
       if(theTune==harryPotter) Serial.println("  Using Harry Potter theme");
       else if(theTune==zeldaPuzzle) Serial.println("  Using Zelda puzzle theme"); 
    }
  }
   
  period=FreqPeriod::getPeriod();
  if (period){
    /*
    Serial.print("period: ");
    Serial.print(period);
    Serial.print(" 1/16us  /  frequency: ");
    */

    frequency = 16000400.0 / period;
    //printDouble(frequency,6);
    //Serial.print(" Hz");

    
    periodFilt = digitalSmooth(period, periodSamples);
    frequencyFilt = 16000400.0 / periodFilt;
    
    //Serial.print("  filtered: ");
    //printDouble(frequencyFilt,6);
    
    isOnTarget=checkNote(frequencyFilt, *note);
    if (!inNote) {
      //waiting for note to start
      /*
      if(curNote != theTune) { //if we're not on the first note
        if(curCheck > checkPerDelay) fail();
      }
      */
      
      if(isOnTarget==0) {
        Serial.print("Caught note ");
        //Serial.println(curNote);
        inNote=1;
        numChecks=0;
        numHits=0;
      }
    } else {
      if(isOnTarget==0) {
        Serial.print('+');
        numHits++;
      }
      
      //if(curCheck > checkPerNote) {
      if(numHits > noteLength * checksPerSixteenth) {
        Serial.println('*');
        Serial.print("numHits=");
        Serial.println(numHits);
        //if(numOnTarget > 80) {
        if(1) {
          Serial.println('! got note');
          // yay!  got the note!
          note += 2; //seg fault?  += 2?
          noteLength = *(note+1);
          inNote=0;
          numChecks=0;
          numHits=0;
          clearLEDs();
          digitalWrite(pin_freqRecognize, LOW);
          delay(200);
          digitalWrite(pin_freqRecognize, HIGH);
          
          if (*note==nEnd) {
            Serial.println("end!");
            //recognized the whole pattern!
            note = theTune;
            noteLength = *(note+1);
            numChecks=0;
            numHits=0;
            inNote=0; 
            
            clearLEDs();
            digitalWrite(pin_freqRecognize, LOW);
            delay(200);
            digitalWrite(pin_freqRecognize, HIGH);
            delay(200);
            digitalWrite(pin_freqRecognize, LOW);
            delay(200);
            digitalWrite(pin_freqRecognize, HIGH);
            delay(200);
            digitalWrite(pin_freqRecognize, LOW);
            delay(200);
            digitalWrite(pin_freqRecognize, HIGH);
          }
        } else {
          fail();
        } 
      }
    }
    
    delay(checkDelay);
    numChecks++;
    
    clearLEDs();
    if (isOnTarget==-1) {
      digitalWrite(pin_freqLow, LOW);
    } else if (isOnTarget==1) {
      digitalWrite(pin_freqHigh, LOW);
    } else if (isOnTarget==0) {
      digitalWrite(pin_freqGood, LOW);
    }
    
    //Serial.println(" ");
  } else {
    clearLEDs();
  }

}

void fail() {
  Serial.println("fail");
  clearLEDs();
  digitalWrite(pin_freqRecognize, LOW);
  delay(1000);
  digitalWrite(pin_freqRecognize, HIGH);
  
  inNote=0;
  numChecks=0;
  numHits=0;
  note=theTune;
  noteLength = *(note+1);
}

void clearLEDs() {
    digitalWrite(pin_freqLow, HIGH);
    digitalWrite(pin_freqGood, HIGH);
    digitalWrite(pin_freqHigh, HIGH);
}

int checkNote(double testFreq, unsigned int toNote) {
  if (testFreq > ((unsigned int) pgm_read_word_near(noteTable + toNote - 1))) {
    if (testFreq < ((unsigned int) pgm_read_word_near(noteTable + toNote + 1))) {
      return 0; 
    } else {
      return 1; 
    }
  }
  return -1;
}

//***************************************************************************
void printDouble( double val, byte precision){
  // prints val with number of decimal places determine by precision
  // precision is a number from 0 to 6 indicating the desired decimial places
  // example: lcdPrintDouble( 3.1415, 2); // prints 3.14 (two decimal places)

  if(val < 0.0){
    Serial.print('-');
    val = -val;
  }

  Serial.print (int(val));  //prints the int part
  if( precision > 0) {
    Serial.print("."); // print the decimal point
    unsigned long frac;
    unsigned long mult = 1;
    byte padding = precision -1;
    while(precision--)
      mult *=10;

    if(val >= 0)
      frac = (val - int(val)) * mult;
    else
      frac = (int(val)- val ) * mult;
    unsigned long frac1 = frac;
    while( frac1 /= 10 )
      padding--;
    while(  padding--)
      Serial.print("0");
    Serial.print(frac,DEC) ;
  }
}




// http://www.arduino.cc/playground/Main/DigitalSmooth
unsigned long int digitalSmooth(unsigned long int rawIn, unsigned long int *sensSmoothArray) {
  unsigned long int temp, top, bottom;
  int j, k;
  unsigned long total;
  static int i;
  static unsigned long int sorted[filterSamples];
  boolean done;
  
  i = (i + 1) % filterSamples;    // increment counter and roll over if necc. -  % (modulo operator) rolls over variable
  sensSmoothArray[i] = rawIn;                 // input new data into the oldest slot

  
  for (j=0; j<filterSamples; j++){     // transfer data array into anther array for sorting and averaging
    sorted[j] = sensSmoothArray[j];
  }
  
  done = 0;                // flag to know when we're done sorting              
  while(done != 1){        // simple swap sort, sorts numbers from lowest to highest
    done = 1;
    for (j = 0; j < (filterSamples - 1); j++){
      if (sorted[j] > sorted[j + 1]) {     // numbers are out of order - swap
        temp = sorted[j + 1];
        sorted [j+1] =  sorted[j] ;
        sorted [j] = temp;
        done = 0;
      }
    }
  }
    
  // throw out top and bottom 15% of samples - limit to throw out at least one from top and bottom
  bottom = max(((filterSamples * 15)  / 100), 1); 
  top = min((((filterSamples * 85) / 100) + 1  ), (filterSamples - 1));   // the + 1 is to make up for asymmetry caused by integer rounding
  k = 0;
  total = 0;
  for ( j = bottom; j< top; j++){
    total += sorted[j];  // total remaining indices
    k++; 
  }
  
  return total / k;    // divide by number of samples
}

