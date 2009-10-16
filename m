From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: add force_link_speed_file config option.
Date: Fri, 16 Oct 2009 18:47:54 +0200
Message-ID: <20091016164754.GT20210@me>
References: <20091015132650.6e8b8dde.weiny2@llnl.gov>
 <20091015212601.GK20210@me>
 <20091015170428.4e75735f.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091015170428.4e75735f.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 17:04 Thu 15 Oct     , Ira Weiny wrote:
> 
> Ok I could see some of these parameters being included on a per port basis.  I
> will make the file generic but I don't have time right now to include every
> option we could think of.  What type of file format were you thinking?
> Something like:
> 
> <begin>
> # Port Option Config File
> 
> # compute node with profiling turned off forced to max of DDR speed
> 0x0002c9030004ea79 force_link_speed=3,cn=true,port_profile=false
> 
> # root guid running at link speed supported
> 0x0002c9020023c288 force_link_speed=15,root=true
> 
> <end>

Such format example may work. But I wouldn't mix port parameters (PortInfo
and friends) with other things like routing. So right now it could be
something like:

<guid> LinkSpeed=3, LinkWidth=1, sl2vl="..." ..., etc.

> This is a bit of work.

To make this reasonably simple it can be fine to start with implementing
just LinkSpeed.

> > Also instead of keeping yet another port map you can just add desired
> > configuration parameters to existing port (osm_physp) structure.
> 
> I don't think so, this is read at startup.  There will not be any osm_physp
> structures at that time...

You may want to update the file content without restarting OpenSM. If so
it would be reasonable to read the file at sweep time after subnet
discovery.

> Ah, ok, I see how this is done with other things now...  The file is parsed
> during runtime when you need the option value...  Don't you think that might
> be slow?  Especially if we combine all these port options into one big config
> file?  If we had settings for root guids, ignore profiling, routing order,
> link speed overrides, io nodes, cn nodes, etc, this is going to be a lot of
> file open, parsing from the start of a file, and file closes.

Comparing to other sweep activities it is not a big overhead and this
let us to keep configuration dynamically.

> [snip]
> 
> > >  
> > > @@ -1331,8 +1413,18 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
> > >  		"#    5: 2.5 or 10.0 Gbps\n"
> > >  		"#    7: 2.5 or 5.0 or 10.0 Gbps\n"
> > >  		"#    2,4,6,8-14 Reserved\n"
> > > -		"#    Default 15: set to PortInfo:LinkSpeedSupported\n"
> > > +		"#    Default %d: set to PortInfo:LinkSpeedSupported\n"
> > >  		"force_link_speed %u\n\n"
> > > +		"# Optional file used to override individual port GUIDs and speeds to be forced.\n"
> > > +		"# Port GUIDs which are _not_ listed in this file will be set to \"force_link_speed\"\n"
> > > +		"# Speeds specified in this file may be higher or lower than the global setting\n"
> > > +		"# (force_link_speed) above\n"
> > > +		"# File Format:\n"
> > > +		"# # comment\n"
> > > +		"# <port_guid> [<setting>] [# comment]\n"
> > > +		"# ...\n"
> > > +		"# if the optional <setting> is not specified the default (%d) will be used\n"
> > > +		"force_link_speed_file %s\n\n"
> > >  		"# The subnet_timeout code that will be set for all the ports\n"
> > >  		"# The actual timeout is 4.096usec * 2^<subnet_timeout>\n"
> > >  		"subnet_timeout %u\n\n"
> > > @@ -1355,7 +1447,10 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
> > >  		p_opts->head_of_queue_lifetime,
> > >  		p_opts->leaf_head_of_queue_lifetime,
> > >  		p_opts->max_op_vls,
> > > +		OSM_DEFAULT_FORCE_LINK_SPEED,
> > >  		p_opts->force_link_speed,
> > > +		OSM_DEFAULT_FORCE_LINK_SPEED,
> > 
> > Shouldn't here be p_opts->force_link_speed?
> 
> No, one could leave out "<setting>" and the default will be set.
> 
> 0x0005ad0000092106    # set to 15: LinkSpeedSupported

And when force_link_speed is reconfigured globally in config file and
!= 15?

> 0x0002c9020040fec8  3 # set to  3: 2.5 or 5.0 Gbps
> 
> This way a user only has to list the GUIDs of the ports they want running at
> full supported speed.  This maps well with our current usage where most of a
> cluster is forced to some speed but a small part (maybe 1 switch) can run at
> full supported speed.  This is where the "exception" comes into the verbiage
> above.  ;-)
> 
> Anyway, if we go with a generic port config this does not matter.  Let me know
> what you were thinking for a file format.  Does the format I mentioned in the
> beginning work for you?

Yes, looks fine to me. But maybe we can RFC file format separately.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
