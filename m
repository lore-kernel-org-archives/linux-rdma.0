From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] Log changes related to event subscription and forwarding
Date: Wed, 12 Jun 2013 15:58:19 -0400
Message-ID: <51B8D2DB.5010700@dev.mellanox.co.il>
References: <8f3f5ded-fc8b-4632-a71a-ef566da9ef91@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8f3f5ded-fc8b-4632-a71a-ef566da9ef91@default>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Line,

[off list...]

On 6/5/2013 7:14 AM, Line Holen wrote:
> Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> ---
> 
> diff --git a/opensm/osm_inform.c b/opensm/osm_inform.c
> index 19bbe72..ef51953 100644
> --- a/opensm/osm_inform.c
> +++ b/opensm/osm_inform.c
> @@ -305,10 +305,12 @@ static ib_api_status_t send_report(IN osm_infr_t * p_infr_rec,	/* the informinfo
>  	/* HACK: who switches or uses the src and dest GIDs in the grh_info ?? */
>  
>  	/* it is better to use LIDs since the GIDs might not be there for SMI traps */
> -	OSM_LOG(p_log, OSM_LOG_DEBUG, "Forwarding Notice Event from LID:%u"
> -		" to InformInfo LID:%u TID:0x%X\n",
> +	OSM_LOG(p_log, OSM_LOG_VERBOSE, "Forwarding Notice Event from LID %u"
> +		" to InformInfo LID %u GUID 0x%" PRIx64 ", TID 0x%X\n",

My one concern with this is changing the log level as there can be a lot
of reports as a single trap can be reported to many subscribers. On one
hand, it's good to see this but is this really moderate or high volume ?
So I'm certainly fine with this staying at DEBUG level but not sure
about VERBOSE level. Is that OK with you or do you have strong
motivation for this being VERBOSE ?

BTW, I have work in the wings to push to the upstream tree on a rewrite
of this area to get better performance/scalability for SA reports.

-- Hal

>  		cl_ntoh16(p_ntc->issuer_lid),
> -		cl_ntoh16(p_infr_rec->report_addr.dest_lid), trap_fwd_trans_id);
> +		cl_ntoh16(p_infr_rec->report_addr.dest_lid),
> +		cl_ntoh64(p_infr_rec->inform_record.subscriber_gid.unicast.interface_id),
> +		trap_fwd_trans_id);
>  
>  	/* get the MAD to send */
>  	p_report_madw = osm_mad_pool_get(p_infr_rec->sa->p_mad_pool,
> diff --git a/opensm/osm_sa_informinfo.c b/opensm/osm_sa_informinfo.c
> index 0b3e1f8..f32b88b 100644
> --- a/opensm/osm_sa_informinfo.c
> +++ b/opensm/osm_sa_informinfo.c
> @@ -3,6 +3,7 @@
>   * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2009 HNR Consulting. All rights reserved.
> + * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -544,6 +545,10 @@ static void infr_rcv_process_set_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
>  				goto Exit;
>  			}
>  
> +			OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
> +				"Adding event subscription for port 0x%" PRIx64 "\n",
> +				cl_ntoh64(inform_info_rec.inform_record.subscriber_gid.unicast.interface_id));
> +
>  			/* Add this new osm_infr_t object to subnet object */
>  			osm_infr_insert_to_db(sa->p_subn, sa->p_log, p_infr);
>  		} else
> @@ -561,9 +566,13 @@ static void infr_rcv_process_set_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
>  		p_recvd_inform_info->subscribe = 0;
>  		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_REQ_INVALID);
>  		goto Exit;
> -	} else
> +	} else {
>  		/* Delete this object from the subnet list of informs */
> +		OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
> +			"Removing event subscription for port 0x%" PRIx64 "\n",
> +			cl_ntoh64(inform_info_rec.inform_record.subscriber_gid.unicast.interface_id));
>  		osm_infr_remove_from_db(sa->p_subn, sa->p_log, p_infr);
> +	}
>  
>  	cl_plock_release(sa->p_lock);
>  
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
