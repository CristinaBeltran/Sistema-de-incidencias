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
    public partial class frmBajaEmpleado : Form
    {
        public frmBajaEmpleado()
        {
            InitializeComponent();
        }

        private void frmBajaEmpleado_Load(object sender, EventArgs e)
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
            string NA = "", EM = "", CE = "", DI = "", RO = "";
            string strComandoC = "SELECT E.Nombre,Email,Celular,Direccion,R.Nombre FROM EMPLEADO E INNER JOIN ROL R ON E.ID_Rol=R.ID";
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
                    NA = Lector.GetValue(0).ToString();
                    EM = Lector.GetValue(1).ToString();
                    CE = Lector.GetValue(2).ToString();
                    DI = Lector.GetValue(3).ToString();
                    RO = Lector.GetValue(3).ToString();

                    ListViewItem Registro = new ListViewItem(NA);
                    Registro.SubItems.Add(EM);
                    Registro.SubItems.Add(CE);
                    Registro.SubItems.Add(DI);
                    Registro.SubItems.Add(RO);

                    lvEmpleados.Items.Add(Registro);
                }
            }
            Connection.Close();
        }

        private void btnEliminar_Click(object sender, EventArgs e)
        {
            if (lvEmpleados.SelectedItems.Count == 0)
            {
                MessageBox.Show("NO HA SELECCIONADO NINGUN EMPLEADO", "SIN SELECCIONAR", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }
            DialogResult R = MessageBox.Show("¿DESEA ELIMINAR EL EMPLEADO SELECCIONADO?", "CONFIRMAR", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (R == DialogResult.Yes)
            {
                string NA, EM;
                for (int i = 0; i < lvEmpleados.Items.Count; i++)
                {
                    if (lvEmpleados.SelectedItems.Contains(lvEmpleados.Items[i]))
                    {
                        NA = lvEmpleados.Items[i].SubItems[0].Text;
                        EM = lvEmpleados.Items[i].SubItems[1].Text;

                        SqlConnection Connection = UsoBD.ConectaBD(Utileria.GetConnectionString());

                        if (Connection == null)
                        {
                            MessageBox.Show("ERROR DE CONEXIÓN CON LA BASE DE DATOS");

                            foreach (SqlError E in UsoBD.ESalida.Errors)
                                MessageBox.Show(E.Message);

                            return;
                        }

                        SqlDataReader Lector = null;

                        string strComandoC = "DELETE FROM EMPLEADO WHERE Nombre LIKE '"+NA+ "' AND Email LIKE '"+EM+"'";

                        Lector = UsoBD.Consulta(strComandoC, Connection);
                        if (Lector == null)
                        {
                            MessageBox.Show("ERROR AL HACER LA CONSULTA");
                            foreach (SqlError E in UsoBD.ESalida.Errors)
                                MessageBox.Show(E.Message);

                            Connection.Close();
                            return;
                        }
                        Connection.Close();
                        lvEmpleados.Items[i].Remove();
                        MessageBox.Show("LA ELIMINACION DEL EMPLEADO SE HA REALIZADO CORRECTAMENTE", "ELIMINACION REALIZADA", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        return;
                    }
                }
            }
        }
    }
}
