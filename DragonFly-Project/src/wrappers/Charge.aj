package wrappers;

import controller.DroneController;
import controller.EnvironmentController;
import controller.HospitalController;
import controller.LoggerController;
import javafx.application.Platform;
import javafx.concurrent.Task;
import model.entity.drone.Drone;
import model.entity.drone.DroneBusinessObject;
import org.aspectj.lang.JoinPoint;
import util.DirectionEnum;
import util.StopWatch;
import view.CellView;
import view.drone.DroneView;
import view.hospital.HospitalView;
import view.river.RiverView;
import java.util.Timer;
import java.util.ArrayList;
import java.util.List;


public aspect Charge {

    pointcut safeLanding(): call (* model.entity.drone.DroneBusinessObject.safeLanding(*));

    boolean around(): safeLanding()
            && if
            (
            (((Drone)thisJoinPoint.getArgs()[0]).getWrapperId() == 16)
            ){

        goToCharge(thisJoinPoint);
        System.out.println();
        return false;
    }


    private void goToCharge(JoinPoint thisJoinPoint) {

        Drone drone = (Drone) thisJoinPoint.getArgs()[0];




        new StopWatch(0,1000) {

            @Override
            public void task() {
                Platform.runLater(() -> {



                    DroneView droneView = DroneController.getInstance().getDroneViewFrom(drone.getUniqueID());
                    HospitalView closerHospitalView = HospitalController.getInstance().getCloserHospital(drone);
                    CellView destinationCellView = closerHospitalView.getCurrentCellView();
                    DirectionEnum goDirection = DroneBusinessObject.closeDirection(droneView.getCurrentCellView(), destinationCellView);

                    LoggerController.getInstance().print("Drone["+drone.getLabel()+"] "+"find charge station");
                    LoggerController.getInstance().print("the nearest Hospital label is : " + closerHospitalView.getHospitalLabel());
                    LoggerController.getInstance().print("its coordinate is X: " + closerHospitalView.getCurrentCellView().getRowPosition() + "Y :"+ closerHospitalView.getCurrentCellView().getCollunmPosition());



                    DroneBusinessObject.flyToDirection(drone, goDirection);

                    if (droneView.getCurrentCellView() == destinationCellView) {
                        drone.setCurrentBattery(100.0);
                    }
                });

            }
            @Override
            public boolean conditionStop() {
                return drone.getCurrentBattery() > 80.0;}
        };




    }
}
