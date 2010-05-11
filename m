From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 1/2] libibnetdisc: Convert to a multi-smp algorithm
Date: Tue, 11 May 2010 19:42:34 +0300
Message-ID: <20100511164234.GF28549@me>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
 <20100413104658.GA10830@me>
 <20100413132531.GI10830@me>
 <20100422191231.bf6021fb.weiny2@llnl.gov>
 <20100507205052.GW7099@me.iol.unh.edu>
 <20100510135353.257d76c0.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100510135353.257d76c0.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13:53 Mon 10 May     , Ira Weiny wrote:
> > > 
> > >    int ibnd_discover_fabric(ibnd_fabric_t **fabric,
> > > 			    cosnt char *ca_name,  <== could we even default this?
> > 
> > I would think about ca_name and port_number. And this is of course may
> > have default (NULL, 0).
> 
> Ok, ca_name and ca_port will be explicit.
> 
> > 
> > > 			    struct ibnd_config *cfg);
> > 
> > What is wrong with current ibdn_fabric_t *ibnd_discover_fabric(...)? Why
> > do we need an extra parameter?
> 
> Well we are breaking the interface again so I figure we might as well clean some things up.  Returning an int allows us to have a reason for the failure returned to the caller rather than just "NULL".  We have cleaned up most of the internals of the library to allow for this.

But we want to keep API simple, no?

> 
> > 
> > > 
> > > I don't mind the ibnd_config_t struct but I don't think it should be visible
> > > to the user.  Make it opaque and use "set" functions.  Something like.
> > > 
> > > ibnd_fabric_t *fabric;
> > > ibnd_config_t cfg;
> > > ib_portid_t * from;
> > > 
> > > ibnd_set_hops(&cfg, hops);         <== default -1
> > > ibnd_set_port_num(&cfg, port_num); <== default 1
> > > ibnd_set_max_smps(&cfg, max_smps); <== default 2
> > > ibnd_set_from_node(&cfg, from);    <== default NULL
> > 
> > I would prefer to not complicate API with ibnd_set_this() helpers. It
> > would be necessary to add new ones in the future which will lead to API
> > changes.
> 
> See below.
> 
> > 
> > > if (ibnd_discover_fabric(&fabric, "foo", &cfg)) {  <== anything not in cfg is
> > >                                                        defaulted here
> > >    fprintf(stderr, "Wow it failed\n");
> > > }
> > > 
> > > This allows us to change ibnd_config structure any time we want without
> > > affecting the API.  I don't think the "pad" you used is a good idea.
> > 
> > Without padding we will break ABI each time when new field is added to
> > the config structure.
> 
> No it does not iff you use the ibnd_set_this() helpers and make the config private.

In you example 'ibnd_config_t cfg' is on the stack... :)

I would really suggest to keep API simple and useful - to fill up
a structure described in header files is much simpler than pass over
various helpers calls.

Sasha

> 
> > 
> > > Also since we are breaking the API we might as well return the fabric as a
> > > parameter and have an error code.  But I could go either way on this one.
> > > 
> > > Ira
> > > 
> > > 
> > > [*] query_smp.c probably should have it's own timeout here but we can discuss
> > > later.
> > > 
> > > [#] What sucks about this is that libibmad already has the functionality to
> > > open the umad port and configure it (50 line function).  Now we will be
> > > duplicating this functionality.
> > 
> > I think you can use mad_rpc_open_port(ca_name, port_number, ...) just
> > fine (and so the rest of libibmad stuff) - it will open separate fd.
> 
> Yes for the libibmad functionality we can do that.  I was speaking of the use of the umad layer.  To use that layer we have to duplicate the functionality of mad_rpc_open_port in every tool which requires umad layer access, correct?  Right now we are mixing the 2 layers (mad and umad) in saquery (get_bind_handle) as well as libibnetdisc.
> 
> I think we need to be careful we don't do this again!
> 
> Ira
> 
> > 
> > Sasha
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://*vger.kernel.org/majordomo-info.html
> > 
> 
> 
> -- 
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
