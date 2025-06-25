// `include "test.sv"
module top #(parameter DATA_WIDTH = 8, DEPTH = 8);
    bit clk = 0;
    always #5 clk = ~clk;
    fif_intf #(DATA_WIDTH, DEPTH) bus(clk);
    test_lib test;
    // FIFO Instantiation
    synchronous_fifo #(DATA_WIDTH, DEPTH) fifo1(
        .clk(bus.clk),
        .rst_n(bus.rst_n),
        .w_en(bus.wr_en),
        .r_en(bus.rd_en),
        .data_in(bus.data_in),
        .data_out(bus.data_out),
        .full(bus.full),
        .empty(bus.empty)
        );

    fifo_coverage #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) cov (
        .clk(bus.clk),
        .rst_n(bus.rst_n),
        .wr_en(bus.wr_en),
        .rd_en(bus.rd_en),
        .full(bus.full),
        .empty(bus.empty),
        .data_in(bus.data_in),
        .data_out(bus.data_out)
    );

    fifo_assertions #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) asser (
        .clk(bus.clk),
        .rst_n(bus.rst_n),
        .wr_en(bus.wr_en),
        .rd_en(bus.rd_en),
        .full(bus.full),
        .empty(bus.empty),
        .data_in(bus.data_in),
        .data_out(bus.data_out)
    );
    // initial begin
    //     bus.rst_n = 0;
    //     @(posedge bus.clk);
    //     bus.rst_n = 1;
    // end
        // reset_test t1(bus);
    initial begin
        test = new(bus, 20);
        test.run_all_tests();
        $finish;
    end

endmodule