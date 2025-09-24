module tb_scorehand();

    logic [3:0] card1;
    logic [3:0] card2;
    logic [3:0] card3;
    logic [3:0] total;
    //logic err;

    scorehand dut(.*);

    task check;

        input logic [3:0] expected_output;

        begin

            if(tb_scorehand.dut.total !== expected_output) begin
                $error("Error: Total is %b, Expected Total is %b", tb_scorehand.dut.total, expected_output);
                //err = 1'b1;
            end

            else 
                $display("Checking total is %b",tb_scorehand.dut.total);
        end
    endtask

    initial begin
        //err = 1'b0;
        card1 = 4'd1;
        card2 = 4'd2;
        card3 = 4'd3;

        #10;

        check(6);


        card1 = 4'd13;
        card2 = 4'd12;
        card3 = 4'd13;

        #10;

        $display("Fail for Coverage");
        check(3);


        card1 = 4'd15;
        card2 = 4'd15;
        card3 = 4'd15;

        #10;

        check(0);

        card1 = 4'd0;
        card2 = 4'd0;
        card3 = 4'd0;

        #10;

        check(0);

        //if(err)
         ///   $display("FAILED");
        //else
           // $display("PASSED");

        $stop;
    end
endmodule
