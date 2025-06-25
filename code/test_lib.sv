// FIFO Test: Configures env1ironment and runs test sequences
class reset_trans extends transaction;
    function void pre_randomize();
        // rst_n_t.rand_mode(0);
        rst_n_t = 0;
        wr_en_t.rand_mode(0);
        rd_en_t.rand_mode(0);
    endfunction
endclass

class fifo_full extends transaction;
    function void pre_randomize();
        wr_en_t.rand_mode(0);
        rd_en_t.rand_mode(0);
        wr_en_t = 1;
        rst_n_t = 1;
    endfunction
endclass

class read_full extends transaction;
      function void pre_randomize();
        wr_en_t.rand_mode(1);
        rd_en_t.rand_mode(1);
        // rd_en_t = 1;
        rst_n_t = 1;
      endfunction
endclass

class rand_RW extends transaction;
  constraint c2 {
    !(rd_en_t == 0 && wr_en_t == 0);
  }
endclass

class test_lib;
  transaction trans;
  env env1;
  virtual fif_intf vif;
  int count;
  // event next;
  function new(virtual fif_intf vif, int count);
    this.vif = vif;
    this.count = count;
    env1 = new(vif, count);
    // trans = new();
  endfunction

  task test1_reset();
    reset_trans t = new();
    env1.gen.trans = t ; 
    env1.run();
  endtask

  task test2_write_full();
    fifo_full t = new();
    env1.gen.trans = t ; 
    env1.run();
  endtask

  task test3_read_full();

    read_full t1 = new();
    env1.gen.trans = t1;
    env1.run();

  endtask

  task test_4_randRW();
    // rand_RW t = new();
    // env1.gen.trans = t;
    env1.run();

  endtask

  task run_all_tests();
    // test1_reset();
    // #20;
    // test2_write_full();
    test3_read_full();
    // test_4_randRW();
    // $display("[TEST] All scenarios executed.");
  endtask

endclass