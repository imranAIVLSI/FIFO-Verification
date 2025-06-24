interface fif_intf#(parameter DEPTH = 8, parameter DATA_WIDTH = 8) (input bit clk);
    bit rst_n;
    bit wr_en;
    bit rd_en;
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;
    bit full;
    bit empty;

    // modport mon_mp (
    //     input clk, rst_n, wr_en, rd_en, data_in, data_out, full, empty
    // );
    // modport driv_mp (
    //     input clk, rst_n, full, empty, data_out,
    //     output wr_en, rd_en, data_in
    // );

endinterface
