class driver;
    transaction trans;
    mailbox gen2driv;
    virtual fif_intf dbus;
    int trans_count;

    function new(virtual fif_intf dbus, mailbox gen2driv);
        trans = new();
        this.gen2driv = gen2driv;
        this.dbus = dbus;
        this.trans_count = 0;
    endfunction

    task run();
        // $display("**============== Driver =============");
        forever begin
            gen2driv.get(trans);
            trans.display("Driver");
            @(negedge dbus.clk);
                dbus.rst_n <= trans.rst_n_t;
                dbus.wr_en <= trans.wr_en_t;
                dbus.rd_en <= trans.rd_en_t;
                dbus.data_in <= trans.data_in_t;
                dbus.data_out <= trans.data_out_t;
            trans_count++;
        end
    endtask

endclass