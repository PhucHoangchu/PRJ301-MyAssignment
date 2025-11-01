/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.BaseModel;

/**
 *
 * @author MWG
 */
public abstract class DBContext<T extends BaseModel> {

     //open connection
    protected java.sql.Connection connection = null;
    public DBContext()
    {
        try {
            String user = "phucch";
            String pass = "123";
            String url = "jdbc:sqlserver://localhost:1433;databaseName=FALL25_Assignment;encrypt=true;trustServerCertificate=true;sendStringParametersAsUnicode=true;";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void closeConnection()
    {
        try {
            if(connection != null && !connection.isClosed())
            {
                connection.close();
            }
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public abstract ArrayList<T> list();
    public abstract T get(int id);
    public abstract void insert(T model);
    public abstract void update(T model);
    public abstract void delete(T model);
}
