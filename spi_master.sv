
package pkg;

	
typedef enum {RESET, IDLE, LOAD, TRANSMIT} state_t;

endpackage


import pkg::*; 

  

module spi_master(input logic clk, input logic reset, output logic  SS, input logic [7:0] data_in, output logic [7:0] data_out_, output logic mosi, input logic miso);
  
  
  logic [7:0] shift_register;
  
  int counter;
  state_t state, nextState;
  
  always@(posedge clk, negedge reset)
    begin : stateTransition
      if(!reset) begin
        state <=RESET;
      end else begin
        
         #5 state <= nextState;
        //$display("CHANGED STATE: %s", state.name());
        
      end
    end : stateTransition
  
 
   
  always@(posedge clk) begin : stateOutput
    
    unique case(state)
      RESET : begin

        
        nextState = IDLE;
        SS = 1;
        data_out_ = 0;
        shift_register = 0;
        mosi <= 0;
        //$display("HERE");
        
      end
      
      IDLE : begin
        //$display("REACHED STATE = %s", state.name());

        nextState = LOAD;
        SS = 1;
        shift_register = 0;
      end
      
      LOAD : begin

        nextState = TRANSMIT;
        SS = 0; //pull slave select low
        if(counter == 0)
        	shift_register = data_in; //load input data into shift reg
        //$display("INPUT DATA (MASTER): %b", data_in);
      end
      
      TRANSMIT : begin
        nextState = LOAD;
       
        if(!SS && counter < 8) begin //transmit only when ss is low
           mosi = shift_register[0];
         // $display("VALUE OF MOSI TO SLAVE: %b", mosi);
          //$display("(PRE SHIFT)SHIFT REG(MASTER): %b, COUNTER: %0d", shift_register, counter);

          #5 shift_register = {miso, shift_register[7:1]};
          //$display("VALUE OF MISO FROM SLAVE TO MASTER: %b", miso);
          

          counter = counter + 1;
          //$display("(POST SHIFT)SHIFT REG(MASTER): %8b, COUNTER: %0d\n", shift_register, counter);
        end
        else if(counter >= 8) begin
          //$display("reached here");
          data_out_ = shift_register;
          $display("OUTPUT(MASTER): %b", data_out_);
          
          
          shift_register = 0;
          counter = 0; 
          SS = 1;
          //nextState = IDLE; 
          
        end                        
        else begin
          nextState = IDLE; 
        end
        
      end
      
      default : begin
        nextState = RESET;
      end
    endcase
  end : stateOutput
  
  
  
endmodule
