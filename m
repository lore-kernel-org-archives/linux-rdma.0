From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_mcast_mgr.c: fix
 osm_mcast_mgr_compute_max_hops for managed switch
Date: Tue, 22 Dec 2009 23:23:48 +0200
Message-ID: <20091222212348.GF26940@me>
References: <4B2F4405.9000300@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B2F4405.9000300-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yevgeny,

On 11:46 Mon 21 Dec     , Yevgeny Kliteynik wrote:
> If a certain mcast group has only one member, and this
> member is a switch, OSM fails to select this switch
> when trying to create spanning tree for this mcast group:
> 
> ERR 0A08: Unable to locate a suitable switch for group 0xC000
> ERR 0A17: Unable to create spanning tree (IB_ERROR) for mlid 0xc000
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
>  opensm/opensm/osm_mcast_mgr.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
> index 697fb58..16f578b 100644
> --- a/opensm/opensm/osm_mcast_mgr.c
> +++ b/opensm/opensm/osm_mcast_mgr.c
> @@ -204,6 +204,12 @@ static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qlist_t * l,
> 
>  	OSM_LOG_ENTER(sm->p_log);
> 
> +	if (cl_qlist_count(l) == 0) {
> +		/*  We should be here if there aren't any ports in the group */
> +		max_hops = 10001; /* see later - we use it to realize no hops */
> +		goto Exit;
> +	}
> +

Could we reach this condition?

>From the caller code:

	num_ports = cl_qlist_count(&port_list);
	if (num_ports == 0) {
		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
			"MLID 0x%X has no members - nothing to do\n",
			mbox->mlid);
		goto Exit;
	}

Sasha

>  	/*
>  	   For each member of the multicast group, compute the
>  	   number of hops to its base LID.
> @@ -215,12 +221,10 @@ static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qlist_t * l,
>  			max_hops = hops;
>  	}
> 
> -	if (max_hops == 0)
> -		/*
> -		   We should be here if there aren't any ports in the group.
> -		 */
> -		max_hops = 10001;	/* see later - we use it to realize no hops */
> -
> +	/* Note that at this point we might get (max_hops == 0),
> +	   which means that there's only one member in the mcast
> +	   group, and it's the current switch */
> +Exit:
>  	OSM_LOG_EXIT(sm->p_log);
>  	return (float)max_hops;
>  }
> -- 
> 1.5.1.4
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
