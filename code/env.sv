class env #(parameter DATA_WIDTH = 8, parameter DEPTH = 8);
    virtual fif_intf vif;
    mailbox gen2driv;
    mailbox gen2sb;
    mailbox mon2sb;

    generator gen;
    driver driv;
    monitor mon;
    scoreboard scb;

    event gen_end;
    int repeat_count;

    function new(virtual fif_intf vif, int repeat_count);
        this.vif = vif;
        this.repeat_count = repeat_count;
        gen2driv = new();
        gen2sb = new();
        mon2sb = new();
        gen = new(gen2driv, gen2sb, gen_end, repeat_count);
        driv = new(vif, gen2driv);
        mon = new(vif, mon2sb);
        scb = new(gen2sb, mon2sb);
    endfunction

    task test();
        fork
            gen.run();
            driv.run();
            mon.run();
            scb.run();
        join_any
    endtask

    task post_test();
        wait(gen_end.triggered);
        // $display("============Generator has Finished producing Transactions. ============");
        $display("================Transaction Count: %0d ================", repeat_count);
        wait(driv.trans_count >= repeat_count);
        wait(scb.trans_count >= repeat_count);
        $display("=================TEST COMPLETED ================");
        $display("Total Errors: %0d", scb.err_count);
        if(scb.err_count != 0)
            $display("FIFO VERIFICATION FAILED");
    
    endtask

    task run();
        test();
        post_test();
        // $stop;
    endtask

endclass