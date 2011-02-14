using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZedGraph;

namespace TuneRecognizerDebug {
    class ZedRepeater {
        private ZedGraphControl _zg;
        private int _curPoint;
        private int _maxPoints;
        
        public string CurveName { get; private set; } // actual name of curves on ZedGraph will be CurveName + "_1" and CurveName + "_2"

        public int MaxPoints {
            get {
                return _maxPoints;
            }
            set {
                _zg.GraphPane.XAxis.Scale.Max = value;
                _maxPoints = value;
            }
        }

        public bool WrapSpace { get; set; }
        public int NumSpacePoints { get; set; }

        public double FractionSpace {
            get {
                if (this.MaxPoints > 0) return this.NumSpacePoints / this.MaxPoints;
                else return 0;
            }
            set {
                if ((value < 0) || (value > 1)) throw new Exception("Fraction space must be betweeon 0 and 1");
                this.NumSpacePoints = (int) (value * this.MaxPoints);
            }
        }

        public ZedRepeater(ZedGraphControl zg, string curveName) {
            _zg = zg;
            CurveName = curveName;

            InitializeZedGraph();
        }

        public void InitializeZedGraph() {
            _zg.GraphPane.XAxis.Scale.MinAuto = false;
            _zg.GraphPane.XAxis.Scale.Min = 1;
            _zg.GraphPane.XAxis.Scale.MaxAuto = false;
            if (MaxPoints==0) _zg.GraphPane.XAxis.Scale.Max = 1;
            else _zg.GraphPane.XAxis.Scale.Max = MaxPoints;

            LineItem seg1 = _zg.GraphPane.AddCurve(CurveName + "_1",
                new PointPairList(), System.Drawing.Color.Black, SymbolType.Circle);
            seg1.Symbol.Fill = new Fill(System.Drawing.Color.White);

            LineItem seg2 = _zg.GraphPane.AddCurve(CurveName + "_2",
                new PointPairList(), System.Drawing.Color.Black, SymbolType.Circle);
            seg2.Symbol.Fill = new Fill(System.Drawing.Color.White);
        }

        public void addValue(double value) {
            _curPoint++;
            IPointListEdit seg1 = _zg.GraphPane.CurveList[CurveName + "_1"].Points as IPointListEdit;
            IPointListEdit seg2 = _zg.GraphPane.CurveList[CurveName + "_2"].Points as IPointListEdit;
            if (_curPoint > MaxPoints) {
                // wrap
                _zg.GraphPane.CurveList[CurveName + "_2"].Points = seg1.Clone() as IPointListEdit;
                seg1.Clear();
                _curPoint = 1;
                seg2 = _zg.GraphPane.CurveList[CurveName + "_2"].Points as IPointListEdit;
            }

            int lastBlankPoint = _curPoint + NumSpacePoints;

            if ((lastBlankPoint > MaxPoints) && WrapSpace) {
                seg1.Add(new PointPair(_curPoint, value));
                seg2.Clear();

                int wrapBlankPoint = lastBlankPoint - MaxPoints;
                while (seg1[0].X <= wrapBlankPoint) {
                    seg1.RemoveAt(0);
                }
            }
            else {
                seg1.Add(new PointPair(_curPoint, value));

                if (seg2.Count != 0) {
                    while (seg2[0].X < lastBlankPoint) {
                        seg2.RemoveAt(0);
                        if (seg2.Count == 0) break;
                    }
                }
            }

            _zg.Invalidate();
        } // public void addValue
    } // class ZedRepeater
}
