`include "color_wheel.sv"

// Top module for the board

module top(
    input logic clk,
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);

    // rst is 1 at the start and becomes 0 after the first clock,
    // so color_wheel always starts from red when the board powers on
    logic rst = 1;
    logic r, g, b;

    always_ff @(posedge clk) begin
        rst <= 0;
    end

    color_wheel u1 (
        .clk        (clk),
        .rst        (rst),
        .red        (),     // only needed in the testbench
        .green      (),
        .blue       (),
        .red_out    (r),
        .green_out  (g),
        .blue_out   (b)
    );

    // rgb led is active low (0 = on) so flip it
    assign RGB_R = !r;
    assign RGB_G = !g;
    assign RGB_B = !b;

endmodule
