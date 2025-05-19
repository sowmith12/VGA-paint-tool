# 🎨 VGA Paint Tool using Nexys A7 FPGA

This project is a **fully interactive VGA Paint Tool** built using the **Nexys A7 FPGA development board (Artix-7)**. It allows users to draw colored pixels on a VGA screen in real-time using switches to choose colors and buttons to move a pixel-shaped cursor. An additional eraser mode lets users remove parts of their drawing.

Designed in **Verilog HDL**, this project interfaces directly with a VGA monitor and implements basic graphics using pixel memory logic and screen refresh via a VGA controller.

---

## 🧠 Project Summary

- **Platform**: Nexys A7 FPGA Board (Artix-7)
- **Language**: Verilog HDL
- **Output Display**: VGA Monitor
- **Inputs**:
  - 16 switches for selecting pixel color
  - 4 directional buttons for moving the cursor (Up, Down, Left, Right)
  - 1 pushbutton to toggle **Eraser Mode**
- **Core Modules**:
  - VGA controller
  - Cursor logic
  - Color selection
  - Frame buffer (pixel memory)

---

## 🔌 Hardware Setup

This is the physical setup of the project. The VGA cable connects the Nexys A7 board to a monitor, while switches and buttons on the board control painting actions.

<p>
  <img src="setup.jpg" alt="Complete Setup of VGA Paint Tool" width="700"/>
</p>

➡️ **What you see**:
- VGA monitor displaying the paint screen
- Nexys A7 board connected to monitor
- Power and USB cable for programming

---

## 💻 Nexys A7 FPGA Board

This is the **Nexys A7 development board**, which contains the **Artix-7 FPGA**. It serves as the hardware brain for the entire paint tool.

<p>
  <img src="fpga.jpg" alt="Nexys A7 FPGA Board Close-up" width="600"/>
</p>

➡️ **Notable Features Used**:
- 16 DIP Switches to select the color (mapped to 4-bit or 5-bit color)
- Onboard buttons for movement (cursor control)
- A pushbutton to toggle erasing
- VGA port for output

---

## 🖼️ Example VGA Output

This is a snapshot of the screen when the paint tool is running. The user can move the pixel cursor and draw patterns or erase them using eraser mode.

<p>
  <img src="example-paint.jpg" alt="VGA Output with Painted Pixels" width="700"/>
</p>

➡️ **What's visible**:
- Drawn pixels in different colors
- Real-time response to user input
- Clean screen refresh handled by the VGA controller

---

## 🧩 Features Breakdown

- 🎨 **16-Color Palette**: Choose from 16 different colors using the switches on the FPGA.
- ⬆️⬇️⬅️➡️ **Cursor Movement**: Navigate across the screen using directional buttons.
- 🧼 **Eraser Mode**: Use a button to enable eraser mode — any drawn pixels will be removed when the cursor moves over them.
- 🖥️ **Real-time VGA Output**: Paint updates are reflected instantly on the VGA screen using accurate sync signals.
- 💾 **Pixel Buffer**: A simple memory system stores which pixels are active and their colors.

---

## 📂 File Structure

| File                     | Description |
|--------------------------|-------------|
| `paint_tool.v`           | Main top module integrating all components |
| `vga_controller.v`       | Generates sync signals and handles display timings |
| `cursor_control.v`       | Controls cursor position and movement |
| `color_select.v`         | Maps 16 switches to RGB color outputs |
| `frame_buffer.v`         | Holds pixel data to be displayed on screen |
| `constraints.xdc`        | **Nexys A7 specific** constraints file |
| `README.md`              | This documentation |

---

## ▶️ How to Run the Project

1. Open **Vivado** and create a new project.
2. Add all Verilog files and the constraint file (`constraints.xdc`).
3. Make sure the FPGA board selected is **Nexys A7 (Artix-7)**.
4. Connect the **VGA monitor** to the board.
5. Synthesize, implement, and generate the bitstream.
6. Program the FPGA board using Vivado hardware manager.
7. Start painting with switches and buttons!

---

## 📌 Additional Notes

- You can expand this project to support **shapes**, **line drawing**, or **mouse input**.
- The color output can be fine-tuned using 3-bit per channel (RGB) logic for more colors.
- Frame memory can be stored in **Block RAM** for larger resolutions or shapes.

---

## 🤝 Credits

Developed by: Sowmith :)  
Built using Verilog and the Nexys A7 FPGA Board with a focus on learning digital design, VGA interfacing, and interactive applications.

---
