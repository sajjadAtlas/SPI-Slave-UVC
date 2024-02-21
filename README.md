This was my first attempt at designing in SystemVerilog and then verifying part of that design (in this case, the slave component). 

The main challenge was related to synchronizing the writing and reading of data; initially I didn't realize that the design wouldn't read the data the moment it gets sent. 
The design has its own processing that consumes clock cycles and so I had to add some delays to make sure the data was being sampled correctly. I am sure there's a better way to do this,
but I was just using EDA Playground and had no waveform tool to use at the time. 

I learned through this small project how to make a simple testbench for a design. I learned how to generate input and drive stimulus to the DUT, and then monitor the actual values via TLM
to then feed it to a scoreboard and see results. I also gained much more experience in object-oriented programming principles, as UVM relies heavily on this.

I'm sure as I learn more about design verification I will uncover more possible improvements and learn to write better, more fluid code.
