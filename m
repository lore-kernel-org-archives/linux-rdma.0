From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH v3 03/17] opensm: Allow the routing engine to
 participate in path SL calculations.
Date: Tue, 13 Jul 2010 14:12:44 -0600
Message-ID: <1279051964.4812.98.camel@sale659.sandia.gov>
References: <1276631604-29230-1-git-send-email-jaschut@sandia.gov>
 <1276631604-29230-4-git-send-email-jaschut@sandia.gov>
 <20100713183658.GS22860@me>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100713183658.GS22860@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Tue, 2010-07-13 at 12:36 -0600, Sasha Khapyorsky wrote:
> Hi Jim,
> 
> On 13:53 Tue 15 Jun     , Jim Schutt wrote:
> > diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
> > index 093c70d..a323671 100644
> > --- a/opensm/opensm/osm_sa_path_record.c
> > +++ b/opensm/opensm/osm_sa_path_record.c
> > @@ -164,6 +164,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
> >  	const osm_physp_t *p_dest_physp;
> >  	const osm_prtn_t *p_prtn = NULL;
> >  	osm_opensm_t *p_osm;
> > +	struct osm_routing_engine *p_re;
> >  	const ib_port_info_t *p_pi;
> >  	ib_api_status_t status = IB_SUCCESS;
> >  	ib_net16_t pkey;
> > @@ -180,7 +181,6 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
> >  	ib_slvl_table_t *p_slvl_tbl = NULL;
> >  	osm_qos_level_t *p_qos_level = NULL;
> >  	uint16_t valid_sl_mask = 0xffff;
> > -	int is_lash;
> >  	int hops = 0;
> >  
> >  	OSM_LOG_ENTER(sa->p_log);
> > @@ -192,6 +192,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
> >  	p_src_physp = p_physp;
> >  	p_pi = &p_physp->port_info;
> >  	p_osm = sa->p_subn->p_osm;
> > +	p_re = p_osm->routing_engine_used;
> >  
> >  	mtu = ib_port_info_get_mtu_cap(p_pi);
> >  	rate = ib_port_info_compute_rate(p_pi);
> > @@ -667,9 +668,6 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
> >  	 * Set PathRecord SL
> >  	 */
> >  
> > -	is_lash = (p_osm->routing_engine_used &&
> > -		   p_osm->routing_engine_used->type == OSM_ROUTING_ENGINE_TYPE_LASH);
> > -
> >  	if (comp_mask & IB_PR_COMPMASK_SL) {
> >  		/*
> >  		 * Specific SL was requested
> > @@ -686,26 +684,10 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
> >  			goto Exit;
> >  		}
> >  
> > -		if (is_lash
> > -		    && osm_get_lash_sl(p_osm, p_src_port, p_dest_port) != sl) {
> > -			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F23: "
> > -				"Required PathRecord SL (%u) doesn't "
> > -				"match LASH SL\n", sl);
> > -			status = IB_NOT_FOUND;
> > -			goto Exit;
> > -		}
> 
> When specific SL is requested in PR shouldn't it verify this value by
> routing engine provided (just similar as it was done with LASH), so
> something like:
> 
> 	if (p_re && p_re->path_sl &&
> 	    sl != p_re->path_sl(p_re->context, sl, p_src_port, p_dest_port)) {
> 		OSM_LOG("blah-blah\n");
> 		status = IB_NOT_FOUND;
> 		goto Exit;
> 	}
> 
> ?

The problem I'm trying to deal with is that torus-2QoS needs to use
3 SL bits for deadlock avoidance, leaving one SL bit for the
"traffic differentiation" sense of QoS.  torus-2QoS uses bit 3 for
this, so SLs 0-7 all reference one traffic class, and SLs 8-15 all
reference the other traffic class.

Thus, to do as you suggest would require that for an application
to be robustly successful in requesting a particular SL in the
face of torus-2QoS routing, it needs to know 1) that torus-2QoS
is being used; and 2) which of SL bits 0-2 will be set by
torus-2QoS for deadlock avoidance.

Instead, my proposal has the result that for torus-2QoS, apps
ask for a particular SL value as before, and torus-2QoS maps it
onto one of the two possible traffic classes, in a fashion that
prevents message deadlock.

The behavior of routing engines other than LASH are unchanged,
because they all use SL only for traffic differentiation.

I believe that the current behavior of LASH is both not
useful, and also wrong.  But, maybe I am missing some
subtlety about LASH's SL use, so please let me know if so.

I believe that it is not useful because currently LASH uses SL only
for message deadlock avoidance, and has no way to differentiate
classes of traffic.  So anyone who makes a PR request with a 
specific SL in an attempt to differentiate traffic is not 
getting what they think they are getting when LASH is routing.

I think it is wrong because for two instances of the same 
PR request (with SL specified), the first can succeed and 
the second can fail if the fabric topology changed (say due
to a component failure) between requests, and LASH computed
a different SL value for the path.

Under my proposal when LASH is used, PR queries that 
specify SL will now succeed when they previously would have
failed.  I believe this is acceptable because 1) currently
most such queries would fail, since LASH uses SL for
deadlock avoidance, not traffic differentiation; and 2)
since LASH can really only support one class of traffic,
any SL returned in a PR query is OK as long as it provides
deadlock free messaging.

So I believe that my proposal 1) leaves existing routing
engines other that LASH unchanged; 2) changes LASH's behavior
to be more useful; 3) allows torus-2QoS to provide two classes
of traffic without deadlock; and 4) doesn't prescribe how some
yet-to-be-developed routing engine might want to make use
of SL values.

What do you think?

-- Jim

> Sasha
> 
> > -
> > -	} else if (is_lash) {
> > -		/*
> > -		 * No specific SL in PathRecord request.
> > -		 * If it's LASH routing - use its SL.
> > -		 * slid and dest_lid are stored in network in lash.
> > -		 */
> > -		sl = osm_get_lash_sl(p_osm, p_src_port, p_dest_port);
> >  	} else if (p_qos_level && p_qos_level->sl_set) {
> >  		/*
> > -		 * No specific SL was requested, and we're not in
> > -		 * LASH routing, but there is an SL in QoS level.
> > +		 * No specific SL was requested, but there is an SL in
> > +		 * QoS level.
> >  		 */
> >  		sl = p_qos_level->sl;
> >  
> > @@ -746,6 +728,14 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
> >  		goto Exit;
> >  	}
> >  
> > +	/*
> > +	 * If the routing engine wants to have a say in path SL selection,
> > +	 * send the currently computed SL value as a hint and let the routing
> > +	 * engine override it.
> > +	 */
> > +	if (p_re && p_re->path_sl)
> > +		sl = p_re->path_sl(p_re->context, sl, p_src_port, p_dest_port);
> > +
> >  	/* reset pkey when raw traffic */
> >  	if (comp_mask & IB_PR_COMPMASK_RAWTRAFFIC &&
> >  	    cl_ntoh32(p_pr->hop_flow_raw) & (1 << 31))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
