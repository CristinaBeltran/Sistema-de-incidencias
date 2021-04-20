using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using LibreriaBD;

namespace GestionDeOperacionesTI
{
    public class ManejaDepartamento
    {
        public bool AddDepto(string Nombre, int Encargado)
        {
            SqlConnection Connection = UsoBD.ConectaBD(Utileria.GetConnectionString());

            if (Connection == null)
            {
                MessageBox.Show("ERROR DE CONEXIÓN CON LA BASE DE DATOS");

                foreach (SqlError E in UsoBD.ESalida.Errors)
                    MessageBox.Show(E.Message);
                return false;
            }


            string strComando = "INSERT INTO DEPARTAMENTO(Nombre,ID_EmpEncar)";
            strComando += " VALUES(@Nombre, @Encargado)";

            SqlCommand Insert = new SqlCommand(strComando, Connection);

            Insert.Parameters.AddWithValue("@Nombre", Nombre.Trim());
            Insert.Parameters.AddWithValue("@Encargado", Encargado);

            try
            {
                Insert.ExecuteNonQuery();
            }
            catch (SqlException Ex)
            {
                foreach (SqlError item in Ex.Errors)
                    MessageBox.Show(item.Message);

                Connection.Close();
                return false;
            }
            Connection.Close();
            return true;
        }
    }
}
