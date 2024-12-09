mtype = {red, yellow, green, flickering}; 

mtype lights[3] = {red, green}; 
mtype p_lights[3] = {red, green, flickering}
byte timers[2] = {15, 12}; 

active proctype Controller() {
    do
    :: atomic{
        lights[0] = red;
        lights[1] = green;
        lights[2] = red;
        printf("Light 1: %e \n", lights[0]);
        printf("Light 2: %e \n", lights[1]);
        printf("Light 3: %e \n", lights[2]);
    }
    :: atomic {
        lights[0] = green;
        lights[1] = red;
        lights[2] = green;
        printf("Light 1: %e \n", lights[0]);
        printf("Light 2: %e \n", lights[1]);
        printf("Light 3: %e \n", lights[2]);
    }
    od;
}
