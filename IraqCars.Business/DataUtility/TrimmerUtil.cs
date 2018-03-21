using System.Text.RegularExpressions;

namespace ShareWeb.Business.DataUtility
{
    public class TrimmerUtil
    {
        static readonly Regex regexTags = new Regex(@">\s*<");
        static readonly Regex trimmer = new Regex(@"/(^\s+|\s+$)/g");

        public static string RemoveSpaces(string xml)
        {
            xml = regexTags.Replace(xml, "><");
            xml=trimmer.Replace(xml, "");

            return xml.Trim();
        }
    }
}
