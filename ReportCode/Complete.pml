mtype = {red, yellow, green, flickering}; 

mtype s_lights[2] = {red, red}; 
mtype tl_lights[2] = {red, green}; 
byte timers[2] = {23, 8};  
mtype p_lights[2] = {green, green}
byte prev_timers[2] = {0, 0};
chan pedestrian_request[2] = [0] of {bool};
chan pedestrian_lights[2] = [0] of {mtype};
chan end = [0] of {bool};

proctype Controller() {
    do
    :: pedestrian_request[0]?true ->
        if
            :: s_lights[0] == green && timers[0] > 5 ->
                printf("Received pedestrian signal in horizontal lights  \n");
                prev_timers[0] = timers[0] - 3;
                s_lights[0] = red; 
                p_lights[0] = green; 
                pedestrian_lights[0]!green;
            :: else -> skip; 
        fi;
    :: pedestrian_request[1]?true ->
        if
            :: s_lights[1] == green && timers[1] > 5 ->
                printf("Received pedestrian signal in vertical lights \n");
                prev_timers[1] = timers[1] - 3;
                s_lights[1] = red; 
                p_lights[1] = green; 
                pedestrian_lights[1]!green;
            :: else -> skip; 
        fi;
    :: pedestrian_request[0]?false ->
        printf("Pedestrian crossed the horizontal lights \n");
        s_lights[0] = green; 
        p_lights[0] = red; 
        pedestrian_lights[0]!red;
        timers[0] = prev_timers[0] - 3; 
    :: pedestrian_request[1]?false ->
        printf("Pedestrian crossed the vertical lights \n");
        s_lights[0] = green; 
        p_lights[0] = red; 
        pedestrian_lights[0]!red;
        timers[0] = prev_timers[0] - 3; 
    ::
        timers[0]--;
        timers[1]--;
        if
            :: timers[0] == 0 -> 
            if
                :: s_lights[0] == red && p_lights[0] == green -> 
                    s_lights[0] = green; 
                    timers[0] = 23; 
                    p_lights[0] = red;
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
                    pedestrian_lights[0]!green;
            fi;
            :: s_lights[0] == red && timers[0] == 3 && tl_lights[0]==red->
                p_lights[0] = flickering; 
            :: else -> skip;
        fi;

        if
            :: timers[1] == 0 -> 
            if
                :: s_lights[1] == red && p_lights[1] == green -> 
                    s_lights[1] = green; 
                    timers[1] = prev_timers[1] - 3; 
                    p_lights[1] = red;
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
                    pedestrian_lights[1]!green;
            fi;
            :: s_lights[1] == red && timers[1] == 3 && tl_lights[1]==red-> p_lights[1] = flickering; 
            :: else -> skip;
        fi;

        assert(!(s_lights[0] == green && s_lights[1] == green));

        printf("[Horizontal] Light 1: %e, Turn left Light 1: %e ,Pedestrian Light 1: %e, Timer: %d  \n ", s_lights[0],tl_lights[0], p_lights[0], timers[0]);
        printf("[Vertical]Light 1: %e, Turn left Light 1: %e ,Pedestrian Light 1: %e, Timer: %d  \n \n", s_lights[1],tl_lights[1], p_lights[1], timers[1]);
    :: end?true -> break;
    od
}

proctype Pedestrian() {
    do
    :: 
        int randomPed;
        int counter = 0;
        select(counter: 5..10); //select number of pedestrian
        printf("Number of pedestrian: %d\n", counter);
        int i;
        int k;
        for (i: 0..counter) {
            int randomTimer = 0;
            int j;
            select(randomTimer: 6..10); 
            randomTimer--;
            if 
            :: randomTimer > 0 ->
                printf("No pedestrian is crossing\n");
            :: else -> skip
            fi;
            select (randomPed: 1..2);
            do
            ::  atomic{
                if
                ::  randomPed == 1 ->
                    pedestrian_request[0]!true; 
                    int horizontalCrossTime = 3;
                    printf("Horizontal pedestrian want to cross\n");
                    :: pedestrian_lights[0]?green ->
                        printf("Horizontal pedestrian is crossing\n");
                        horizontalCrossTime--;
                        if 
                        :: horizontalCrossTime == 0 -> 
                            pedestrian_request[0]!false; 
                        :: else -> skip
                        fi;
                    break;
                ::  randomPed == 2 ->
                    pedestrian_request[1]!true; 
                    int verticalCrossTime = 3;
                    printf("Vertical pedestrian want to cross\n");
                    :: pedestrian_lights[1]?green ->
                        printf("Vertical pedestrian is crossing\n");
                        verticalCrossTime--;
                        if 
                        :: verticalCrossTime == 0 -> 
                            pedestrian_request[1]!false; 
                        :: else -> skip
                        fi;
                    break;
                fi;
                }
            od
        }
        break;
    od;
    end!true;
}



init{
    run Controller();
    run Pedestrian();
}