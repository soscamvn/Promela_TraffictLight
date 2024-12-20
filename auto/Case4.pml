mtype = {red, yellow, green, flickering}; 

mtype s_lights[2] = {red, red}; 
mtype tl_lights[2] = {red, green}; 

mtype p_lights[2] = {green, green}
byte timers[2] = {23, 8};      

active proctype Controller() {
    do
    :: atomic {
           timers[0]--;
           if
           :: timers[0] == 0 -> 
               if
               :: s_lights[0] == red && tl_lights[0] == red->
                   s_lights[0] = red;
                   tl_lights[0] = green;
                   timers[0] = 8; 
                   p_lights[0] = red;
               :: tl_lights[0] == green && s_lights[0] == red-> 
                   tl_lights[0] = red;
                   s_lights[0] = green;
                   timers[0] = 12 ;  
                   p_lights[0] = red;
               :: s_lights[0] == green -> 
                   s_lights[0] = yellow;
                   tl_lights[0] = red;
                   timers[0] = 3; 
                   p_lights[0] = red;
               :: s_lights[0] == yellow && tl_lights[0] == red->
                   s_lights[0]= red;
                   tl_lights[0] = red;
                   timers[0] = 23 ; 
                   p_lights[0] = green;
               fi;
           :: s_lights[0] == red && timers[0] == 3 && tl_lights[0]==red-> p_lights[0] = flickering; 
           :: else -> skip;
           fi;

           timers[1]--;
           if
           :: timers[1] == 0 -> 
               if
               :: s_lights[1] == red && tl_lights[1] == red->
                   s_lights[1] = red;
                   tl_lights[1] = green;
                   timers[1] = 8; 
                   p_lights[1] = red;
               :: tl_lights[1] == green && s_lights[1] == red-> 
                   tl_lights[1] = red;
                   s_lights[1] = green;
                   timers[1] = 12 ;  
                   p_lights[1] = red;
               :: s_lights[1] == green -> 
                   s_lights[1] = yellow;
                   tl_lights[1] = red;
                   timers[1] = 3; 
                   p_lights[1] = red;
               :: s_lights[1] == yellow && tl_lights[1] == red->
                   s_lights[1]= red;
                   tl_lights[1] = red;
                   timers[1] = 23 ; 
                   p_lights[1] = green;
               fi;
           :: s_lights[1] == red && timers[1] == 3 && tl_lights[1]==red-> p_lights[1] = flickering; 
           :: else -> skip;
           fi;
            printf("Light 1: %e, Turn left Light 1: %e ,Pedestrian Light 1: %e, Timer: %d  \n", s_lights[0],tl_lights[0], p_lights[0], timers[0]);
            printf("Light 2: %e, Turn left Light 2: %e ,Pedestrian Light 2: %e, Timer: %d  \n", s_lights[1],tl_lights[1], p_lights[1], timers[1]);
       }
    od
}

// init {
//     run Controller(); 
// }
