`include "ws2812b.sv"
`include "controller.sv"
`include "gameOfLife.sv"

module top(
    input logic clk,
    output logic _48b
);

    logic [7:0] red_data;
    logic [7:0] green_data;
    logic [7:0] blue_data;

    logic [5:0] pixel;
    logic [23:0] shift_reg = 24'd0;
    logic load_sreg;
    logic transmit_pixel;
    logic next_frame;
    logic shift;

    gameOfLife #(.INIT_FILE("red.memh")) u1 (.clk(clk), .next_frame(next_frame), .pixel(pixel), .data(red_data));
    gameOfLife #(.INIT_FILE("green.memh")) u2 (.clk(clk), .next_frame(next_frame), .pixel(pixel), .data(green_data));
    gameOfLife #(.INIT_FILE("blue.memh")) u3 (.clk(clk), .next_frame(next_frame), .pixel(pixel), .data(blue_data));

    ws2812b u4 (.clk(clk), .serial_in(shift_reg[23]), .transmit(transmit_pixel), .ws2812b_out(_48b), .shift(shift));

    controller u5 (.clk(clk), .load_sreg(load_sreg), .transmit_pixel(transmit_pixel), .next_frame(next_frame), .pixel(pixel));

    always_ff @(posedge clk) begin
        if (load_sreg)
            shift_reg = {green_data, red_data, blue_data};
        else if (shift)
            shift_reg = {shift_reg[22:0], 1'b0};
    end

endmodule
