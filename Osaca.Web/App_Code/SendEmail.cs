using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Net.Mail;
using System.Net.Mime;
using System.Net.Configuration;
using System.Web.Configuration;
using System.IO;
using System.Net;

/// <summary>
/// Summary description for Send Email class
/// </summary>
public class SendEmail
{
    #region "Private Declaration"

    private string host, Username, Password, from, BCC;
    int port;

    MailMessage message = new MailMessage();

    #endregion

    #region "/public Methods"

    public SendEmail()
    {
        GetSMTPsettings();
    }
    public bool SendAnEmail(string MsgTo, string Subj, string Body) // , FileUpload FileMsg
    {
        bool IsSend = false;
        try
        {
            SmtpClient smtpClient = new SmtpClient(host);

            // we set our email and alt of email as wrote [  "Home company" <dev.gmail.com>    ]
            //MailAddress fromAddress = new MailAddress(from, "pieceofcake-uae.com");
            MailAddress fromAddress = new MailAddress(from);

            // You can specify the host name or ipaddress of your server
            // Default in IIS will be localhost 
            // smtpClient.Host = "smtp.gmail.com";
            //smtpClient.EnableSsl = true;
            smtpClient.Credentials = CredentialCache.DefaultNetworkCredentials; //new System.Net.NetworkCredential(Username, Password);
            //Default port will be 25

            smtpClient.Port = port;
            //From address will be given as a MailAddress Object
            message.From = fromAddress;


            // To address collection of MailAddress
            message.To.Add(MsgTo);
            message.Subject = Subj;

            // CC and BCC optional
            //message.CC.Add(CC);
            // You can specify Address directly as string

            message.Bcc.Add(new MailAddress(BCC));

            //Body can be Html or text format
            //Specify true if it  is html message
            message.IsBodyHtml = true;

            // Bind attached file.
            //if (FileMsg.HasFile)
            //    message.Attachments.Add(AttachFiles(FileMsg));

            // Message body content            
            message.Body = Body;

            // Send SMTP mail

            smtpClient.Send(message);
            IsSend = true;
        }
        catch
        {
            IsSend = false;

        }
        return IsSend;
    }
    public bool SendAnEmail(string MsgTo, string Subj, string Body, HttpPostedFile FileMsg)
    {
        bool IsSend = false;
        try
        {
            SmtpClient smtpClient = new SmtpClient(host);
            // we set our email and alt of email as wrote [  "Home company" <dev.gmail.com>    ]
            //MailAddress fromAddress = new MailAddress(from, "pieceofcake-uae.com");
            MailAddress fromAddress = new MailAddress(from);

            // You can specify the host name or ipaddress of your server
            // Default in IIS will be localhost 
            //smtpClient.EnableSsl = true;
            smtpClient.Credentials = new System.Net.NetworkCredential(Username, Password);
            smtpClient.Port = port;
            //From address will be given as a MailAddress Object


            message.From = fromAddress;
            message.To.Add(MsgTo);// To address collection of MailAddress
            message.Subject = Subj;

            // CC and BCC optional
            //message.CC.Add(CC);
            // You can specify Address directly as string

            message.Bcc.Add(new MailAddress(BCC));

            //Body can be Html or text format
            //Specify true if it  is html message
            message.IsBodyHtml = true;

            // Bind attached file.
            if (FileMsg.ContentLength > 0)
                AttachFiles(FileMsg);

            // Message body content            
            message.Body = Body;

            // Send SMTP mail
            smtpClient.Send(message);
            IsSend = true;
        }
        catch
        {
            IsSend = false;

        }
        return IsSend;
    }

