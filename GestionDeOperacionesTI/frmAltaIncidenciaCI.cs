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
    public partial class frmAltaIncidenciaCI : Form
    {
        private ManejaCI AdmCI;
        private ManejaIncidencia AdmIn;
        private int Tipo, IDEmp;
        public frmAltaIncidenciaCI(ManejaCI AdmCI, ManejaIncidencia AdmIn, int TipoIn, int IDEmp)
        {
            InitializeComponent();
            this.AdmCI = AdmCI;
            this.AdmIn = AdmIn;
            Tipo = TipoIn;
            this.IDEmp = IDEmp;
        }

        private void frmAltaIncidenciaCI_Load(object sender, EventArgs e)
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

            string strComandoC = "SELECT NumSerie FROM CI";

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
                   cmbNumCI.Items.Add(Lector.GetValue(0).ToString());
                }
            }
            Connection.Close();
        }

        private void btnGuardar_Click(object sender, EventArgs e)
        {
            DialogResult Result = MessageBox.Show("¿DESEA AGREGAR ESTE ELEMENTO?", "PREGUNTA", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (Result == DialogResult.No)
                return;

            int IDCI = 0;

            if (Utileria.IsEmpty(txtDescripcion.Text))
            {
                MessageBox.Show("NO SE ACEPTAN CAMPOS VACIOS EN LA DESCRIPCION", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            SqlConnection Connection = UsoBD.ConectaBD(Utileria.GetConnectionString());

            if (Connection == null)
            {
                MessageBox.Show("ERROR DE CONEXIÓN CON LA BASE DE DATOS");

                foreach (SqlError E in UsoBD.ESalida.Errors)
                    MessageBox.Show(E.Message);
                return;
            }

            SqlDataReader Lector = null;
            string strComandoC = "SELECT ID FROM CI WHERE NumSerie LIKE '" + cmbNumCI.SelectedItem.ToString() + "'";
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
                    IDCI = Convert.ToInt32(Lector.GetValue(0).ToString());
                }
            }
            Connection.Close();
            AdmIn.AddInCI(txtDescripcion.Text, maskDate.Text, IDCI, Tipo, IDEmp);
        }
    }
}
