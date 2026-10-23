`include "gameOfLife.sv"

module gameOfLife_tb;

    logic clk = 0;
    logic next_frame = 0;
    logic [5:0] pixel = 0;
    logic [7:0] data;

    gameOfLife #(.INIT_FILE("red.memh")) u0 (.clk(clk), .next_frame(next_frame), .pixel(pixel), .data(data));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("gameOfLife.vcd");
        $dumpvars(0, gameOfLife_tb);
        for (int g = 0; g <= 16; g++) begin
            $display("generation %0d", g);
            for (int r = 0; r < 8; r++) begin
                for (int c = 0; c < 8; c++)
                    $write("%0d ", u0.grid[r*8+c]);
                $display("");
            end
            next_frame = 1;
            #10;
            next_frame = 0;
            #10;
        end
        $finish;
    end

endmodule
