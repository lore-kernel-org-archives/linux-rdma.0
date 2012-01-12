From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] opensm: Get correct guid in case of multiple ports
Date: Thu, 12 Jan 2012 12:45:34 -0600
Message-ID: <20120112184533.GA8168@shrek.cartoons>
References: <20111005183610.GA18253@shrek.cartoons>
 <20120111121005.GB2254@calypso>
 <20120111160231.GA3498@shrek.cartoons>
 <20120112172330.GD6571@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120112172330.GD6571@calypso>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Alex,

On Thu, Jan 12, 2012 at 07:23:30PM +0200, Alex Netes wrote:
> Hi Goldwyn,
> 
> On 10:02 Wed 11 Jan     , Goldwyn Rodrigues wrote:
> > 
> > Hi Alex,
> > 
> > Let me start with how we encountered the problem:
> > This problem came up when our customer was using a 2 port card with only
> > one of the port active. opensm could not get the guid of the port
> > that was active in daemon mode.
> 
> I guess it's because your costumer runs opensm with "-g 0 -B" in command line.
> 
> > 
> > > On 13:36 Wed 05 Oct     , Goldwyn Rodrigues wrote:
> > > > 
> > > > In case of multiple ports and running in daemon mode, the active port is not selected because opt.guid is set to INVALID_GUID in main() but the check in get_port_guid is done against zero: 
> > > > 	if (port_guid == 0) {
> > > 
> > > opt.guid is set to 0 by default.
> > > opt.guid is set to INVALID_GUID if a user used "-g WRONG_GUID" command line
> > > option when executing the SM. 
> > 
> > What happens when "-g 0 -B" is specified? Check the getopt code. It sets guid
> > to INVALID_GUID. Consider /etc/sysconfig/opensm  as well.
> 
> You are correct. Setting argument "-g 0" will set port_guid to INVALID_GUID.
> From OpenSM man page:
> -g, --guid <GUID in hex>
> 	This option specifies the local port GUID value with which OpenSM
> 	should bind.  OpenSM may be bound to 1 port at a time.  If GUID given
> 	is 0, OpenSM displays a list of possible port GUIDs and waits for user
> 	input.  Without -g, OpenSM tries to use the default port.
> 
> So I guess the behavior of running OpenSM with "-g 0 -B" is undefined. I think
> it's better to exit than execute OpenSM with wrong parameter.

Think from a user POV instead of a programmer's POV. A user will be
confused when he attempts to start the daemon and the daemon just exits.
Could opensm atleast complain about it saying that the options
are incompatible or it does not want to use the available guids?

> 
> Moreover, there is no problem when you set "guid 0" in the opensm.conf and run
> opensm as a daemon (actually this is the default).

Have you tried it with multi-port? For 1 port, get_port_guid() selects the
default one because num_ports is 1 and the daemon will not exit, even if
you supply " -g 0 -B". 

BTW, We are using SLES 11.

> > 
> > What happens when you provide "-g WRONG_GUID -B"?
> > I think in this case, -B should take priority and set with the first
> > active port available.
> 
> I think that in that case, a user intended to bind OpenSM on specific port and
> it could be a major issue if OpenSM will automatically binds to a different
> port.
> 
> > 
> > 
> > > In that case, when SM runs not in daemon mode,
> > > SM prompts the user to choose available port GUID out of available range.
> > > In case when SM runs in daemon mode, it can't prompt the user so it just exits.
> > > 
> > > > 
> > > > On second thoughts, passing port_guid is worthless because this function is called only when no guid is supplied at the command prompt. So, removed the port_guid parameter from the function altogether.
> > > > 
> > > > If not in daemon mode, it would show the list of ports as intended.
> > > > 
> > > > Also added error message if no ports are found.
> > > > 
> > > > Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
> > > > 
> > > > diff --git a/opensm/main.c b/opensm/main.c
> > > > index 51c8291..a236859 100644
> > > > --- a/opensm/main.c
> > > > +++ b/opensm/main.c
> > > > @@ -403,7 +403,7 @@ static void show_usage(void)
> > > >  	exit(2);
> > > >  }
> > > >  
> > > > -static ib_net64_t get_port_guid(IN osm_opensm_t * p_osm, uint64_t port_guid)
> > > > +static ib_net64_t get_port_guid(IN osm_opensm_t *p_osm)
> > > >  {
> > > >  	ib_port_attr_t attr_array[MAX_LOCAL_IBPORTS];
> > > >  	uint32_t num_ports = MAX_LOCAL_IBPORTS;
> > > > @@ -436,21 +436,19 @@ static ib_net64_t get_port_guid(IN osm_opensm_t * p_osm, uint64_t port_guid)
> > > >  		       cl_hton64(attr_array[0].port_guid));
> > > >  		return attr_array[0].port_guid;
> > > >  	}
> > > > -	/* If port_guid is 0 - use the first connected port */
> > > > -	if (port_guid == 0) {
> > > > +	/* If in daemon mode autoselect first available port */
> > > > +	if (p_osm->subn.opt.daemon) {
> > > >  		for (i = 0; i < num_ports; i++)
> > > >  			if (attr_array[i].link_state > IB_LINK_DOWN)
> > > >  				break;
> > > > +		/* No port found which is available */
> > > >  		if (i == num_ports)
> > > > -			i = 0;
> > > > +			return 0;
> > > >  		printf("Using default GUID 0x%" PRIx64 "\n",
> > > >  		       cl_hton64(attr_array[i].port_guid));
> > > >  		return attr_array[i].port_guid;
> > > >  	}
> > > >  
> > > > -	if (p_osm->subn.opt.daemon)
> > > > -		return 0;
> > > > -
> > > >  	/* More than one possible port - list all ports and let the user
> > > >  	 * to choose. */
> > > >  	while (1) {
> > > > @@ -1106,10 +1104,12 @@ int main(int argc, char *argv[])
> > > >  	   then get a port GUID value with which to bind.
> > > >  	 */
> > > >  	if (opt.guid == 0 || cl_hton64(opt.guid) == CL_HTON64(INVALID_GUID))
> > > > -		opt.guid = get_port_guid(&osm, opt.guid);
> > > > +		opt.guid = get_port_guid(&osm);
> > > >  
> > > > -	if (opt.guid == 0)
> > > > +	if (opt.guid == 0) {
> > > > +		printf("\nError: No available ports\n");
> > > >  		goto Exit;
> > > > +	}
> > > >  
> > > >  	status = osm_opensm_bind(&osm, opt.guid);
> > > >  	if (status != IB_SUCCESS) {
> > > > 
> > > > -- 
> > > > Goldwyn
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > > -- 
> > > 
> > > -- Alex
> > 
> > -- 
> > Goldwyn
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> 
> -- Alex

-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
