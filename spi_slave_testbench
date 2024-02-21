
import uvm_pkg::*;
interface spi_interface(input logic clk, input logic reset);
  
  
  bit MOSI;
  bit MISO;
  bit [7:0] data_in;
  logic rst;
  logic [7:0] data_out;
  
endinterface


class item_spi extends uvm_sequence_item;
  rand bit [7:0] DATA;
  	bit  [7:0] DATA_R;
  
  `uvm_object_utils_begin(item_spi)
		`uvm_field_int(DATA, UVM_DEFAULT)
  		`uvm_field_int(DATA_R, UVM_DEFAULT)
 `uvm_object_utils_end
  

  function new(string name = "item_spi");
		super.new(name);
	endfunction
  
  //constraint startBit { DATA[0] == 1'b1; }
  //constraint endBit { DATA[7] == 1'b1; }


endclass

class spi_item_sequence extends uvm_sequence;
  
	`uvm_object_utils(spi_item_sequence)
  
  
  function new(string name = "spi_item_sequence");
		super.new(name);
	endfunction
  

  
	virtual task body();

	  
      for(int i = 0;i<15;i++)
          begin
			item_spi seq_item = item_spi::type_id::create("seq_item");
			start_item(seq_item);
            assert(seq_item.randomize());
            //seq_item.print();
			finish_item(seq_item);
		end

	endtask
endclass




class spi_driver extends uvm_driver#(item_spi);

	virtual spi_interface spi_if;

  `uvm_component_utils(spi_driver)
  function new(string name = "spi_driver", uvm_component parent=null);
		super.new(name, parent);
	endfunction


  virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
    if(!uvm_config_db#(virtual spi_interface)::get(this, "*", "spi_if", spi_if))
      `uvm_fatal("DRV", "COULD NOT FIND INTERFACE")
	
  endfunction
	
  virtual task run_phase(uvm_phase phase);
    
		forever begin
          item_spi seq_item;
          seq_item_port.get_next_item(seq_item);
          
          #300 drive_item(seq_item);
		  seq_item_port.item_done();
		end
  endtask

	


  task drive_item(item_spi spi_item);
    for(int i = 0;i<8;i++) 
        begin
         @(posedge spi_if.clk);
          	
            spi_if.MOSI = spi_item.DATA[i];
         
		end
    
    	 spi_if.data_in = spi_item.DATA;
		
		
		
	endtask

endclass



class spi_sequencer extends uvm_sequencer#(item_spi);
  
  `uvm_component_utils(spi_sequencer)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
endclass
	

class spi_monitor extends uvm_monitor;
  
  virtual spi_interface spi_if;

  `uvm_component_utils(spi_monitor)


  

  function new(string name = "spi_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  uvm_analysis_port#(item_spi) spi_analysis_port;
  
	
  virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      	spi_analysis_port = new("spi_analysis_port", this);
      if(! uvm_config_db#(virtual spi_interface)::get(this, "*", "spi_if", spi_if)) 
      begin
        `uvm_error("build_phase","Test virtual interface failed")
      end

	endfunction
	
	int count = 0;
  logic [7:0] shiftReg;
	virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
      
      forever begin
      	item_spi spi_item = item_spi::type_id::create("spi_item");
        
      
        for(int i = 0;i<15;i++) begin

          
          @(posedge spi_if.clk)
          	#1000 spi_item.DATA_R = spi_if.data_out;
			      spi_item.DATA = spi_if.data_in;
          	//spi_item.print();
          if(spi_item.DATA_R !=0)
          	spi_analysis_port.write(spi_item);
        end	
        
      end


	endtask


endclass
    
    
class spi_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(spi_scoreboard)
   
  function new(string name = "spi_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  uvm_analysis_imp #(item_spi, spi_scoreboard) spi_analysis_imp;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    spi_analysis_imp = new("spi_analysis_imp", this);
  endfunction
  
  virtual function write(item_spi spi_item);
    
    //spi_item.print();
    
    if(spi_item.DATA_R == spi_item.DATA)
      begin
        `uvm_info("SCOREBOARD", $sformatf("PASSED! READ DATA MATCHES EXPECTED VALUE: %b == %b", spi_item.DATA_R, spi_item.DATA), UVM_MEDIUM);
      end
    else 
      begin
        `uvm_error("SCOREBOARD", $sformatf("FAILED! READ DATA MATCHES EXPECTED VALUE: %b == %b", spi_item.DATA_R, spi_item.DATA));
       end
    
  endfunction
  
endclass
    

class spi_agent extends uvm_agent;
	
	`uvm_component_utils(spi_agent)
	
	spi_driver d0;
	spi_monitor m0;
  	spi_sequencer s0;
	virtual spi_interface spi_if;
  function new(string name = "spi_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
		
  	super.build_phase(phase);
		
			
    s0 = spi_sequencer::type_id::create("s0", this);
			
    d0 = spi_driver::type_id::create("d0", this);
			
    m0 = spi_monitor::type_id::create("m0", this);
    
    uvm_config_db#(virtual spi_interface)::set(this, "s0", "spi_if", spi_if);
    uvm_config_db#(virtual spi_interface)::set(this, "d0", "spi_if", spi_if);
    uvm_config_db#(virtual spi_interface)::set(this, "m0", "spi_if", spi_if);

  endfunction


	virtual function void connect_phase(uvm_phase phase);
       super.connect_phase(phase);
      
      uvm_config_db#(uvm_object_wrapper)::set(this, "d0", "seq_item_export", spi_sequencer::get_type());

		
      d0.seq_item_port.connect(s0.seq_item_export);
      

		 

	endfunction

endclass



class spi_env extends uvm_env;
  	
  `uvm_component_utils(spi_env)
	
	spi_agent a0;
	spi_scoreboard scb0;

	virtual spi_interface spi_if;

  function new(string name = "spi_env",uvm_component parent=null);
    super.new(name, parent);
  endfunction

	virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      a0 = spi_agent::type_id::create("a0", this);
      scb0 = spi_scoreboard::type_id::create("scb0", this);
      uvm_config_db#(virtual spi_interface)::set(this, "a0", "spi_if", spi_if);
      uvm_config_db#(virtual spi_interface)::set(this, "scb0", "spi_if", spi_if);



	endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a0.m0.spi_analysis_port.connect(scb0.spi_analysis_imp);
  endfunction
  
 

endclass
    
    

  
  


class spi_test extends uvm_test;
	
	`uvm_component_utils(spi_test)
  
  	spi_env e0;
	item_spi seq_item;
	 spi_item_sequence spi_seq; 
	virtual spi_interface spi_if;
  
  
  
  function new(string name = "spi_test", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	
  
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
      e0 = spi_env::type_id::create("e0", this);
      uvm_config_db#(virtual spi_interface)::set(this, "e0", "spi_if", spi_if);
      

	endfunction

	virtual function void end_of_elaboration_phase(uvm_phase phase);
      
	  uvm_top.print_topology();
    uvm_factory::get().print();
      
	endfunction

      

      virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
       	spi_seq = spi_item_sequence::type_id::create("spi_seq");
        phase.raise_objection(this);
        
        spi_seq.start(e0.a0.s0);
        
        
        #1200;
     
        
        phase.drop_objection(this);

	endtask
endclass

			

module tb();
  

 logic [7:0] data_out;
  logic clk;
  logic rst;
  
  always #50 clk <= ~clk;
  spi_interface spi_if(clk, 1'b0);
  spi_slave s0(.clk(spi_if.clk), 
               .reset(rst),
               .SS(1'b0),
               .mosi(spi_if.MOSI),
               .data_out_slave(spi_if.data_out),
               .miso(spi_if.MISO));
  
  
  initial 
    begin
      
     rst = 0;
      clk <= 0;
     #50 rst = 1;
      
  end
 
  
  initial 
    begin
      uvm_config_db#(virtual spi_interface)::set(uvm_root::get(),"*","spi_if",spi_if);
      run_test("spi_test");
      
    end
  
endmodule

  
  
