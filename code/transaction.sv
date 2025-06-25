class transaction #(parameter DATA_WIDTH = 8);
    // Transaction fields
    bit rst_n_t;
    rand bit wr_en_t;
    rand bit rd_en_t;
    rand bit [DATA_WIDTH-1:0] data_in_t;
    bit [DATA_WIDTH-1:0]data_out_t;
    bit full_t;
    bit empty_t;
    // Constructor
    function new(bit wr_en_t = 0, bit rd_en_t = 0, bit [DATA_WIDTH-1:0] data_in_t = 'h0);
        this.rst_n_t = 1;
        this.wr_en_t = wr_en_t;
        this.rd_en_t = rd_en_t;
        this.data_in_t = data_in_t;
        data_out_t = 'h0;
        full_t = 1'b0;
        empty_t = 1'b0;
    endfunction

    constraint c1 {
        
    }
// added clone method because driver only takes last randomize transaction so from generator send cloned transaction at mailboxes
    virtual function transaction #(DATA_WIDTH) clone();
        transaction #(DATA_WIDTH) t = new();
        t.rst_n_t   = this.rst_n_t;
        t.wr_en_t   = this.wr_en_t;
        t.rd_en_t   = this.rd_en_t;
        t.data_in_t = this.data_in_t;
        t.data_out_t= this.data_out_t;
        t.full_t    = this.full_t;
        t.empty_t   = this.empty_t;
        return t;
    endfunction

    // Display Method
    function void display(string tx);
        // $display("***============== %s Transaction ===============***", tx);
        $display("[%0t][%s] \tReset:\t%0b\tWrite Enable:\t%0b\tRead Enable:\t%0b\tData IN:\t%0d\tData Out:\t%0d\tFull Flag:\t%0b\tEmpty Flag:\t%0b",$time,tx,rst_n_t,wr_en_t,rd_en_t,data_in_t,data_out_t,full_t,empty_t);
    endfunction

endclass
