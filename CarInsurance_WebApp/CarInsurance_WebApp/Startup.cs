using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(CarInsurance_WebApp.Startup))]
namespace CarInsurance_WebApp
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
