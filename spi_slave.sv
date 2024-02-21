package pkg;

	
typedef enum {RESET, IDLE, LOAD, TRANSMIT} state_t;

endpackage


import pkg::*; 

  

  
module spi_slave(input logic clk, input logic reset, input logic  SS, output logic [7:0] data_out_slave, input logic mosi, output logic miso);
  
  
  logic [7:0] shift_register;
   logic [7:0] out;
  static logic [7:0] out2;
  
  state_t state, nextState;
  int count;
  
  assign data_out_slave = out;
  always@(posedge clk) begin
    unique case(state)
      
      RESET : begin
        nextState = IDLE;
        //data_out_slave = 0;
        //out = 0;
        shift_register = 0;
        miso = 0;
      end
      
      IDLE : begin
        nextState = LOAD;
        //data_out_slave = 0;
		out = 0;
        shift_register = 8'b0;
      end
       LOAD : begin
         nextState = TRANSMIT;
         if(count == 0) begin
        	shift_register = 8'b0;
         end
       end
      
      TRANSMIT : begin
        
        if(!SS && count < 8) begin
          
          
             shift_register = {mosi, shift_register[7:1]};
            miso = shift_register[7];

          //$display("mosi: %b", mosi);
   
          //$display("shift reg: %b", shift_register);

           count = count + 1;
          //$display("count:%d", count);
          

        end 
        else if(count >= 8) begin
          nextState = LOAD;
          
            #50 out = shift_register;
          //shift_register = 8'b0;
           //#50 $display("OUTPUT AT SLAVE: %b", out);

          count = 0;
          


        end
        else begin
          nextState = LOAD;
          
        end
        
      end
      
      default : begin
        nextState = RESET;
      end
    endcase
  end
  always@(posedge clk)
    begin : stateTransition
      if(!reset) begin
        state <=RESET;
        $display("reset");
      end 
      else 
        begin
          state <= nextState;
      end
    end : stateTransition
  
endmodule  

     
        
        
        
      
      
        
        
        
        
