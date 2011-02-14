namespace TuneRecognizerDebug
{
    partial class frmMain
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.cmbPort = new System.Windows.Forms.ComboBox();
            this.btRefreshPortsList = new System.Windows.Forms.Button();
            this.zg = new ZedGraph.ZedGraphControl();
            this.button1 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // cmbPort
            // 
            this.cmbPort.FormattingEnabled = true;
            this.cmbPort.Location = new System.Drawing.Point(35, 12);
            this.cmbPort.Name = "cmbPort";
            this.cmbPort.Size = new System.Drawing.Size(138, 21);
            this.cmbPort.TabIndex = 0;
            // 
            // btRefreshPortsList
            // 
            this.btRefreshPortsList.Location = new System.Drawing.Point(179, 12);
            this.btRefreshPortsList.Name = "btRefreshPortsList";
            this.btRefreshPortsList.Size = new System.Drawing.Size(86, 21);
            this.btRefreshPortsList.TabIndex = 1;
            this.btRefreshPortsList.Text = "Refesh List";
            this.btRefreshPortsList.UseVisualStyleBackColor = true;
            this.btRefreshPortsList.Click += new System.EventHandler(this.btRefreshPortsList_Click);
            // 
            // zg
            // 
            this.zg.Location = new System.Drawing.Point(218, 128);
            this.zg.Name = "zg";
            this.zg.ScrollGrace = 0D;
            this.zg.ScrollMaxX = 0D;
            this.zg.ScrollMaxY = 0D;
            this.zg.ScrollMaxY2 = 0D;
            this.zg.ScrollMinX = 0D;
            this.zg.ScrollMinY = 0D;
            this.zg.ScrollMinY2 = 0D;
            this.zg.Size = new System.Drawing.Size(510, 246);
            this.zg.TabIndex = 2;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(218, 84);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(38, 24);
            this.button1.TabIndex = 3;
            this.button1.Text = "button1";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // frmMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(756, 412);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.zg);
            this.Controls.Add(this.btRefreshPortsList);
            this.Controls.Add(this.cmbPort);
            this.Name = "frmMain";
            this.Text = "Tune Recognizer";
            this.Load += new System.EventHandler(this.frmMain_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ComboBox cmbPort;
        private System.Windows.Forms.Button btRefreshPortsList;
        private ZedGraph.ZedGraphControl zg;
        private System.Windows.Forms.Button button1;
    }
}

