mtype = {red, yellow, green, flickering}; 

mtype lights[3] = {green, green, green}; 
mtype p_lights[3] = {red, green, flickering}
byte timers[3] = {12, 12, 12};      

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
                   timers[1] = 15; 
                   p_lights[1] = red;
               :: lights[1] == green -> 
                   lights[1] = yellow;
                   timers[1] = 5;  
                   p_lights[1] = red; 
               :: lights[1] == yellow -> 
                   lights[1] = red;
                   timers[1] = 20;
                   p_lights[1] = green; 
               fi;
           :: lights[1] == red && timers[1] == 3-> p_lights[1] = flickering; 
           :: else ->skip

           fi;

           timers[2]--;
           if
           :: timers[2] == 0 -> 
               if
               :: lights[2] == red -> 
                   lights[2] = green;
                   timers[2] = 15; 
                   p_lights[2] = red;
               :: lights[2] == green -> 
                   lights[2] = yellow;
                   timers[2] = 3;  
                   p_lights[2] = red; 
               :: lights[2] == yellow -> 
                   lights[2] = red;
                   timers[2] = 18;
                   p_lights[2] = green; 
               fi;
           :: lights[2] == red && timers[2] == 3-> p_lights[2] = flickering; 
           :: else ->skip

           fi;

            printf("Light 1: %e, Timer: %d, Pedestrian Light 1: %e \n", lights[0], timers[0], p_lights[0]);
            printf("Light 2: %e, Timer: %d, Pedestrian Light 2: %e \n",lights[1], timers[1], p_lights[1]);
            printf("Light 3: %e, Timer: %d, Pedestrian Light 3: %e \n",lights[2], timers[2], p_lights[2]);
       }
    od
}

init {
    run Controller(); 
}
