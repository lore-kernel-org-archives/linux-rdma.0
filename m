From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/3 v2] opensm SA DB dump/restore: dump SA DB only if
 modified
Date: Thu, 26 Nov 2009 16:15:19 +0200
Message-ID: <20091126141519.GB28564@me>
References: <4AF15EF0.6050903@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AF15EF0.6050903-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13:01 Wed 04 Nov     , Yevgeny Kliteynik wrote:
> Optimizing SA DB dump - added "dirty" flag to denote
> that the SA DB was modified, so that the DB will be
> dumped only when the flag is on.
> 
> [v2 - no changes, just rebased and resolved conflicts]
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
>  opensm/include/opensm/osm_sa.h         |    5 +++++
>  opensm/opensm/osm_inform.c             |    2 ++
>  opensm/opensm/osm_multicast.c          |    3 +++
>  opensm/opensm/osm_sa.c                 |    7 ++++++-
>  opensm/opensm/osm_sa_mcmember_record.c |    4 ++++
>  opensm/opensm/osm_service.c            |    3 +++
>  6 files changed, 23 insertions(+), 1 deletions(-)
> 
> diff --git a/opensm/include/opensm/osm_sa.h b/opensm/include/opensm/osm_sa.h
> index dad3142..35684cc 100644
> --- a/opensm/include/opensm/osm_sa.h
> +++ b/opensm/include/opensm/osm_sa.h
> @@ -125,6 +125,7 @@ typedef struct osm_sa {
>  	atomic32_t sa_trans_id;
>  	osm_sa_mad_ctrl_t mad_ctrl;
>  	cl_timer_t sr_timer;
> +	boolean_t dirty;
>  	cl_disp_reg_handle_t cpi_disp_h;
>  	cl_disp_reg_handle_t nr_disp_h;
>  	cl_disp_reg_handle_t pir_disp_h;
> @@ -178,6 +179,10 @@ typedef struct osm_sa {
>  *	mad_ctrl
>  *		Mad Controller
>  *
> +*	dirty
> +*		A flag that denotes that SA DB is dirty and needs
> +*		to be written to the dump file (if dumping is enabled)
> +*
>  * SEE ALSO
>  *	SM object
>  *********/
> diff --git a/opensm/opensm/osm_inform.c b/opensm/opensm/osm_inform.c
> index 84310a5..d2dd8e7 100644
> --- a/opensm/opensm/osm_inform.c
> +++ b/opensm/opensm/osm_inform.c
> @@ -248,6 +248,7 @@ void osm_infr_insert_to_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
>  #endif
> 
>  	cl_qlist_insert_head(&p_subn->sa_infr_list, &p_infr->list_item);
> +	p_subn->p_osm->sa.dirty = TRUE;
> 
>  	OSM_LOG(p_log, OSM_LOG_DEBUG, "Dump after insertion (size %d)\n",
>  		cl_qlist_count(&p_subn->sa_infr_list));
> @@ -271,6 +272,7 @@ void osm_infr_remove_from_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
>  			     OSM_LOG_DEBUG);
> 
>  	cl_qlist_remove_item(&p_subn->sa_infr_list, &p_infr->list_item);
> +	p_subn->p_osm->sa.dirty = TRUE;
> 
>  	osm_infr_delete(p_infr);
> 
> diff --git a/opensm/opensm/osm_multicast.c b/opensm/opensm/osm_multicast.c
> index 8ccab8e..c501986 100644
> --- a/opensm/opensm/osm_multicast.c
> +++ b/opensm/opensm/osm_multicast.c
> @@ -197,6 +197,7 @@ osm_mcm_port_t *osm_mgrp_add_port(IN osm_subn_t * subn, osm_log_t * log,
>  	    ++mgrp->full_members == 1)
>  		mgrp_send_notice(subn, log, mgrp, 66);
> 
> +	subn->p_osm->sa.dirty = TRUE;
>  	return mcm_port;
>  }
> 
> @@ -251,6 +252,8 @@ void osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
>  		mgrp_send_notice(subn, log, mgrp, 67);
>  		osm_mgrp_cleanup(subn, mgrp);
>  	}
> +
> +	subn->p_osm->sa.dirty = TRUE;
>  }

In general I don't like an idea of spreading this global "dirty" flag
over various OpenSM areas (it makes the code dirty). But even if it is
needed couldn't we minimize number of such occurrences?

