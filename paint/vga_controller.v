`timescale 1ns / 1ps
module vga_controller(
    input clk_100MHz,
    input reset,
    output reg video_on,
    output reg hsync,
    output reg vsync,
    output reg p_tick,
    output reg [9:0] x,
    output reg [9:0] y
);
    // VGA timing parameters (for 640x480 @ 60Hz)
    parameter H_RES = 640;      // Horizontal resolution
    parameter H_PULSE = 96;     // Horizontal sync pulse width
    parameter H_BACK = 48;      // Horizontal back porch
    parameter H_FRONT = 16;     // Horizontal front porch
    parameter V_RES = 480;      // Vertical resolution
    parameter V_PULSE = 2;      // Vertical sync pulse width
    parameter V_BACK = 33;     // Vertical back porch
    parameter V_FRONT = 10;     // Vertical front porch

    // Horizontal and vertical counters
    reg [9:0] h_count;
    reg [9:0] v_count;

    // Pixel clock counter (for p_tick)
    reg [3:0] p_tick_count;
    localparam P_TICK_DIV = 4; // Divide 100MHz by 4 to get 25MHz pixel clock

    always @(posedge clk_100MHz or posedge reset) begin
        if (reset) begin
            h_count <= 0;
            v_count <= 0;
            hsync <= 1;
            vsync <= 1;
            video_on <= 0;
            x <= 0;
            y <= 0;
            p_tick <= 0;
            p_tick_count <= 0;
        end else begin
            // Pixel clock generation
            p_tick_count <= p_tick_count + 1;
            if (p_tick_count == P_TICK_DIV - 1) begin
                p_tick <= 1;
                p_tick_count <= 0;
            end else begin
                p_tick <= 0;
            end

            // Horizontal counter
            if (h_count < H_PULSE + H_BACK + H_RES + H_FRONT - 1) begin
                h_count <= h_count + 1;
            end else begin
                h_count <= 0;
                // Vertical counter
                if (v_count < V_PULSE + V_BACK + V_RES + V_FRONT - 1) begin
                    v_count <= v_count + 1;
                end else begin
                    v_count <= 0;
                end
            end

            // Horizontal sync generation
            if (h_count < H_PULSE) begin
                hsync <= 0;
            end else begin
                hsync <= 1;
            end

            // Vertical sync generation
            if (v_count < V_PULSE) begin
                vsync <= 0;
            end else begin
                vsync <= 1;
            end

            // Video on signal generation
            if (h_count >= H_PULSE + H_BACK && h_count < H_PULSE + H_BACK + H_RES &&
                v_count >= V_PULSE + V_BACK && v_count < V_PULSE + V_BACK + V_RES) begin
                video_on <= 1;
                x <= h_count - (H_PULSE + H_BACK);
                y <= v_count - (V_PULSE + V_BACK);
            end else begin
                video_on <= 0;
                x <= 0;
                y <= 0;
            end
        end
    end
endmodule
