package controller;

import javafx.scene.input.KeyEvent;
import model.entity.ChargeStation;
import model.entity.drone.Drone;
import view.CellView;
import view.SelectableView;
import view.drone.DroneView;
import view.chargeStation.ChargeStationView;
import view.chargeStation.ChargeStationViewImpl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ChargeStationController {

    protected Map<String, ChargeStationView> hospitalViewMap = new HashMap<>();
    protected Map<String, ChargeStation>  hospitalMap = new HashMap<>();
    private static ChargeStationController instance;

    private ChargeStationController() {

    }

    public static ChargeStationController getInstance(){
        if(instance == null){

            instance = new ChargeStationController();
        }

        return instance;
    }

    public ChargeStation createHospital(String uniqueID, String labelHospital, CellView currentCellView){

        ChargeStationView chargeStationView = new ChargeStationViewImpl(uniqueID, labelHospital,currentCellView);


        hospitalViewMap.put(uniqueID, chargeStationView);


        ChargeStation chargeStation = new ChargeStation(uniqueID, labelHospital, currentCellView.getRowPosition(), currentCellView.getCollunmPosition());

        chargeStation.addListener(chargeStationView);

        hospitalMap.put(uniqueID, chargeStation);

        chargeStation.setSelected(true);

        return chargeStation;
    }



    public ChargeStationView getHospitalViewFrom(String identifierHospital) {

        return hospitalViewMap.get(identifierHospital);
    }

    public ChargeStation getHospitalFrom(String identifierHospital) {
        return hospitalMap.get(identifierHospital);
    }

    public void consumeReset() {

    }

    public void consumeClickEvent(SelectableView selectedEntityView ) {
        if(selectedEntityView instanceof ChargeStationView){
            ChargeStation chargeStation =  getHospitalFrom(selectedEntityView.getUniqueID());
            chargeStation.setSelected(true);
        }
    }

    public void consumeOnKeyPressed(SelectableView selectedEntityView, KeyEvent keyEvent) {
        if(!(selectedEntityView instanceof ChargeStationView)){
            return;
        }

    }


    public void consumeRunEnviroment() {

    }

    public Map<String, ChargeStationView> getHospitalViewMap() {
        return hospitalViewMap;
    }

    public void setHospitalViewMap(Map<String, ChargeStationView> hospitalViewMap) {
        this.hospitalViewMap = hospitalViewMap;
    }

    public Map<String, ChargeStation> getHospitalMap() {
        return hospitalMap;
    }

    public void setHospitalMap(Map<String, ChargeStation> hospitalMap) {
        this.hospitalMap = hospitalMap;
    }

    public void consumeCleanEnvironment() {
        hospitalMap.clear();
        hospitalViewMap.clear();
        ChargeStation.restartCount();
    }


    public void cleanSelections() {
        for(ChargeStation chargeStation : hospitalMap.values()){
            chargeStation.setSelected(false);
        }
    }

    public void deleteHospital(ChargeStation chargeStation) {
        hospitalMap.remove(chargeStation.getUniqueID());
        ChargeStationView chargeStationView = hospitalViewMap.remove(chargeStation.getUniqueID());
        chargeStationView.getCurrentCellView().getChildren().remove(chargeStationView);
    }

    public List<ChargeStationView> getHospitalViewList(){
        return new ArrayList<>(hospitalViewMap.values());
    }

    public ChargeStationView getCloserChargeStation(Drone drone) {
        DroneView droneView = DroneController.getInstance().getDroneViewFrom(drone.getUniqueID());
        List<ChargeStationView> chargeStationViewList = getHospitalViewList();
        Double closerDistance = 9999999D;
        ChargeStationView closerChargeStationView = null;
        for(ChargeStationView chargeStationView : chargeStationViewList){
            double newDistance = CellController.getInstance().calculeteDisplacementFrom(droneView, chargeStationView);

            if(newDistance < closerDistance){
                closerDistance = newDistance;
                closerChargeStationView = chargeStationView;
            }
        }
        return closerChargeStationView;

    }







}