For example those specific ones in osm_multicast.c are duplicated in
osm_sa_mcmember_record.c (and also will cause 'dirty' flag setup on the
SA DB from file loading). Could we consolidate all multicast related
cases with re-routing requesting for example?

Sasha

> 
>  void osm_mgrp_delete_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
> diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
> index e44eab4..91a7459 100644
> --- a/opensm/opensm/osm_sa.c
> +++ b/opensm/opensm/osm_sa.c
> @@ -707,7 +707,12 @@ static void sa_dump_all_sa(osm_opensm_t * p_osm, FILE * file)
> 
>  int osm_sa_db_file_dump(osm_opensm_t * p_osm)
>  {
> -	return opensm_dump_to_file(p_osm, "opensm-sa.dump", sa_dump_all_sa);
> +	int res = 0;
> +	if (p_osm->sa.dirty) {
> +		res = opensm_dump_to_file(p_osm, "opensm-sa.dump", sa_dump_all_sa);
> +		p_osm->sa.dirty = FALSE;
> +	}
> +	return res;
>  }
> 
>  /*
> diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
> index 95c41e4..5ba139f 100644
> --- a/opensm/opensm/osm_sa_mcmember_record.c
> +++ b/opensm/opensm/osm_sa_mcmember_record.c
> @@ -818,6 +818,7 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
>  		       &(*pp_mgrp)->mcmember_rec.mgid, &(*pp_mgrp)->map_item);
>  	sa->p_subn->mgroups[cl_ntoh16(mlid) - IB_LID_MCAST_START_HO] = *pp_mgrp;
> 
> +	sa->dirty = TRUE;
>  Exit:
>  	OSM_LOG_EXIT(sa->p_log);
>  	return status;
> @@ -942,6 +943,7 @@ static void mcmr_rcv_leave_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
>  	/* remove port and/or update join state */
>  	osm_mgrp_remove_port(sa->p_subn, sa->p_log, p_mgrp, p_mcm_port,
>  			     &mcmember_rec);
> +	sa->dirty = TRUE;
>  	CL_PLOCK_RELEASE(sa->p_lock);
> 
>  	mcmr_rcv_respond(sa, p_madw, &mcmember_rec);
> @@ -1155,6 +1157,7 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
>  	if (osm_log_is_active(sa->p_log, OSM_LOG_DEBUG))
>  		osm_dump_mc_record(sa->p_log, &mcmember_rec, OSM_LOG_DEBUG);
> 
> +	sa->dirty = TRUE;
>  	mcmr_rcv_respond(sa, p_madw, &mcmember_rec);
> 
>  Exit:
> @@ -1187,6 +1190,7 @@ static ib_api_status_t mcmr_rcv_new_mcmr(IN osm_sa_t * sa,
>  	   State, Port Guid, and Proxy */
>  	p_rec_item->rec = *p_rcvd_rec;
>  	cl_qlist_insert_tail(p_list, &p_rec_item->list_item);
> +	sa->dirty = TRUE;
> 
>  Exit:
>  	OSM_LOG_EXIT(sa->p_log);
> diff --git a/opensm/opensm/osm_service.c b/opensm/opensm/osm_service.c
> index ceb8aad..91715e6 100644
> --- a/opensm/opensm/osm_service.c
> +++ b/opensm/opensm/osm_service.c
> @@ -46,6 +46,7 @@
>  #include <complib/cl_debug.h>
>  #include <complib/cl_timer.h>
>  #include <opensm/osm_service.h>
> +#include <opensm/osm_opensm.h>
> 
>  void osm_svcr_delete(IN osm_svcr_t * p_svcr)
>  {
> @@ -122,6 +123,7 @@ void osm_svcr_insert_to_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
>  		"Inserting new Service Record into Database\n");
> 
>  	cl_qlist_insert_head(&p_subn->sa_sr_list, &p_svcr->list_item);
> +	p_subn->p_osm->sa.dirty = TRUE;
> 
>  	OSM_LOG_EXIT(p_log);
>  }
> @@ -137,6 +139,7 @@ void osm_svcr_remove_from_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
>  		p_svcr->service_record.service_id);
> 
>  	cl_qlist_remove_item(&p_subn->sa_sr_list, &p_svcr->list_item);
> +	p_subn->p_osm->sa.dirty = TRUE;
> 
>  	OSM_LOG_EXIT(p_log);
>  }
> -- 
> 1.5.1.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
