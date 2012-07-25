From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 04/10] opensm: perfmgr delete "inactive" nodes from the
 DB
Date: Wed, 25 Jul 2012 09:19:45 -0700
Message-ID: <20120725091945.46bc418839be9a8e2b93c3e5@llnl.gov>
References: <20120703165312.4096026b.weiny2@llnl.gov>
	<20120725125758.GI5690@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120725125758.GI5690@calypso>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 25 Jul 2012 15:57:58 +0300
Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> Hi Ira,
> 
> On 16:53 Tue 03 Jul     , Ira Weiny wrote:
> > 
> > 
> > When a node drops from the fabric the default behavior was to leave the node
> > data in the PerfMgr DB.  Add the option (with default set to TRUE) to delete
> > these "inactive" or missing nodes from the DB.
> > 
> > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > ---

[snip]

> > +}
> > +
> >  /**********************************************************************
> >   * Dump a reading vs the previous reading to stdout
> >   **********************************************************************/
> > diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
> > index 662e591..06efa9c 100644
> > --- a/opensm/osm_subnet.c
> > +++ b/opensm/osm_subnet.c
> > @@ -493,6 +493,7 @@ static const opt_rec_t opt_tbl[] = {
> >  	{ "perfmgr_max_outstanding_queries", OPT_OFFSET(perfmgr_max_outstanding_queries), opts_parse_uint32, NULL, 0 },
> >  	{ "perfmgr_ignore_cas", OPT_OFFSET(perfmgr_ignore_cas), opts_parse_boolean, NULL, 0 },
> >  	{ "event_db_dump_file", OPT_OFFSET(event_db_dump_file), opts_parse_charp, NULL, 0 },
> > +	{ "perfmgr_rm_nodes", OPT_OFFSET(perfmgr_rm_nodes), opts_parse_boolean, NULL, 0 },
> 
> I guess that this option can be enabled to be changed on the fly, as it might
> be changed also via the console.

yes.

> 
> >  #endif				/* ENABLE_OSM_PERF_MGR */
> >  	{ "event_plugin_name", OPT_OFFSET(event_plugin_name), opts_parse_charp, NULL, 0 },
> >  	{ "event_plugin_options", OPT_OFFSET(event_plugin_options), opts_parse_charp, NULL, 0 },
> > @@ -985,6 +986,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
> >  	    OSM_PERFMGR_DEFAULT_MAX_OUTSTANDING_QUERIES;
> >  	p_opt->perfmgr_ignore_cas = FALSE;
> >  	p_opt->event_db_dump_file = NULL; /* use default */
> > +	p_opt->perfmgr_rm_nodes = TRUE;
> 
> Here you change the default behavior. Any thoughts what is the added value to
> leave disconnected nodes in the DB?

Originally I was thinking that leaving nodes in the DB would reduce the load
on the perfmgr when nodes disappears/reappears for "normal" reasons.  For
example a full reboot of all compute nodes.

As we start to finally ramp up to use this I don't think the load is that
great and we are having issues with hardware replacements leaving nodes in the
DB and causing user confusion (for example they have 2 nodes of the same name
being reported).  So for users I think the default is better set at TRUE.

Ira

> 
> >  #endif				/* ENABLE_OSM_PERF_MGR */
> >  
> >  	p_opt->event_plugin_name = NULL;
> > @@ -2009,12 +2011,15 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
> >  		"perfmgr_sweep_time_s %u\n\n"
> >  		"# Max outstanding queries\n"
> >  		"perfmgr_max_outstanding_queries %u\n"
> > -		"perfmgr_ignore_cas %s\n\n",
> > +		"perfmgr_ignore_cas %s\n\n"
> > +		"# Remove missing nodes from DB\n"
> > +		"perfmgr_rm_nodes %s\n",
> >  		p_opts->perfmgr ? "TRUE" : "FALSE",
> >  		p_opts->perfmgr_redir ? "TRUE" : "FALSE",
> >  		p_opts->perfmgr_sweep_time_s,
> >  		p_opts->perfmgr_max_outstanding_queries,
> > -		p_opts->perfmgr_ignore_cas ? "TRUE" : "FALSE");
> > +		p_opts->perfmgr_ignore_cas ? "TRUE" : "FALSE",
> > +		p_opts->perfmgr_rm_nodes ? "TRUE" : "FALSE");
> >  
> >  	fprintf(out,
> >  		"#\n# Event DB Options\n#\n"
> > -- 
> > 1.7.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
