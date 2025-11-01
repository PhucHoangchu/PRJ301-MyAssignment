/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import model.iam.User;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.core.Employee;

/**
 *
 * @author MWG
 */
public class UserDBContext extends DBContext<User> {

    public User get(String username, String password) {
        try {
            String sql =
                    "SELECT u.uid, u.username, u.displayname, e.eid, e.ename " +
                    "FROM [User] u INNER JOIN [Enrollment] en ON u.[uid] = en.[uid] " +
                    "INNER JOIN [Employee] e ON e.eid = en.eid " +
                    "WHERE u.username = ? AND u.[password] = ? AND en.active = 1";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, username);
            stm.setString(2, password);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                User u = new User();
                Employee e = new Employee();
                e.setId(rs.getInt("eid"));
                e.setName(rs.getString("ename"));
                u.setEmployee(e);

                u.setUsername(username);
                u.setId(rs.getInt("uid"));
                u.setDisplayname(rs.getString("displayname"));
                return u;
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return null;
    }

    @Override
    public ArrayList<User> list() {
        ArrayList<User> users = new ArrayList<>();
        try {
            String sql =
                    "SELECT u.uid, u.username, u.displayname, e.eid, e.ename " +
                    "FROM [User] u " +
                    "LEFT JOIN [Enrollment] en ON u.[uid] = en.[uid] AND en.active = 1 " +
                    "LEFT JOIN [Employee] e ON e.eid = en.eid";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("uid"));
                u.setUsername(rs.getString("username"));
                u.setDisplayname(rs.getString("displayname"));

                if (rs.getObject("eid") != null) {
                    Employee e = new Employee();
                    e.setId(rs.getInt("eid"));
                    e.setName(rs.getString("ename"));
                    u.setEmployee(e);
                }
                users.add(u);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return users;
    }

    @Override
    public User get(int id) {
        try {
            String sql =
                    "SELECT u.uid, u.username, u.displayname, e.eid, e.ename " +
                    "FROM [User] u " +
                    "LEFT JOIN [Enrollment] en ON u.[uid] = en.[uid] AND en.active = 1 " +
                    "LEFT JOIN [Employee] e ON e.eid = en.eid " +
                    "WHERE u.uid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("uid"));
                u.setUsername(rs.getString("username"));
                u.setDisplayname(rs.getString("displayname"));

                if (rs.getObject("eid") != null) {
                    Employee e = new Employee();
                    e.setId(rs.getInt("eid"));
                    e.setName(rs.getString("ename"));
                    u.setEmployee(e);
                }
                return u;
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return null;
    }

    @Override
    public void insert(User model) {
        try {
            String sql = "INSERT INTO [User] (uid, username, [password], displayname) VALUES (?, ?, ?, ?)";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, model.getId());
            stm.setString(2, model.getUsername());
            stm.setString(3, model.getPassword()); // Sử dụng password từ model
            stm.setString(4, model.getDisplayname());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    @Override
    public void update(User model) {
        try {
            String sql = "UPDATE [User] SET displayname = ? WHERE uid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, model.getDisplayname());
            stm.setInt(2, model.getId());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    @Override
    public void delete(User model) {
        try {
            String sql = "DELETE FROM [User] WHERE uid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, model.getId());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }
}
