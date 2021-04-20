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
    public partial class frmEditaPerfil : Form
    {
        private ManejaEmpleado AdmEmp;
        int IDEmp;
        public frmEditaPerfil(ManejaEmpleado AdmEmp, int IDEmp)
        {
            InitializeComponent();
            this.AdmEmp = AdmEmp;
            this.IDEmp = IDEmp;
        }

        private void btnActualizar_Click(object sender, EventArgs e)
        {
            DialogResult Result = MessageBox.Show("¿DESEA GUARDAR LOS CAMBIOS?", "PREGUNTA", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (Result == DialogResult.No)
                return;

            string NumCel = txtNumCel.Text;
            string Dir = txtDir.Text;

            if (Utileria.ValidaTextoNum(NumCel))
            {
                MessageBox.Show("EN ESTE CAMPO SOLO SE ACEPTAN NUMEROS", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            if (Utileria.IsEmpty(NumCel))
            {
                MessageBox.Show("NO SE ACEPTAN CAMPOS VACIOS", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            if (Utileria.IsEmpty(Dir))
            {
                MessageBox.Show("NO SE ACEPTAN CAMPOS VACIOS", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            AdmEmp.UpdateCel(IDEmp,NumCel);
            AdmEmp.UpdateDir(IDEmp, Dir);
            Limpiar();
            
        }
        private void Limpiar()
        {
            txtNumCel.Text = "";
            txtDir.Text = "";
        }

    }
}
