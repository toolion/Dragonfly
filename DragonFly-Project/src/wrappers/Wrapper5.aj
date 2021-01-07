///find the nearest charging station


package wrappers;

import controller.DroneController;
import controller.EnvironmentController;
import controller.LoggerController;
import javafx.application.Platform;
import javafx.concurrent.Task;
import model.entity.drone.Drone;
import model.entity.drone.DroneBusinessObject;
import org.aspectj.lang.JoinPoint;
import util.AStarAlgorithm;
import view.CellView;
import view.drone.DroneView;
import view.river.RiverView;

import java.util.ArrayList;
import java.util.List;




public aspect Wrapper5 {

    pointcut safeLanding(): call (* model.entity.drone.DroneBusinessObject.safeLanding(*));

    pointcut returnToHome(): call (* model.entity.drone.DroneBusinessObject.returnToHome(*));
    pointcut updateBatteryPerSecond(): call (* model.entity.drone.DroneBusinessObject.updateBatteryPerSecond(*));
    pointcut landing(): call (* model.entity.drone.DroneBusinessObject.landing(*));
    pointcut resetSettingsDrone(): call (void model.entity.drone.DroneBusinessObject.resetSettingsDrone(*));
    pointcut consumeRunEnviroment(): call (void controller.DroneController.consumeRunEnviroment());
    pointcut goDestinyAutomatic(): call (void controller.DroneAutomaticController.goDestinyAutomatic(*));
    pointcut applyEconomyMode() : call (void model.entity.drone.DroneBusinessObject.applyEconomyMode(*));

    boolean around(): safeLanding()
            && if(
            (((Drone)thisJoinPoint.getArgs()[0]).getWrapperId() == 5)
            &&
            (((Drone)thisJoinPoint.getArgs()[0]).getCurrentBattery() <= 10)
            //TODO the condition that triggers the drone to find the nearest charging station

            ){

        GoToCharge(thisJoinPoint);
        keepFlying(thisJoinPoint);
        return false;
    }


    private void GoToCharge(JoinPoint thisJoinPoint) {
        //TODO implement A* to find the charge station and charge


        AStarAlgorithm


    }

    private void keepFlying(JoinPoint thisJoinPoint) {
        Drone drone = (Drone) thisJoinPoint.getArgs()[0];
        //drone.setEconomyMode(false);
        System.out.println("Drone["+drone.getLabel()+"] "+"Keep Flying");
        LoggerController.getInstance().print("Drone["+drone.getLabel()+"] "+"Keep Flying");
    }




//if

//if




}