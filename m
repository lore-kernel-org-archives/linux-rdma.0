From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_ucast_cache.c: Cosmetic change to log
 message for consistency
Date: Thu, 15 Oct 2009 21:26:47 +0200
Message-ID: <20091015192647.GF20210@me>
References: <20091015133639.GB8041@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091015133639.GB8041-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09:36 Thu 15 Oct     , Hal Rosenstock wrote:
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> diff --git a/opensm/opensm/osm_ucast_cache.c b/opensm/opensm/osm_ucast_cache.c
> index 31a5333..8db9df2 100644
> --- a/opensm/opensm/osm_ucast_cache.c
> +++ b/opensm/opensm/osm_ucast_cache.c
> @@ -876,7 +876,7 @@ void osm_ucast_cache_add_link(osm_ucast_mgr_t * p_mgr,
>  	if (osm_node_get_type(p_node_1) != IB_NODE_TYPE_SWITCH &&
>  	    osm_node_get_type(p_node_2) != IB_NODE_TYPE_SWITCH) {
>  		OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
> -			"Dropping CA-2-CA link - cache invalid\n");
> +			"Dropping CA/RTR-2-CA/RTR link - cache invalid\n");

IMHO it looks more confusing after the change.

BTW why should OSM_LOG_INFO level be used here?

Sasha

>  		osm_ucast_cache_invalidate(p_mgr);
>  		goto Exit;
>  	}
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
