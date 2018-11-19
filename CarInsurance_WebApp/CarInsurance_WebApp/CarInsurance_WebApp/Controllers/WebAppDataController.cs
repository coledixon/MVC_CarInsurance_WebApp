using CarInsurance_WebApp.Controllers;
using CarInsurance_WebApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CarInsurance_WebApp.Controllers
{
    public class WebAppDataController : Controller
    {
        // instantiate controller(s)
        WebAppExtController ext = new WebAppExtController();

        #region select
        [HttpGet]
        public bool DataSelect(db_insuranceEntities db, vinsuree_data_all data) // load all applicable records
        {
            bool res = false; // default to fail

            return res;
        }

        [HttpGet]
        public bool DataSelect(db_insuranceEntities db, vinsuree_data_all data, int key) // single record select
        {
            bool res = false; // default to fail

            return res;
        }
        #endregion

        #region insert/update
        [HttpPost]
        public bool DataInsert(db_insuranceEntities db, vinsuree_data_all data)
        {
            bool res = false; // default to fail

            data.curr_quote = ext.CalcQuote(data);

            db.vinsuree_data_all.Add(data);
            db.SaveChanges();

            return res;
        }

        [HttpPost]
        public bool DataUpdate(db_insuranceEntities db, [Bind(Exclude = "insuree_key")] vinsuree_data_all data, int key)
        {
            bool res = false; // default to fail

            db.vinsuree_data_all.Add(data);
            db.SaveChanges();

            return res;
        }
        #endregion

        #region delete
        [HttpDelete]
        public bool DataDelete(db_insuranceEntities db, vinsuree_data_all data, int key)
        {
            bool res = false; // default to fail

            return res;
        }
        #endregion
    }
}