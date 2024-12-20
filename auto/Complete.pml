mtype = {red, yellow, green, flickering}; 

mtype s_lights[2] = {red, green}; 
mtype tl_lights[2] = {red, red}; 
byte timers[2] = {23, 8};  
mtype p_lights[2] = {red, red}
byte prev_timers[2]={0,0};
chan pedestrian_request[2] = [0] of {bool};
byte is_ped_signal[2] = {0,0};

proctype Controller() {
    do
    :: atomic {
            // Pedestrian request checking
            if
                :: pedestrian_request[0]?true ->
                    if
                        :: s_lights[0] == green && timers[0] > 5 ->
                            printf("Received pedestrian signal in horizontal lights  \n");
                            prev_timers[0] = timers[0]-3;
                            is_ped_signal[0]=1;
                            s_lights[0] = red; 
                            p_lights[0] = green; 
                            timers[0] = 3; 
                        :: else -> skip; 
                    fi;
                :: pedestrian_request[1]?true ->
                    if
                        :: s_lights[1] == green && timers[1] > 5 ->
                            printf("Received pedestrian signal in vertical lights \n");
                            prev_timers[1] = timers[1]-3;
                            is_ped_signal[1]=1;
                            s_lights[1] = red; 
                            p_lights[1] = green; 
                            timers[1] = 3; 
                        :: else -> skip; 
                    fi;
            fi;

            // Horizontal lights
            timers[0]--;
            if
                :: timers[0] == 0 -> 
                if
                    :: s_lights[0] == red && p_lights[0] == green -> 
                        s_lights[0] = green; 
                        timers[0] = prev_timers[0]; 
                        is_ped_signal[0]=0;
                        p_lights[0] = red;
                    :: s_lights[0] == red && tl_lights[0] == red && is_ped_signal[0]==0->
                        s_lights[0] = red;
                        tl_lights[0] = green;
                        p_lights[0] = red;
                        timers[0] = 8; 
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
                    :: s_lights[0] == yellow && tl_lights[0] == red ->
                        s_lights[0]= red;
                        tl_lights[0] = red;
                        timers[0] = 23 ; 
                        p_lights[0] = red;
                        
                fi;
                :: s_lights[0] == red && tl_lights[0] == red && timers[0] == 15-> p_lights[0] = green;
                :: s_lights[0] == red && timers[0] == 3 && tl_lights[0]==red-> p_lights[0] = flickering; 
                :: else -> skip;
            fi;

            // Vertical lights
            timers[1]--;
            if
                :: timers[1] == 0 -> 
                if
                    :: s_lights[1] == red && p_lights[1] == green -> 
                        s_lights[1] = green; 
                        timers[1] = prev_timers[1]; 
                        is_ped_signal[1]=0;
                        p_lights[1] = red;
                    :: s_lights[1] == red && tl_lights[1] == red && is_ped_signal[1]==0->
                        s_lights[1] = red;
                        tl_lights[1] = green;
                        p_lights[1] = red;
                        timers[1] = 8; 
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
                        p_lights[1] = red;
                fi;
                :: s_lights[1] == red && timers[1] == 15 && tl_lights[1]==red-> p_lights[1] = green;
                :: s_lights[1] == red && timers[1] == 3 && tl_lights[1]==red-> p_lights[1] = flickering; 
                :: else -> skip;
            fi;
            
            // Resetting the lights to safe state
            if
            :: (s_lights[0] == green && s_lights[1] == green) || 
               (s_lights[0] == green && tl_lights[0] == green) || 
               (s_lights[1] == green && tl_lights[1] == green) || 
               (tl_lights[0] == green && p_lights[0] == green) || 
               (tl_lights[1] == green && p_lights[1] == green) -> 
                    printf("RESET: Detected invalid state (both lights green). Resetting to safe state.\n \n"); 
                    s_lights[0] = red;
                    s_lights[1] = red;
                    tl_lights[0] = red;
                    tl_lights[1] = green;
                    p_lights[0] = green;
                    p_lights[1] = red;
                    timers[0] = 23;
                    timers[1] = 8;
                    prev_timers[0] = 0;
                    prev_timers[1] = 0;
                    is_ped_signal[0] = 0;
                    is_ped_signal[1] = 0;
            :: else -> skip;
            fi;

            printf("[Horizontal] Light 1: %e, Turn left Light 1: %e ,Pedestrian Light 1: %e, Timer: %d  \n ", s_lights[0],tl_lights[0], p_lights[0], timers[0]);
            printf("[Vertical]Light 1: %e, Turn left Light 1: %e ,Pedestrian Light 1: %e, Timer: %d  \n \n", s_lights[1],tl_lights[1], p_lights[1], timers[1]);

        }
    od
}

proctype PedestrianRequester() {
    do
    :: atomic {
           if
           :: pedestrian_request[0]!true; 
           :: pedestrian_request[1]!true; 
           :: skip; 
           fi;
       }
    od
}



init{
    run Controller();
    run PedestrianRequester();
}