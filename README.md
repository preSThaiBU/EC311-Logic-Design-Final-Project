# EC311-Logic-Design-Final-Project

Project Name: Whack-a-mole game with VGA display, Mouse Input, Time limit and three difficulty levels. 

This repository dedicated to Final Project for EC311 Introduction to Logic Design Fall 2023 Boston University taught by professor Douglas Densmore.

This project is inspired by this user's project. We will improve by using graphic and modify some game logic such as adding time limit option, slowing down the clock, etc. behind the original code from nyLiao

Group Members:

1.Pree Simphliphan Computer Engineering class of 2026

2.Rawisara Chairat Computer Engineering class of 2026

3.Arnav Pratap Chaudhry Computer Science class of 2026

4.Vansh Bhatia Electrical Engineering class of 2025

Demo Video : Yout Tube link - https://youtu.be/xJwtOaYMmew?si=ZioFx-ER5Zgv4R0E

How to run our code:
1. Import all the verilog code modules into Vivado 2019.1
2. Download constraint file for final version of top modules (Contrantfileforfinalversion.xdc) and import into your vivado project.
3. Having FPGA board (NEXYS-A7) ready to connected with monitor and mouse
4. Set Top_module file as the top one; then synthesize, implement, and generate bitstream for fpga board.
5. Push the bitstream to the board and have Fun!

How to play the game!
1. Click on the level you want to play
2. Make sure that both debouncer switches (Switch 12 and 13) are turned on and if there are any problems with the mouse cursor just press the reset button once to solve that.
3. Click on play button and it will bring you to the play page
4. You will have 30 seconds to hit the moles that pop up in one of each 8 moles.
5. Keep in mind that they're randomly generated and they can be generated at the same holes.
6. You will get 3 points each time you hit the mole but you will not be penalized for each mistake.

Overview of the code structure:
The folder Whac-A-Mole-FPGA is created by nyLiao (https://github.com/nyLiao/Whac-A-Mole-FPGA). There are some modification on the original code for this project as following:
1. We cut wam_lst file because we want to test on fpga board if the modification of main logic works or not; therefore we don't need dim light functionility of 7-segment display.
2. We don't use wam.ucf (the constraint file for their version and fpga board)
3. We don't use wam_main but we use it as a prototype for our own module.
4. We don't use wam_m.bit (their bitstream file from wam_main)
5. We use the same algorithm and logic from wam_scr.v (containing wam_scr and wam_cnt modules for detecting the player's score). We modify output from BCD to binary and we change 1 point per hit to 3 points per hit.
6. We keep wam_hrd.v (containing wam_tch, wam_hrd and wam_par for sending the value of parameter for each difficulty)
7. We use the same wam_hit.v (containing wam_tap.v and wam_hit.v to check if the player hits the mole or not)
8. We use the same generator (wam_gen.v) but we will change the clock frequency input to slow down the mole speed in our top module.
9. Lastly, we keep the wam_dis.v file for fpga testing with led and 7-segment display purpose; however, we need to display 8 digits to display both time display and score with difficulty; which means we need to add the case condition in wam_dis.v.

Game_logic.v: this module is modeled from wam_main.v. The main purpose is for connecting generator module(wam_gen.v), hit checker module (wam_hit), and score module (wam_scr).
This module will receive input pause signal from time_counter module to check if the generator is stopped or not, start signal from time_counter to check if the game is restarted, the difficulty variable, and tap variable to check which holes are clicked. Then, it will output the holes variables for vga to display which holes are mole generated at a certain time and output score for vga to display.

fpga_test.v: this module contained difficulty module(since we control this by button when we test the game logic with time_counter on fpga board), tap module(we input this from switch on fpga), led and display modules (to output led and 7-segment on fpga board).

Time_counter.v: this module is created for 30-sec timer. It will receive start signal to indicate the start. It will have count to slow down the clock frequency to exact 1 second in real life, but we also need pause signal to connect with the old code from myliao to indicate the generator to stop. However, our modules will be only able to play on 1st, 3rd, 5th time we click start because of latches happened on the posedge of pause signal in the original module; hence, to fix this, we add activate signal to get rid of this latch.
It will output the time_display as an output along with pause signal for the generator module.

music.v: we played music background via buzzer by adding pac-man note we found on musescore. We adjust the clock and write FSM to generate each note in each state with the counter in each state to determine the different range of each note. Lastly, we add the condition to play sound at each state of FSM.

VGA2.v : This is the top module for the first screen of the game. The overall functionality of this module is to assign RGB colours to the title of the game i.e "WHAC-A-MOLE", "PLAY" and "LEVEL : 1 2 3", which all together makes up the first state of our state machine as well. 

vga.v : This module is to display moles randomly generated in the eight holes on the game screen as well as the time remaining and the score.  This module works by assigning the horizontal and vertical positions to display colors via the RGB output ports. It will also be include in the FSM as the second state.

vga_last.v : This module is for the last screen of the game that will be finalizing the player score after the turn is finished and displaying on the screen. There will be a restart button in this screen that will bring the player back to the first screen in order to play again. This screen will be the third state of our FSM.

lettermap2.v : This is a hardcode module for all the segments that make up a letter displayed on our VGA. Each segment is passed through an if condition which has parammeters of the extreme x and y co-ordinates of pixel positions. Moreover, each segment 
of a letter is summed up together (using OR gates) to actually make a letter. In the same way different letters of a word are summed up to make one word. By making different cases for each letter, we passed those cases to out VGA2.v module and later assigned colour those pixels. 

Clock_divider.v : This module is useful to divide or reduce the frequency of the clock by half.

mouse.v - This is the top level mouse module that helps integrate the vga screen with the mouse functionality. This takes in the ps2 data and clock signals and outputs 33 bit data that has been segregated and formatted. Thus, the outputs of this include the button clicks and relative x and y velocity. This module also calls other modules like ps2_rxtx.v which is the module primarily used for data extraction and also files like debounce_explicit.v which are used to implement debouncer switches to makes sure that noise is filtered and only important inputs are registered. 

ps2_rxtx.v - The ps2_rxtx module subsequenlty has two more submodules which are ps2_rx.v and ps2_tx.v.

ps2_rx, ps2_tx, debounce_explicit - Modules mentioned above used in mouse.v and ps2_rxtx.v.

For FPGA Test modules
1. We display time on 7-segment display; we have to change number of bits of an.
2. We use pause signal along with timer countdown; we don't need pause button anymore
3. We connect music background to output music, we connect game_logic with fpga_test to hook the input switch and button to check if the game logic works with the time_counter on FPGA or not.

For Top Module
We connect time_counter, all the vga_display, mouse, music, and game_logic to display our final product.

Testbench files
For the simulation test, to correct the mistakes of logic.

How to improve:
We encountered the issue with buzzer; therefore, we can't check if the music module can be played. This is the topic that can be improved in the future once we have a resource for the actual speaker.

