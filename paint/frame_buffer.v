`timescale 1ns / 1ps
module frame_buffer(
    input clk,
    input [9:0] x, y,
    input [9:0] box_x, box_y,
    input [3:0] red_in, green_in, blue_in,
    input paint_enable,
    output reg [3:0] vga_red, vga_green, vga_blue
);
    parameter H_RES = 640;
    parameter V_RES = 480;
    parameter BOX_WIDTH = 10;
    parameter BOX_HEIGHT = 10;

    // Framebuffer memory (stores color for each pixel)
    reg [3:0] fb_red_mem [0:H_RES-1][0:V_RES-1];
    reg [3:0] fb_green_mem [0:H_RES-1][0:V_RES-1];
    reg [3:0] fb_blue_mem [0:H_RES-1][0:V_RES-1];

    always @(posedge clk) begin
        if (paint_enable &&
            x >= box_x && x < box_x + BOX_WIDTH &&
            y >= box_y && y < box_y + BOX_HEIGHT) begin
            // Write to framebuffer
            fb_red_mem[x][y]   <= red_in;
            fb_green_mem[x][y] <= green_in;
            fb_blue_mem[x][y]  <= blue_in;
        end
        //Read from frame buffer
        vga_red   <= fb_red_mem[x][y];
        vga_green <= fb_green_mem[x][y];
        vga_blue  <= fb_blue_mem[x][y];
    end
endmodule
