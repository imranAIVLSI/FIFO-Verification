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

    // run task
    task run();
        repeat(repeat_count/2) begin
            transaction temp;
            // trans.display("generator");
            // assert(trans.randomize()) 
            assert(trans.randomize() with {trans.wr_en_t ==1; trans.rd_en_t == 0;}) 
            else
            $error("Transaction Randomization Failed");


            temp = trans.clone();
            gen2driv.put(temp);
            gen2scoreboard.put(temp);
            // trans.display("Generator");
        end
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