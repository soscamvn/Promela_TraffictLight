mtype = {red, yellow, green, flickering}; 

mtype lights[3] = {red, green, green}; 
mtype p_lights[3] = {green, red, red};
byte timers[2] = {15, 12}; 

active proctype Controller() {
    do
    :: atomic{
        lights[0] = red;
        lights[1] = green;
        lights[2] = green;
        p_lights[0] = green;
        p_lights[1] = red;
        p_lights[2] = red;
        printf("Light 1: %e, Pedestrian Light 1: %e \n", lights[0], p_lights[0]);
        printf("Light 2: %e, Pedestrian Light 2: %e \n", lights[1], p_lights[1]);
        printf("Light 3: %e, Pedestrian Light 3: %e \n", lights[2], p_lights[2]);
    }
    :: atomic {
        lights[0] = green;
        lights[1] = red;
        lights[2] = red;
        p_lights[0] = red;
        p_lights[1] = green;
        p_lights[2] = green;
        printf("Light 1: %e, Pedestrian Light 1: %e \n", lights[0], p_lights[0]);
        printf("Light 2: %e, Pedestrian Light 2: %e \n", lights[1], p_lights[1]);
        printf("Light 3: %e, Pedestrian Light 3: %e \n", lights[2], p_lights[2]);
    }
    od;
}
