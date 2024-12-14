mtype = {red, yellow, green, flickering}; 

mtype s_lights[2] = {red, red}; 
mtype tl_lights[2] = {red, green}; 
byte timers[2] = {23, 8};  
mtype p_lights[2] = {green, green}
byte prev_timers[2] = {0, 0};
chan pedestrian_request[2] = [0] of {bool};
chan end1 = [1] of {bool};
chan end2 = [1] of {bool};

proctype Controller() {
    do
    :: pedestrian_request[0]?true ->
        if
            :: s_lights[0] == green && timers[0] > 5 ->
                printf("Received pedestrian signal in horizontal lights  \n");
                prev_timers[0] = timers[0] - 2;
                s_lights[0] = red; 
                p_lights[0] = green; 
            :: else -> skip; 
        fi;
        printf("[Horizontal] Light 1: %e, Turn left Light 1: %e ,Pedestrian Light 1: %e, Timer: %d  \n ", s_lights[0],tl_lights[0], p_lights[0], timers[0]);
        printf("[Vertical]Light 1: %e, Turn left Light 1: %e ,Pedestrian Light 1: %e, Timer: %d  \n \n", s_lights[1],tl_lights[1], p_lights[1], timers[1]);
    :: pedestrian_request[1]?true ->
        if
            :: s_lights[1] == green && timers[1] > 5 ->
                printf("Received pedestrian signal in vertical lights \n");
                prev_timers[1] = timers[1] - 2;
                s_lights[1] = red; 
                p_lights[1] = green; 
            :: else -> skip; 
        fi;
        printf("[Horizontal] Light 1: %e, Turn left Light 1: %e ,Pedestrian Light 1: %e, Timer: %d  \n ", s_lights[0],tl_lights[0], p_lights[0], timers[0]);
        printf("[Vertical]Light 1: %e, Turn left Light 1: %e ,Pedestrian Light 1: %e, Timer: %d  \n \n", s_lights[1],tl_lights[1], p_lights[1], timers[1]);
    :: pedestrian_request[0]?false ->
        printf("[Horizontal]Pedestrian crossed the horizontal lights \n");
        s_lights[0] = green; 
        p_lights[0] = red; 
        timers[0] = prev_timers[0]; 
        printf("[Horizontal] Light 1: %e, Turn left Light 1: %e ,Pedestrian Light 1: %e, Timer: %d  \n ", s_lights[0],tl_lights[0], p_lights[0], timers[0]);
        printf("[Vertical]Light 1: %e, Turn left Light 1: %e ,Pedestrian Light 1: %e, Timer: %d  \n \n", s_lights[1],tl_lights[1], p_lights[1], timers[1]);
    :: pedestrian_request[1]?false ->
        printf("[Vertical]Pedestrian crossed the vertical lights \n");
        s_lights[0] = green; 
        p_lights[0] = red; 
        timers[0] = prev_timers[0]; 
        printf("[Horizontal] Light 1: %e, Turn left Light 1: %e ,Pedestrian Light 1: %e, Timer: %d  \n ", s_lights[0],tl_lights[0], p_lights[0], timers[0]);
        printf("[Vertical]Light 1: %e, Turn left Light 1: %e ,Pedestrian Light 1: %e, Timer: %d  \n \n", s_lights[1],tl_lights[1], p_lights[1], timers[1]);
    ::
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
                    timers[1] = prev_timers[1]; 
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
            fi;
            :: s_lights[1] == red && timers[1] == 3 && tl_lights[1]==red-> p_lights[1] = flickering; 
            :: else -> skip;
        fi;
        timers[0]--;
        timers[1]--;

        assert(!(s_lights[0] == green && s_lights[1] == green));

        printf("[Horizontal] Light 1: %e, Turn left Light 1: %e ,Pedestrian Light 1: %e, Timer: %d  \n ", s_lights[0],tl_lights[0], p_lights[0], timers[0]);
        printf("[Vertical]Light 1: %e, Turn left Light 1: %e ,Pedestrian Light 1: %e, Timer: %d  \n \n", s_lights[1],tl_lights[1], p_lights[1], timers[1]);
    od
}

proctype HorizontalPedestrian() {
    int numberPedestrians = 0;
    int timer = 0;
    int buffer = 0;
    bool isCrossing = false;
    select (numberPedestrians : 2..5);
    printf("Number of horizontal pedestrians: %d \n", numberPedestrians);
    do
    :: timer == 0 && !isCrossing && buffer <= 0 ->
        numberPedestrians--;
        pedestrian_request[0]!1;
        timer = 2;
        printf("Pedestrian want to cross the horizontal road \n");
        isCrossing = true;
    :: timer > 0 && isCrossing && p_lights[0] == green->
        timer--;
        printf("Pedestrian crossing the horizontal road \n");
    :: timer == 0 && isCrossing->
        pedestrian_request[0]!0;
        isCrossing = false;
        printf("Pedestrian crossed the horizontal road \n");
        buffer = 2;
    :: buffer > 0 ->
        buffer--;
        printf("Not sending signal \n");
    :: numberPedestrians == 0 && isCrossing == false->
        printf("No more pedestrians. Ending process.\n");
        break;
    od;
}

proctype VerticalPedestrian() {
    int numberPedestrians = 0;
    int timer = 0;
    int buffer = 0;
    int randomTimer = 0;
    bool isCrossing = false;
    select (numberPedestrians : 2..5);
    select (randomTimer : 1..5);
    printf("Number of vertical pedestrians: %d \n", numberPedestrians);
    do
    :: if
        :: randomTimer > 0 -> 
            randomTimer--;
        :: else ->
            :: timer == 0 && !isCrossing && buffer <= 0 ->
                numberPedestrians--;
                pedestrian_request[1]!1;
                timer = 2;
                printf("Pedestrian want to cross the vertical road \n");
                isCrossing = true;
            :: timer > 0 && isCrossing && p_lights[1] == green->
                timer--;
                printf("Pedestrian crossing the vertical road \n");
            :: timer == 0 && isCrossing->
                pedestrian_request[1]!0;
                isCrossing = false;
                printf("Pedestrian crossed the vertical road \n");
                buffer = 3;
                select(randomTimer : 1..5);
            :: buffer > 0 ->
                buffer--;
                printf("Not sending signal \n");
            :: numberPedestrians == 0 && isCrossing == false->
                printf("No more pedestrians. Ending process.\n");
                break;
        fi;
    od;
}

init{
    run Controller();
    run HorizontalPedestrian();
    run VerticalPedestrian();
}