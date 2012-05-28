From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: fix SMInfo delayed response sending due to
 multiple timeouts in the fabric.
Date: Mon, 28 May 2012 10:12:24 +0300
Message-ID: <20120528071224.GA13030@calypso>
References: <20120524121023.GB2232@calypso>
 <20120524105107.a393999a.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120524105107.a393999a.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Please ignore for now. A new patch will follow.

On 10:51 Thu 24 May     , Ira Weiny wrote:
> On Thu, 24 May 2012 15:10:23 +0300
> Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> 
> > The issue is resolved by adding High priority unicast FIFO queue to the VL15
> > poller thread.
> > 
> > Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >  include/opensm/osm_sm.h       |    7 +++++--
> >  include/opensm/osm_vl15intf.h |   15 +++++++++++++--
> >  opensm/osm_req.c              |    6 +++---
> >  opensm/osm_resp.c             |    5 +++--
> >  opensm/osm_sm_mad_ctrl.c      |    2 +-
> >  opensm/osm_sminfo_rcv.c       |    8 ++++----
> >  opensm/osm_trap_rcv.c         |    2 +-
> >  opensm/osm_vl15intf.c         |   36 +++++++++++++++++++++++++++++-------
> >  8 files changed, 59 insertions(+), 22 deletions(-)
> > 
> > diff --git a/include/opensm/osm_sm.h b/include/opensm/osm_sm.h
> > index 4c7b120..17d6afd 100644
> > --- a/include/opensm/osm_sm.h
> > +++ b/include/opensm/osm_sm.h
> > @@ -495,7 +495,8 @@ ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
> >  ib_api_status_t osm_resp_send(IN osm_sm_t * sm,
> >  			      IN const osm_madw_t * p_req_madw,
> >  			      IN ib_net16_t status,
> > -			      IN const uint8_t * p_payload);
> > +			      IN const uint8_t * p_payload,
> > +			      IN boolean_t force_flag);
> >  /*
> >  * PARAMETERS
> >  *	p_resp
> > @@ -510,7 +511,9 @@ ib_api_status_t osm_resp_send(IN osm_sm_t * sm,
> >  *
> >  *	p_payload
> >  *		[in] Pointer to the payload of the response MAD.
> > -*
> > +*	force_flag
> > +*		[in] If TRUE, indicates that the response should be processed immediately
> > +*		by VL15 poller thread
> 
> Shouldn't "force_flag" be something like "immediate"?  Same comment for all callers of this function.
> 
> >  * RETURN VALUES
> >  *	IB_SUCCESS if the response was successful.
> >  *
> > diff --git a/include/opensm/osm_vl15intf.h b/include/opensm/osm_vl15intf.h
> > index e621c68..a600de6 100644
> > --- a/include/opensm/osm_vl15intf.h
> > +++ b/include/opensm/osm_vl15intf.h
> > @@ -123,6 +123,7 @@ typedef struct osm_vl15 {
> >  	cl_thread_t poller;
> >  	cl_qlist_t rfifo;
> >  	cl_qlist_t ufifo;
> > +	cl_qlist_t hp_ufifo;
> >  	cl_spinlock_t lock;
> >  	osm_vendor_t *p_vend;
> >  	osm_log_t *p_log;
> > @@ -156,6 +157,10 @@ typedef struct osm_vl15 {
> >  *		First-in First-out queue for outbound VL15 MADs for which
> >  *		no response is expected, aka the "unicast fifo".
> >  *
> > +*	hp_ufifo
> > +*		First-in First-out high priority queue for outbound VL15 MADs for which
> > +*		no response is expected. SMInfo response MADs are placed in this queue
> > +*
> >  *	poller
> >  *		Worker thread pool that services the fifo to transmit VL15 MADs
> >  *
> > @@ -298,7 +303,7 @@ ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl15, IN osm_vendor_t * p_vend,
> >  *
> >  * SYNOPSIS
> >  */
> > -void osm_vl15_post(IN osm_vl15_t * p_vl15, IN osm_madw_t * p_madw);
> > +void osm_vl15_post(IN osm_vl15_t * p_vl15, IN osm_madw_t * p_madw, IN boolean_t force_flag);
> >  /*
> >  * PARAMETERS
> >  *	p_vl15
> > @@ -307,6 +312,9 @@ void osm_vl15_post(IN osm_vl15_t * p_vl15, IN osm_madw_t * p_madw);
> >  *	p_madw
> >  *		[in] Pointer to a MAD wrapper structure containing the MAD.
> >  *
> > +*	force_flag
> > +*		[in] If set to TRUE, high priority ucast queue should be used
> > +*
> 
> or "high_priority"?  Same comment for all callers of this function.
> 
> Ira
> 
> >  * RETURN VALUES
> >  *	This function does not return a value.
> >  *
> > @@ -327,12 +335,15 @@ void osm_vl15_post(IN osm_vl15_t * p_vl15, IN osm_madw_t * p_madw);
> >  *
> >  * SYNOPSIS
> >  */
> > -void osm_vl15_poll(IN osm_vl15_t * p_vl);
> > +void osm_vl15_poll(IN osm_vl15_t * p_vl, IN boolean_t force_flag);
> >  /*
> >  * PARAMETERS
> >  *	p_vl15
> >  *		[in] Pointer to an osm_vl15_t object.
> >  *
> > +*	force_flag
> > +*		[in] If set to TRUE, poller thread should be signalled immediately
> > +*
> >  * RETURN VALUES
> >  *	None.
> >  *
> > diff --git a/opensm/osm_req.c b/opensm/osm_req.c
> > index 7e9e664..3728327 100644
> > --- a/opensm/osm_req.c
> > +++ b/opensm/osm_req.c
> > @@ -117,7 +117,7 @@ ib_api_status_t osm_req_get(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
> >  	if (p_context)
> >  		p_madw->context = *p_context;
> >  
> > -	osm_vl15_post(sm->p_vl15, p_madw);
> > +	osm_vl15_post(sm->p_vl15, p_madw, FALSE);
> >  
> >  Exit:
> >  	OSM_LOG_EXIT(sm->p_log);
> > @@ -189,7 +189,7 @@ ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
> >  
> >  	memcpy(osm_madw_get_smp_ptr(p_madw)->data, p_payload, payload_size);
> >  
> > -	osm_vl15_post(sm->p_vl15, p_madw);
> > +	osm_vl15_post(sm->p_vl15, p_madw, FALSE);
> >  
> >  Exit:
> >  	OSM_LOG_EXIT(sm->p_log);
> > @@ -267,7 +267,7 @@ int osm_send_trap144(osm_sm_t * sm, ib_net16_t local)
> >  		"Sending Trap 144, TID 0x%" PRIx64 " to SM lid %u\n",
> >  		cl_ntoh64(smp->trans_id), cl_ntoh16(madw->mad_addr.dest_lid));
> >  
> > -	osm_vl15_post(sm->p_vl15, madw);
> > +	osm_vl15_post(sm->p_vl15, madw, FALSE);
> >  
> >  	return 0;
> >  }
> > diff --git a/opensm/osm_resp.c b/opensm/osm_resp.c
> > index ee391b6..cc52b68 100644
> > --- a/opensm/osm_resp.c
> > +++ b/opensm/osm_resp.c
> > @@ -95,7 +95,8 @@ Exit:
> >  ib_api_status_t osm_resp_send(IN osm_sm_t * sm,
> >  			      IN const osm_madw_t * p_req_madw,
> >  			      IN ib_net16_t mad_status,
> > -			      IN const uint8_t * p_payload)
> > +			      IN const uint8_t * p_payload,
> > +			      IN boolean_t force_flag)
> >  {
> >  	const ib_smp_t *p_req_smp;
> >  	ib_smp_t *p_smp;
> > @@ -142,7 +143,7 @@ ib_api_status_t osm_resp_send(IN osm_sm_t * sm,
> >  		ib_get_sm_attr_str(p_smp->attr_id), cl_ntoh16(p_smp->attr_id),
> >  		cl_ntoh32(p_smp->attr_mod), cl_ntoh64(p_smp->trans_id));
> >  
> > -	osm_vl15_post(sm->p_vl15, p_madw);
> > +	osm_vl15_post(sm->p_vl15, p_madw, force_flag);
> >  
> >  Exit:
> >  	OSM_LOG_EXIT(sm->p_log);
> > diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
> > index f0bcff2..2ccfbfa 100644
> > --- a/opensm/osm_sm_mad_ctrl.c
> > +++ b/opensm/osm_sm_mad_ctrl.c
> > @@ -163,7 +163,7 @@ static void sm_mad_ctrl_update_wire_stats(IN osm_sm_mad_ctrl_t * p_ctrl)
> >  	   We can signal the VL15 controller to send another MAD
> >  	   if any are waiting for transmission.
> >  	 */
> > -	osm_vl15_poll(p_ctrl->p_vl15);
> > +	osm_vl15_poll(p_ctrl->p_vl15, FALSE);
> >  	OSM_LOG_EXIT(p_ctrl->p_log);
> >  }
> >  
> > diff --git a/opensm/osm_sminfo_rcv.c b/opensm/osm_sminfo_rcv.c
> > index e45d14e..6f0b099 100644
> > --- a/opensm/osm_sminfo_rcv.c
> > +++ b/opensm/osm_sminfo_rcv.c
> > @@ -111,7 +111,7 @@ static void smi_rcv_process_get_request(IN osm_sm_t * sm,
> >  		p_smi->sm_key = 0;
> >  	}
> >  
> > -	status = osm_resp_send(sm, p_madw, 0, payload);
> > +	status = osm_resp_send(sm, p_madw, 0, payload, TRUE);
> >  	if (status != IB_SUCCESS) {
> >  		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F02: "
> >  			"Error sending response (%s)\n",
> > @@ -208,7 +208,7 @@ static void smi_rcv_process_set_request(IN osm_sm_t * sm,
> >  			"Check legality failed. AttributeModifier:0x%X RemoteState:%s\n",
> >  			p_smp->attr_mod,
> >  			osm_get_sm_mgr_state_str(ib_sminfo_get_state(sm_smi)));
> > -		status = osm_resp_send(sm, p_madw, 7, payload);
> > +		status = osm_resp_send(sm, p_madw, 7, payload, TRUE);
> >  		if (status != IB_SUCCESS)
> >  			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F05: "
> >  				"Error sending response (%s)\n",
> > @@ -253,7 +253,7 @@ static void smi_rcv_process_set_request(IN osm_sm_t * sm,
> >  			"AttributeModifier:0x%X RemoteState:%s\n",
> >  			p_smp->attr_mod,
> >  			osm_get_sm_mgr_state_str(ib_sminfo_get_state(sm_smi)));
> > -		status = osm_resp_send(sm, p_madw, 7, payload);
> > +		status = osm_resp_send(sm, p_madw, 7, payload, TRUE);
> >  		if (status != IB_SUCCESS)
> >  			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F08: "
> >  				"Error sending response (%s)\n",
> > @@ -263,7 +263,7 @@ static void smi_rcv_process_set_request(IN osm_sm_t * sm,
> >  	}
> >  
> >  	/* the SubnSet(SMInfo) command is ok. Send a response. */
> > -	status = osm_resp_send(sm, p_madw, 0, payload);
> > +	status = osm_resp_send(sm, p_madw, 0, payload, TRUE);
> >  	if (status != IB_SUCCESS)
> >  		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F09: "
> >  			"Error sending response (%s)\n",
> > diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
> > index 2aaaba4..132c510 100644
> > --- a/opensm/osm_trap_rcv.c
> > +++ b/opensm/osm_trap_rcv.c
> > @@ -410,7 +410,7 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
> >  		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3809: "
> >  			"Failed to find source physical port for trap\n");
> >  
> > -	status = osm_resp_send(sm, &tmp_madw, 0, payload);
> > +	status = osm_resp_send(sm, &tmp_madw, 0, payload, FALSE);
> >  	if (status != IB_SUCCESS) {
> >  		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3802: "
> >  			"Error sending response (%s)\n",
> > diff --git a/opensm/osm_vl15intf.c b/opensm/osm_vl15intf.c
> > index c845597..5019f64 100644
> > --- a/opensm/osm_vl15intf.c
> > +++ b/opensm/osm_vl15intf.c
> > @@ -131,9 +131,12 @@ static void vl15_poller(IN void *p_ptr)
> >  		   The unicast FIFO has priority, since somebody is waiting
> >  		   for a timely response.
> >  		 */
> > +send_next:
> >  		cl_spinlock_acquire(&p_vl->lock);
> >  
> > -		if (cl_qlist_count(&p_vl->ufifo) != 0)
> > +		if (cl_qlist_count(&p_vl->hp_ufifo) != 0)
> > +			p_fifo = &p_vl->hp_ufifo;
> > +		else if (cl_qlist_count(&p_vl->ufifo) != 0)
> >  			p_fifo = &p_vl->ufifo;
> >  		else
> >  			p_fifo = &p_vl->rfifo;
> > @@ -151,6 +154,9 @@ static void vl15_poller(IN void *p_ptr)
> >  						OSM_LOG_FRAMES);
> >  
> >  			vl15_send_mad(p_vl, p_madw);
> > +			/* we should always drain the high priority queue first */
> > +			if (p_fifo == &p_vl->hp_ufifo)
> > +				goto send_next;
> >  		} else
> >  			/*
> >  			   The VL15 FIFO is empty, so we have nothing left to do.
> > @@ -195,6 +201,7 @@ void osm_vl15_construct(IN osm_vl15_t * p_vl)
> >  	cl_spinlock_construct(&p_vl->lock);
> >  	cl_qlist_init(&p_vl->rfifo);
> >  	cl_qlist_init(&p_vl->ufifo);
> > +	cl_qlist_init(&p_vl->hp_ufifo);
> >  	cl_thread_construct(&p_vl->poller);
> >  }
> >  
> > @@ -232,6 +239,10 @@ void osm_vl15_destroy(IN osm_vl15_t * p_vl, IN struct osm_mad_pool *p_pool)
> >  		p_madw = (osm_madw_t *) cl_qlist_remove_head(&p_vl->ufifo);
> >  		osm_mad_pool_put(p_pool, p_madw);
> >  	}
> > +	while (!cl_is_qlist_empty(&p_vl->hp_ufifo)) {
> > +		p_madw = (osm_madw_t *) cl_qlist_remove_head(&p_vl->hp_ufifo);
> > +		osm_mad_pool_put(p_pool, p_madw);
> > +	}
> >  
> >  	cl_spinlock_release(&p_vl->lock);
> >  
> > @@ -281,7 +292,7 @@ Exit:
> >  	return status;
> >  }
> >  
> > -void osm_vl15_poll(IN osm_vl15_t * p_vl)
> > +void osm_vl15_poll(IN osm_vl15_t * p_vl, IN boolean_t force_flag)
> >  {
> >  	OSM_LOG_ENTER(p_vl->p_log);
> >  
> > @@ -296,8 +307,8 @@ void osm_vl15_poll(IN osm_vl15_t * p_vl)
> >  	   the event here.  To cover this rare case, the poller
> >  	   thread checks for a spurious wake-up.
> >  	 */
> > -	if (p_vl->p_stats->qp0_mads_outstanding_on_wire <
> > -	    (int32_t) p_vl->max_wire_smps) {
> > +	if (force_flag || (p_vl->p_stats->qp0_mads_outstanding_on_wire <
> > +	    (int32_t) p_vl->max_wire_smps)) {
> >  		OSM_LOG(p_vl->p_log, OSM_LOG_DEBUG,
> >  			"Signalling poller thread\n");
> >  		cl_event_signal(&p_vl->signal);
> > @@ -306,7 +317,7 @@ void osm_vl15_poll(IN osm_vl15_t * p_vl)
> >  	OSM_LOG_EXIT(p_vl->p_log);
> >  }
> >  
> > -void osm_vl15_post(IN osm_vl15_t * p_vl, IN osm_madw_t * p_madw)
> > +void osm_vl15_post(IN osm_vl15_t * p_vl, IN osm_madw_t * p_madw, boolean_t force_flag)
> >  {
> >  	OSM_LOG_ENTER(p_vl->p_log);
> >  
> > @@ -322,7 +333,8 @@ void osm_vl15_post(IN osm_vl15_t * p_vl, IN osm_madw_t * p_madw)
> >  		cl_qlist_insert_tail(&p_vl->rfifo, &p_madw->list_item);
> >  		osm_stats_inc_qp0_outstanding(p_vl->p_stats);
> >  	} else
> > -		cl_qlist_insert_tail(&p_vl->ufifo, &p_madw->list_item);
> > +		cl_qlist_insert_tail(force_flag ? &p_vl->hp_ufifo : &p_vl->ufifo,
> > +				     &p_madw->list_item);
> >  	cl_spinlock_release(&p_vl->lock);
> >  
> >  	OSM_LOG(p_vl->p_log, OSM_LOG_DEBUG,
> > @@ -330,7 +342,7 @@ void osm_vl15_post(IN osm_vl15_t * p_vl, IN osm_madw_t * p_madw)
> >  		p_vl->p_stats->qp0_mads_outstanding_on_wire,
> >  		p_vl->p_stats->qp0_mads_outstanding);
> >  
> > -	osm_vl15_poll(p_vl);
> > +	osm_vl15_poll(p_vl, force_flag);
> >  
> >  	OSM_LOG_EXIT(p_vl->p_log);
> >  }
> > @@ -350,6 +362,16 @@ void osm_vl15_shutdown(IN osm_vl15_t * p_vl, IN osm_mad_pool_t * p_mad_pool)
> >  	/* go over all outstanding MADs and retire their transactions */
> >  
> >  	/* first we handle the list of response MADs */
> > +	p_madw = (osm_madw_t *) cl_qlist_remove_head(&p_vl->hp_ufifo);
> > +	while (p_madw != (osm_madw_t *) cl_qlist_end(&p_vl->hp_ufifo)) {
> > +		OSM_LOG(p_vl->p_log, OSM_LOG_DEBUG,
> > +			"Releasing High Priority Response p_madw = %p\n", p_madw);
> > +
> > +		osm_mad_pool_put(p_mad_pool, p_madw);
> > +
> > +		p_madw = (osm_madw_t *) cl_qlist_remove_head(&p_vl->hp_ufifo);
> > +	}
> > +
> >  	p_madw = (osm_madw_t *) cl_qlist_remove_head(&p_vl->ufifo);
> >  	while (p_madw != (osm_madw_t *) cl_qlist_end(&p_vl->ufifo)) {
> >  		OSM_LOG(p_vl->p_log, OSM_LOG_DEBUG,
> > -- 
> > 1.7.7.6
> > 
> > 
> > -- 
> > 
> > -- Alex
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> -- 
> Ira Weiny
> Member of Technical Staff
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
