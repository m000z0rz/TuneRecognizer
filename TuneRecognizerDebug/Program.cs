using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace TuneRecognizerDebug {
    static class Program {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static System.IO.Ports.SerialPort serial;

        [STAThread]
        static void Main() {
            serial = new System.IO.Ports.SerialPort("COM1", 115200, System.IO.Ports.Parity.None, 8, System.IO.Ports.StopBits.One);
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new frmMain());
        }
    }
}
