module fifo_assertions #(parameter DATA_WIDTH=8, DEPTH=8) (
  input logic clk,
  input logic rst_n,
  input logic wr_en,
  input logic rd_en,
  input logic full,
  input logic empty,
  input logic [DATA_WIDTH-1:0] data_in,
  input logic [DATA_WIDTH-1:0] data_out
);

  // Reset: FIFO must be empty, not full
  property p_reset_flags;
    @(posedge clk) (!rst_n) |-> (empty && !full);
  endproperty
  a_reset_flags: assert property(p_reset_flags);

  // Write only when not full
  property p_no_write_when_full;
    @(posedge clk) (wr_en && full) |-> $stable(data_out);
  endproperty
  a_no_write_when_full: assert property(p_no_write_when_full);

  // Read only when not empty
  property p_no_read_when_empty;
    @(posedge clk) (rd_en && empty) |-> $stable(data_out);
  endproperty
  a_no_read_when_empty: assert property(p_no_read_when_empty);

  // Full flag set only when FIFO is full
  property p_full_flag_set;
    @(posedge clk) (full) |-> !(wr_en && !rd_en);
  endproperty
  a_full_flag_set: assert property(p_full_flag_set);

  // Empty flag set only when FIFO is empty
  property p_empty_flag_set;
    @(posedge clk) (empty) |-> !(rd_en && !wr_en);
  endproperty
  a_empty_flag_set: assert property(p_empty_flag_set);

endmodule