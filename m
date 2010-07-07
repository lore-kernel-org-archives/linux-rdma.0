From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH v3 01/17] opensm: Prepare for routing engine input
 to path record SL lookup and SL2VL map setup.
Date: Wed, 7 Jul 2010 11:57:40 -0600
Message-ID: <1278525460.4812.22.camel@sale659.sandia.gov>
References: <1276631604-29230-1-git-send-email-jaschut@sandia.gov>
 <1276631604-29230-2-git-send-email-jaschut@sandia.gov>
 <20100707170630.GN22860@me>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100707170630.GN22860@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha:

On Wed, 2010-07-07 at 11:06 -0600, Sasha Khapyorsky wrote:
> Hi Jim,
> 
> On 13:53 Tue 15 Jun     , Jim Schutt wrote:
> > diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
> > index d3dc02e..5614240 100644
> > --- a/opensm/opensm/osm_opensm.c
> > +++ b/opensm/opensm/osm_opensm.c
> > @@ -147,7 +147,8 @@ static void append_routing_engine(osm_opensm_t *osm,
> >  	r->next = routing_engine;
> >  }
> >  
> > -static void setup_routing_engine(osm_opensm_t *osm, const char *name)
> > +static struct osm_routing_engine *setup_routing_engine(osm_opensm_t *osm,
> > +						       const char *name)
> >  {
> >  	struct osm_routing_engine *re;
> >  	const struct routing_engine_module *m;
> > @@ -158,47 +159,53 @@ static void setup_routing_engine(osm_opensm_t *osm, const char *name)
> >  			if (!re) {
> >  				OSM_LOG(&osm->log, OSM_LOG_VERBOSE,
> >  					"memory allocation failed\n");
> > -				return;
> > +				return NULL;
> >  			}
> >  			memset(re, 0, sizeof(struct osm_routing_engine));
> >  
> >  			re->name = m->name;
> > +			re->type = osm_routing_engine_type(m->name);
> >  			if (m->setup(re, osm)) {
> >  				OSM_LOG(&osm->log, OSM_LOG_VERBOSE,
> >  					"setup of routing"
> >  					" engine \'%s\' failed\n", name);
> > -				return;
> > +				free(re);
> > +				return NULL;
> >  			}
> >  			OSM_LOG(&osm->log, OSM_LOG_DEBUG,
> >  				"\'%s\' routing engine set up\n", re->name);
> > -			append_routing_engine(osm, re);
> > -			return;
> > +			if (re->type == OSM_ROUTING_ENGINE_TYPE_MINHOP)
> > +				osm->default_routing_engine = re;
> > +			return re;
> >  		}
> >  	}
> >  
> >  	OSM_LOG(&osm->log, OSM_LOG_ERROR,
> >  		"cannot find or setup routing engine \'%s\'\n", name);
> > +	return NULL;
> >  }
> >  
> >  static void setup_routing_engines(osm_opensm_t *osm, const char *engine_names)
> >  {
> >  	char *name, *str, *p;
> > +	struct osm_routing_engine *re;
> >  
> > -	if (!engine_names || !*engine_names) {
> > -		setup_routing_engine(osm, "minhop");
> > -		return;
> > +	if (engine_names && *engine_names) {
> > +		str = strdup(engine_names);
> > +		name = strtok_r(str, ", \t\n", &p);
> > +		while (name && *name) {
> > +			re = setup_routing_engine(osm, name);
> > +			if (re)
> > +				append_routing_engine(osm, re);
> > +			name = strtok_r(NULL, ", \t\n", &p);
> > +		}
> > +		free(str);
> >  	}
> > -
> > -	str = strdup(engine_names);
> > -	name = strtok_r(str, ", \t\n", &p);
> > -	while (name && *name) {
> > -		setup_routing_engine(osm, name);
> > -		name = strtok_r(NULL, ", \t\n", &p);
> > +	if (!osm->default_routing_engine) {
> > +		re = setup_routing_engine(osm, "minhop");
> > +		if (!osm->routing_engine_list && re)
> > +			append_routing_engine(osm, re);
> 
> Shouldn't here be:
> 
> 		osm->default_routing_engine = re;
> 
> too?

I think above call to setup_routing_engine(osm, "minhop")
does that, because we're explicitly calling it for minhop?

But now that I look at this again, I'm confused why I
thought I needed to append a minhop routing engine to
the routing engine list when the list was empty and there 
was no default routing engine.

I was trying to exactly duplicate old functionality, where
minhop is only in the routing engine list if explicitly
configured, but always called if no routing engines are
configured or all configured engines fail.
   
So I think the end of the above chunk only needs to be

-
-	str = strdup(engine_names);
-	name = strtok_r(str, ", \t\n", &p);
-	while (name && *name) {
-		setup_routing_engine(osm, name);
-		name = strtok_r(NULL, ", \t\n", &p);
- 	}
+	if (!osm->default_routing_engine)
+		setup_routing_engine(osm, "minhop");

-- Jim

> 
> 
> >  	}
> > -	free(str);
> > -
> > -	if (!osm->routing_engine_list)
> > -		setup_routing_engine(osm, "minhop");
> >  }
> >  
> >  void osm_opensm_construct(IN osm_opensm_t * p_osm)
> 
> 
> So that this chunk in osm_ucast_mgr_process() (below) will not break
> over NULL pointer?
> 
> > -	if (p_osm->routing_engine_used == OSM_ROUTING_ENGINE_TYPE_NONE) {
> > +	if (!p_osm->routing_engine_used) {
> >  		/* If configured routing algorithm failed, use default MinHop */
> > -		osm_ucast_mgr_build_lid_matrices(p_mgr);
> > -		ucast_mgr_build_lfts(p_mgr);
> > +		struct osm_routing_engine *r = p_osm->default_routing_engine;
> > +
> > +		r->build_lid_matrices(r->context);
> > +		r->ucast_build_fwd_tables(r->context);
> > +		p_osm->routing_engine_used = r;
> >  		osm_ucast_mgr_set_fwd_tables(p_mgr);
> > -		p_osm->routing_engine_used = OSM_ROUTING_ENGINE_TYPE_MINHOP;
> >  	}
> 
> Sasha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
