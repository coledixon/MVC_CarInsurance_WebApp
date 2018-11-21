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

        // instantiate model(s)
        car_main _car = new car_main();
        insuree_main _main = new insuree_main();
        insuree_info _info = new insuree_info();
        insuree_hist _hist = new insuree_hist();
        insuree_quote _quote = new insuree_quote();

        #region GET_select
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

        #region POST_insert/update
        [HttpPost]
        public bool DataInsert(db_insuranceEntities db, vinsuree_data_all data)
        {
            bool res = true; // default to pass

            ParseDataHelper(data);
            SetTableValHelper(db);

            try { db.SaveChanges(); }
            catch (Exception ex) { throw new Exception(ex.Message); }

            return res;
        }

        [HttpPost]
        public bool DataInsert(db_insuranceEntities db)
        {
            bool res = false; // default to fail
            
            return res;
        }

        [HttpPost]
        public bool DataUpdate(db_insuranceEntities db, [Bind(Exclude = "insuree_key")] vinsuree_data_all data, int key)
        {
            bool res = false; // default to fail

            db.SaveChanges();

            return res;
        }
        #endregion

        #region DEL_delete
        [HttpDelete]
        public bool DataDelete(db_insuranceEntities db, vinsuree_data_all data, int key)
        {
            bool res = false; // default to fail

            return res;
        }
        #endregion

        #region helpers
        // parse data values to correct table prior saving
        private void ParseDataHelper(vinsuree_data_all data)
        {
            try
            {
                // car_main
                _car.car_year = data.car_year.GetValueOrDefault();
                _car.car_make = data.car_make;
                _car.car_model = data.car_model;

                // insuree_main
                _main.first_name = data.first_name;
                _main.last_name = data.last_name;

                // insuree_info
                _info.email = data.email;
                _info.dob = data.dob.GetValueOrDefault();
                _info.state = ext.ValidateParseStateCode(data.state); // validate
                _info.zip = data.zip.GetValueOrDefault();

                // insuree_hist
                _hist.dui = data.dui.GetValueOrDefault();
                _hist.tickets = data.tickets.GetValueOrDefault();

                // insuree_quote
                _quote.curr_quote = data.curr_quote = ext.CalcQuote(data);
                // WIP _quote.prev_quote = data.prev_quote;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        private void SetTableValHelper(db_insuranceEntities db)
        {
            try
            {
                db.car_main.Add(_car);
                db.insuree_main.Add(_main);
                db.insuree_info.Add(_info);
                db.insuree_hist.Add(_hist);
                db.insuree_quote.Add(_quote);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        #endregion
    }
}