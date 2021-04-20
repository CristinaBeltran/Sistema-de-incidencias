using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace GestionDeOperacionesTI
{
    public partial class frmMenuTecnico : Form
    {
        private ManejaEmpleado AdmEmp;
        int IDEmp;
        public frmMenuTecnico(ManejaEmpleado AdmEmp, int IDEmp)
        {
            InitializeComponent();
            this.AdmEmp = AdmEmp;
            this.IDEmp = IDEmp;
        }
        private void AbrirForm(object formP)
        {
            if (this.pnContenido.Controls.Count > 0)
            {
                this.pnContenido.Controls.Clear();
                Form frm = formP as Form;
                frm.TopLevel = false;
                frm.Dock = DockStyle.Fill;
                this.pnContenido.Controls.Add(frm);
                this.pnContenido.Tag = frm;
                frm.Show();
            }
        }
        private void homeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            AbrirForm(new frmInicio(AdmEmp, IDEmp));
        }

        private void frmMenuTecnico_Load(object sender, EventArgs e)
        {
            AbrirForm(new frmInicio(AdmEmp, IDEmp));
        }

        private void editarPerfilToolStripMenuItem_Click(object sender, EventArgs e)
        {
            AbrirForm(new frmEditaPerfil(AdmEmp, IDEmp));
        }
    }
}
