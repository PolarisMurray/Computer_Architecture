module main(
    input logic clk,
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);

    logic [20:0] count;
    logic[2:0] color;

    initial begin
        count = 0;
        color = 0;
    end

    always @(posedge clk) begin
        if (count == 1999999) begin
            count <= 0;

            if (color == 5)
                color <= 0;
            else begin
                color <= color + 1;
            end
        end else begin
            count <= count + 1;
        end
    end

    always @(*) begin
        case (color)
            0: begin RGB_R = 0; RGB_G = 1; RGB_B = 1; end // 红
            1: begin RGB_R = 0; RGB_G = 0; RGB_B = 1; end // 黄
            2: begin RGB_R = 1; RGB_G = 0; RGB_B = 1; end // 绿
            3: begin RGB_R = 1; RGB_G = 0; RGB_B = 0; end // 青
            4: begin RGB_R = 1; RGB_G = 1; RGB_B = 0; end // 蓝
            5: begin RGB_R = 0; RGB_G = 1; RGB_B = 0; end // 品红
            default: begin RGB_R = 0; RGB_G = 1; RGB_B = 1; end
        endcase
    end

endmodule