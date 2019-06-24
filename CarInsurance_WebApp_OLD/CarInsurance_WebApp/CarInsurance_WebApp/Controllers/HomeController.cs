using CarInsurance_WebApp.Controllers;
using CarInsurance_WebApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CarInsurance_WebApp.Controllers
{
    public class HomeController : Controller
    {
        static WebAppDataController _data;
        static WebAppExtController _ext;
        static db_insuranceEntities_  _db;
        static vinsuree_data_all _vdata;

        static HomeController()
        {
            // instantiate data objects 
            _db = new db_insuranceEntities_();
            _vdata = new vinsuree_data_all();

            // instantiate controller(s)
            _data = new WebAppDataController();
            _ext = new WebAppExtController();
        }

        #region GET_actions
        // GET : Index page
        public ActionResult Index()
        {
            // pass data from db to View
            return View(_db.vinsuree_data_all.ToList());
        }

        // GET: Admin page
        public ActionResult Admin()
        {
            return View();
        }

        // GET: Create page
        public ActionResult Create()
        {
            List<string> dui = new List<string>();
            dui = _ext.DUI();

            ViewBag.Dui = new SelectList(dui, "dui", "dui2");

            return View();
        }
        #endregion

        #region POST_actions
        // POST: create db record
        [HttpPost]
        public ActionResult Create(vinsuree_data_all rec)
        {
            bool pass;

            pass = _ext.CheckFieldVals(rec); // validate req fields are populated
            if (!pass) { ViewBag.ErrorMessage = "All fields required for record creation."; return View("Error"); }

            pass = _data.DataInsert(_db, rec); // insert record to db
            if (!pass) { ViewBag.ErrorMessage = "Error on record creation at WebAppDataController.DataInsert()"; return View("Error"); }

            return View();
        }

        // POST: update db record
        [HttpPost]
        public ActionResult Edit(int key)
        {
            // narrow to edit record
            var edit = (from rec in _db.vinsuree_data_all
                             where rec.insuree_key == key
                             select rec).First();

            return View(edit);
        }
        #endregion

        #region RESULT_actions
        public ActionResult Success()
        {
            return View(_db.vinsuree_data_all.OrderByDescending(x => x.curr_quote).Take(1).ToList());
        }

        public ActionResult Delete()
        {
            return View();
        }
        #endregion
    }
}