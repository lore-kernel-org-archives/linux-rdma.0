From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_state_mgr.c: force heavy sweep when fabric
 consists of single switch
Date: Wed, 4 Nov 2009 00:12:17 +0200
Message-ID: <20091103221217.GE29388@me>
References: <4AF0056A.5030503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AF0056A.5030503-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12:26 Tue 03 Nov     , Yevgeny Kliteynik wrote:
> Always do heavy sweep when there is only one node in the
> fabric, and this node is a switch, and SM runs on top of it -
> there may be a race when OSM starts running before the
> external ports are ports are up, or if they went through
> reset while SM was starting.
> In this race switch brings up the ports and turns on the
> PSC bit, but OSM might get PortInfo before SwitchInfo, and it
> might see all ports as down, but PSC bit on. If that happens,
> OSM turns off PSC bit, and it will never see external ports
> again - it won't perform any heavy sweep, only light sweep

Could such race happen when there are more than one node in a fabric?

Sasha

> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
>  opensm/opensm/osm_state_mgr.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
> index 4303d6e..537c855 100644
> --- a/opensm/opensm/osm_state_mgr.c
> +++ b/opensm/opensm/osm_state_mgr.c
> @@ -1062,13 +1062,18 @@ static void do_sweep(osm_sm_t * sm)
>  	 * Otherwise, this is probably our first discovery pass
>  	 * or we are connected in loopback. In both cases do a
>  	 * heavy sweep.
> -	 * Note: If we are connected in loopback we want a heavy
> -	 * sweep, since we will not be getting any traps if there is
> -	 * a lost connection.
> +	 * Note the following:
> +	 * 1. If we are connected in loopback we want a heavy sweep, since we
> +	 *    will not be getting any traps if there is a lost connection.
> +	 * 2. If we are in DISCOVERING state - this means it is either in
> +	 *    initializing or wake up from STANDBY - run the heavy sweep.
> +	 * 3. If there is only one node in the fabric, and this node is a
> +	 *    switch, and OSM runs on top of it, there might be a race when
> +	 *    OSM starts running before the external ports are up - run the
> +	 *    heavy sweep.
>  	 */
> -	/*  if we are in DISCOVERING state - this means it is either in
> -	 *  initializing or wake up from STANDBY - run the heavy sweep */
>  	if (cl_qmap_count(&sm->p_subn->sw_guid_tbl)
> +	    && cl_qmap_count(&sm->p_subn->node_guid_tbl) != 1
>  	    && sm->p_subn->sm_state != IB_SMINFO_STATE_DISCOVERING
>  	    && sm->p_subn->opt.force_heavy_sweep == FALSE
>  	    && sm->p_subn->force_heavy_sweep == FALSE
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
