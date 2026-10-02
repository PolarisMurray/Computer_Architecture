// Color wheel
// red -> yellow -> green -> cyan -> blue -> magenta -> back to red, one loop per second
// brightness of each color is done with pwm

module color_wheel(
    input logic clk,
    input logic rst,
    output logic [7:0] red, green, blue, // brightness 0 - 250
    output logic red_out, green_out, blue_out  // pwm output, 1 = on
);

    // clk is 12MHz, the pwm period = 250 clocks, 12MHz / 250 = 48kHz so no flicker
    // color changes one step every 8000 clocks
    // 250 steps in each stage, 6 stages, 8000 * 250 * 6 = 12000000 clocks = 1 sec

    logic [7:0] pwm_count; // 1 - 250
    logic [12:0] count; // 0 - 7999, 2^13 = 8192
    logic [7:0] step;  // 0 - 249
    logic [2:0] stage; // 0 - 5

    // with <= everything updates together at the clock edge,
    always_ff @(posedge clk) begin
        if (rst) begin
            pwm_count <= 1;
            count <= 0;
            step <= 0;
            stage <= 0;
            red <= 250;
            green <= 0;
            blue <= 0;
        end
        else begin
            if (pwm_count == 250)
                pwm_count <= 1;
            else
                pwm_count <= pwm_count + 1;

            if (count == 7999) begin
                count <= 0;

                if (stage == 0)
                    green <= green + 1; // red -> yellow -> green -> cyan -> blue -> magenta -> bacl
                else if (stage == 1)
                    red <= red - 1;
                else if (stage == 2)
                    blue <= blue + 1;
                else if (stage == 3)
                    green <= green - 1;
                else if (stage == 4)
                    red <= red + 1;
                else if (stage == 5)
                    blue <= blue - 1;

                if (step == 249) begin // next stage after 250 steps
                    step <= 0;
                    if (stage == 5)
                        stage <= 0;
                    else
                        stage <= stage + 1;
                end
                else
                    step <= step + 1;
            end
            else
                count <= count + 1;
        end
    end


    assign red_out = (pwm_count <= red);
    assign green_out = (pwm_count <= green);
    assign blue_out = (pwm_count <= blue);

endmodule
