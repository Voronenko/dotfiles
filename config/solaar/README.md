Credits: https://github.com/aloadir/solaar_logitech_m720/tree/main?tab=readme-ov-file

Solaar is a Linux manager for many Logitech keyboards, mice, and trackpads that connect wirelessly via a USB Unifying, Bolt, Lightspeed, or Nano receiver; via a USB cable; or via Bluetooth.

These rules aim to emulate the behavior of the Multiplatform Gesture Button as implemented in Logitech’s software for Windows.
You can see a demonstration of the gesture functionality in this video https://www.youtube.com/watch?v=E7YjQ01gacE

Download the rules.yaml file from this repository.
Replace your existing rules.yaml file (typically located at ~/.config/solaar/rules.yaml) with the downloaded file.
Open Solaar. The new rules will appear automatically in the Rule Editor.

Functionality Overview
Zoom In and Zoom Out
The first two rules configure the left and right tilt actions of the scroll wheel to perform Zoom In and Zoom Out, respectively.

Multiplatform Gesture Button Setup
The next three sections configure the three side buttons on the mouse to act as Multiplatform Gesture Buttons.
Forward Button Configuration
When the Forward button is released, Solaar checks the direction of the mouse movement and triggers a corresponding action:
Up, Down, Left, Right movements each trigger a different action, "Print", "Escape", Control + f, Control + l + h, respectively.
If no movement is detected, a default action is executed. In this case, the action is press the key combo Control + f.
