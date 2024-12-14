mtype = {red, yellow, green, flickering}; 

mtype lights[1] = {green}; 
mtype p_lights[1] = {red};
chan ped = [20] of {byte};
chan pedLight = [1] of {byte};
chan end = [1] of {byte};

proctype Light(){
    do
    :: ped ? 1 ->
        lights[0] = red;
        p_lights[0] = green;
        printf("Pedestrian signal received, traffic light is %e, pedestrian light is %e \n", lights[0], p_lights[0]);
    :: ped ? 0 ->
        p_lights[0] = red;
        lights[0] = green;
        printf("Pedestrian crossed, traffic light is %e, pedestrian light is %e \n", lights[0], p_lights[0]);
    :: end ? 1 ->
        break;
    od;
}

proctype PedestrianCensor() {
    int numberPedestrians = 0;
    int timer = 0;
    int buffer = 0;
    bool isCrossing = false;
    select (numberPedestrians : 2..5);
    printf("Number of pedestrians: %d \n", numberPedestrians);
    do
    :: timer == 0 && !isCrossing && buffer <= 0 ->
        numberPedestrians--;
        ped!1;
        timer = 2;
        printf("Pedestrian want to cross the road \n");
        isCrossing = true;
    :: timer > 0 && isCrossing->
        timer--;
        printf("Pedestrian crossing the road \n");
    :: timer == 0 && isCrossing->
        ped!0;
        isCrossing = false;
        printf("Pedestrian crossed the road \n");
        buffer = 2;
    :: buffer > 0 ->
        buffer--;
        printf("Not sending signal \n");
    :: numberPedestrians == 0 && isCrossing == false->
        printf("No more pedestrians \n");
        break;
    od;
    end!1;
}

init {
    run Light();
    run PedestrianCensor();
}
