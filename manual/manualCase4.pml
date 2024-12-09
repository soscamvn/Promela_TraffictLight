mtype = {red, yellow, green, flickering}; 

mtype lights[2] = {red, green}; 
mtype p_lights[3] = {red, green, flickering}
mtype turn_lights[4] = {red, red, red, red};
byte timers[2] = {15, 12}; 

active proctype Controller() {
    do
    :: atomic{
        lights[0] = red;
        lights[1] = green;
        turn_lights[0] = red;
        turn_lights[1] = red;
        turn_lights[2] = red;
        turn_lights[3] = red;
        p_lights[0] = green;
        p_lights[0] = red;
        printf("Light 1: %e, Pedestrian Light 1: %e \n", lights[0], p_lights[0]);
        printf("Light 2: %e, Pedestrian Light 2: %e \n", lights[1], p_lights[1]);
    }
    :: atomic {
        lights[0] = green;
        lights[1] = red;
        turn_lights[0] = red;
        turn_lights[1] = red;
        turn_lights[2] = red;
        turn_lights[3] = red;
        p_lights[1] = red;
        printf("Light 1: %e, Pedestrian Light 1: %e \n", lights[0], p_lights[0]);
        printf("Light 2: %e, Pedestrian Light 2: %e \n", lights[1], p_lights[1]);
    }
    :: atomic {
        lights[0] = red;
        lights[1] = red;
        turn_lights[0] = green;
        turn_lights[1] = red;
        turn_lights[2] = red;
        turn_lights[3] = red;
        p_lights[2] = red;
    }
    od;
}
