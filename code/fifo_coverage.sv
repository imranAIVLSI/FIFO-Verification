module fifo_coverage #(parameter DATA_WIDTH=8, DEPTH=8) (
  input logic clk,
  input logic rst_n,
  input logic wr_en,
  input logic rd_en,
  input logic full,
  input logic empty,
  input logic [DATA_WIDTH-1:0] data_in,
  input logic [DATA_WIDTH-1:0] data_out
);

  covergroup cg_flags @(posedge clk);
    coverpoint full;
    coverpoint empty;
    flags_cp: cross full, empty {
      illegal_bins illegal = 
        binsof(full) intersect {1} && binsof(empty) intersect {1};
    }
  endgroup


  covergroup cg_ops @(posedge clk);
    coverpoint {wr_en, rd_en} {
      bins idle = {2'b00};
      bins write = {2'b10};
      bins read = {2'b01};
      bins both = {2'b11};
    }
  endgroup

  cg_flags flags_inst = new();
  cg_ops ops_inst = new();

endmodule