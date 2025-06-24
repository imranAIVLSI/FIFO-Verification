class scoreboard #(parameter DATA_WIDTH = 8, parameter DEPTH = 8);
    mailbox gen_sb;
    mailbox mon_sb;
    int trans_count;
    int err_count;
    int pass;
    bit [DATA_WIDTH-1:0] exp_queue [$];
    bit [DATA_WIDTH-1:0] exp_data_out;
    bit exp_full, exp_empty;

    function new(mailbox gen_sb, mailbox mon_sb);
        this.gen_sb = gen_sb;
        this.mon_sb = mon_sb;
        this.trans_count = 0;
        this.err_count = 0;
        // trans = new();
    endfunction


    task run();
        transaction trans_gen, trans_mon;

        forever begin
            trans_gen = new();
            trans_mon = new();
            gen_sb.get(trans_gen);
            mon_sb.get(trans_mon);
            // trans_mon.display("monitor");
            // trans_gen.display("generator:");
            if(!trans_gen.rst_n_t) begin
                exp_queue.delete();
                if(trans_mon.empty_t && !trans_mon.full_t) begin
                    if(exp_queue.size() == 0)begin
                    $display("Reset Test Passed");
                    end
                end
                else begin
                    $display("Reset Test Failed");
                    err_count++;
                end
            end
            else if(trans_gen.wr_en_t && exp_queue.size() <= DEPTH) begin
                exp_queue.push_back(trans_gen.data_in_t);
                $display("Data [%0d] Pushed in Golden Model at the back.", trans_gen.data_in_t);
            end
            
            if((exp_queue.size()) > DEPTH ) begin
                if(trans_mon.full_t) begin
                    $display("FIFO FULL Test PASSED");
                end
                else begin
                    $display("FIFO FULL TEST FAILED");
                end
            end

            if(trans_mon.rd_en_t && !trans_mon.empty_t) begin
                assert(exp_queue.size() != 0)
                exp_data_out = exp_queue.pop_front();
                else
                $error("FIFO Read occured but Queue is empty");
                err_count++;
                // return;
            end
            if(exp_data_out !== trans_mon.data_out_t) begin
                $error("Data Mismatch! Expected:  %0d\t, GOT: %0d\t", exp_data_out, trans_mon.data_out_t);
                $display("============== FIFO VERIFICATION FAILED ================");
                err_count++;
            end
            else begin
                $display("Data Match: %0d", trans_mon.data_out_t);
                $display("========== FIFO VERIFICATION SUCCESSFULL ===============");
            end
            trans_count++;
        end
    endtask

endclass