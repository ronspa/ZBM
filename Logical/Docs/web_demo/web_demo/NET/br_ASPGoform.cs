using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;


namespace BR_ASP_Request
{
    public class PV_Access
    {
        private static String pvAccess(String host, String payload)
        {
            string url = "http://" + host + "/goform/ReadWrite";
            byte[] parameter = Encoding.UTF8.GetBytes(payload);
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "POST";
            request.Timeout = 3000; // 3 Sek Timeout
            try
            {
                Stream requestStream = request.GetRequestStream();
                requestStream.Write(parameter, 0, parameter.Length);
                requestStream.Close();
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                if (response == null) return "";
                Stream responseStream = response.GetResponseStream();
                StreamReader streamReader = new StreamReader(responseStream);
                string antwort = streamReader.ReadToEnd();
                streamReader.Close();
                responseStream.Close();
                antwort = antwort.Replace("<!-- B&R ASP Webserver -->", "");
                return antwort;
            }
            catch (Exception e)
            {
                return e.Message;
            }
        }

        public static String ReadPV(String host, String PvName)
        {
            string Parameter = "redirect=/response.asp&read=1&variable=" + PvName + "&value=none";
            return pvAccess(host, Parameter);
        }

        public static String WritePV(String host, String PvName, String PvValue)
        {
            string Parameter = "redirect=/response.asp&write=1&variable=" + PvName + "&value=" + PvValue;
            return pvAccess(host, Parameter);
        }
    }
}
