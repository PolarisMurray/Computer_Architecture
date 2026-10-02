`timescale 1ns/1ps
`include "color_wheel.sv"

// this is the testbench
// run one full loop and check that it ends up back at red

module color_wheel_tb;

    logic clk = 0;
    logic rst = 1;
    logic [7:0] red, green, blue;
    logic red_out, green_out, blue_out;

    color_wheel u0 (
        .clk        (clk),
        .rst        (rst),
        .red        (red),
        .green      (green),
        .blue       (blue),
        .red_out    (red_out),
        .green_out  (green_out),
        .blue_out   (blue_out)
    );

    // the period
    always begin
        #5
        clk = ~clk;
    end

    initial begin
        $dumpfile("color_wheel.vcd");
        // only dump these
        $dumpvars(0, red, green, blue, red_out, green_out, blue_out);

        #20
        rst = 0;

        // one loop = 8000 * 250 * 6 = 12000000 clocks
        for (int i = 0; i < 12000000; i++) begin
            @(posedge clk);
            // if (i % 1000000 == 0) $display("i = %d", i);
        end
        #1;     // wait, right at the clock edge it still has the old values

        $display("red = %d, green = %d, blue = %d", red, green, blue);
        if (red == 250 && green == 0 && blue == 0)
            $display("passed, back to red after 1 loop");
        else
            $display("FAILED, should be red = 250, green = 0, blue = 0");

        $finish;
    end

endmodule
