using System;
using System.Web.UI;

public partial class sys_master : MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (SessionManager.Current.ID == "0")
            Server.Transfer("~/sys/default.aspx");
    }
}
