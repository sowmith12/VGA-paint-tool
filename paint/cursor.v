`timescale 1ns / 1ps
module cursor(  // Changed module name
    input clk,
    input reset,
    input p_tick,
    input [9:0] x, y,
    input btnU, btnD, btnL, btnR,
    input paint_btn,
    input [4:0] color_select,
    output reg [9:0] box_x, box_y,
    output reg [3:0] red, green, blue,
    output reg paint_enable,
    output [3:0] vga_red, vga_green, vga_blue
);
    // Box (cursor) movement parameters
    parameter H_RES = 640;
    parameter V_RES = 480;
    parameter BOX_WIDTH  = 10;
    parameter BOX_HEIGHT = 10;
    parameter STEP_SIZE = 10;

    // Internal registers for button states (for debouncing)
    reg btnU_r, btnD_r, btnL_r, btnR_r, paint_btn_r;

    // Color selection
    always @(*) begin
        case (color_select)
            5'b00000: {red, green, blue} = {4'hF, 4'h0, 4'h0}; // Red
            5'b00001: {red, green, blue} = {4'h0, 4'hF, 4'h0}; // Green
            5'b00010: {red, green, blue} = {4'h0, 4'h0, 4'hF}; // Blue
            5'b00011: {red, green, blue} = {4'hF, 4'hF, 4'h0}; // Yellow
            5'b00100: {red, green, blue} = {4'hF, 4'h0, 4'hF}; // Magenta
            5'b00101: {red, green, blue} = {4'h0, 4'hF, 4'hF}; // Cyan
            5'b00110: {red, green, blue} = {4'hF, 4'hF, 4'hF}; // White
            default:  {red, green, blue} = {4'h0, 4'h0, 4'h0}; // Black
        endcase
    end

    // Debouncing and state updates
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            btnU_r <= 1'b0;
            btnD_r <= 1'b0;
            btnL_r <= 1'b0;
            btnR_r <= 1'b0;
            paint_btn_r <= 1'b0;
            box_x <= H_RES/2 - BOX_WIDTH/2;
            box_y <= V_RES/2 - BOX_HEIGHT/2;
            paint_enable <= 1'b0; // Start with paint enabled
        end else begin
            // Debounce buttons
            btnU_r <= btnU;
            btnD_r <= btnD;
            btnL_r <= btnL;
            btnR_r <= btnR;
            paint_btn_r <= paint_btn;

            // Update box position on p_tick (after debouncing)
            if (p_tick) begin
                if (btnU_r) begin
                    if (box_y >= STEP_SIZE)
                        box_y <= box_y - STEP_SIZE;
                end
                if (btnD_r) begin
                    if (box_y <= V_RES - BOX_HEIGHT - STEP_SIZE)
                        box_y <= box_y + STEP_SIZE;
                end
                if (btnL_r) begin
                    if (box_x >= STEP_SIZE)
                        box_x <= box_x - STEP_SIZE;
                end
                if (btnR_r) begin
                    if (box_x <= H_RES - BOX_WIDTH - STEP_SIZE)
                        box_x <= box_x + STEP_SIZE;
                end
            end
            // Toggle paint enable on rising edge of paint_btn
            if (paint_btn_r && !paint_btn)
                paint_enable <= ~paint_enable;
        end
    end

    // Cursor color - Make it distinct.
    assign vga_red   = 4'hF;
    assign vga_green = 4'hF;
    assign vga_blue  = 4'hF;

endmodule
