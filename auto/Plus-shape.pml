mtype = {red, yellow, green, flickering}; 

mtype lights[2] = {red, green}; 
mtype p_lights[3] = {red, green, flickering}
byte timers[2] = {15, 12};      

active proctype Controller() {
    do
    :: atomic {
           timers[0]--;
           if
           :: timers[0] == 0 -> 
               if
               :: lights[0] == red -> 
                   lights[0] = green;
                   timers[0] = 12; 
                   p_lights[0] = red;
               :: lights[0] == green -> 
                   lights[0] = yellow;
                   timers[0] = 3;  
                   p_lights[0] = red;
               :: lights[0] == yellow -> 
                   lights[0] = red;
                   timers[0] = 15; 
                   p_lights[0] = green;
               fi;
           :: lights[0] == red && timers[0] == 3-> p_lights[0] = flickering; 
           :: else -> skip
           fi;

           timers[1]--;
           if
           :: timers[1] == 0 -> 
               if
               :: lights[1] == red -> 
                   lights[1] = green;
                   timers[1] = 12; 
                   p_lights[1] = red;
               :: lights[1] == green -> 
                   lights[1] = yellow;
                   timers[1] = 3;  
                   p_lights[1] = red;
               :: lights[1] == yellow -> 
                   lights[1] = red;
                   timers[1] = 15; 
                   p_lights[1] = green;
               fi;
           :: lights[1] == red && timers[1] == 3-> p_lights[1] = flickering; 
           :: else -> skip
           fi;

            printf("Light 1: %e, Timer: %d, Pedestrian Light 1: %e \n", lights[0], timers[0], p_lights[0]);
            printf("Light 2: %e, Timer: %d, Pedestrian Light 2: %e \n",lights[1], timers[1], p_lights[1]);

       }
    od
}

init {
    run Controller(); 
}
