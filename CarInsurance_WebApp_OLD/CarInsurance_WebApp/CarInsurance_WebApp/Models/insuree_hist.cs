//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CarInsurance_WebApp.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class insuree_hist
    {
        public int hist_key { get; set; }
        public int insuree_key { get; set; }
        public string dui { get; set; }
        public string tickets { get; set; }
    
        public virtual insuree_main insuree_main { get; set; }
    }
}