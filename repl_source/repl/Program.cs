using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

namespace repl
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                System.Console.WriteLine("Format: repl oldstring newstring filepath");
            } 
            else 
            {
                try
                {
                    string oldstring = args[0];
                    string newstring = args[1];
                    string filepath = args[2];

                    File.WriteAllText(filepath, Regex.Replace(File.ReadAllText(filepath), oldstring, newstring));

                    System.Console.WriteLine(oldstring + " <= " + newstring + " in file " + filepath );
                }
                catch (Exception ex)
                {
                    System.Console.WriteLine("Cannot perform due to Exception: " + ex.Message);
                }
            }
        }
    }
}
