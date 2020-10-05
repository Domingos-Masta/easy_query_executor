/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dbq_executor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
/**
 *
 * @author domingos
 */
public class Executor {

    public static String[] getDatabaseTable() {
        ArrayList<String> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            
            conn = Conexao.getConnection();
            ps = conn.prepareStatement("show tables;");
            rs = ps.executeQuery();
            int i = rs.getMetaData().getColumnCount();
            while (rs.next()) { 
                for (int j = 1; j <= i; j++) {
                  result.add(rs.getString(j));  
                }
            }

        } catch (SQLException ex) {
            System.err.println("\nErro ao carregar dados: " + ex.getMessage());
            return null;
        } finally {
            Conexao.closeConnection(conn, ps, rs);
        }
        String str[] = new String[result.size()];
        for (int i = 0; i < result.size(); i++) {
            str[i] = result.get(i);
            
        }
        return str;
    }
    
    public static String[] getDatabaseTriggers() {
        ArrayList<String> result = new ArrayList<>();
        String strAux = "";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            
            conn = Conexao.getConnection();
            ps = conn.prepareStatement("show triggers;");
            rs = ps.executeQuery();
            int i = rs.getMetaData().getColumnCount();
            if(rs != null)
            {
                for (int j = 1; j <= i; j++) {
                      strAux += " -[ ";
                      strAux += rs.getMetaData().getColumnName(j);  
                      strAux += " ]- ";
                    }
            }
            result.add(strAux);
            while (rs.next()) { 
                strAux = "";
                for (int j = 1; j <= i; j++) {
                  strAux += " -[ ";
                  strAux += rs.getString(j);
                  strAux += " ]- ";
                  //result.add(rs.getString(j));  
                }
                result.add(strAux);
            }

        } catch (SQLException ex) {
            System.err.println("\nErro ao carregar dados: " + ex.getMessage());
            return null;
        } finally {
            Conexao.closeConnection(conn, ps, rs);
        }
        String str[] = new String[result.size()];
        for (int i = 0; i < result.size(); i++) {
            str[i] = result.get(i);
            
        }
        return str;
    }
    
    public static String[] getDatabaseProcedures() {
        ArrayList<String> result = new ArrayList<>();
        String strAux = "";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            
            conn = Conexao.getConnection();
            ps = conn.prepareStatement("show procedure status;");
            rs = ps.executeQuery();
            int i = rs.getMetaData().getColumnCount();
            if(rs != null)
            {
                for (int j = 1; j <= i; j++) {
                      strAux += " -[ ";
                      strAux += rs.getMetaData().getColumnName(j);  
                      strAux += " ]- ";
                    }
            }
            result.add(strAux);
            while (rs.next()) {
                strAux = "";
                for (int j = 1; j <= i; j++) {
                  strAux += "-[ ";
                  strAux += rs.getString(j);
                  strAux += " ]- ";
                  //result.add(rs.getString(j));  
                }
                result.add(strAux);
            }

        } catch (SQLException ex) {
            System.err.println("\nErro ao carregar dados: " + ex.getMessage());
            return null;
        } finally {
            Conexao.closeConnection(conn, ps, rs);
        }
        String str[] = new String[result.size()];
        for (int i = 0; i < result.size(); i++) {
            str[i] = result.get(i);
            
        }
        return str;
    }
    
    
    public static ArrayList<String> getDatabases() {
        ArrayList<String> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            
            conn = Conexao.getConnection();
            ps = conn.prepareStatement("show databases;");
            rs = ps.executeQuery();
            int i = rs.getMetaData().getColumnCount();
            while (rs.next()) { 
                for (int j = 1; j <= i; j++) {
                  result.add(rs.getString(j));  
                }

            }

        } catch (SQLException ex) {
            System.err.println("\nErro ao carregar dados: " + ex.getMessage());
            return null;
        } finally {
            Conexao.closeConnection(conn, ps, rs);
        }
        return result;
    }
    
  
    public static String executarQuery(String query) {
        String result = "";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            
            conn = Conexao.getConnection();
            ps = conn.prepareStatement(query);
            ps.execute();
            
            result += "\n" + query + "- Comando Executado com sucesso";

        } catch (SQLException ex) {
            return "\nErro ao carregar dados: " + ex.getMessage();
        } finally {
            Conexao.closeConnection(conn, ps);
        }
        return result;
    }
    
    public static String executarQuerySearch(String query) {
        String result = "";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            
            conn = Conexao.getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            int i = rs.getMetaData().getColumnCount();
            if(rs != null)
            {
                result +="\n"; 
                for (int j = 1; j <= i; j++) {
                      result += rs.getMetaData().getColumnName(j);  
                      result += " | ";
                    }
            }
            while (rs.next()) {
                result +="\n";  
                for (int j = 1; j <= i; j++) {
                  result += rs.getString(j);  
                  result += " | ";
                }

            }


        } catch (SQLException ex) {
            return "\nErro ao carregar dados: " + ex.getMessage();
        } finally {
            Conexao.closeConnection(conn, ps, rs);
        }
        return result;
    }
    
    public static boolean validarInstrucao(String instrucao)
    {
        if (instrucao.length() > 10)
        {
            if (instrucao.substring(0, 6).equalsIgnoreCase("select"))
                return true;
//            if (instrucao.contains("create") || instrucao.contains("CREATE"))
//                return true;
//            else if (instrucao.contains("create") || instrucao.contains("CREATE"))
//                return true;
//            else if (instrucao.contains("update") || instrucao.contains("UPDATE"))
//                return true;
//            else if (instrucao.contains("delete") || instrucao.contains("DELETE"))
//                return true;
//            else if (instrucao.contains("drop") || instrucao.contains("DROP"))
//                return true;
//            else if (instrucao.contains("alter") || instrucao.contains("ALTER"))
//                return true;
//            else if (instrucao.contains("insert") || instrucao.contains("INSERT"))
//                return true;
//            else if (instrucao.contains("truncate") || instrucao.contains("TRUNCATE"))
//                return true;
        }
        return false;
        
    }
    

    
}
