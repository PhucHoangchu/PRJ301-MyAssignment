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
public class Division extends BaseModel{
       private String name;

    public Division() {
    }

    public Division(int id,String name) {
        this.setId(id);
        this.name = name;
    }
    

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
