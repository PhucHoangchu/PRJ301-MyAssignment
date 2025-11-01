/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.core;

import model.BaseModel;

/**
 *
 * @author MWG
 */
public class Employee extends BaseModel{
    private String name;
    private Division division;  // quan he voi phong ban
    private Employee supervisor; // quan he tu tham chieu 

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Division getDivision() {
        return division;
    }

    public void setDivision(Division division) {
        this.division = division;
    }

    public Employee getSupervisor() {
        return supervisor;
    }

    public void setSupervisor(Employee supervisor) {
        this.supervisor = supervisor;
    }
    
}
