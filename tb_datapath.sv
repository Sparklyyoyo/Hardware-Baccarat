`define TWO   7'b0100100
`define THREE 7'b0110000
`define FOUR  7'b0011001
`define FIVE  7'b0010010
`define SIX   7'b0000010
`define SEVEN 7'b1111000
`define EIGHT 7'b0000000
`define NINE  7'b0010000
`define TEN 7'b1000000

`define ACE   7'b0001000
`define JACK  7'b1100001
`define QUEEN 7'b0011000
`define KING  7'b0001001

`define EMPTY 7'b1111111

module tb_datapath();

    //Inputs
    logic slow_clock;
    logic fast_clock;
    logic resetb;
    logic load_pcard1;
    logic load_pcard2;
    logic load_pcard3;
    logic load_dcard1;
    logic load_dcard2;
    logic load_dcard3;

    //Outputs
    logic [3:0] pcard3_out;
    logic [3:0] pscore_out;
    logic [3:0] dscore_out;
    logic [6:0] HEX5;
    logic [6:0] HEX4;
    logic [6:0] HEX3;
    logic [6:0] HEX2;
    logic [6:0] HEX1;
    logic [6:0] HEX0;

    //Error Signal
    logic err;

    datapath dut(.*);

    task check;

        input logic [3:0] out;
        input logic [3:0] expected_output;

        begin
            if(out !== expected_output) begin
                $error("Error: Output is %b, Expected Output is %b", out, expected_output);
                err = 1'b1;
            end
        end
    endtask

    task check_not_equal;

        input logic [3:0] out;
        input logic [3:0] expected_output;

        begin
            if(out === expected_output) begin
                $error("Error: Output is %b, Expected Output is %b", out, expected_output);
                err = 1'b1;
            end
        end
    endtask

    initial begin
        slow_clock = 1'b0;
        #5;

        forever begin
            slow_clock = 1'b1;
            #5;

            slow_clock = 1'b0;
            #5;
        end  
    end

    initial begin
        fast_clock = 1'b0;
        #1;

        forever begin
            fast_clock = 1'b1;
            #1;

            fast_clock = 1'b0;
            #1;
        end  
    end

    initial begin
        err = 1'b0;
        resetb = 1'b0;
        #10;
        $display("Checking that all HEX's and CARDS are EMPTY/ZERO");
        check(HEX0,`EMPTY);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(tb_datapath.dut.pcard1_out, 4'd0);
        check(tb_datapath.dut.pcard2_out, 4'd0);
        check(pcard3_out, 4'd0);
        check(tb_datapath.dut.dcard1_out, 4'd0);
        check(tb_datapath.dut.dcard2_out, 4'd0);
        check(tb_datapath.dut.dcard3_out, 4'd0);



        resetb = 1'b1;
        load_pcard1 = 1'b1;
        load_pcard2 = 1'b0;
        load_pcard3 = 1'b0;
        load_dcard1 = 1'b0;
        load_dcard2 = 1'b0;
        load_dcard3 = 1'b0;
        #10;

        $display("Checking that HEX 0 and PCARD1 are not EMPTY/ZERO");
        check_not_equal(HEX0,`EMPTY);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check_not_equal(tb_datapath.dut.pcard1_out, 4'd0);
        check(tb_datapath.dut.pcard2_out, 4'd0);
        check(pcard3_out, 4'd0);
        check(tb_datapath.dut.dcard1_out, 4'd0);
        check(tb_datapath.dut.dcard2_out, 4'd0);
        check(tb_datapath.dut.dcard3_out, 4'd0);



        load_pcard1 = 1'b0;
        load_pcard2 = 1'b1;
        load_pcard3 = 1'b0;
        load_dcard1 = 1'b0;
        load_dcard2 = 1'b0;
        load_dcard3 = 1'b0;
        #10;

        $display("Checking that HEX 1 and PCARD2 are not EMPTY/ZERO");
        check_not_equal(HEX0,`EMPTY);
        check_not_equal(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check_not_equal(tb_datapath.dut.pcard1_out, 4'd0);
        check_not_equal(tb_datapath.dut.pcard2_out, 4'd0);
        check(pcard3_out, 4'd0);
        check(tb_datapath.dut.dcard1_out, 4'd0);
        check(tb_datapath.dut.dcard2_out, 4'd0);
        check(tb_datapath.dut.dcard3_out, 4'd0);



        load_pcard1 = 1'b0;
        load_pcard2 = 1'b0;
        load_pcard3 = 1'b1;
        load_dcard1 = 1'b0;
        load_dcard2 = 1'b0;
        load_dcard3 = 1'b0;
        #10;

        $display("Checking that HEX 2 and PCARD3 are not EMPTY/ZERO");
        check_not_equal(HEX0,`EMPTY);
        check_not_equal(HEX1,`EMPTY);
        check_not_equal(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check_not_equal(tb_datapath.dut.pcard1_out, 4'd0);
        check_not_equal(tb_datapath.dut.pcard2_out, 4'd0);
        check_not_equal(pcard3_out, 4'd0);
        check(tb_datapath.dut.dcard1_out, 4'd0);
        check(tb_datapath.dut.dcard2_out, 4'd0);
        check(tb_datapath.dut.dcard3_out, 4'd0);
        


        load_pcard1 = 1'b0;
        load_pcard2 = 1'b0;
        load_pcard3 = 1'b0;
        load_dcard1 = 1'b1;
        load_dcard2 = 1'b0;
        load_dcard3 = 1'b0;
        #10;

        $display("Checking that HEX 3 and DCARD1 are not EMPTY/ZERO");
        check_not_equal(HEX0,`EMPTY);
        check_not_equal(HEX1,`EMPTY);
        check_not_equal(HEX2,`EMPTY);
        check_not_equal(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check_not_equal(tb_datapath.dut.pcard1_out, 4'd0);
        check_not_equal(tb_datapath.dut.pcard2_out, 4'd0);
        check_not_equal(pcard3_out, 4'd0);
        check_not_equal(tb_datapath.dut.dcard1_out, 4'd0);
        check(tb_datapath.dut.dcard2_out, 4'd0);
        check(tb_datapath.dut.dcard3_out, 4'd0);
          


        load_pcard1 = 1'b0;
        load_pcard2 = 1'b0;
        load_pcard3 = 1'b0;
        load_dcard1 = 1'b0;
        load_dcard2 = 1'b1;
        load_dcard3 = 1'b0;
        #10;

        $display("Checking that HEX 4 and DCARD2 are not EMPTY/ZERO");
        check_not_equal(HEX0,`EMPTY);
        check_not_equal(HEX1,`EMPTY);
        check_not_equal(HEX2,`EMPTY);
        check_not_equal(HEX3,`EMPTY);
        check_not_equal(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check_not_equal(tb_datapath.dut.pcard1_out, 4'd0);
        check_not_equal(tb_datapath.dut.pcard2_out, 4'd0);
        check_not_equal(pcard3_out, 4'd0);
        check_not_equal(tb_datapath.dut.dcard1_out, 4'd0);
        check_not_equal(tb_datapath.dut.dcard2_out, 4'd0);
        check(tb_datapath.dut.dcard3_out, 4'd0);



        load_pcard1 = 1'b0;
        load_pcard2 = 1'b0;
        load_pcard3 = 1'b0;
        load_dcard1 = 1'b0;
        load_dcard2 = 1'b0;
        load_dcard3 = 1'b1;
        #10;

        $display("Checking that HEX 5 and DCARD3 are not EMPTY/ZERO");
        check_not_equal(HEX0,`EMPTY);
        check_not_equal(HEX1,`EMPTY);
        check_not_equal(HEX2,`EMPTY);
        check_not_equal(HEX3,`EMPTY);
        check_not_equal(HEX4,`EMPTY);
        check_not_equal(HEX5,`EMPTY);
        check_not_equal(tb_datapath.dut.pcard1_out, 4'd0);
        check_not_equal(tb_datapath.dut.pcard2_out, 4'd0);
        check_not_equal(pcard3_out, 4'd0);
        check_not_equal(tb_datapath.dut.dcard1_out, 4'd0);
        check_not_equal(tb_datapath.dut.dcard2_out, 4'd0);
        check_not_equal(tb_datapath.dut.dcard3_out, 4'd0);

        if(err)
            $display("FAILED");
        else
            $display("PASSED");
        
        $stop;
    end
endmodule
