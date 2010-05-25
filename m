From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH/RFC] opensm: toggle sweeping V2
Date: Tue, 25 May 2010 18:14:02 +0300
Message-ID: <20100525151402.GT28549@me>
References: <20100519235727.GP7678@sgi.com>
 <20100522170431.GU28549@me>
 <20100524211830.GJ2678@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100524211830.GJ2678-sJ/iWh9BUns@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dale.R.Talcott-NSQ8wuThN14@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 14:18 Mon 24 May     , Arthur Kepner wrote:
> > > .....
> > >  	/* do a sweep if we received a trap */
> > >  	if (sm->p_subn->opt.sweep_on_trap) {
> > 
> > > -		/* if this is trap number 128 or run_heavy_sweep is TRUE -
> > > -		   update the force_heavy_sweep flag of the subnet.
> > > -		   Sweep also on traps 144 - these traps signal a change of
> > > -		   certain port capabilities.
> > > -		   TODO: In the future this can be changed to just getting
> > > -		   PortInfo on this port instead of sweeping the entire subnet. */
> > > -		if (ib_notice_is_generic(p_ntci) &&
> > > -		    (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 128 ||
> > > -		     cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 144 ||
> > > -		     run_heavy_sweep)) {
> > > -			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
> > > -				"Forcing heavy sweep. Received trap:%u\n",
> > > +		if (!sm->p_subn->sweeping_enabled) {
> > > +			OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
> > > +				"sweeping disabled - ignoring trap %u\n",
> > >  				cl_ntoh16(p_ntci->g_or_v.generic.trap_num));
> > 
> > Isn't this case already handled in osm_state_mgr_process() and this code
> > addition in osm_trap_rcv.c redundant?
> 
> It is redundant.

So could you remove this part from the patch? The rest seems fine for
me.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
