`timescale 1ns / 1ps
module top(
    input clk,          // 100MHz clock
    input reset,        // active high reset
    input btnU, btnD, btnL, btnR,
    input btnC,         // Center button for paint toggle (can alias to paint_btn)
    input paint_btn,      // Paint toggle button input
    input [4:0] color_select, // Color selection input
    output hsync,
    output vsync,
    output [3:0] vga_red,
    output [3:0] vga_green,
    output [3:0] vga_blue
);

    // === VGA Signal Wires ===
    wire video_on, p_tick;
    wire [9:0] x, y;

    // === VGA Controller Instance ===
    vga_controller vga_inst (
        .clk_100MHz(clk),
        .reset(reset),
        .video_on(video_on),
        .hsync(hsync),
        .vsync(vsync),
        .p_tick(p_tick),
        .x(x),
        .y(y)
    );

    // === Box and Color Wires ===
    wire [9:0] box_x, box_y;
    wire [3:0] red, green, blue;
    wire paint_enable;
    wire [3:0] cursor_red, cursor_green, cursor_blue;

    // === Box Module Instance ===
    cursor cursor_inst (  //Renamed box_inst to cursor_inst and boxxx to cursor
        .clk(clk),
        .reset(reset),
        .p_tick(p_tick),
        .x(x),
        .y(y),
        .btnU(btnU),
        .btnD(btnD),
        .btnL(btnL),
        .btnR(btnR),
        .paint_btn(paint_btn), // You can also tie btnC here if using it
        .color_select(color_select),
        .box_x(box_x),
        .box_y(box_y),
        .red(red),
        .green(green),
        .blue(blue),
        .paint_enable(paint_enable),
        .vga_red(cursor_red),
        .vga_green(cursor_green),
        .vga_blue(cursor_blue)
    );

    // === Framebuffer Output Wires ===
    wire [3:0] fb_red, fb_green, fb_blue;

    // === Frame Buffer Instance ===
    frame_buffer fb (
        .clk(clk),
        .x(x),
        .y(y),
        .box_x(box_x),
        .box_y(box_y),
        .red_in(red),
        .green_in(green),
        .blue_in(blue),
        .paint_enable(paint_enable),
        .vga_red(fb_red),
        .vga_green(fb_green),
        .vga_blue(fb_blue)
    );

    // === Cursor-on-pixel Detection ===
    parameter BOX_WIDTH  = 10;
    parameter BOX_HEIGHT = 10;

    wire cursor_on = (x >= box_x && x < box_x + BOX_WIDTH &&
                        y >= box_y && y < box_y + BOX_HEIGHT);

    // === Final VGA Output Selection (Cursor Takes Priority) ===
    assign vga_red   = video_on ? (cursor_on ? cursor_red   : fb_red)   : 4'b0;
    assign vga_green = video_on ? (cursor_on ? cursor_green : fb_green) : 4'b0;
    assign vga_blue  = video_on ? (cursor_on ? cursor_blue  : fb_blue)  : 4'b0;

endmodule
