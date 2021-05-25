using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using LibreriaBD;

namespace GestionDeOperacionesTI
{
    public partial class frmAltaEmpleado : Form
    {
        private ManejaEmpleado AdmEmp;

        public frmAltaEmpleado(ManejaEmpleado AdmEmp)
        {
            InitializeComponent();
            this.AdmEmp = AdmEmp;
        }

        private void frmAltaEmpleado_Load(object sender, EventArgs e)
        {
            SqlConnection Connection = UsoBD.ConectaBD(Utileria.GetConnectionString());

            if (Connection == null)
            {
                MessageBox.Show("ERROR DE CONEXIÓN CON LA BASE DE DATOS");

                foreach (SqlError E in UsoBD.ESalida.Errors)
                    MessageBox.Show(E.Message);

                return;
            }
            SqlDataReader Lector = null;

            string strComandoC = "SELECT Nombre FROM ROL";

            Lector = UsoBD.Consulta(strComandoC, Connection);
            if (Lector == null)
            {
                MessageBox.Show("ERROR AL HACER LA CONSULTA");
                foreach (SqlError E in UsoBD.ESalida.Errors)
                    MessageBox.Show(E.Message);

                Connection.Close();
                return;
            }
            if (Lector.HasRows)
            {
                while (Lector.Read())
                {
                    cmbRol.Items.Add(Lector.GetValue(0).ToString());
                }
            }
            Connection.Close();
        }

        private void btnAgregar_Click(object sender, EventArgs e)
        {
            DialogResult Result = MessageBox.Show("¿DESEA AGREGAR ESTE EMPLEADO?", "PREGUNTA", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (Result == DialogResult.No)
                return;

            if (Utileria.IsEmpty(txtNombre.Text))
            {
                MessageBox.Show("NO SE ACEPTAN CAMPOS VACIOS EN EL NOMBRE", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            if (Utileria.IsEmpty(txtEmail.Text))
            {
                MessageBox.Show("NO SE ACEPTAN CAMPOS VACIOS EN EL EMAIL", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            if (Utileria.IsEmpty(txtDireccion.Text))
            {
                MessageBox.Show("NO SE ACEPTAN CAMPOS VACIOS EN LA DIRECCION", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            if (Utileria.ValidaTextoNum(txtCelular.Text))
            {
                MessageBox.Show("EN ESTE CAMPO SOLO SE ACEPTAN NUMEROS", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            int Rol=AdmEmp.GetIDByNameRol(cmbRol.SelectedItem.ToString());

           if(AdmEmp.AddEmp(txtNombre.Text, txtEmail.Text, txtCelular.Text, txtDireccion.Text, Rol))
            {
                MessageBox.Show("EMPLEADO AGREGADO EXITOSAMENRE", "INFORMACION", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }
    }
}
