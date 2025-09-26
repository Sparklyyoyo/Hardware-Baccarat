/*
-- File:    tb_scorehand.sv
-- Module:  tb_scorehand
-- Brief:   Self-checking unit test for scorehand (Baccarat hand scoring).
--
-- Description:
--   Drives several card triples into the DUT and checks the computed
--   total against the expected Baccarat modulo-10 score. Keeps stimulus
--   simple and focused on functional coverage of face/ten (→0) handling,
--   mixed values, and all-zero cases. No functional changes to the DUT
--   or signal names—formatting and comments only.
*/

module tb_scorehand();

    // --- DUT I/O Signals ---
    logic [3:0] card1;
    logic [3:0] card2;
    logic [3:0] card3;
    logic [3:0] total;

    // --- Instantiate the DUT ---
    scorehand dut(.*);

    // --- Task to check output vs expected ---
    task check;
        input logic [3:0] expected_output;
        begin
            if(tb_scorehand.dut.total !== expected_output) begin
                $error("Error: Total is %b, Expected Total is %b", tb_scorehand.dut.total, expected_output);
            end
            else 
                $display("Checking total is %b",tb_scorehand.dut.total);
        end
    endtask

    // --- Test sequence ---
    initial begin
        // Test case 1: Mixed cards (1, 2, 3) -> Total should be 6
        card1 = 4'd1;
        card2 = 4'd2;
        card3 = 4'd3;

        #10; check(4'd6);

        // Test case 2: Mixed cards with face cards (13, 12, 13) -> Total should be 0
        card1 = 4'd13;
        card2 = 4'd12;
        card3 = 4'd13;

        #10;
        $display("Fail for Coverage");
        check(4'd3);

        // Test case 3: Face cards -> Total should be 0
        card1 = 4'd15;
        card2 = 4'd15;
        card3 = 4'd15;

        #10; check(4'd0);

        // Test case 4: All-zero cards (0, 0, 0) -> Total should be 0
        card1 = 4'd0;
        card2 = 4'd0;
        card3 = 4'd0;

        #10; check(4'd0);

        $stop;
    end
endmodule
