/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */



import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.logging.Level;
import java.util.logging.Logger;


public class BR_ASP_Request
{
    public static String readPv(String variable, String target)
    {
        try 
        {
            // Construct data
            String data = URLEncoder.encode("redirect", "UTF-8") + "=" + "/response.asp";
            data += "&" + URLEncoder.encode("variable", "UTF-8") + "=" + URLEncoder.encode(variable, "UTF-8");
            data += "&" + URLEncoder.encode("value", "UTF-8") + "=";
            data += "&" + URLEncoder.encode("read", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8");
            URL url = new URL("http://" + target + ":80/goform/ReadWrite");
            return pvAccess(data, url);
        } 
        catch (Exception ex) 
        {
            Logger.getLogger(BR_ASP_Request.class.getName()).log(Level.SEVERE, null, ex);
        }
        return "Error";
    }

    public static String writePv(String variable, String value, String target)
    {     
        try 
        {
            // Construct data
            String data = URLEncoder.encode("redirect", "UTF-8") + "=" + "/response.asp";
            data += "&" + URLEncoder.encode("variable", "UTF-8") + "=" + URLEncoder.encode(variable, "UTF-8");
            data += "&" + URLEncoder.encode("value", "UTF-8") + "=" + URLEncoder.encode(value, "UTF-8");
            data += "&" + URLEncoder.encode("write", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8");
            URL url = new URL("http://" + target + ":80/goform/ReadWrite");
            return pvAccess(data, url);
        } 
        catch (Exception ex) 
        {
            Logger.getLogger(BR_ASP_Request.class.getName()).log(Level.SEVERE, null, ex);
        }
        return "Error";
    }

    public static String pvAccess(String data, URL url)
    {
        String line = null;
        String response = "";
        try 
        {
            // Send data
            URLConnection conn = url.openConnection();
            conn.setConnectTimeout(3);
            conn.setDoOutput(true);
            OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
            wr.write(data);
            wr.flush();
            wr.close();

            // Get the response
            BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            
            while ((line = rd.readLine()) != null) 
            {
            	// For AR < 3.08
                line = line.replace("<!-- B&R ASP Webserver -->","" );
                response += line;   
            }
            
            wr.close();
            rd.close();
            return response;

        } 
        catch (Exception e) 
        {
            System.out.println(e.toString());
            return e.toString();
        }
    }
}
