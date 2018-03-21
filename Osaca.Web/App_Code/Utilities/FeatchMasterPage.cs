using System;
using System.Web.UI;
using System.Web.UI.HtmlControls;

public abstract class FactshMasterPage : System.Web.UI.Page
{
    protected void Page_PreInit(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(Request.QueryString["click"]))
            this.MasterPageFile = string.Format("~/{0}/master2.master", Config.AdminUrl);
        else if (!string.IsNullOrEmpty(Request.QueryString["_ajx"]))
            this.MasterPageFile = "~/SiteAr2.master";
    }
}