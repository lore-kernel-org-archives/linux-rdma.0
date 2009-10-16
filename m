From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] opensm: add force_link_speed_file config option.
Date: Thu, 15 Oct 2009 17:04:28 -0700
Message-ID: <20091015170428.4e75735f.weiny2@llnl.gov>
References: <20091015132650.6e8b8dde.weiny2@llnl.gov>
	<20091015212601.GK20210@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091015212601.GK20210@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 15 Oct 2009 23:26:01 +0200
Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> Hi Ira,
> 
> On 13:26 Thu 15 Oct     , Ira Weiny wrote:
> > 
> > From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > Date: Wed, 14 Oct 2009 16:09:25 -0700
> > Subject: [PATCH] opensm: add force_link_speed_file config option.
> > 
> > 	From the config file help:
> > 
> > 	# Optional file used to override individual port GUIDs and speeds to be forced.
> 
> And what about width and other potentially tunable port parameters?

I don't think width is "tunable" via the spec.  The force_link_speed option
was a non-standard work around for potentially bad hardware.  I was trying to
avoid going down the non-standard path too much.

> 
> I would suggest instead of adding config file per option to develop more
> generic config file(s) framework where various per port (or in even more
> generic case per port group) PortInfo parameters could be preconfigured.
> BTW it could include some existing stuff like sl2vl, vlarb, etc..

Ok I could see some of these parameters being included on a per port basis.  I
will make the file generic but I don't have time right now to include every
option we could think of.  What type of file format were you thinking?
Something like:

<begin>
# Port Option Config File

# compute node with profiling turned off forced to max of DDR speed
0x0002c9030004ea79 force_link_speed=3,cn=true,port_profile=false

# root guid running at link speed supported
0x0002c9020023c288 force_link_speed=15,root=true

<end>

Combine port_prof_ignore_file, root_guid_file, cn_guid_file, io_guid_file,
ids_guid_file, guid_routing_order_file, and add in a sl2vl and vlarb setting
to this file?  This is a bit of work.

> 
> Some other comments are below.
> 

[snip]

> > diff --git a/opensm/opensm/osm_link_mgr.c b/opensm/opensm/osm_link_mgr.c
> > index c9bdfee..21dcc50 100644
> > --- a/opensm/opensm/osm_link_mgr.c
> > +++ b/opensm/opensm/osm_link_mgr.c
> > @@ -106,6 +106,8 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
> >  	boolean_t esp0 = FALSE, send_set = FALSE;
> >  	osm_physp_t *p_remote_physp;
> >  	int ret = 0;
> > +	uint8_t force_link_speed;
> > +	force_speed_exception_t *except;
> 
> I would suggest to avoid word "exception" - it is not actually exception
> but rather desired configuration, - when not requested default value is
> used.

Yea, I thought the same thing but it is an "exception" to the
"force_link_speed" option.  GUID's which are not listed in this map/file will
default to the "force_link_speed" setting.  Therefore, GUID's in this file are
an exception...

However, I can see the confusion, I will change the name.

> > @@ -927,6 +930,73 @@ static ib_api_status_t osm_parse_prefix_routes_file(IN osm_subn_t * p_subn)
> >  
> >  /**********************************************************************
> >   **********************************************************************/
> > +void osm_parse_force_link_speed_except_file(IN osm_opensm_t * const p_osm,
> > +					    IN char *file)
> 
> We have generic guid file parser helper already - parse_node_map().

Ok, I will use this.

>
> Also instead of keeping yet another port map you can just add desired
> configuration parameters to existing port (osm_physp) structure.

I don't think so, this is read at startup.  There will not be any osm_physp
structures at that time...

Ah, ok, I see how this is done with other things now...  The file is parsed
during runtime when you need the option value...  Don't you think that might
be slow?  Especially if we combine all these port options into one big config
file?  If we had settings for root guids, ignore profiling, routing order,
link speed overrides, io nodes, cn nodes, etc, this is going to be a lot of
file open, parsing from the start of a file, and file closes.

[snip]

> >  
> > @@ -1331,8 +1413,18 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
> >  		"#    5: 2.5 or 10.0 Gbps\n"
> >  		"#    7: 2.5 or 5.0 or 10.0 Gbps\n"
> >  		"#    2,4,6,8-14 Reserved\n"
> > -		"#    Default 15: set to PortInfo:LinkSpeedSupported\n"
> > +		"#    Default %d: set to PortInfo:LinkSpeedSupported\n"
> >  		"force_link_speed %u\n\n"
> > +		"# Optional file used to override individual port GUIDs and speeds to be forced.\n"
> > +		"# Port GUIDs which are _not_ listed in this file will be set to \"force_link_speed\"\n"
> > +		"# Speeds specified in this file may be higher or lower than the global setting\n"
> > +		"# (force_link_speed) above\n"
> > +		"# File Format:\n"
> > +		"# # comment\n"
> > +		"# <port_guid> [<setting>] [# comment]\n"
> > +		"# ...\n"
> > +		"# if the optional <setting> is not specified the default (%d) will be used\n"
> > +		"force_link_speed_file %s\n\n"
> >  		"# The subnet_timeout code that will be set for all the ports\n"
> >  		"# The actual timeout is 4.096usec * 2^<subnet_timeout>\n"
> >  		"subnet_timeout %u\n\n"
> > @@ -1355,7 +1447,10 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
> >  		p_opts->head_of_queue_lifetime,
> >  		p_opts->leaf_head_of_queue_lifetime,
> >  		p_opts->max_op_vls,
> > +		OSM_DEFAULT_FORCE_LINK_SPEED,
> >  		p_opts->force_link_speed,
> > +		OSM_DEFAULT_FORCE_LINK_SPEED,
> 
> Shouldn't here be p_opts->force_link_speed?

No, one could leave out "<setting>" and the default will be set.

0x0005ad0000092106    # set to 15: LinkSpeedSupported
0x0002c9020040fec8  3 # set to  3: 2.5 or 5.0 Gbps

This way a user only has to list the GUIDs of the ports they want running at
full supported speed.  This maps well with our current usage where most of a
cluster is forced to some speed but a small part (maybe 1 switch) can run at
full supported speed.  This is where the "exception" comes into the verbiage
above.  ;-)

Anyway, if we go with a generic port config this does not matter.  Let me know
what you were thinking for a file format.  Does the format I mentioned in the
beginning work for you?

Ira

[snip]

-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
