using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for GridViewUtility
/// </summary>
public static class GridViewUtility
{
    public static void SetHeaderFooter(GridView gvItems)
    {
        if (gvItems.Rows.Count > 0)
        {
            //This will add the <thead> and <tbody> elements
            gvItems.HeaderRow.TableSection = TableRowSection.TableHeader;

            //This adds the <tfoot> element. 
            //Remove if you don't have a footer row
            gvItems.FooterRow.TableSection = TableRowSection.TableFooter;
        }
    }
}