using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class SessionManager
{
    private SessionManager()
    {
        ID = "0";
        IP = HttpContext.Current.Request.UserHostAddress;
        Level = "";
    }

    public static SessionManager Current
    {
        get
        {
            if (HttpContext.Current != null)
            {
                SessionManager session = (SessionManager)HttpContext.Current.Session["_ShareSession_"];
                if (session == null)
                {
                    session = new SessionManager();
                    HttpContext.Current.Session["_ShareSession_"] = session;
                }
                return session;
            }
            else
            {
                SessionManager session = new SessionManager();
                HttpContext.Current.Session["_ShareSession_"] = session;
                return session;
            }
        }
    }

    public string ID { get; set; }
    public string Name { get; set; }
    public string Level { get; set; }
    public string IP { get; set; }
}
