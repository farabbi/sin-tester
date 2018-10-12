/* Sin Tester - A game to test your deadly sin
 *  Made by Jiuxin Zhu, Tamanda Msosa
 *  A mini program in Costumes of Game Controller course
 */

int GSR = A10;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  int reading = analogRead(GSR);
  Serial.println(reading);
  delay(200);
}
