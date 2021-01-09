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
import view.CellView;
import view.drone.DroneView;
import view.hospital.HospitalView;
import view.river.RiverView;

import java.util.ArrayList;
import java.util.List;


public aspect Charge {

    pointcut safeLanding(): call (* model.entity.drone.DroneBusinessObject.safeLanding(*));

    boolean around(): safeLanding()
            && if
            (
            (((Drone)thisJoinPoint.getArgs()[0]).getWrapperId() == 8)
            ){

                goToCharge(thisJoinPoint);
                System.out.println();
                return false;
    }


    private void goToCharge(JoinPoint thisJoinPoint) {

        Drone drone = (Drone) thisJoinPoint.getArgs()[0];

        DroneView droneView = DroneController.getInstance().getDroneViewFrom(drone.getUniqueID());
        HospitalView closerHospitalView = HospitalController.getInstance().getCloserHospital(drone);

        LoggerController.getInstance().print("Drone["+drone.getLabel()+"] "+"find chare station");
        LoggerController.getInstance().print("the nearest Hospital label is : " + closerHospitalView.getHospitalLabel());
        LoggerController.getInstance().print("its coordinate is X: " + closerHospitalView.getCurrentCellView().getRowPosition() + "Y :"+ closerHospitalView.getCurrentCellView().getCollunmPosition());

        boolean hasArrived = false;

        while (!hasArrived) {
            String goDirection = DroneBusinessObject.closeDirection(droneView.getCurrentCellView(), closerHospitalView.getCurrentCellView());
            LoggerController.getInstance().print("the next direction is : " + goDirection);
            DroneBusinessObject.goTo(drone, goDirection);

            if (droneView.getCurrentCellView() == closerHospitalView.getCurrentCellView()) {
                hasArrived = true;
                drone.setCurrentBattery(100.0);
            }
        }



    }
}