    public bool SendAnEmail(string _from, string MsgTo, string Subj, string Body) // , FileUpload FileMsg
    {
        bool IsSend = false;
        try
        {
            SmtpClient smtpClient = new SmtpClient(host);
            MailMessage message = new MailMessage();

            if (!_from.Equals("") && _from.Length > 3)
                from = _from;

            //MailAddress fromAddress = new MailAddress(from, "pieceofcake-uae.com");
            MailAddress fromAddress = new MailAddress(from);

            // You can specify the host name or ipaddress of your server
            // Default in IIS will be localhost
            // smtpClient.Host = "smtp.gmail.com";

            //smtpClient.EnableSsl = true;
            smtpClient.Credentials = new System.Net.NetworkCredential(Username, Password);
            //Default port will be 25
            smtpClient.Port = port;

            //From address will be given as a MailAddress Object
            message.From = fromAddress;

            // To address collection of MailAddress
            message.To.Add(MsgTo);
            message.Subject = Subj;

            // CC and BCC optional
            //message.CC.Add(CC);
            // You can specify Address directly as string

            message.Bcc.Add(new MailAddress(BCC));

            //Body can be Html or text format
            //Specify true if it  is html message
            message.IsBodyHtml = true;

            // Bind attached file.
            //if (FileMsg.HasFile)
            //    message.Attachments.Add(AttachFiles(FileMsg));

            // Message body content            
            message.Body = Body;

            // Send SMTP mail

            smtpClient.Send(message);
            IsSend = true;
        }
        catch
        {
            IsSend = false;

        }
        return IsSend;
    }
    public bool SendAnEmail2(string _from, string MsgTo, string Subj, string Body) // , FileUpload FileMsg
    {
        bool IsSend = false;
        try
        {
            SmtpClient smtpClient = new SmtpClient(host);

            if (!_from.Equals("") && _from.Length > 3)
                from = _from;

            // we set our email and alt of email as wrote [  "SAS company" <dev.gmail.com>    ]
            //MailAddress fromAddress = new MailAddress(from, "pieceofcake-uae.com");
            MailAddress fromAddress = new MailAddress(from);

            // You can specify the host name or ipaddress of your server
            // Default in IIS will be localhost 
            // smtpClient.Host = "smtp.gmail.com";
            //smtpClient.EnableSsl = true;
            //Default port will be 25     
            //From address will be given as a MailAddress Object

            message.From = fromAddress;

            // To address collection of MailAddress
            message.To.Add(MsgTo);

            message.Subject = Subj;

            // CC and BCC optional
            //message.CC.Add(CC);

            // You can specify Address directly as string
            message.Bcc.Add(new MailAddress(BCC));

            //Body can be Html or text format

            //Specify true if it  is html message
            message.IsBodyHtml = true;

            // Bind attached file.
            //if (FileMsg.HasFile)
            //    message.Attachments.Add(AttachFiles(FileMsg));

            // Message body content            
            message.Body = Body;

            // Send SMTP mail

            smtpClient.Send(message);
            IsSend = true;
        }
        catch
        {
            IsSend = false;

        }
        return IsSend;
    }

    public bool SendNow(string msgFrom, string MsgTo, string Subj, string Body) // , FileUpload FileMsg
    {
        host = "smtp.gmail.com";
        port = 587;
        Username = "m.salah@minutesuae.info";
        Password = "msaah856789!";
        from = msgFrom; // "no-replay@iraqusedcars.ae";


        bool IsSend = false;
        try
        {
            var fromAddress = new MailAddress(from, "www.iraqusedcars.ae");
            var toAddress = new MailAddress(MsgTo, "www.iraqusedcars.ae");

            var smtp = new SmtpClient
            {
                Host = host,
                Port = port,
                EnableSsl = true,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(Username, Password)
            };
            using (var message = new MailMessage(fromAddress, toAddress)
            {
                Subject = Subj,
                IsBodyHtml = true,
                Body = Body
            })
            {
                smtp.Send(message);
                IsSend = true;
            }
        }
        catch
        {
            IsSend = false;
        }
        return IsSend;
    }

    public string ReadTemplate(string strTemplatePath)
    {
        System.IO.StreamReader srBody = System.IO.File.OpenText(strTemplatePath);
        return srBody.ReadToEnd();
    }
    #endregion

    #region "Private Methods"

    private void GetSMTPsettings()
    {
        host = "smtpout.asia.secureserver.net";
        port = 25;
        Username = "info@pieceofcake-uae.com";
        Password = "POC378asd!123";
        from = "no-reply@pieceofcake-uae.com";
        BCC = "m.salah@minutesuae.info";
    }

    // Attache file
    private void AttachFiles(HttpPostedFile fileMsg)
    {

        if (fileMsg != null && fileMsg.ContentLength > 0)
        {
            string fileName = Path.GetFileName(fileMsg.FileName);
            var attachment = new Attachment(fileMsg.InputStream, fileName);
            message.Attachments.Add(attachment);
        }
    }

    #endregion
}
