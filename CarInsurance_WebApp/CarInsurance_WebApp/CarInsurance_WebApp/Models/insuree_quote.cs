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
    
    public partial class insuree_quote
    {
        public int insuree_key { get; set; }
        public string coverage_type { get; set; }
        public string curr_quote { get; set; }
        public string prev_quote { get; set; }
    
        public virtual insuree_main insuree_main { get; set; }
    }
}
