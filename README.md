## LFSR-Linear-Feedback-Shift-Register
The project consists in a simple implementation and validation of an LFSR in VHDL developed for Xilint ZYNQ boards using Vivado IDE.
<p align="center">
<img width="500" height="150" src="https://upload.wikimedia.org/wikipedia/commons/9/99/Lfsr.gif">
</p>
The VHDL code implements a Fibonacci LFSR, that is deeply explained in the pdf you can find in the project folder. the behaviour of this component is show in the picture above.

## Software simulator in C
To ensure that the device is working correctly I wrote a simple C implementation of such component in order to compare outputs retrieved from same input. To do that both the SW and the HW LFSR will start with the same seed and then the output for one whole period of the hardware one will be saved in a .txt file using VHDL libraries and MODELSIM simulation and then used to compare with the results of the software one. This approach is used since there no way apart from that to be sure that a component with lots of different output will work correctly for all the input it can receive.<br/>
I performed both coverage and boundary test to guarantee the periodicity of the LFSR. In fact once a period finished the component must repropose the same output for the same input of the previous period, and this is the case.

## Author
Edoardo Cittadini - Scuola Superiore Sant'Anna and University of Pisa - Embedded Computing System Master Degree <br/> https://github.com/Edocit
