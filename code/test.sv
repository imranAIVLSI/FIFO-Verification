// // class reset_fifo #(parameter DATA_WIDTH = 8) extends transaction ;

// //     function new();
// //         super.new();
// //     endfunction

// //     function void pre_randomization();
// //         rst_n_t.rand_mode(0);
// //         this.rst_n_t = 0;
// //         // this.rd_en_t = 0;
// //         // this.wr_en_t = 0;
// //     endfunction

// // endclass

// program reset_test (fif_intf vif);
//     // virtual fif_intf vif;
//     env env1;
//         initial begin
//             $display("======Reset Test=======");
//             // reset_fifo rt;
//             // rt = new();

//             env1 = new(vif, 10);
//             // env1.gen.repeat_count = 10;
//             // env1.gen.trans = rt;
//             // @(posedge vif.clk); vif.wr_en = 0; vif.rd_en = 0;
//             // @(negedge vif.rst_n); // asynchronous reset
//             // @(posedge vif.clk);
//             env1.run();
//             $finish;
//         end

// endprogram