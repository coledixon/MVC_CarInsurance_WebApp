﻿using CarInsurance_WebApp.Controllers;
using CarInsurance_WebApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Mvc;

namespace CarInsurance_WebApp.Controllers
{
    public class WebAppExtController : Controller
    {
        public string CalcQuote(vinsuree_data_all data)
        {
            decimal quote = 50.00M; // default quote val

            // age logic
            quote = (DateTime.Now.Year - data.dob.Value.Year > 25) ? quote + 25.00M : quote;
            quote = (DateTime.Now.Year - data.dob.Value.Year < 18) ? quote + 25.00M : quote;
            quote = (DateTime.Now.Year - data.dob.Value.Year > 100) ? quote + 25.00M : quote;

            // automobile logic
            quote = (data.car_year < 2000) ? quote + 25.00M : quote;
            quote = (data.car_year > 2015) ? quote + 25.00M : quote;
            quote = (data.car_make.ToLower() == "porsche") ? quote + 25.00M : quote;
            quote = (data.car_make.ToLower() == "porsche" && data.car_model.Contains("carrera")) ? quote + 25.00M : quote;
            
            // risk logic
            //TO DO quote = (data.tickets > 4) ? quote + (data.tickets * 10).Value : quote;
            //TO DO quote = (data.dui > 0) ? quote + (Decimal.Multiply(quote, .25M)): quote;
            quote = (data.coverage_type.ToLower() == "full") ? quote + (Decimal.Multiply(quote, .25M)) : quote;

            return quote.ToString();
        }

        // validate/parse state code submitted exists in US
        public string ValidateParseStateCode(string state)
        {
            List<US_State> _states;
            _states = StateCodeArray.States().ToList();

            if (state.Length > 2)
            {
                foreach (US_State s in _states)
                {
                    if (s.Name.ToLower() == state.ToLower()) { state = s.Abbr.ToUpper(); }
                }
                if (state.Length > 2) { throw new Exception("Invalid state name for US."); }
            }
            else
            {
                foreach (US_State ab in _states)
                {
                    if (ab.Abbr.ToUpper() == state.ToUpper()) { state = state.ToUpper(); }
                    else { throw new Exception("Invalid state code for US."); }
                }
            }

            return state;
        }

        // validate cshtml fields are populated
        public bool CheckFieldVals(vinsuree_data_all data)
        {
            bool res = true; // default to valid
            PropertyInfo[] props = typeof(vinsuree_data_all).GetProperties();

            var _props = new List<PropertyInfo>(props);
            _props.RemoveRange(13,2); // remove quote vals
            _props.ToArray();

            foreach (PropertyInfo prop in _props)
            {
                object value = prop.GetValue(data, null);
                if (value == null)
                {
                    return res = false;
                }
            }

            return res;
        }

        // define lists for cshtml dropdowns
        #region dropdown
        public List<string> DUI()
        {
            var dui = new List<string>
            {
                "true",
                "false"
            };

            return dui;
        }

        public List<int> TICKETS()
        {
            var tix = new List<int>();

            tix.Add(0); tix.Add(1);
            tix.Add(2); tix.Add(3);
            tix.Add(4); tix.Add(5);

            return tix;
        }
        #endregion
    }
}