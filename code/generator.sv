class generator #(parameter DATA_WIDTH = 8);
    transaction trans;
    mailbox gen2driv;
    mailbox gen2scoreboard;
    int repeat_count;
    event gen_done;
    // constructor
    function new(mailbox gen2driv, mailbox gen2scoreboard,
            event gen_done, int repeat_count);
        this.gen2driv = gen2driv;
        this.gen2scoreboard = gen2scoreboard;
        this.repeat_count = repeat_count;
        this.gen_done = gen_done;
        // trans = new();
        trans = new();
    endfunction    


    // task run();
    //     reset_test();
    //     // write();
    //     // fifo_full();
    //     // read();


    //     ->gen_done;

    // endtask

    // task reset_test();
    // repeat(repeat_count) begin
    //     transaction temp;
    //     trans.rst_n_t = 0;
    //     assert (trans.randomize()) else $error("Randomization Failed");
    //     temp = trans.clone();
    //     gen2driv.put(temp);
    //     gen2scoreboard.put(temp);
    //     // trans.display("Reset");
    // end
    // endtask

    // task write();
    // repeat (repeat_count) begin
    //     transaction temp;
    //     trans.rd_en_t.rand_mode(0);
    //     trans.wr_en_t = 1;
    //     trans.rst_n_t = 1;
    //     assert (trans.randomize()) else $error("Randomization Failed");
    //     temp = trans.clone();
    //     gen2driv.put(temp);
    //     gen2scoreboard.put(temp);
    //     // trans.display("Write");
    // end
    // endtask

    // task read();
    // repeat(repeat_count) begin
    //     transaction temp;
    //     trans.wr_en_t.rand_mode(0);
    //     trans.rd_en_t = 1;
    //     trans.wr_en_t = 0;
    //     trans.rst_n_t = 1;
    //     assert (trans.randomize()) else $error("Randomization Failed");
    //     temp = trans.clone();
    //     gen2driv.put(temp);
    //     gen2scoreboard.put(temp);
    //     // trans.display("Read"); 
    // end       
    // endtask

    // task fifo_full();
    //     repeat(repeat_count) begin
    //         transaction temp;
    //         trans.wr_en_t.rand_mode(0);
    //         trans.rd_en_t.rand_mode(0);
    //         trans.wr_en_t = 1;
    //         trans.rst_n_t = 1;
    //         trans.rd_en_t = 0;
    //         assert (trans.randomize()) else $error("Randomization Failed");
    //         temp = trans.clone();
    //         gen2driv.put(temp);
    //         gen2scoreboard.put(temp);
    //         trans.display("Generator");
    //         repeat_count++;
    //     end
    // endtask








    // run task
    task run();
        repeat(repeat_count/2) begin // divide/2 for read full test
            transaction temp;
            // trans.display("generator");
            // assert(trans.randomize()) // comment this for Read_full Fifo test
            assert(trans.randomize() with {trans.wr_en_t ==1; trans.rd_en_t == 0;}) // Uncomment this for Read Full FIFO Test
            else
            $error("Transaction Randomization Failed");


            temp = trans.clone();
            gen2driv.put(temp);
            gen2scoreboard.put(temp);
            // trans.display("Generator");
        end
        // Uncomment below part of code for READ _full fifo test
            repeat(repeat_count/2) begin
            transaction temp;
            // trans.display("generator");
            // assert(trans.randomize()) 
            assert(trans.randomize() with {trans.wr_en_t ==0; trans.rd_en_t == 1;}) 
            else
            $error("Transaction Randomization Failed");


            temp = trans.clone();
            gen2driv.put(temp);
            gen2scoreboard.put(temp);
            // trans.display("Generator");
        end
        ->gen_done;
    endtask
endclass