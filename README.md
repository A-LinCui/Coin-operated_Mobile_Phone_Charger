## **Coin Operated Mobile Phone Charger**
### **Components**
- [x] **Clock Divider:** Reduce the frequency from 50MHz to 1000Hz. The output signal serves as the global clock.
- [x] **Standard 7448**
- [x] **Keyboard_Scanner:** Scan the keyboard circuit and receive the value of the pressed key.
- [x] **InputProcessor:** Manage the input for keyboard scanner.
- [x] **ChargeController:** Controll the current state.
- [x] **AmountTranslator:** Convert the amount of money and time inside the controller into a form that the digital tube can output.
- [x] **OutputScanner:** Scan the digital tubes for digital output.
- [x] **StateDisplayer:** Display the state of the controller to luminous diodes.
- [x] **ScanModule:** Manage the final output to lights and tubes. 
### **Testbenches**
- [x] **chargecontroller_tb**
- [x] **keyboardscanner_tb**
- [x] **standard_7448_tb**
- [x] **scanmodule_tb** 