module gameOfLife #(
    parameter INIT_FILE = ""
)(
    input logic clk,
    input logic next_frame,
    input logic [5:0] pixel,
    output logic [7:0] data
);

    logic grid [0:63];
    logic [2:0] up, down, left, right;
    logic [2:0] count;

    initial $readmemh(INIT_FILE, grid);

    always_ff @(posedge clk) begin
        if (next_frame) begin
            for (int r = 0; r < 8; r++) begin
                for (int c = 0; c < 8; c++) begin
                    up = r - 1;
                    down = r + 1;
                    left = c - 1;
                    right = c + 1;
                    count = grid[up*8+left] + grid[up*8+c] + grid[up*8+right]
                          + grid[r*8+left] + grid[r*8+right]
                          + grid[down*8+left] + grid[down*8+c] + grid[down*8+right];
                    grid[r*8+c] <= (count == 3) || (grid[r*8+c] && count == 2);
                end
            end
        end
    end

    assign data = grid[pixel] ? 8'h20 : 8'h00;

endmodule
