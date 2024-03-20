# System-Verilog-verification-Environment-for-ALU-Project

**Introduction**



In this project, I implemented ALU (arithmetic logic unit) using SV and tested that it works well using SV verification Environment. SV environment consists of: (Test Class, Environment class, Scoreboard class, Monitor, Driver Class, Transaction class and generator class). I also used interface block between DUT and my test class module in testbench top module as shown in figure[1]


![image](https://github.com/ayaahmed20018414/System-Verilog-verification-Environment-for-ALU-Project/assets/82789012/5b6d5a45-9c89-49f0-9e60-eb88cecd41c8)
                                                              
                                                Figure 1 SV environment architecture.
                                                

**ALU design procedure** 

In ALU specification document it is required to implement an ALU that make arithmetic and logic operations under certain conditions:
•	Using ALU_en to enable ALU to do operations and if ALU_en=0 the ALU output in this case will be Zero.
•	When both a_en and b_en are equal to zero, the ALU will be also disabled in this case and output will be Zero.
•	When a_en=1 and b_en=0, ALU will require to do 7 operations according to a_op value and it isn’t allowed to take value of seven and if it took this value the design will give me and message that it isn’t allowed to drive design with this value and to enter values from 0 to 6.
•	When a_en=0 and b_en=1, ALU will require to do 3 operations according to b_op value and it isn’t allowed to take value of three and if it took this value the design will give me and message that it isn’t allowed to drive design with this value and to enter values from 0 to 2.
•	When a_en=1 and b_en=1, ALU will require to do 4 operations according to b_op value.



**Verification Environment using system Verilog**

1.	Transaction class
    
In transaction class, input and output data is declared inside it(except clk as it is input for interface from testbench top) as data will be transferred from each class in the Environment in form of transaction(from generator to driver through gen2drv mailbox, from monitor to Scoreboard through mon2Scb mailbox and from monitor to coverpoints class through mon2cov mailbox).
I transaction class, A, B, a_op, b_op, a_en, b_en are randomized to take different values under certain constraints to apply them to our design to test the functionality.
In transaction class, a_op is randomized to take all possible values except the value of 7 as it isn’t allowed to apply this value to the design and if it is applied to it the design will give an error message as we said before to tell the verifier not to put value of 7.
Also in transaction class, b_op is randomized to take all possible values except the value of 3 as it isn’t allowed to apply this value to the design and if it is applied to it the design will give an error message as we said before to tell the verifier not to put value of 3.
ALU_en is randomized with distribution to take most of time value of 1 so that I can test all the functionality of the ALU.
a_en, and b_en is randomized to take half of the time 0 and the other half to have 1 so that I can have all the combinations between them to test all possible ALU functionality.
Function print_info is used to display transaction information so that I can see the transactions information from generator to driver or from generator to driver and so on.


2. 	Generator class
   
The generator class is used to generate stimulus that will be applied to design interface. In class generator it randomizes rand data in transaction class for a specific number of times (repeat_count) and then put generated transactions to mailbox gen2drv so that driver (bin level transaction) can take these generated transactions and apply it to the design interface.
An event called ended is used to trigger that the generator finished generated all transactions and put them in the gen2drv mailbox.


3. Driver class
    
Driver class used to drive the generated stimulus from generator (transactions) to the design interface acting as a bin level transaction.
In driver class it has 2 tasks (not functions as it consumes time):
•	reset task: in reset task firstly, it waits for reset to happen then it will display when this happens by a message reset asserted (it is preferred to start the simulation with asserting reset to the design interface) after that drive the design with zeros as in this case the design output will be zero and won’t take into consideration the input value.
•	main task: in this task, transactions from generator will be given to the design interface as a bin level transaction and then assign the output from the design interface after one clock cycle so that the transaction in this case encapsulates the design input and output in the same transaction.

4.	monitor class
    
monitor class is used to monitor input and output of design interface.it encapsulates the input and output from the design interface into a transaction and then give them to 2 mailboxes:
•	mon2Scb mailbox: this mailbox will then transfer data to the Scoreboard to compare input and output data from the design.
•	Mon2cov mailbox: this mailbox is used to transfer transactions from monitor to coverpoints class to make functional coverage to the design.


5.	Scoreboard class
   
Scoreboard class used to check if the output from design is as expected or not. In Scoreboard class I tried to test all possible functionalities in ALU to be sure that the design hasn’t any problems.
In scoreboard class, I implemented temp1,temp2 and temp3 variables to save expected output from the design value then check if the design output value is equal to this values or not and if there is an error the Scoreboard will display an error message that the expected output value is temp1 or temp2 or temp3 according to a_en, b_en, a_op and b_op values and the output from design will be in this case false.


6.	Coverpoints class (functional coverage)

In coverpoints class, I check that if values of A, B, a_en, b_en, a_op and b_op are covered 100% (as a functional coverage). Also, I used cross coverage between A, B and between a_en and b_en to guarantee that all values of both inputs are coming together.

![image](https://github.com/ayaahmed20018414/System-Verilog-verification-Environment-for-ALU-Project/assets/82789012/c6555ccb-4075-43b3-8adc-07fea3616499)

                                      final functional coverage from class coverpoints with 98.44% coverage


![image](https://github.com/ayaahmed20018414/System-Verilog-verification-Environment-for-ALU-Project/assets/82789012/b8161d4e-8bf7-42d7-87be-dd69b8a1b95f)

                                          value 7 of a_op isn't covered (not illegible value to be given to design). 

As shown in figure, that value of 7 isn’t covered because of in specs document it isn’t illegible to apply a_op to be 7 to the design so it will be uncovered. Because of design specs, 7 value for a_op won’t be covered in all cases so I will exclude this value and save it to exclusions_file.le.


![image](https://github.com/ayaahmed20018414/System-Verilog-verification-Environment-for-ALU-Project/assets/82789012/fa2a4363-d146-4a89-a2ad-adb77a507569)


                                                      coverage after exclude value of 7 from coverage and it will be 100%.


7.	Environment class
    
In Environment class, I will create one object from all previous classes and create three mailboxes to synchronize communication between them. In Environment class there are 3 tasks pre_test(), test(), post_test(). In pre_test() task I will run function reset exists in driver to be sure that before I start my test that the design’s reset has been asserted before. Then task test () will be started to run which will run 5 parallel tasks together for each class in the Environment (generator main task, driver main task, monitor main task, scoreboard main task and sample_task for coverpoints class). Finally, I will run function post_test() to trigger that the generator have finished its function through ended Event then check that the no_transactions in driver is equal to repeat_count in generator and also will check that no_transactions in scoreboard is equal to repeat_count in generator to check that the test is ended.


8.	Test module
   
In test module, Environment class is created and given to it repeat_count to specify number of generated stimuluses that I want to give to the design.


9.	Test bench top module
    
In test bench top module, test module and design will be connected through the interface and generated clock with 10ns period (100MHz frequency) will be given to the interface and reset signal also will be generated and given to the interface.




**Code coverage** 
1.	line coverage  

![image](https://github.com/ayaahmed20018414/System-Verilog-verification-Environment-for-ALU-Project/assets/82789012/478bd7f1-5281-4d2e-a26b-c7ff1eb21cb4)

                                                      line coverage value = 87.74%

                                                      
As shown in figure, line coverage will be 87.74% as we won’t give the design value of 7 for a_op as it isn’t illegible, so it won’t cover the line of display error message when a_op.  


As this is design specification, we can say after excluding this case that line coverage is 96.15%.


![image](https://github.com/ayaahmed20018414/System-Verilog-verification-Environment-for-ALU-Project/assets/82789012/039df2b9-daeb-412d-b9a3-5749525d5a44)

                                                  line coverage after exclude line 32.


In case that a_en=0 and b_en=1, it isn’t illegible to give the design value of b_op=3 so it won’t take this value and this statement won’t be covered and we can exclude it from our line coverage.

![image](https://github.com/ayaahmed20018414/System-Verilog-verification-Environment-for-ALU-Project/assets/82789012/69076f67-0788-4222-bbcc-2112e4275f3c)

                                                line coverage after exclude line 48 is 100%.


2.	Toggle coverage


![image](https://github.com/ayaahmed20018414/System-Verilog-verification-Environment-for-ALU-Project/assets/82789012/d3bb654d-42bc-4644-a734-665105418af4)

                                  `  toggle coverage in the design is 100%.


3.	Condition coverage

![image](https://github.com/ayaahmed20018414/System-Verilog-verification-Environment-for-ALU-Project/assets/82789012/c816ea95-5df6-4282-93a5-443c00d96e73)


conditional coverage percentage for each condition.

As shown in figure, last condition won’t take values 0 and 1 or 1 and 0 respectively for a_en and b_en value as it is the last condition in the if statement chain which make sense, so we can exclude it from our condition coverage report.



![image](https://github.com/ayaahmed20018414/System-Verilog-verification-Environment-for-ALU-Project/assets/82789012/ec7d1a7f-3d26-476e-80f8-35eddc5d8d8c)

                                                condition coverage after excluding unexpected condition. 


4. branch coverage 
As mentioned before in line coverage we won’t give the design value of 7 for a_op as it isn’t illegible, so it won’t cover the line of display error message when a_op, so we won’t enter branch case that a_op=7 in case statement as well as value of b_op=3 in branch case when a_en=0 and b_en=1.



![image](https://github.com/ayaahmed20018414/System-Verilog-verification-Environment-for-ALU-Project/assets/82789012/0df490a5-e1ed-4fec-a73a-f29d974cd1f0)

                                                    branch coverage before excluding unachievable conditions.



![image](https://github.com/ayaahmed20018414/System-Verilog-verification-Environment-for-ALU-Project/assets/82789012/3b9a4356-215e-4ac8-992c-b13f20b9a62f)

                                                      final branch coverage after excluding all unachievable conditions.

![image](https://github.com/ayaahmed20018414/System-Verilog-verification-Environment-for-ALU-Project/assets/82789012/5f751162-2bdc-490b-8fbc-8947f48d3cbf)
                                                      
                                                      final code coverage percentages.



![image](https://github.com/ayaahmed20018414/System-Verilog-verification-Environment-for-ALU-Project/assets/82789012/8a32035a-e84c-4a0b-aacb-700d22cb66de)

                                                          exclusion file contents.

**Conclusion **

In conclusion, the SystemVerilog environment developed for the ALU design project has proven to be robust, efficient, and highly functional. Through the implementation of SystemVerilog constructs, such as classes and covergroups, we have created a comprehensive verification framework that ensures the correctness and reliability of the ALU under various conditions. The testbench, constructed using SystemVerilog features, including constrained randomization and functional coverage, has facilitated the exploration of the ALU's operational space, exposing potential corner cases and uncovering subtle bugs. The use of covergroups has allowed us to quantify the quality of our testbench, providing valuable insights into the completeness of our verification efforts. The SystemVerilog environment presented in this report has proven to be an invaluable tool for verifying the ALU design. Its effectiveness in uncovering subtle issues and providing quantitative metrics for coverage underscores the importance of adopting advanced verification methodologies in complex digital designs.
                                                      
                                                    

                                                


