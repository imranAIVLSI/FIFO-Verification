class monitor;
    virtual fif_intf mbus;
    mailbox mon2sb;

    function new(virtual fif_intf mbus, mailbox mon2sb);
        this.mbus = mbus;
        this.mon2sb = mon2sb;
    endfunction

    task run();
        transaction trans;
        trans = new();
        forever begin
            @(posedge mbus.clk);
                #1ns;
                trans.rd_en_t = mbus.rd_en;
                trans.wr_en_t = mbus.wr_en;
                trans.data_in_t = mbus.data_in;
                trans.data_out_t = mbus.data_out;
                trans.full_t = mbus.full;
                trans.empty_t = mbus.empty;
                trans.rst_n_t=mbus.rst_n;

            mon2sb.put(trans);
            trans.display("Monitor");
        end
    endtask
endclass