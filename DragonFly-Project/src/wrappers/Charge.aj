package wrappers;

import controller.DroneController;
import controller.ChargeStationController;
import controller.LoggerController;
import javafx.application.Platform;
import model.entity.drone.Drone;
import model.entity.drone.DroneBusinessObject;
import org.aspectj.lang.JoinPoint;
import util.DirectionEnum;
import util.StopWatch;
import view.CellView;
import view.drone.DroneView;
import view.chargeStation.ChargeStationView;


public aspect Charge {

    pointcut safeLanding(): call (* model.entity.drone.DroneBusinessObject.safeLanding(*));

    boolean around(): safeLanding()
            && if
            (
            (((Drone)thisJoinPoint.getArgs()[0]).getWrapperId() == 16)
            ){

        goToCharge(thisJoinPoint);
        //charge(thisJoinPoint);
        return false;
    }

    private void charge(JoinPoint thisJoinPoint) {
        Drone drone = (Drone) thisJoinPoint.getArgs()[0];

        new StopWatch(0, 100) {
            boolean isCharged;
            @Override
            public void task() {
                if (drone.getCurrentBattery() > 70.0 ) {
                    isCharged = true;
                } else drone.setCurrentBattery(drone.getCurrentBattery() + 1.0);

            }
            @Override
            public boolean conditionStop() {
                return isCharged;
            }
        };
    }

    private void goToCharge(JoinPoint thisJoinPoint) {

        Drone drone = (Drone) thisJoinPoint.getArgs()[0];

        new StopWatch(0,1500) {

            @Override
            public void task() {
                Platform.runLater(() -> {
                    //Find the nearest charge station first
                    DroneView droneView = DroneController.getInstance().getDroneViewFrom(drone.getUniqueID());
                    ChargeStationView closerChargeStationView = ChargeStationController.getInstance().getCloserChargeStation(drone);
                    CellView destinationCellView = closerChargeStationView.getCurrentCellView();
                    DirectionEnum goDirection = DroneBusinessObject.closeDirection(droneView.getCurrentCellView(), destinationCellView);

                    LoggerController.getInstance().print("Drone["+drone.getLabel()+"] "+"find charge station");
                    LoggerController.getInstance().print("the nearest charge station label is : " + closerChargeStationView.getHospitalLabel());
                    LoggerController.getInstance().print("its coordinate is [ " + closerChargeStationView.getCurrentCellView().getRowPosition() + " ,"+ closerChargeStationView.getCurrentCellView().getCollunmPosition()+" ]");
                    DroneBusinessObject.flyToDirection(drone, goDirection);

                    if (droneView.getCurrentCellView() == destinationCellView) {
                        drone.setCurrentBattery(drone.getCurrentBattery() + 10.0);
                    }
                });
            }
            @Override
            public boolean conditionStop() {
                return drone.getCurrentBattery() > 80.0;}
        };




    }
}
