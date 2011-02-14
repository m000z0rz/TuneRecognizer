using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO.Ports;
using ZedGraph;

namespace TuneRecognizerDebug {
    public partial class frmMain : Form {

        private ZedRepeater zgRepeater;

        public frmMain() {
            InitializeComponent();
        }

        private void frmMain_Load(object sender, EventArgs e) {
            this.Resize += frmMain_Resize;
            refreshPorts();
            resizeGraph();

            GraphPane zgPane = zg.GraphPane;

            // Set the titles and axis labels
            zgPane.Title.Text = "Frequency";
            zgPane.XAxis.Title.Text = "Time";
            zgPane.YAxis.Title.Text = "Frequency (Hz)";
            //zgPane.Y2Axis.Title.Text = "Parameter B";

            zgRepeater = new ZedRepeater(zg, "frequency");
            zgRepeater.MaxPoints = 22;
            zgPane.YAxis.Scale.Min = 0;
            zgPane.YAxis.Scale.Max = 6;
            zgPane.AxisChange();
        }

        private void btRefreshPortsList_Click(object sender, EventArgs e) {
            refreshPorts();
        }

        private void frmMain_Resize(object sender, EventArgs e) {
            resizeGraph();
        }

        private void resizeGraph() {
            zg.Width = this.ClientRectangle.Width - zg.Left - 10;
            zg.Height = this.ClientRectangle.Height - zg.Top - 10;
        }

        private void refreshPorts() {
            string oldPort = cmbPort.Text;
            cmbPort.Items.Clear();
            string[] ports;
            ports = SerialPort.GetPortNames();
            for (int i = 0; i < ports.Length; i++) {
                cmbPort.Items.Add(ports[i]);
            }
            if (cmbPort.Items.Contains(oldPort)) cmbPort.Text = oldPort;
            else if (cmbPort.Items.Count > 0) cmbPort.Text = (string)cmbPort.Items[0];
            else cmbPort.Text = "";
        }

        private void button1_Click(object sender, EventArgs e) {
            int i;
            for (i = 0; i<6; i++) {
                zgRepeater.addValue(i);
            }
        }


    }
}
