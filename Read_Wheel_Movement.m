function [Final_Position,Overall_Movement]=Read_Wheel_Movement(TTL1,TTL2)
%This function is using the ttls recorded from a rotary encoder and
%translating them to the actual degrees of movement. This particular script
%is done for the specific rotary encoder used in Jian's recording with the
%Phenosys virtual environment.
%%%%%%%%%%%%% Inputs
% TTL1 = From the pin A of the rotor encoder // digital_input_3 from the
%        digitalin.dat

% TTL2 = From the pin B of the rotor encoder // digital_input_3 from the
%        digitalin.dat

%%%%%%%%%%%%% Outputs
% Final_Position = The final angle (positive is Clock wise) on which the
%                  wheel stopped, relative to the initial accounted as 0

% Overall_Movement = All the registered positions after a movement. It is
%                    NOT the movement sample by sample, but just when the 
%                    animal moves

%% Variable initialisation
enconderCPR = 1024; % Encoder resolution
Position = 0; % Relative start position

%% Position decoding
%%%%%%%%%%% Detecting positive changes
A=diff(TTL1);
IndexA=find(A==1)+1;
%%%%%%%%%%%
count = 1;
for i = IndexA'
    if TTL2(i) == 0  % Checking the value of the pin B when there is movement in A
        Position = Position + 360/enconderCPR;
        
    else
        Position = Position - 360/enconderCPR;
        
    end
    Overall_Movement(count)=Position;
    count = count + 1;
end
Final_Position=Position;



end