From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: Subject: [PATCH] opensm/perfmgr: update node name when Node
 Description is received from node
Date: Tue, 19 Feb 2013 14:23:23 -0800
Message-ID: <20130219142323.aa76e0630bf418025999bd5f@llnl.gov>
References: <20130213135037.b6ba879a9e3c3c65ed3d9673@llnl.gov>
	<5123E26D.50005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5123E26D.50005-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 19 Feb 2013 15:37:01 -0500
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 2/13/2013 4:50 PM, Ira Weiny wrote:
> > 
> > 
> > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > ---
> >  include/opensm/osm_perfmgr.h    |    2 ++
> >  include/opensm/osm_perfmgr_db.h |    3 +++
> >  opensm/osm_node_desc_rcv.c      |    7 +++++++
> >  opensm/osm_perfmgr.c            |    6 ++++++
> >  opensm/osm_perfmgr_db.c         |   13 +++++++++++++
> >  5 files changed, 31 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/opensm/osm_perfmgr.h b/include/opensm/osm_perfmgr.h
> > index 97fead1..26b1ae6 100644
> > --- a/include/opensm/osm_perfmgr.h
> > +++ b/include/opensm/osm_perfmgr.h
> > @@ -247,6 +247,8 @@ void osm_perfmgr_dump_counters(osm_perfmgr_t * p_perfmgr,
> >  			       perfmgr_db_dump_t dump_type);
> >  void osm_perfmgr_print_counters(osm_perfmgr_t *pm, char *nodename, FILE *fp,
> >  				char *port, int err_only);
> > +void osm_perfmgr_update_nodename(osm_perfmgr_t *pm, uint64_t node_guid,
> > +				char *nodename);
> >  
> >  ib_api_status_t osm_perfmgr_bind(osm_perfmgr_t * p_perfmgr,
> >  				 ib_net64_t port_guid);
> > diff --git a/include/opensm/osm_perfmgr_db.h b/include/opensm/osm_perfmgr_db.h
> > index 6333692..5491d2f 100644
> > --- a/include/opensm/osm_perfmgr_db.h
> > +++ b/include/opensm/osm_perfmgr_db.h
> > @@ -164,6 +164,9 @@ perfmgr_db_err_t perfmgr_db_create_entry(perfmgr_db_t * db, uint64_t guid,
> >  perfmgr_db_err_t perfmgr_db_delete_entry(perfmgr_db_t * db, uint64_t guid);
> >  perfmgr_db_err_t perfmgr_db_delete_inactive(perfmgr_db_t * db, unsigned *cnt);
> >  
> > +perfmgr_db_err_t perfmgr_db_update_name(perfmgr_db_t * db, uint64_t node_guid,
> > +					char *name);
> > +
> >  perfmgr_db_err_t perfmgr_db_add_err_reading(perfmgr_db_t * db, uint64_t guid,
> >  					    uint8_t port,
> >  					    perfmgr_db_err_reading_t * reading);
> > diff --git a/opensm/osm_node_desc_rcv.c b/opensm/osm_node_desc_rcv.c
> > index 741c944..ff1b05e 100644
> > --- a/opensm/osm_node_desc_rcv.c
> > +++ b/opensm/osm_node_desc_rcv.c
> > @@ -79,6 +79,13 @@ static void nd_rcv_process_nd(IN osm_sm_t * sm, IN osm_node_t * p_node,
> >  		free(p_node->print_desc);
> >  	p_node->print_desc = tmp_desc;
> >  
> > +#ifdef ENABLE_OSM_PERF_MGR
> > +	/* update the perfmgr entry if available */
> > +	osm_perfmgr_update_nodename(&(sm->p_subn->p_osm->perfmgr),
> 
> Nit: no need for parentheses around sm->p_subn->p_osm->perfmgr

ok.

> 
> > +				cl_ntoh64(osm_node_get_node_guid(p_node)),
> > +				p_node->print_desc);
> > +#endif				/* ENABLE_OSM_PERF_MGR */
> > +
> >  	OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
> >  		"Node 0x%" PRIx64 "\n\t\t\t\tDescription = %s\n",
> >  		cl_ntoh64(osm_node_get_node_guid(p_node)), p_node->print_desc);
> > diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
> > index 5207245..9bc1154 100644
> > --- a/opensm/osm_perfmgr.c
> > +++ b/opensm/osm_perfmgr.c
> > @@ -1459,4 +1459,10 @@ void osm_perfmgr_print_counters(osm_perfmgr_t * pm, char *nodename, FILE * fp,
> >  	} else
> >  		perfmgr_db_print_all(pm->db, fp, err_only);
> >  }
> > +void osm_perfmgr_update_nodename(osm_perfmgr_t *pm, uint64_t node_guid,
> > +				char *nodename)
> > +{
> > +	if (pm->db)
> > +		perfmgr_db_update_name(pm->db, node_guid, nodename);
> > +}
> >  #endif				/* ENABLE_OSM_PERF_MGR */
> > diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
> > index 6095e1a..238081b 100644
> > --- a/opensm/osm_perfmgr_db.c
> > +++ b/opensm/osm_perfmgr_db.c
> > @@ -197,6 +197,19 @@ Exit:
> >  }
> >  
> >  perfmgr_db_err_t
> > +perfmgr_db_update_name(perfmgr_db_t * db, uint64_t node_guid, char *name)
> > +{
> > +	db_node_t *node = NULL;
> > +
> > +	cl_plock_excl_acquire(&db->lock);
> > +	node = get(db, node_guid);
> > +	if (node)
> > +		snprintf(node->node_name, sizeof(node->node_name), "%s", name);
> 
> Should some error like PERFMGR_EVENT_DB_GUIDNOTFOUND be returned when
> node GUID is not found ?

No.  There is no guarantee that the node will be in the DB yet.  For example, a new node will not be added to the PM DB until the next PM sweep.

Ira

> 
> -- Hal
> 
> > +	cl_plock_release(&db->lock);
> > +	return (PERFMGR_EVENT_DB_SUCCESS);
> > +}
> > +
> > +perfmgr_db_err_t
> >  perfmgr_db_delete_entry(perfmgr_db_t * db, uint64_t guid)
> >  {
> >  	cl_map_item_t * rc = cl_qmap_remove(&db->pc_data, guid);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


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
