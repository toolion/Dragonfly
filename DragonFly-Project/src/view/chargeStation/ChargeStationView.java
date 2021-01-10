package view.chargeStation;

import javafx.scene.Group;
import javafx.scene.Node;
import model.entity.ChargeStation;
import view.SelectableView;

public abstract class ChargeStationView extends Group implements SelectableView, ChargeStation.Listener {
    protected String uniqueID = null;
  /*  public static List<ChargeStationView> hospitalViewList = new ArrayList<>();
    public Object getHospital() {
        return null;
    }*/


    @Override
    public String getUniqueID() {
        return uniqueID;
    }

    public Node getNode() {
        return null;
    }
/*
    public static void cleanHospitalViewList() {}

    public static List<ChargeStationView> getHospitalViewList() {
        return hospitalViewList;
    }

    public static void removeHospitalViewFromList(ChargeStationView hospitalView) {

    }

    public static void addHospitalViewFromList(ChargeStationView hospitalView){

    }*/


    public abstract String getHospitalLabel();

    @Override
    public void removeStyleSelected() {

    }

    @Override
    public void applyStyleSelected() {

    }
}
