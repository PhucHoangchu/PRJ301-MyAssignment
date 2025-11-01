/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import model.iam.Role;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.iam.Feature;

/**
 *
 * @author MWG
 */
public class RoleDBContext extends DBContext<Role> {

    public ArrayList<Role> getByUserId(int id) {
        ArrayList<Role> roles = new ArrayList<>();
        try {
            String sql =
                    "SELECT r.rid, r.rname, f.fid, f.url " +
                    "FROM [User] u INNER JOIN [UserRole] ur ON u.uid = ur.uid " +
                    "INNER JOIN [Role] r ON r.rid = ur.rid " +
                    "INNER JOIN [RoleFeature] rf ON rf.rid = r.rid " +
                    "INNER JOIN [Feature] f ON f.fid = rf.fid " +
                    "WHERE u.uid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            
            Role current = new Role();
            current.setId(-1);
            while (rs.next()) {                
                int rid = rs.getInt("rid");
                if(rid != current.getId()){
                    current = new Role();
                    current.setId(rid);
                    current.setName(rs.getString("rname"));
                    roles.add(current);
                }
                Feature f = new Feature();
                f.setId(rs.getInt("fid"));
                f.setUrl(rs.getString("url"));
                current.getFeatures().add(f);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RoleDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }finally{
            closeConnection();
        }
        return roles;
    }

    @Override
    public ArrayList<Role> list() {
        ArrayList<Role> roles = new ArrayList<>();
        try {
            String sql =
                    "SELECT r.rid, r.rname, f.fid, f.url " +
                    "FROM [Role] r " +
                    "LEFT JOIN [RoleFeature] rf ON rf.rid = r.rid " +
                    "LEFT JOIN [Feature] f ON f.fid = rf.fid " +
                    "ORDER BY r.rid";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            Role current = null;
            while (rs.next()) {
                int rid = rs.getInt("rid");
                if (current == null || current.getId() != rid) {
                    current = new Role();
                    current.setId(rid);
                    current.setName(rs.getString("rname"));
                    roles.add(current);
                }
                
                if(rs.getObject("fid") != null) {
                    Feature f = new Feature();
                    f.setId(rs.getInt("fid"));
                    f.setUrl(rs.getString("url"));
                    current.getFeatures().add(f);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(RoleDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return roles;
    }

    @Override
    public Role get(int id) {
        try {
            String sql =
                    "SELECT r.rid, r.rname, f.fid, f.url " +
                    "FROM [Role] r " +
                    "LEFT JOIN [RoleFeature] rf ON rf.rid = r.rid " +
                    "LEFT JOIN [Feature] f ON f.fid = rf.fid " +
                    "WHERE r.rid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            Role current = null;
            while (rs.next()) {
                if (current == null) {
                    current = new Role();
                    current.setId(rs.getInt("rid"));
                    current.setName(rs.getString("rname"));
                }
                if(rs.getObject("fid") != null) {
                    Feature f = new Feature();
                    f.setId(rs.getInt("fid"));
                    f.setUrl(rs.getString("url"));
                    current.getFeatures().add(f);
                }
            }
            return current;
        } catch (SQLException ex) {
            Logger.getLogger(RoleDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return null;
    }

    @Override
    public void insert(Role model) {
        try {
            String sql = "INSERT INTO [Role] (rid, rname) VALUES (?, ?)";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, model.getId());
            stm.setString(2, model.getName());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(RoleDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    @Override
    public void update(Role model) {
        try {
            String sql = "UPDATE [Role] SET rname = ? WHERE rid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, model.getName());
            stm.setInt(2, model.getId());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(RoleDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    @Override
    public void delete(Role model) {
        try {
            // Phải xóa các bảng tham chiếu trước
            connection.setAutoCommit(false);
            
            String sqlFeatures = "DELETE FROM [RoleFeature] WHERE rid = ?";
            PreparedStatement stmFeatures = connection.prepareStatement(sqlFeatures);
            stmFeatures.setInt(1, model.getId());
            stmFeatures.executeUpdate();
            
            String sqlUsers = "DELETE FROM [UserRole] WHERE rid = ?";
            PreparedStatement stmUsers = connection.prepareStatement(sqlUsers);
            stmUsers.setInt(1, model.getId());
            stmUsers.executeUpdate();

            String sqlRole = "DELETE FROM [Role] WHERE rid = ?";
            PreparedStatement stmRole = connection.prepareStatement(sqlRole);
            stmRole.setInt(1, model.getId());
            stmRole.executeUpdate();
            
            connection.commit();
        } catch (SQLException ex) {
            Logger.getLogger(RoleDBContext.class.getName()).log(Level.SEVERE, null, ex);
            try {
                connection.rollback();
            } catch (SQLException ex1) {
                Logger.getLogger(RoleDBContext.class.getName()).log(Level.SEVERE, null, ex1);
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                Logger.getLogger(RoleDBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
            closeConnection();
        }
    }
}
