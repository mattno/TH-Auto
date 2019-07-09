# TH-Auto
Automate/set specific Thrustmaster settings automatically.

Automates the settings of Thrustmaster wheels. Can be to used to either set before starting
a game, or reset your after you exit the game - like a profiler.

The following settings are supported:

| Setting         | Default |
|:----------------|--------:|
| Rotation/Angle  |    900  |
| Master Gain     |     75  |
| Constant        |    100  |
| Periodic        |    100  |
| Spring          |    100  | 
| Damper          |    100  |

To use your own settings, create a Windows shortcut with your values as arguments. Ordered as above. So the
default values should be:

`TH-Auto.exe 900 75 100 100 100 100 100`

## Tested with

* **Operating System:** Windows 10 X64
* **Language:** English
* **Thrustmaster package:** 1.TTRS.2019
* **Wheel/rims**:
  * TS-PC
  * TS-PC Racer
  * Ferrari F1 Wheel Advanced TS-PC Racer

For more wheels, please provide feedback with the name of the wheel, as seen, from the Game Controller panel (Win+R joy.cpl),
and also the name of of the window after opening the Thrustmaster control panel.

## Build

Download AutoIt and compile/run yourself.

