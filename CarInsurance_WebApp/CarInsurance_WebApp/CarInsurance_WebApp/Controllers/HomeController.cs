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
        // instantiate data objects 
        public static db_insuranceEntities _db = new db_insuranceEntities();
        public vinsuree_data_all _vdata = new vinsuree_data_all();

        // instantiate controller(s)
        WebAppDataController _data = new WebAppDataController();
        WebAppExtController _ext = new WebAppExtController();

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
            return View();
        }
        #endregion

        #region POST_actions
        // POST: create db record
        [HttpPost]
        public ActionResult Create(vinsuree_data_all rec)
        {
            bool pass = _data.DataInsert(_db, rec);
            if (pass) { return View(); }
            else { return View("Error"); }
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